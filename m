From: akpm@linux-foundation.org
Subject: +
 scripts-coccinelle-free-add-null-test-before-freeing-functions.patch added
 to -mm tree
Date: Mon, 30 Jun 2014 16:35:26 -0700
Message-ID: <53b1f43e.Bm1QstxGV3jD/m2y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:54508 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaF3Xf1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jun 2014 19:35:27 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so2049326obb.2
        for <mm-commits@vger.kernel.org>; Mon, 30 Jun 2014 16:35:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, Gilles.Muller@lip6.fr, Julia.Lawall@lip6.fr, elfring@users.sourceforge.net, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/coccinelle/free: add NULL test before freeing functions
has been added to the -mm tree.  Its filename is
     scripts-coccinelle-free-add-null-test-before-freeing-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-coccinelle-free-add-null-test-before-freeing-functions.patch

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
Subject: scripts/coccinelle/free: add NULL test before freeing functions

Warns or generates patch for NULL check before the following functions:

kfree
usb_free_urb
debugfs_remove
debugfs_remove_recursive

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>
Cc: Joe Perches <joe@perches.com>
Cc: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/coccinelle/free/ifnullfree.cocci |   53 +++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff -puN /dev/null scripts/coccinelle/free/ifnullfree.cocci
--- /dev/null
+++ a/scripts/coccinelle/free/ifnullfree.cocci
@@ -0,0 +1,53 @@
+/// NULL check before some freeing functions is not needed.
+///
+/// Based on checkpatch warning
+/// "kfree(NULL) is safe this check is probably not required"
+/// and kfreeaddr.cocci by Julia Lawall.
+///
+/// Comments: -
+/// Options: --no-includes --include-headers
+
+virtual patch
+virtual org
+virtual report
+virtual context
+
+@r2 depends on patch@
+expression E;
+@@
+- if (E)
+(
+-	kfree(E);
++ kfree(E);
+|
+-	debugfs_remove(E);
++ debugfs_remove(E);
+|
+-	debugfs_remove_recursive(E);
++ debugfs_remove_recursive(E);
+|
+-	usb_free_urb(E);
++ usb_free_urb(E);
+)
+
+@r depends on context || report || org @
+expression E;
+position p;
+@@
+
+* if (E)
+*	\(kfree@p\|debugfs_remove@p\|debugfs_remove_recursive@p\|usb_free_urb\)(E);
+
+@script:python depends on org@
+p << r.p;
+@@
+
+cocci.print_main("NULL check before that freeing function is not needed", p)
+
+@script:python depends on report@
+p << r.p;
+@@
+
+msg = "WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values."
+coccilib.report.print_report(p[0], msg)
+
_

Patches currently in -mm which might be from fabf@skynet.be are

kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-squashfs-superc-logging-clean-up.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-ocfs2-slot_mapc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mm-internalh-use-nth_page.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
lib-test-kstrtoxc-use-array_size-instead-of-sizeof-sizeof.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
fs-ufs-convert-printk-to-pr_foo.patch
fs-ufs-use-pr_fmt.patch
fs-ufs-superc-use-__func__-in-logging.patch
fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch
fs-ufs-convert-ufsd-printk-to-pr_debug.patch
fs-reiserfs-replace-not-standard-%lu-%ld.patch
fs-reiserfs-use-linux-uaccessh.patch
fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
proc-constify-seq_operations.patch
fs-exofs-ore_raidc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-gcov-fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
fs-adfs-dir_fplusc-replace-countsize-kzalloc-by-kcalloc.patch
drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch
fs-pstore-ram_corec-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
fs-omfs-inodec-replace-countsize-kzalloc-by-kcalloc.patch
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

