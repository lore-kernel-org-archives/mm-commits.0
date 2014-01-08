From: akpm@linux-foundation.org
Subject: + kexec-add-sysctl-to-disable-kexec_load.patch added to -mm tree
Date: Wed, 08 Jan 2014 15:54:14 -0800
Message-ID: <52cde526.sHLmNVMCkkLd4TpU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbaAHXyP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jan 2014 18:54:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, riel@redhat.com, ebiederm@xmission.com, keescook@chromium.org

Subject: + kexec-add-sysctl-to-disable-kexec_load.patch added to -mm tree
To: keescook@chromium.org,ebiederm@xmission.com,riel@redhat.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 08 Jan 2014 15:54:14 -0800


The patch titled
     Subject: kexec: add sysctl to disable kexec_load
has been added to the -mm tree.  Its filename is
     kexec-add-sysctl-to-disable-kexec_load.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-add-sysctl-to-disable-kexec_load.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-add-sysctl-to-disable-kexec_load.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: kexec: add sysctl to disable kexec_load

For general-purpose (i.e.  distro) kernel builds it makes sense to build
with CONFIG_KEXEC to allow end users to choose what kind of things they
want to do with kexec.  However, in the face of trying to lock down a
system with such a kernel, there needs to be a way to disable kexec_load
(much like module loading can be disabled).  Without this, it is too easy
for the root user to modify kernel memory even when CONFIG_STRICT_DEVMEM
and modules_disabled are set.  With this change, it is still possible to
load an image for use later, then disable kexec_load so the image (or lack
of image) can't be altered.

The intention is for using this in environments where "perfect"
enforcement is hard.  Without a verified boot, along with verified
modules, and along with verified kexec, this is trying to give a system a
better chance to defend itself (or at least grow the window of
discoverability) against attack in the face of a privilege escalation.

In my mind, I consider several boot scenarios:

1) Verified boot of read-only verified root fs loading fd-based
   verification of kexec images.
2) Secure boot of writable root fs loading signed kexec images.
3) Regular boot loading kexec (e.g. kcrash) image early and locking it.
4) Regular boot with no control of kexec image at all.

1 and 2 don't exist yet, but will soon once the verified kexec series has
landed.  4 is the state of things now.  The gap between 2 and 4 is too
large, so this change creates scenario 3, a middle-ground above 4 when 2
and 1 are not possible for a system.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   15 ++++++++++++++-
 include/linux/kexec.h           |    1 +
 kernel/kexec.c                  |    3 ++-
 kernel/sysctl.c                 |   13 +++++++++++++
 4 files changed, 30 insertions(+), 2 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~kexec-add-sysctl-to-disable-kexec_load Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~kexec-add-sysctl-to-disable-kexec_load
+++ a/Documentation/sysctl/kernel.txt
@@ -33,6 +33,7 @@ show up in /proc/sys/kernel:
 - domainname
 - hostname
 - hotplug
+- kexec_load_disabled
 - kptr_restrict
 - kstack_depth_to_print       [ X86 only ]
 - l2cr                        [ PPC only ]
@@ -287,6 +288,18 @@ Default value is "/sbin/hotplug".
 
 ==============================================================
 
+kexec_load_disabled:
+
+A toggle indicating if the kexec_load syscall has been disabled. This
+value defaults to 0 (false: kexec_load enabled), but can be set to 1
+(true: kexec_load disabled). Once true, kexec can no longer be used, and
+the toggle cannot be set back to false. This allows a kexec image to be
+loaded before disabling the syscall, allowing a system to set up (and
+later use) an image without it being altered. Generally used together
+with the "modules_disabled" sysctl.
+
+==============================================================
+
 kptr_restrict:
 
 This toggle indicates whether restrictions are placed on
@@ -331,7 +344,7 @@ A toggle value indicating if modules are
 in an otherwise modular kernel.  This toggle defaults to off
 (0), but can be set true (1).  Once true, modules can be
 neither loaded nor unloaded, and the toggle cannot be set back
-to false.
+to false.  Generally used with the "kexec_load_disabled" toggle.
 
 ==============================================================
 
diff -puN include/linux/kexec.h~kexec-add-sysctl-to-disable-kexec_load include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-add-sysctl-to-disable-kexec_load
+++ a/include/linux/kexec.h
@@ -170,6 +170,7 @@ unsigned long paddr_vmcoreinfo_note(void
 
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
+extern int kexec_load_disabled;
 
 #ifndef kexec_flush_icache_page
 #define kexec_flush_icache_page(page)
diff -puN kernel/kexec.c~kexec-add-sysctl-to-disable-kexec_load kernel/kexec.c
--- a/kernel/kexec.c~kexec-add-sysctl-to-disable-kexec_load
+++ a/kernel/kexec.c
@@ -932,6 +932,7 @@ static int kimage_load_segment(struct ki
  */
 struct kimage *kexec_image;
 struct kimage *kexec_crash_image;
+int kexec_load_disabled;
 
 static DEFINE_MUTEX(kexec_mutex);
 
@@ -942,7 +943,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
 	int result;
 
 	/* We only trust the superuser with rebooting the system. */
-	if (!capable(CAP_SYS_BOOT))
+	if (!capable(CAP_SYS_BOOT) || kexec_load_disabled)
 		return -EPERM;
 
 	/*
diff -puN kernel/sysctl.c~kexec-add-sysctl-to-disable-kexec_load kernel/sysctl.c
--- a/kernel/sysctl.c~kexec-add-sysctl-to-disable-kexec_load
+++ a/kernel/sysctl.c
@@ -62,6 +62,7 @@
 #include <linux/capability.h>
 #include <linux/binfmts.h>
 #include <linux/sched/sysctl.h>
+#include <linux/kexec.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -612,6 +613,18 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_KEXEC
+	{
+		.procname	= "kexec_load_disabled",
+		.data		= &kexec_load_disabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		/* only handle a transition from default "0" to "1" */
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
+		.extra2		= &one,
+	},
+#endif
 #ifdef CONFIG_MODULES
 	{
 		.procname	= "modprobe",
_

Patches currently in -mm which might be from keescook@chromium.org are

test-add-minimal-module-for-verification-testing.patch
test-check-copy_to-from_user-boundary-validation.patch
test-check-copy_to-from_user-boundary-validation-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch
exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch
exec-move-the-final-allow_write_access-fput-into-free_bprm.patch
exec-kill-task_struct-did_exec.patch
fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch
kernel-sysc-k_getrusage-can-use-while_each_thread.patch
kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch
kexec-add-sysctl-to-disable-kexec_load.patch
linux-next.patch

