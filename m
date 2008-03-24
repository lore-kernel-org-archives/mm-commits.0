From: akpm@linux-foundation.org
Subject: + netdev-cassini-use-shorter-list_splice_init-macro-for-brevity.patch added to -mm tree
Date: Mon, 24 Mar 2008 15:31:06 -0700
Message-ID: <200803242231.m2OMV6Cv028654@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552AbYCXWbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 18:31:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     netdev: cassini: use shorter list_splice_init() macro for brevity
has been added to the -mm tree.  Its filename is
     netdev-cassini-use-shorter-list_splice_init-macro-for-brevity.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
lapb-use-the-shorter-list_head-form-for-brevity.patch
bluetooth-replace-deprecated-rw_lock_unlocked-macros.patch
git-nfsd.patch
git-sparc64.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch
netdev-cassini-use-shorter-list_splice_init-macro-for-brevity.patch

