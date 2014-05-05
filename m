From: akpm@linux-foundation.org
Subject: + kernel-exec_domainc-code-clean-up.patch added to -mm tree
Date: Mon, 05 May 2014 13:14:04 -0700
Message-ID: <5367f10c.5KrT6jquRL06IHok%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaEEUOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 16:14:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + kernel-exec_domainc-code-clean-up.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 13:14:04 -0700


The patch titled
     Subject: kernel/exec_domain.c: code clean-up
has been added to the -mm tree.  Its filename is
     kernel-exec_domainc-code-clean-up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-exec_domainc-code-clean-up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-exec_domainc-code-clean-up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/exec_domain.c: code clean-up

Fix checkpatch warnings about EXPORT_SYMBOL and return()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exec_domain.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN kernel/exec_domain.c~kernel-exec_domainc-code-clean-up kernel/exec_domain.c
--- a/kernel/exec_domain.c~kernel-exec_domainc-code-clean-up
+++ a/kernel/exec_domain.c
@@ -37,7 +37,7 @@ static unsigned long ident_map[32] = {
 struct exec_domain default_exec_domain = {
 	.name		= "Linux",		/* name */
 	.handler	= default_handler,	/* lcall7 causes a seg fault. */
-	.pers_low	= 0, 			/* PER_LINUX personality. */
+	.pers_low	= 0,			/* PER_LINUX personality. */
 	.pers_high	= 0,			/* PER_LINUX personality. */
 	.signal_map	= ident_map,		/* Identity map signals. */
 	.signal_invmap	= ident_map,		/*  - both ways. */
@@ -83,7 +83,7 @@ lookup_exec_domain(unsigned int personal
 	ep = &default_exec_domain;
 out:
 	read_unlock(&exec_domains_lock);
-	return (ep);
+	return ep;
 }
 
 int
@@ -110,8 +110,9 @@ register_exec_domain(struct exec_domain
 
 out:
 	write_unlock(&exec_domains_lock);
-	return (err);
+	return err;
 }
+EXPORT_SYMBOL(register_exec_domain);
 
 int
 unregister_exec_domain(struct exec_domain *ep)
@@ -133,6 +134,7 @@ unregister:
 	write_unlock(&exec_domains_lock);
 	return 0;
 }
+EXPORT_SYMBOL(unregister_exec_domain);
 
 int __set_personality(unsigned int personality)
 {
@@ -144,6 +146,7 @@ int __set_personality(unsigned int perso
 
 	return 0;
 }
+EXPORT_SYMBOL(__set_personality);
 
 #ifdef CONFIG_PROC_FS
 static int execdomains_proc_show(struct seq_file *m, void *v)
@@ -188,8 +191,3 @@ SYSCALL_DEFINE1(personality, unsigned in
 
 	return old;
 }
-
-
-EXPORT_SYMBOL(register_exec_domain);
-EXPORT_SYMBOL(unregister_exec_domain);
-EXPORT_SYMBOL(__set_personality);
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
init-mainc-code-clean-up.patch
ufs-sb-mutex-merge-mutex_destroy.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
kernel-exec_domainc-code-clean-up.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-cpusetc-kernel-doc-fixes.patch
kernel-cpusetc-convert-printk-to-pr_foo.patch

