From: akpm@linux-foundation.org
Subject: + checkpatch-catch-struct-foo-blah.patch added to -mm tree
Date: Thu, 07 Jun 2007 23:02:11 -0700
Message-ID: <200706080602.l5862BhI020702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37486 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760737AbXFHGCy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:02:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, apw@shadowen.org


The patch titled
     checkpatch: catch "struct foo * blah"
has been added to the -mm tree.  Its filename is
     checkpatch-catch-struct-foo-blah.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: checkpatch: catch "struct foo * blah"
From: Randy Dunlap <randy.dunlap@oracle.com>

Catch "struct foo * blah" by allowing spaces preceding the '*'.  Bah. 
Maybe the error string needs a small change also.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-catch-struct-foo-blah scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-catch-struct-foo-blah
+++ a/scripts/checkpatch.pl
@@ -393,7 +393,7 @@ sub process {
 		}
 
 # * goes on variable not on type
-		if ($line=~/[A-Za-z\d_]+\* [A-Za-z\d_]+/) {
+		if ($line=~/[\sA-Za-z\d_]+\* [A-Za-z\d_]+/) {
 			print "\"foo* bar\" should be \"foo *bar\"\n";
 			print "$herecurr";
 			$clean = 0;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

mount-t-tmpfs-o-mpol=-check-nodes-online.patch
isdn-diva-fix-section-mismatch.patch
hexdump-more-output-formatting.patch
checkpatch-catch-struct-foo-blah.patch
git-acpi.patch
toshica_acpi-fix-section-mismatch-in-allyesconfig.patch
romfs-printk-format-warnings.patch
mtd-use-null-for-pointer.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
add-pci_try_set_mwi-prism54pci.patch
mac80211-fix-1-bit-bitfield-to-unsigned.patch
git-ipwireless_cs.patch
x86_64-use-null-for-pointer.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
sony-laptop-use-null-for-pointer.patch
hugetlbfs-use-lib-parser-fix-docs.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
schedstats-fix-printk-format.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
