Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88EEC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbiLAAIT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiLAAGc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:06:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB3F6DFEC
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FACAB81D69
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B89C433B5;
        Thu,  1 Dec 2022 00:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852947;
        bh=tPQP6TgAZfXkbnUYDs6NoeR6oWTlLdxwnhKi51D2N+E=;
        h=Date:To:From:Subject:From;
        b=aThf9iOYUATa7e29Jj1dkIlji5F1Jh98wdwSEsGn6O/lrc0o9PFeL2ms8YHlkjg6K
         Fc29UBXuphjcYTAabBt7W8RHuypcQHV2Klw2wfglRREzhpqzWVlFoGZzcQ1ZsDEkdo
         ssGA3jE0jjOOlCWwRmoq6P5wzvq9SoinQCR13arg=
Date:   Wed, 30 Nov 2022 16:02:27 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-remove-null-checks-on-node_data.patch removed from -mm tree
Message-Id: <20221201000227.B5B89C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: remove NULL checks on NODE_DATA()
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-remove-null-checks-on-node_data.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: remove NULL checks on NODE_DATA()
Date: Tue, 15 Nov 2022 18:38:08 -0700

NODE_DATA() is preallocated for all possible nodes after commit
09f49dca570a ("mm: handle uninitialized numa nodes gracefully").  Checking
its return value against NULL is now unnecessary.

Link: https://lkml.kernel.org/r/20221116013808.3995280-2-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-remove-null-checks-on-node_data
+++ a/mm/vmscan.c
@@ -3166,7 +3166,7 @@ static struct lruvec *get_lruvec(struct
 	if (memcg) {
 		struct lruvec *lruvec = &memcg->nodeinfo[nid]->lruvec;
 
-		/* for hotadd_new_pgdat() */
+		/* see the comment in mem_cgroup_lruvec() */
 		if (!lruvec->pgdat)
 			lruvec->pgdat = pgdat;
 
@@ -3175,7 +3175,7 @@ static struct lruvec *get_lruvec(struct
 #endif
 	VM_WARN_ON_ONCE(!mem_cgroup_disabled());
 
-	return pgdat ? &pgdat->__lruvec : NULL;
+	return &pgdat->__lruvec;
 }
 
 static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
@@ -3239,9 +3239,6 @@ void lru_gen_add_mm(struct mm_struct *mm
 	for_each_node_state(nid, N_MEMORY) {
 		struct lruvec *lruvec = get_lruvec(memcg, nid);
 
-		if (!lruvec)
-			continue;
-
 		/* the first addition since the last iteration */
 		if (lruvec->mm_state.tail == &mm_list->fifo)
 			lruvec->mm_state.tail = &mm->lru_gen.list;
@@ -3271,9 +3268,6 @@ void lru_gen_del_mm(struct mm_struct *mm
 	for_each_node(nid) {
 		struct lruvec *lruvec = get_lruvec(memcg, nid);
 
-		if (!lruvec)
-			continue;
-
 		/* where the last iteration ended (exclusive) */
 		if (lruvec->mm_state.tail == &mm->lru_gen.list)
 			lruvec->mm_state.tail = lruvec->mm_state.tail->next;
@@ -5348,9 +5342,6 @@ static void lru_gen_change_state(bool en
 		for_each_node(nid) {
 			struct lruvec *lruvec = get_lruvec(memcg, nid);
 
-			if (!lruvec)
-				continue;
-
 			spin_lock_irq(&lruvec->lru_lock);
 
 			VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
_

Patches currently in -mm which might be from yuzhao@google.com are


