From: akpm@linux-foundation.org
Subject: + fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:08:00 -0700
Message-ID: <200707210008.l6L080rU023484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50134 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753466AbXGUAIH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:08:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     fs/super.c: use list_for_each_entry() instead of list_for_each()
has been added to the -mm tree.  Its filename is
     fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/super.c: use list_for_each_entry() instead of list_for_each()
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

fs/super.c: use list_for_each_entry() instead of list_for_each() in
sget()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/super.c~fs-superc-use-list_for_each_entry-instead-of-list_for_each fs/super.c
--- a/fs/super.c~fs-superc-use-list_for_each_entry-instead-of-list_for_each
+++ a/fs/super.c
@@ -332,14 +332,12 @@ struct super_block *sget(struct file_sys
 			void *data)
 {
 	struct super_block *s = NULL;
-	struct list_head *p;
+	struct super_block *old;
 	int err;
 
 retry:
 	spin_lock(&sb_lock);
-	if (test) list_for_each(p, &type->fs_supers) {
-		struct super_block *old;
-		old = list_entry(p, struct super_block, s_instances);
+	if (test) list_for_each_entry(old, &type->fs_supers, s_instances) {
 		if (!test(old, data))
 			continue;
 		if (!grab_super(old))
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
kcopyd-use-mutex-instead-of-semaphore.patch
git-mtd.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
