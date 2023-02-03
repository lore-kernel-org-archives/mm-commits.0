Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B27C6379F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjBCGmv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbjBCGld (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6427A449A
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B3FAB8297E
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467E3C4339B;
        Fri,  3 Feb 2023 06:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406284;
        bh=Fmft81uxjwY6dmqsSfqveOVK2U8AroxiVDRYvGbnTDA=;
        h=Date:To:From:Subject:From;
        b=2LfAXPAuRuSn1ue4to5HA350ijmWwXQ7Hyr9I5aavJHvJIMERMUaO1K/9amv0wWXL
         O14DQvKuon0lmjZRdm6e22giLjvhhDvI6j8qcLpNJnyXrrfbrzELnFDoUbOeqRB35/
         sb6kbpimpABGZgs/1k40IC/a5nCagreg6tPbXm44=
Date:   Thu, 02 Feb 2023 22:38:03 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        catalin.marinas@arm.com, longman@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-fix-uaf-bug-in-kmemleak_scan.patch removed from -mm tree
Message-Id: <20230203063804.467E3C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kmemleak: fix UAF bug in kmemleak_scan()
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-fix-uaf-bug-in-kmemleak_scan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/kmemleak: fix UAF bug in kmemleak_scan()
Date: Wed, 18 Jan 2023 23:01:11 -0500

Commit 6edda04ccc7c ("mm/kmemleak: prevent soft lockup in first object
iteration loop of kmemleak_scan()") fixes soft lockup problem in
kmemleak_scan() by periodically doing a cond_resched().  It does take a
reference of the current object before doing it.  Unfortunately, if the
object has been deleted from the object_list, the next object pointed to
by its next pointer may no longer be valid after coming back from
cond_resched().  This can result in use-after-free and other nasty
problem.

Fix this problem by adding a del_state flag into kmemleak_object structure
to synchronize the object deletion process between kmemleak_cond_resched()
and __remove_object() to make sure that the object remained in the
object_list in the duration of the cond_resched() call.

Link: https://lkml.kernel.org/r/20230119040111.350923-3-longman@redhat.com
Fixes: 6edda04ccc7c ("mm/kmemleak: prevent soft lockup in first object iteration loop of kmemleak_scan()")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kmemleak.c~mm-kmemleak-fix-uaf-bug-in-kmemleak_scan
+++ a/mm/kmemleak.c
@@ -13,11 +13,12 @@
  *
  * The following locks and mutexes are used by kmemleak:
  *
- * - kmemleak_lock (raw_spinlock_t): protects the object_list modifications and
- *   accesses to the object_tree_root (or object_phys_tree_root). The
- *   object_list is the main list holding the metadata (struct kmemleak_object)
- *   for the allocated memory blocks. The object_tree_root and object_phys_tree_root
- *   are red black trees used to look-up metadata based on a pointer to the
+ * - kmemleak_lock (raw_spinlock_t): protects the object_list as well as
+ *   del_state modifications and accesses to the object_tree_root (or
+ *   object_phys_tree_root). The object_list is the main list holding the
+ *   metadata (struct kmemleak_object) for the allocated memory blocks.
+ *   The object_tree_root and object_phys_tree_root are red
+ *   black trees used to look-up metadata based on a pointer to the
  *   corresponding memory block. The object_phys_tree_root is for objects
  *   allocated with physical address. The kmemleak_object structures are
  *   added to the object_list and object_tree_root (or object_phys_tree_root)
@@ -148,6 +149,7 @@ struct kmemleak_object {
 	struct rcu_head rcu;		/* object_list lockless traversal */
 	/* object usage count; object freed when use_count == 0 */
 	atomic_t use_count;
+	unsigned int del_state;		/* deletion state */
 	unsigned long pointer;
 	size_t size;
 	/* pass surplus references to this pointer */
@@ -177,6 +179,11 @@ struct kmemleak_object {
 /* flag set for object allocated with physical address */
 #define OBJECT_PHYS		(1 << 4)
 
+/* set when __remove_object() called */
+#define DELSTATE_REMOVED	(1 << 0)
+/* set to temporarily prevent deletion from object_list */
+#define DELSTATE_NO_DELETE	(1 << 1)
+
 #define HEX_PREFIX		"    "
 /* number of bytes to print per line; must be 16 or 32 */
 #define HEX_ROW_SIZE		16
@@ -571,7 +578,9 @@ static void __remove_object(struct kmeml
 	rb_erase(&object->rb_node, object->flags & OBJECT_PHYS ?
 				   &object_phys_tree_root :
 				   &object_tree_root);
-	list_del_rcu(&object->object_list);
+	if (!(object->del_state & DELSTATE_NO_DELETE))
+		list_del_rcu(&object->object_list);
+	object->del_state |= DELSTATE_REMOVED;
 }
 
 /*
@@ -643,6 +652,7 @@ static void __create_object(unsigned lon
 	object->count = 0;			/* white color initially */
 	object->jiffies = jiffies;
 	object->checksum = 0;
+	object->del_state = 0;
 
 	/* task information */
 	if (in_hardirq()) {
@@ -1479,9 +1489,22 @@ static void kmemleak_cond_resched(struct
 	if (!get_object(object))
 		return;	/* Try next object */
 
+	raw_spin_lock_irq(&kmemleak_lock);
+	if (object->del_state & DELSTATE_REMOVED)
+		goto unlock_put;	/* Object removed */
+	object->del_state |= DELSTATE_NO_DELETE;
+	raw_spin_unlock_irq(&kmemleak_lock);
+
 	rcu_read_unlock();
 	cond_resched();
 	rcu_read_lock();
+
+	raw_spin_lock_irq(&kmemleak_lock);
+	if (object->del_state & DELSTATE_REMOVED)
+		list_del_rcu(&object->object_list);
+	object->del_state &= ~DELSTATE_NO_DELETE;
+unlock_put:
+	raw_spin_unlock_irq(&kmemleak_lock);
 	put_object(object);
 }
 
_

Patches currently in -mm which might be from longman@redhat.com are


