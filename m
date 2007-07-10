From: akpm@linux-foundation.org
Subject: - block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:49:32 -0700
Message-ID: <200707101949.l6AJnWCW026106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760077AbXGJTzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:55:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Block device elevator: use list_for_each_entry() instead of list_for_each()
has been removed from the -mm tree.  Its filename was
     block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Block device elevator: use list_for_each_entry() instead of list_for_each()
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Use list_for_each_entry() instead of list_for_each() in the block device
elevator

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/elevator.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff -puN block/elevator.c~block-device-elevator-use-list_for_each_entry-instead-of-list_for_each block/elevator.c
--- a/block/elevator.c~block-device-elevator-use-list_for_each_entry-instead-of-list_for_each
+++ a/block/elevator.c
@@ -112,12 +112,8 @@ static inline int elv_try_merge(struct r
 static struct elevator_type *elevator_find(const char *name)
 {
 	struct elevator_type *e;
-	struct list_head *entry;
-
-	list_for_each(entry, &elv_list) {
-
-		e = list_entry(entry, struct elevator_type, list);
 
+	list_for_each_entry(e, &elv_list, list) {
 		if (!strcmp(e->elevator_name, name))
 			return e;
 	}
@@ -1116,14 +1112,11 @@ ssize_t elv_iosched_show(request_queue_t
 {
 	elevator_t *e = q->elevator;
 	struct elevator_type *elv = e->elevator_type;
-	struct list_head *entry;
+	struct elevator_type *__e;
 	int len = 0;
 
 	spin_lock(&elv_list_lock);
-	list_for_each(entry, &elv_list) {
-		struct elevator_type *__e;
-
-		__e = list_entry(entry, struct elevator_type, list);
+	list_for_each_entry(__e, &elv_list, list) {
 		if (!strcmp(elv->elevator_name, __e->elevator_name))
 			len += sprintf(name+len, "[%s] ", elv->elevator_name);
 		else
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
kcopyd-use-mutex-instead-of-semaphore.patch
git-dvb.patch
git-mtd.patch
git-net.patch
use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver.patch
git-block.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
drivers-block-ubc-use-list_for_each_entry.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
fs-block_devc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
