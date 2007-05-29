From: akpm@linux-foundation.org
Subject: + block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch added to -mm tree
Date: Tue, 29 May 2007 16:08:57 -0700
Message-ID: <200705292308.l4TN8vXp013981@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbXE2XLa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 19:11:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, jens.axboe@oracle.com


The patch titled
     Block device elevator: use list_for_each_entry() instead of list_for_each()
has been added to the -mm tree.  Its filename is
     block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kcopyd-use-mutex-instead-of-semaphore.patch
power-management-use-mutexes-instead-of-semaphores.patch
sysdev-use-mutex-instead-of-semaphore.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch
use-list_for_each_entry-for-iteration-in-hostap_apc.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
