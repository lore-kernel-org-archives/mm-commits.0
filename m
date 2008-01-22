From: akpm@linux-foundation.org
Subject: + random-add-async-notification-support-to-dev-random.patch added to -mm tree
Date: Tue, 22 Jan 2008 11:06:20 -0800
Message-ID: <200801221906.m0MJ6A41002799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57560 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbYAVTHc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 14:07:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, mpm@selenic.com, tytso@mit.edu


The patch titled
     random: add async notification support to /dev/random
has been added to the -mm tree.  Its filename is
     random-add-async-notification-support-to-dev-random.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: add async notification support to /dev/random
From: Jeff Dike <jdike@addtoit.com>

Add async notification support to /dev/random.

A little test case is below.  Without this patch, you get:

$ ./async-random
Drained the pool
Found more randomness

With it, you get:

$ ./async-random
Drained the pool
SIGIO
Found more randomness

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <errno.h>
#include <fcntl.h>

static void handler(int sig)
{
        printf("SIGIO\n");
}

int main(int argc, char **argv)
{
        int fd, n, err, flags;

        if(signal(SIGIO, handler) < 0){
                perror("setting SIGIO handler");
                exit(1);
        }

        fd = open("/dev/random", O_RDONLY);
        if(fd < 0){
                perror("open");
                exit(1);
        }

        flags = fcntl(fd, F_GETFL);
        if (flags < 0){
                perror("getting flags");
                exit(1);
        }

        flags |= O_NONBLOCK;
        if (fcntl(fd, F_SETFL, flags) < 0){
                perror("setting flags");
                exit(1);
        }

        while((err = read(fd, &n, sizeof(n))) > 0) ;

        if(err == 0){
                printf("random returned 0\n");
                exit(1);
        }
        else if(errno != EAGAIN){
                perror("read");
                exit(1);
        }

        flags |= O_ASYNC;
        if (fcntl(fd, F_SETFL, flags) < 0){
                perror("setting flags");
                exit(1);
        }

        if (fcntl(fd, F_SETOWN, getpid()) < 0) {
                perror("Setting SIGIO");
                exit(1);
        }

        printf("Drained the pool\n");
        read(fd, &n, sizeof(n));
        printf("Found more randomness\n");

        return(0);
}

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff -puN drivers/char/random.c~random-add-async-notification-support-to-dev-random drivers/char/random.c
--- a/drivers/char/random.c~random-add-async-notification-support-to-dev-random
+++ a/drivers/char/random.c
@@ -370,6 +370,7 @@ static struct poolinfo {
  */
 static DECLARE_WAIT_QUEUE_HEAD(random_read_wait);
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
+static struct fasync_struct *fasync;
 
 #if 0
 static int debug;
@@ -533,8 +534,11 @@ static void credit_entropy_bits(struct e
 		r->entropy_count = r->poolinfo->POOLBITS;
 
 	/* should we wake readers? */
-	if (r == &input_pool && r->entropy_count >= random_read_wakeup_thresh)
+	if (r == &input_pool &&
+	    r->entropy_count >= random_read_wakeup_thresh) {
 		wake_up_interruptible(&random_read_wait);
+		kill_fasync(&fasync, SIGIO, POLL_IN);
+	}
 
 	spin_unlock_irqrestore(&r->lock, flags);
 }
@@ -743,8 +747,10 @@ static size_t account(struct entropy_sto
 		else
 			r->entropy_count = reserved;
 
-		if (r->entropy_count < random_write_wakeup_thresh)
+		if (r->entropy_count < random_write_wakeup_thresh) {
 			wake_up_interruptible(&random_write_wait);
+			kill_fasync(&fasync, SIGIO, POLL_OUT);
+		}
 	}
 
 	DEBUG_ENT("debiting %d entropy credits from %s%s\n",
@@ -1101,17 +1107,31 @@ static long random_ioctl(struct file *f,
 	}
 }
 
+static int random_fasync(int fd, struct file *filp, int on)
+{
+	return fasync_helper(fd, filp, on, &fasync);
+}
+
+static int random_release(struct inode *inode, struct file *filp)
+{
+	return fasync_helper(-1, filp, 0, &fasync);
+}
+
 const struct file_operations random_fops = {
 	.read  = random_read,
 	.write = random_write,
 	.poll  = random_poll,
 	.unlocked_ioctl = random_ioctl,
+	.fasync = random_fasync,
+	.release = random_release,
 };
 
 const struct file_operations urandom_fops = {
 	.read  = urandom_read,
 	.write = random_write,
 	.unlocked_ioctl = random_ioctl,
+	.fasync = random_fasync,
+	.release = random_release,
 };
 
 /***************************************************************
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
git-x86.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-header-untangling-fix.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
uml-fix-command-line-cflags-and-ldflags-support.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-miscellaneous-code-cleanups.patch
uml-style-fixes-in-filec.patch
uml-64-bit-tlb-fixes.patch
uml-customize-tlbh.patch
uml-eliminate-setjmp_wrapper.patch
uml-install-panic-notifier-earlier.patch
uml-use-barrier-instead-of-mb.patch
uml-tidy-helper-code.patch
uml-dont-kill-pid-0.patch
uml-get-rid-of-syscall-counters.patch
uml-dont-allow-processes-to-call-into-stub.patch
uml-move-sig_handler_common_skas.patch
uml-clean-up-sig_handler_common_skas.patch
uml-style-fixes-in-arch-um-kernel.patch
uml-signal-handling-tidying.patch
uml-remove-init_irq_signals.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
