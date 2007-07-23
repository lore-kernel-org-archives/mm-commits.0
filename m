From: akpm@linux-foundation.org
Subject: + kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:33:02 -0700
Message-ID: <200707232133.l6NLX2bZ012943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38962 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757649AbXGWVdL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:33:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     kernel/user.c: Use list_for_each_entry instead of list_for_each
has been added to the -mm tree.  Its filename is
     kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/user.c: Use list_for_each_entry instead of list_for_each
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

kernel/user.c: Convert list_for_each to list_for_each_entry in
uid_hash_find()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff -puN kernel/user.c~kernel-userc-use-list_for_each_entry-instead-of-list_for_each kernel/user.c
--- a/kernel/user.c~kernel-userc-use-list_for_each_entry-instead-of-list_for_each
+++ a/kernel/user.c
@@ -67,13 +67,9 @@ static inline void uid_hash_remove(struc
 
 static inline struct user_struct *uid_hash_find(uid_t uid, struct list_head *hashent)
 {
-	struct list_head *up;
-
-	list_for_each(up, hashent) {
-		struct user_struct *user;
-
-		user = list_entry(up, struct user_struct, uidhash_list);
+	struct user_struct *user;
 
+	list_for_each_entry(user, hashent, uidhash_list) {
 		if(user->uid == uid) {
 			atomic_inc(&user->__count);
 			return user;
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

kcopyd-use-mutex-instead-of-semaphore.patch
git-mtd.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch
