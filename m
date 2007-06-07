From: akpm@linux-foundation.org
Subject: + mac80211-fix-1-bit-bitfield-to-unsigned.patch added to -mm tree
Date: Wed, 06 Jun 2007 19:01:55 -0700
Message-ID: <200706070201.l5721t0x018423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762605AbXFGCCH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 22:02:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     mac80211: fix 1-bit bitfield to unsigned
has been added to the -mm tree.  Its filename is
     mac80211-fix-1-bit-bitfield-to-unsigned.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mac80211: fix 1-bit bitfield to unsigned
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix 17 of these pairs of sparse warnings since it's difficult for a 1-bit
bitfield to have both a value bit and a sign bit.

net/mac80211/sta_info.h:105:16: error: dubious bitfield without explicit `signed' or `unsigned'
net/mac80211/sta_info.h:107:15: error: dubious bitfield without explicit `signed' or `unsigned'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/sta_info.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN net/mac80211/sta_info.h~mac80211-fix-1-bit-bitfield-to-unsigned net/mac80211/sta_info.h
--- a/net/mac80211/sta_info.h~mac80211-fix-1-bit-bitfield-to-unsigned
+++ a/net/mac80211/sta_info.h
@@ -102,9 +102,9 @@ struct sta_info {
 #ifdef CONFIG_MAC80211_DEBUGFS
 	int debugfs_registered;
 #endif
-	int assoc_ap:1; /* whether this is an AP that we are
-			 * associated with as a client */
-	int dls_sta:1; /* whether this stations is a DLS peer of us */
+	unsigned int assoc_ap:1; /* whether this is an AP that we are
+				  * associated with as a client */
+	unsigned int dls_sta:1; /* whether this stations is a DLS peer of us */
 
 #define DLS_STATUS_OK		0
 #define DLS_STATUS_NOLINK	1
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

mount-t-tmpfs-o-mpol=-check-nodes-online.patch
isdn-diva-fix-section-mismatch.patch
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
hexdump-more-output-formatting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
sony-laptop-use-null-for-pointer.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
