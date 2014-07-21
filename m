From: akpm@linux-foundation.org
Subject: + fs-dlm-lockd-convert-int-result-to-unsigned-char-type.patch
 added to -mm tree
Date: Mon, 21 Jul 2014 15:24:02 -0700
Message-ID: <53cd9302.Ut9g3yE9bU2Ern/C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:43974 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaGUWYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 18:24:03 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so896757oig.5
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 15:24:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bfields@fieldses.org, ccaulfie@redhat.com, jlayton@poochiereds.net, teigland@redhat.com, trond.myklebust@primarydata.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: dlm/lockd: convert int result to unsigned char type
has been added to the -mm tree.  Its filename is
     fs-dlm-lockd-convert-int-result-to-unsigned-char-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-dlm-lockd-convert-int-result-to-unsigned-char-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-dlm-lockd-convert-int-result-to-unsigned-char-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: fs: dlm/lockd: convert int result to unsigned char type

op->info.rv is an s32, but it's only used as a u8.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Teigland <teigland@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/plock.c     |    6 +++---
 fs/lockd/svclock.c |   10 +++++-----
 include/linux/fs.h |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/dlm/plock.c~fs-dlm-lockd-convert-int-result-to-unsigned-char-type fs/dlm/plock.c
--- a/fs/dlm/plock.c~fs-dlm-lockd-convert-int-result-to-unsigned-char-type
+++ a/fs/dlm/plock.c
@@ -30,7 +30,7 @@ struct plock_op {
 
 struct plock_xop {
 	struct plock_op xop;
-	int (*callback)(struct file_lock *fl, int result);
+	int (*callback)(struct file_lock *fl, unsigned char type);
 	void *fl;
 	void *file;
 	struct file_lock flc;
@@ -190,7 +190,7 @@ static int dlm_plock_callback(struct plo
 	struct file *file;
 	struct file_lock *fl;
 	struct file_lock *flc;
-	int (*notify)(struct file_lock *fl, int result) = NULL;
+	int (*notify)(struct file_lock *fl, unsigned char type) = NULL;
 	struct plock_xop *xop = (struct plock_xop *)op;
 	int rv = 0;
 
@@ -209,7 +209,7 @@ static int dlm_plock_callback(struct plo
 	notify = xop->callback;
 
 	if (op->info.rv) {
-		notify(fl, op->info.rv);
+		notify(fl, (unsigned char)op->info.rv);
 		goto out;
 	}
 
diff -puN fs/lockd/svclock.c~fs-dlm-lockd-convert-int-result-to-unsigned-char-type fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~fs-dlm-lockd-convert-int-result-to-unsigned-char-type
+++ a/fs/lockd/svclock.c
@@ -667,16 +667,16 @@ nlmsvc_cancel_blocked(struct net *net, s
  * deferred rpc for GETLK and SETLK.
  */
 static void
-nlmsvc_update_deferred_block(struct nlm_block *block, int result)
+nlmsvc_update_deferred_block(struct nlm_block *block, unsigned char type)
 {
 	block->b_flags |= B_GOT_CALLBACK;
-	if (result == 0)
+	if (type == 0)
 		block->b_granted = 1;
 	else
 		block->b_flags |= B_TIMED_OUT;
 }
 
-static int nlmsvc_grant_deferred(struct file_lock *fl, int result)
+static int nlmsvc_grant_deferred(struct file_lock *fl, unsigned char type)
 {
 	struct nlm_block *block;
 	int rc = -ENOENT;
@@ -691,8 +691,8 @@ static int nlmsvc_grant_deferred(struct
 					rc = -ENOLCK;
 					break;
 				}
-				nlmsvc_update_deferred_block(block, result);
-			} else if (result == 0)
+				nlmsvc_update_deferred_block(block, type);
+			} else if (type == 0)
 				block->b_granted = 1;
 
 			nlmsvc_insert_block_locked(block, 0);
diff -puN include/linux/fs.h~fs-dlm-lockd-convert-int-result-to-unsigned-char-type include/linux/fs.h
--- a/include/linux/fs.h~fs-dlm-lockd-convert-int-result-to-unsigned-char-type
+++ a/include/linux/fs.h
@@ -842,7 +842,7 @@ struct lock_manager_operations {
 	int (*lm_compare_owner)(struct file_lock *fl1, struct file_lock *fl2);
 	unsigned long (*lm_owner_key)(struct file_lock *fl);
 	void (*lm_notify)(struct file_lock *fl);	/* unblock callback */
-	int (*lm_grant)(struct file_lock *fl, int result);
+	int (*lm_grant)(struct file_lock *fl, unsigned char type);
 	void (*lm_break)(struct file_lock *fl);
 	int (*lm_change)(struct file_lock **fl, int type);
 };
_

Patches currently in -mm which might be from joe@perches.com are

fs-fscache-make-ctl_table-static.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
printk-tweak-do_syslog-to-match-comments.patch
kernelh-remove-deprecated-pack_hex_byte.patch
mm-utilc-add-kstrimdup.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum-declarations.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
checkpatch-warn-on-unnecessary-parentheses-around-references-of-foo-bar.patch
checkpatch-allow-multiple-const-types.patch
checkpatch-improve-no-space-after-cast-test.patch
checkpatch-emit-fewer-kmalloc_array-kcalloc-conversion-warnings.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
checkpatch-emit-a-warning-on-file-add-move-delete.patch
checkpatch-warn-on-break-after-goto-or-return-with-same-tab-indentation.patch
checkpatch-add-an-index-variable-for-fixed-lines.patch
checkpatch-add-ability-to-insert-and-delete-lines-to-patch-file.patch
checkpatch-add-fix_insert_line-and-fix_delete_line-helpers.patch
checkpatch-use-the-correct-indentation-for-which.patch
checkpatch-add-fix-option-for-a-couple-open_brace-misuses.patch
checkpatch-fix-brace-style-misuses-of-else-and-while.patch
checkpatch-add-for_each-tests-to-indentation-and-brace-tests.patch
checkpatch-add-short-int-to-c-variable-types.patch
checkpatch-add-signed-generic-types.patch
checkpatch-add-test-for-native-c90-types-in-unusual-order.patch
fs-isofs-logging-clean-up.patch
proc-constify-seq_operations.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
adfs-add-__printf-verification-fix-format-argument-mismatches.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
linux-next.patch
maintainers-remove-two-ancient-eata-sections.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch
maintainers-update-microcode-patterns.patch
maintainers-update-cifs-location.patch
maintainers-use-the-correct-efi-stub-location.patch
maintainers-update-clk-sirf-patterns.patch
maintainers-fix-ssbi-pattern.patch
maintainers-use-correct-filename-for-sdhci-bcm-kona.patch
maintainers-fix-pxa3xx-nand-flash-driver-pattern.patch
maintainers-update-picoxcell-patterns.patch
maintainers-remove-section-cirrus-logic-ep93xx-ohci-usb-host-driver.patch
maintainers-remove-metag-imgdafs-pattern.patch
maintainers-remove-unused-radeon-drm-pattern.patch
maintainers-remove-unusd-arm-qualcomm-msm-pattern.patch
maintainers-remove-unused-nfsd-pattern.patch
fsh-remove-unnecessary-extern-prototypes.patch
fsh-whitespace-neatening.patch
fsh-a-few-more-whitespace-neatenings.patch
fsh-add-argument-names-to-struct-file_lock_operations-funcs.patch
fsh-add-member-argument-descriptions-to-lock_manager_operations.patch
dlm-plock-add-argument-descriptions-to-notify.patch
dlm-fs-remove-unused-conf-from-lm_grant.patch
dlm-plock-reduce-indentation-by-rearranging-order.patch
fs-dlm-lockd-convert-int-result-to-unsigned-char-type.patch

