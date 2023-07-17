Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8582EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 18:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjGQSj2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjGQSjY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 14:39:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4F5A1
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 11:39:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BEAC611E9
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 18:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B255C433C8;
        Mon, 17 Jul 2023 18:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689619162;
        bh=Yu2a2/RdTzGQ6PmaOdxULFjDY3CSNYoAeuTWBeZfn8c=;
        h=Date:To:From:Subject:From;
        b=Za1JPnSs29KNMTPCLhAmJ8bBMQ8CCSnptH4vTRzkmw5ux9MxLkKDGrgS8vmaE63ni
         1LZSKde5oaCr7uvXJIm2vTVw48AYGfRRhLQy/RjOeigtxGFl8gyzxj0e2rnOrBsx7V
         hKJRPCxTL5gW1FqMjdZ3jhfDSnaiYl8dxC/nSopU=
Date:   Mon, 17 Jul 2023 11:39:21 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        oliver.sang@intel.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-be-more-strict-about-locking.patch added to mm-unstable branch
Message-Id: <20230717183922.6B255C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: be more strict about locking
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-be-more-strict-about-locking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-be-more-strict-about-locking.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: be more strict about locking
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
@@ -185,11 +185,16 @@ typedef struct lockdep_map *lockdep_map_
 #define mt_lock_is_held(mt)                                             \
 	(!(mt)->ma_external_lock || lock_is_held((mt)->ma_external_lock))
 
+#define mt_write_lock_is_held(mt)					\
+	(!(mt)->ma_external_lock ||					\
+	 lock_is_held_type((mt)->ma_external_lock, 0))
+
 #define mt_set_external_lock(mt, lock)					\
 	(mt)->ma_external_lock = &(lock)->dep_map
 #else
 typedef struct { /* nothing */ } lockdep_map_p;
-#define mt_lock_is_held(mt)	1
+#define mt_lock_is_held(mt)		1
+#define mt_write_lock_is_held(mt)	1
 #define mt_set_external_lock(mt, lock)	do { } while (0)
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

mm-mlock-fix-vma-iterator-conversion-of-apply_vma_lock_flags.patch
maple_tree-fix-32-bit-mas_next-testing.patch
maple_tree-fix-node-allocation-testing-on-32-bit.patch
mm-mmap-clean-up-validate_mm-calls.patch
maple_tree-relax-lockdep-checks-for-on-stack-trees.patch
mm-mmap-change-detached-vma-locking-scheme.patch
maple_tree-be-more-strict-about-locking.patch

