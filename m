From: akpm@linux-foundation.org
Subject: - netdev-cassini-use-shorter-list_splice_init-macro-for-brevity.patch removed from -mm tree
Date: Mon, 24 Mar 2008 17:19:27 -0700
Message-ID: <200803250019.m2P0JRVK032686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226AbYCYA3F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 20:29:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     netdev: cassini: use shorter list_splice_init() macro for brevity
has been removed from the -mm tree.  Its filename was
     netdev-cassini-use-shorter-list_splice_init-macro-for-brevity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netdev: cassini: use shorter list_splice_init() macro for brevity
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cassini.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/net/cassini.c~netdev-cassini-use-shorter-list_splice_init-macro-for-brevity drivers/net/cassini.c
--- a/drivers/net/cassini.c~netdev-cassini-use-shorter-list_splice_init-macro-for-brevity
+++ a/drivers/net/cassini.c
@@ -532,8 +532,7 @@ static void cas_spare_free(struct cas *c
 	/* free spare buffers */
 	INIT_LIST_HEAD(&list);
 	spin_lock(&cp->rx_spare_lock);
-	list_splice(&cp->rx_spare_list, &list);
-	INIT_LIST_HEAD(&cp->rx_spare_list);
+	list_splice_init(&cp->rx_spare_list, &list);
 	spin_unlock(&cp->rx_spare_lock);
 	list_for_each_safe(elem, tmp, &list) {
 		cas_page_free(cp, list_entry(elem, cas_page_t, list));
@@ -546,13 +545,11 @@ static void cas_spare_free(struct cas *c
 	 * lock than used everywhere else to manipulate this list.
 	 */
 	spin_lock(&cp->rx_inuse_lock);
-	list_splice(&cp->rx_inuse_list, &list);
-	INIT_LIST_HEAD(&cp->rx_inuse_list);
+	list_splice_init(&cp->rx_inuse_list, &list);
 	spin_unlock(&cp->rx_inuse_lock);
 #else
 	spin_lock(&cp->rx_spare_lock);
-	list_splice(&cp->rx_inuse_list, &list);
-	INIT_LIST_HEAD(&cp->rx_inuse_list);
+	list_splice_init(&cp->rx_inuse_list, &list);
 	spin_unlock(&cp->rx_spare_lock);
 #endif
 	list_for_each_safe(elem, tmp, &list) {
@@ -573,8 +570,7 @@ static void cas_spare_recover(struct cas
 	/* make a local copy of the list */
 	INIT_LIST_HEAD(&list);
 	spin_lock(&cp->rx_inuse_lock);
-	list_splice(&cp->rx_inuse_list, &list);
-	INIT_LIST_HEAD(&cp->rx_inuse_list);
+	list_splice_init(&cp->rx_inuse_list, &list);
 	spin_unlock(&cp->rx_inuse_lock);
 
 	list_for_each_safe(elem, tmp, &list) {
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-ieee1394.patch
infiniband-use-shorter-list_splice_init-for-brevity.patch
git-net.patch
lapb-use-the-shorter-list_head-form-for-brevity.patch
bluetooth-replace-deprecated-rw_lock_unlocked-macros.patch
git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch

