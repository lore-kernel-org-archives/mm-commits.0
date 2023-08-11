Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C636AC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbjHKXFn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbjHKXD5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED702448D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67652666E3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB125C433C7;
        Fri, 11 Aug 2023 23:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794922;
        bh=v5s4jp0ecBvBFU4Vq10PIRhRtZ3lKWXdXvwRU9EQWzY=;
        h=Date:To:From:Subject:From;
        b=z9AMs+zXo0as80zIC1KOAezd3t44Em+5megVofROqmYk1o3Ozt69Y54miyzgRqvgy
         hL4ryMY5q0mPSpm8aEmtYFC7eVSKSvljB70PufnNnbXMZ6+uTZN7W6y1gJ4ey/6/ew
         BbBaSmq4ABgb5kgOqVDk4j1d/4qyJGjSUUJgvWps=
Date:   Fri, 11 Aug 2023 16:02:02 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        oliver.sang@intel.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-be-more-strict-about-locking.patch removed from -mm tree
Message-Id: <20230811230202.BB125C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: Be more strict about locking
has been removed from the -mm tree.  Its filename was
     maple_tree-be-more-strict-about-locking.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: Be more strict about locking
Date: Fri, 14 Jul 2023 15:55:51 -0400

Use lockdep to check the write path in the maple tree holds the lock in
write mode.

Introduce mt_write_lock_is_held() to check if the lock is held for
writing.  Update the necessary checks for rcu_dereference_protected() to
use the new write lock check.

Link: https://lkml.kernel.org/r/20230714195551.894800-5-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oliver Sang <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    7 ++++++-
 lib/maple_tree.c           |   10 ++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-be-more-strict-about-locking
+++ a/include/linux/maple_tree.h
@@ -185,13 +185,18 @@ typedef struct lockdep_map *lockdep_map_
 #define mt_lock_is_held(mt)                                             \
 	(!(mt)->ma_external_lock || lock_is_held((mt)->ma_external_lock))
 
+#define mt_write_lock_is_held(mt)					\
+	(!(mt)->ma_external_lock ||					\
+	 lock_is_held_type((mt)->ma_external_lock, 0))
+
 #define mt_set_external_lock(mt, lock)					\
 	(mt)->ma_external_lock = &(lock)->dep_map
 
 #define mt_on_stack(mt)			(mt).ma_external_lock = NULL
 #else
 typedef struct { /* nothing */ } lockdep_map_p;
-#define mt_lock_is_held(mt)	1
+#define mt_lock_is_held(mt)		1
+#define mt_write_lock_is_held(mt)	1
 #define mt_set_external_lock(mt, lock)	do { } while (0)
 #define mt_on_stack(mt)			do { } while (0)
 #endif
--- a/lib/maple_tree.c~maple_tree-be-more-strict-about-locking
+++ a/lib/maple_tree.c
@@ -777,6 +777,12 @@ static inline void __rcu **ma_slots(stru
 	}
 }
 
+static inline bool mt_write_locked(const struct maple_tree *mt)
+{
+	return mt_external_lock(mt) ? mt_write_lock_is_held(mt) :
+		lockdep_is_held(&mt->ma_lock);
+}
+
 static inline bool mt_locked(const struct maple_tree *mt)
 {
 	return mt_external_lock(mt) ? mt_lock_is_held(mt) :
@@ -792,7 +798,7 @@ static inline void *mt_slot(const struct
 static inline void *mt_slot_locked(struct maple_tree *mt, void __rcu **slots,
 				   unsigned char offset)
 {
-	return rcu_dereference_protected(slots[offset], mt_locked(mt));
+	return rcu_dereference_protected(slots[offset], mt_write_locked(mt));
 }
 /*
  * mas_slot_locked() - Get the slot value when holding the maple tree lock.
@@ -835,7 +841,7 @@ static inline void *mas_root(struct ma_s
 
 static inline void *mt_root_locked(struct maple_tree *mt)
 {
-	return rcu_dereference_protected(mt->ma_root, mt_locked(mt));
+	return rcu_dereference_protected(mt->ma_root, mt_write_locked(mt));
 }
 
 /*
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch

