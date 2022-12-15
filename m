Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE979C4167B
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 21:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiLOVFX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 16:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiLOVFW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 16:05:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB2E537F8
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 13:05:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEFE3B81C86
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 21:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC5BC433D2;
        Thu, 15 Dec 2022 21:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671138318;
        bh=RnOxv89kUOMWxNmzIkbOWyZWHI0QrxHl9dON8f/+c7Y=;
        h=Date:To:From:Subject:From;
        b=oN/QZI0fuxH5au5iGFBK2jF5LvZBmrABgcj1KmMzzFoSUbjJbKIlKcfA4hJz/eB8v
         tQ7ylf1dFjuyZaPW+6Lmqq7OGEgkb4+PnXQZIDKFJcxAEleqs8NcmgH6G6a6vbq/ab
         O9EbcEdZiAZqD+KrbF8W1qbUlG5A0YuOmebH01Jg=
Date:   Thu, 15 Dec 2022 13:05:18 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        catalin.marinas@arm.com, longman@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-fix-uaf-bug-in-kmemleak_scan.patch added to mm-unstable branch
Message-Id: <20221215210518.7EC5BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: fix UAF bug in kmemleak_scan()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-fix-uaf-bug-in-kmemleak_scan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-fix-uaf-bug-in-kmemleak_scan.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/kmemleak: fix UAF bug in kmemleak_scan()
Date: Thu, 15 Dec 2022 11:02:59 -0500

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

Link: https://lkml.kernel.org/r/20221215160259.261136-3-longman@redhat.com
Fixes: 6edda04ccc7c ("mm/kmemleak: prevent soft lockup in first object iteration loop of kmemleak_scan()")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

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

mm-kmemleak-simplify-kmemleak_cond_resched-usage.patch
mm-kmemleak-fix-uaf-bug-in-kmemleak_scan.patch

