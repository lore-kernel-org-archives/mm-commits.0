From: akpm@linux-foundation.org
Subject: [merged] idr-refactor-idr_get_new_above.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:06 -0800
Message-ID: <20130228201306.939F731C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:34313 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab3B1UNH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:07 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so244836vea.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: refactor idr_get_new_above()
has been removed from the -mm tree.  Its filename was
     idr-refactor-idr_get_new_above.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: idr: refactor idr_get_new_above()

Move slot filling to idr_fill_slot() from idr_get_new_above_int() and
make idr_get_new_above() directly call it.  idr_get_new_above_int() is
no longer needed and removed.

This will be used to implement a new ID allocation interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff -puN lib/idr.c~idr-refactor-idr_get_new_above lib/idr.c
--- a/lib/idr.c~idr-refactor-idr_get_new_above
+++ a/lib/idr.c
@@ -278,24 +278,15 @@ build_up:
 	return(v);
 }
 
-static int idr_get_new_above_int(struct idr *idp, void *ptr, int starting_id)
-{
-	struct idr_layer *pa[MAX_IDR_LEVEL];
-	int id;
-
-	id = idr_get_empty_slot(idp, starting_id, pa);
-	if (id >= 0) {
-		/*
-		 * Successfully found an empty slot.  Install the user
-		 * pointer and mark the slot full.
-		 */
-		rcu_assign_pointer(pa[0]->ary[id & IDR_MASK],
-				(struct idr_layer *)ptr);
-		pa[0]->count++;
-		idr_mark_full(pa, id);
-	}
-
-	return id;
+/*
+ * @id and @pa are from a successful allocation from idr_get_empty_slot().
+ * Install the user pointer @ptr and mark the slot full.
+ */
+static void idr_fill_slot(void *ptr, int id, struct idr_layer **pa)
+{
+	rcu_assign_pointer(pa[0]->ary[id & IDR_MASK], (struct idr_layer *)ptr);
+	pa[0]->count++;
+	idr_mark_full(pa, id);
 }
 
 /**
@@ -318,11 +309,14 @@ static int idr_get_new_above_int(struct 
  */
 int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id)
 {
+	struct idr_layer *pa[MAX_IDR_LEVEL];
 	int rv;
 
-	rv = idr_get_new_above_int(idp, ptr, starting_id);
+	rv = idr_get_empty_slot(idp, starting_id, pa);
 	if (rv < 0)
 		return rv == -ENOMEM ? -EAGAIN : rv;
+
+	idr_fill_slot(ptr, rv, pa);
 	*id = rv;
 	return 0;
 }
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

