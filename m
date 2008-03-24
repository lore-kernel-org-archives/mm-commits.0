From: akpm@linux-foundation.org
Subject: + lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch added to -mm tree
Date: Mon, 24 Mar 2008 15:32:21 -0700
Message-ID: <200803242232.m2OMWLpK028695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753519AbYCXWcx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 18:32:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     lists: add "const" qualifier to first arg of list_splice() operations
has been added to the -mm tree.  Its filename is
     lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch

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
Subject: lists: add "const" qualifier to first arg of list_splice() operations
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Since neither the list_splice() nor __list_splice() routines modify their
first argument, might as well declare them "const".

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/list.h~lists-add-const-qualifier-to-first-arg-of-list_splice-operations include/linux/list.h
--- a/include/linux/list.h~lists-add-const-qualifier-to-first-arg-of-list_splice-operations
+++ a/include/linux/list.h
@@ -220,7 +220,7 @@ static inline int list_is_singular(const
 	return !list_empty(head) && (head->next == head->prev);
 }
 
-static inline void __list_splice(struct list_head *list,
+static inline void __list_splice(const struct list_head *list,
 				 struct list_head *head)
 {
 	struct list_head *first = list->next;
@@ -239,7 +239,7 @@ static inline void __list_splice(struct 
  * @list: the new list to add.
  * @head: the place to add it in the first list.
  */
-static inline void list_splice(struct list_head *list, struct list_head *head)
+static inline void list_splice(const struct list_head *list, struct list_head *head)
 {
 	if (!list_empty(list))
 		__list_splice(list, head);
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-ieee1394.patch
infiniband-use-shorter-list_splice_init-for-brevity.patch
lapb-use-the-shorter-list_head-form-for-brevity.patch
bluetooth-replace-deprecated-rw_lock_unlocked-macros.patch
netdev-cassini-use-shorter-list_splice_init-macro-for-brevity.patch
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
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch

