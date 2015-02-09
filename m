From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-of_device_id-to-structs-that-should-be-const.patch added to
 -mm tree
Date: Mon, 09 Feb 2015 12:56:46 -0800
Message-ID: <54d91f0e.Kz48+BKl8gKE4VVc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759332AbbBIU4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2015 15:56:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add of_device_id to structs that should be const
has been added to the -mm tree.  Its filename is
     checkpatch-add-of_device_id-to-structs-that-should-be-const.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-of_device_id-to-structs-that-should-be-const.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-of_device_id-to-structs-that-should-be-const.patch

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
Subject: checkpatch: add of_device_id to structs that should be const

Uses of struct of_device_id are most commonly const.

Suggest using it as such.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-of_device_id-to-structs-that-should-be-const scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-of_device_id-to-structs-that-should-be-const
+++ a/scripts/checkpatch.pl
@@ -5223,8 +5223,9 @@ sub process {
 			     "please use device_initcall() or more appropriate function instead of __initcall() (see include/linux/init.h)\n" . $herecurr);
 		}
 
-# check for various ops structs, ensure they are const.
-		my $struct_ops = qr{acpi_dock_ops|
+# check for various structs that are normally const (ops, kgdb, device_tree)
+		my $const_structs = qr{
+				acpi_dock_ops|
 				address_space_operations|
 				backlight_ops|
 				block_device_operations|
@@ -5247,6 +5248,7 @@ sub process {
 				mtrr_ops|
 				neigh_ops|
 				nlmsvc_binding|
+				of_device_id|
 				pci_raw_ops|
 				pipe_buf_operations|
 				platform_hibernation_ops|
@@ -5262,7 +5264,7 @@ sub process {
 				usb_mon_operations|
 				wd_ops}x;
 		if ($line !~ /\bconst\b/ &&
-		    $line =~ /\bstruct\s+($struct_ops)\b/) {
+		    $line =~ /\bstruct\s+($const_structs)\b/) {
 			WARN("CONST_STRUCT",
 			     "struct $1 should normally be const\n" .
 				$herecurr);
_

Patches currently in -mm which might be from joe@perches.com are

kernelh-remove-ancient-__function__-hack.patch
kernelh-remove-ancient-__function__-hack-fix.patch
printk-correct-timeout-comment-neaten-module_parm_desc.patch
mm-utilc-add-kstrimdup.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
checkpatch-improve-octal-permissions-tests.patch
checkpatch-ignore-__pure-attribute.patch
checkpatch-fix-unnecessary_kern_level-false-positive.patch
checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions.patch
checkpatch-allow-comments-in-macros-tested-for-single-statements.patch
checkpatch-update-git-commit-message.patch
checkpatch-add-likely-unlikely-comparison-misuse-test.patch
checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines.patch
checkpatch-add-types-for-other-os-typedefs.patch
checkpatch-add-ability-to-fix-unnecessary-blank-lines-around-braces.patch
checkpatch-improve-seq_print-seq_puts-suggestion.patch
checkpatch-improve-no-space-necessary-after-cast-test.patch
checkpatch-neaten-printk_ratelimited-message-position.patch
checkpatch-add-strict-test-for-spaces-around-arithmetic.patch
checkpatch-make-sure-a-commit-reference-description-uses-parentheses.patch
checkpatch-try-to-avoid-poor-patch-subject-lines.patch
checkpatch-add-of_device_id-to-structs-that-should-be-const.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

