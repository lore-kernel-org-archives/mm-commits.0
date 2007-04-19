From: akpm@linux-foundation.org
Subject: - execc-fix-coredump-to-pipe-problem-and-obscure-security.patch removed from -mm tree
Date: Thu, 19 Apr 2007 13:01:38 -0700
Message-ID: <200704192001.l3JK1c9q029309@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767008AbXDSUDN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 16:03:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, caker@theshore.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     exec.c: fix coredump to pipe problem and obscure "security hole"
has been removed from the -mm tree.  Its filename was
     execc-fix-coredump-to-pipe-problem-and-obscure-security.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: exec.c: fix coredump to pipe problem and obscure "security hole"
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The patch checks for "|" in the pattern not the output and doesn't nail a
pid on to a piped name (as it is a program name not a file)

Also fixes a very very obscure security corner case.  If you happen to have
decided on a core pattern that starts with the program name then the user
can run a program called "|myevilhack" as it stands.  I doubt anyone does
this.

Signed-off-by: Alan Cox <alan@redhat.com>
Confirmed-by: Christopher S. Aker <caker@theshore.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN fs/exec.c~execc-fix-coredump-to-pipe-problem-and-obscure-security fs/exec.c
--- a/fs/exec.c~execc-fix-coredump-to-pipe-problem-and-obscure-security
+++ a/fs/exec.c
@@ -1244,13 +1244,17 @@ EXPORT_SYMBOL(set_binfmt);
  * name into corename, which must have space for at least
  * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
  */
-static void format_corename(char *corename, const char *pattern, long signr)
+static int format_corename(char *corename, const char *pattern, long signr)
 {
 	const char *pat_ptr = pattern;
 	char *out_ptr = corename;
 	char *const out_end = corename + CORENAME_MAX_SIZE;
 	int rc;
 	int pid_in_pattern = 0;
+	int ispipe = 0;
+
+	if (*pattern == '|')
+		ispipe = 1;
 
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
@@ -1341,8 +1345,8 @@ static void format_corename(char *corena
 	 *
 	 * If core_pattern does not include a %p (as is the default)
 	 * and core_uses_pid is set, then .%pid will be appended to
-	 * the filename */
-	if (!pid_in_pattern
+	 * the filename. Do not do this for piped commands. */
+	if (!ispipe && !pid_in_pattern
             && (core_uses_pid || atomic_read(&current->mm->mm_users) != 1)) {
 		rc = snprintf(out_ptr, out_end - out_ptr,
 			      ".%d", current->tgid);
@@ -1350,8 +1354,9 @@ static void format_corename(char *corena
 			goto out;
 		out_ptr += rc;
 	}
-      out:
+out:
 	*out_ptr = 0;
+	return ispipe;
 }
 
 static void zap_process(struct task_struct *start)
@@ -1502,16 +1507,15 @@ int do_coredump(long signr, int exit_cod
 	 * uses lock_kernel()
 	 */
  	lock_kernel();
-	format_corename(corename, core_pattern, signr);
+	ispipe = format_corename(corename, core_pattern, signr);
 	unlock_kernel();
- 	if (corename[0] == '|') {
+ 	if (ispipe) {
 		/* SIGPIPE can happen, but it's just never processed */
  		if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
  			goto fail_unlock;
  		}
-		ispipe = 1;
  	} else
  		file = filp_open(corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma-fix.patch
git-netdev-all.patch
pcmcia-irq-probe-can-be-done-without-risking-an-irq-storm.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
protect-tty-drivers-list-with-tty_mutex.patch
fix-82875-pci-setup.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
remove-redundant-check-from-proc_sys_setattr.patch
apm-fix-incorrect-comment.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
