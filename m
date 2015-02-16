From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-of_device_id-to-structs-that-should-be-const.patch removed
 from -mm tree
Date: Mon, 16 Feb 2015 12:17:38 -0800
Message-ID: <54e25062.BgfD/v0LW1e5Y4aE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbbBPUSO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:18:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, robh@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add of_device_id to structs that should be const
has been removed from the -mm tree.  Its filename was
     checkpatch-add-of_device_id-to-structs-that-should-be-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add of_device_id to structs that should be const

Uses of struct of_device_id are most commonly const.

Suggest using it as such.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Rob Herring <robh@kernel.org>
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

origin.patch
mm-utilc-add-kstrimdup.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

