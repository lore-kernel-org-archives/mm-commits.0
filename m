Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2E4C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 23:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236796AbiKPXB2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 18:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234473AbiKPXB0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 18:01:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EED6AEDD
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 15:01:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E47162034
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 23:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9144AC433D6;
        Wed, 16 Nov 2022 23:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668639684;
        bh=35OZpsVQAqvlf0mZIVuQivjFKhssl3KzzcvtM/11ce0=;
        h=Date:To:From:Subject:From;
        b=YdYeYmeTE8fzJ5zhij8sSy40K1EAqQuH5rK1tA9UOAncYbm9VPzGX4nHkDIGed6XF
         LyGtFxZqwnWNuCmLJEGjFEGgOx0FCB4DoRhIuuA0Rn1UAGW6ekoaSoAeGiMHJnbkdB
         VKBQWTjMFzhbHDX7fWh4bmZktXCQVaWcXkzy8Rds=
Date:   Wed, 16 Nov 2022 15:01:23 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-remove-null-checks-on-node_data.patch added to mm-hotfixes-unstable branch
Message-Id: <20221116230124.9144AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: remove NULL checks on NODE_DATA()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-multi-gen-lru-remove-null-checks-on-node_data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-remove-null-checks-on-node_data.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
@@ -3154,7 +3154,7 @@ static struct lruvec *get_lruvec(struct
 	if (memcg) {
 		struct lruvec *lruvec = &memcg->nodeinfo[nid]->lruvec;
 
-		/* for hotadd_new_pgdat() */
+		/* see the comment in mem_cgroup_lruvec() */
 		if (!lruvec->pgdat)
 			lruvec->pgdat = pgdat;
 
@@ -3163,7 +3163,7 @@ static struct lruvec *get_lruvec(struct
 #endif
 	VM_WARN_ON_ONCE(!mem_cgroup_disabled());
 
-	return pgdat ? &pgdat->__lruvec : NULL;
+	return &pgdat->__lruvec;
 }
 
 static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
@@ -3227,9 +3227,6 @@ void lru_gen_add_mm(struct mm_struct *mm
 	for_each_node_state(nid, N_MEMORY) {
 		struct lruvec *lruvec = get_lruvec(memcg, nid);
 
-		if (!lruvec)
-			continue;
-
 		/* the first addition since the last iteration */
 		if (lruvec->mm_state.tail == &mm_list->fifo)
 			lruvec->mm_state.tail = &mm->lru_gen.list;
@@ -3259,9 +3256,6 @@ void lru_gen_del_mm(struct mm_struct *mm
 	for_each_node(nid) {
 		struct lruvec *lruvec = get_lruvec(memcg, nid);
 
-		if (!lruvec)
-			continue;
-
 		/* where the last iteration ended (exclusive) */
 		if (lruvec->mm_state.tail == &mm->lru_gen.list)
 			lruvec->mm_state.tail = lruvec->mm_state.tail->next;
@@ -5336,9 +5330,6 @@ static void lru_gen_change_state(bool en
 		for_each_node(nid) {
 			struct lruvec *lruvec = get_lruvec(memcg, nid);
 
-			if (!lruvec)
-				continue;
-
 			spin_lock_irq(&lruvec->lru_lock);
 
 			VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-multi-gen-lru-retry-folios-written-back-while-isolated.patch
mm-multi-gen-lru-remove-null-checks-on-node_data.patch

