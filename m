Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3015EB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jun 2023 23:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbjFWXKo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 19:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbjFWXKo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 19:10:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4516AEA;
        Fri, 23 Jun 2023 16:10:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B45CA61032;
        Fri, 23 Jun 2023 23:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14465C433C0;
        Fri, 23 Jun 2023 23:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687561842;
        bh=9D2gxM3MefNukqRvygLHlTpTq6KpftKL3EmG4IYUc5s=;
        h=Date:To:From:Subject:From;
        b=Fdqh2GUgPnYx3x+SODanYbSY/HPwPF/MfR9nGYan3l9XBjgFSrjlodCFgagiIbfSC
         wvd3jGxv8pyXRWMydpGNL/Va/IA5iMvk6ZLR+LtnrJGr73JeqHYhfI0qu6YR3OAhGN
         WU4Dw3v8DTXexVJHcfjHP4Yn3ynNTZ04DuYW0NYM=
Date:   Fri, 23 Jun 2023 16:10:41 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        stable@vger.kernel.org, yuzhao@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mglru-make-memcg_lru-lock-irq-safe.patch removed from -mm tree
Message-Id: <20230623231042.14465C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mglru: make memcg_lru->lock irq safe
has been removed from the -mm tree.  Its filename was
     mm-mglru-make-memcg_lru-lock-irq-safe.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/mglru: make memcg_lru->lock irq safe
Date: Mon, 19 Jun 2023 13:38:21 -0600

lru_gen_rotate_memcg() can happen in softirq if memory.soft_limit_in_bytes
is set.  This requires memcg_lru->lock to be irq safe.  Lockdep warns on
this.

This problem only affects memcg v1.

Link: https://lkml.kernel.org/r/20230619193821.2710944-1-yuzhao@google.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: syzbot+87c490fd2be656269b6a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=87c490fd2be656269b6a
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/vmscan.c~mm-mglru-make-memcg_lru-lock-irq-safe
+++ a/mm/vmscan.c
@@ -4728,10 +4728,11 @@ static void lru_gen_rotate_memcg(struct
 {
 	int seg;
 	int old, new;
+	unsigned long flags;
 	int bin = get_random_u32_below(MEMCG_NR_BINS);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	spin_lock(&pgdat->memcg_lru.lock);
+	spin_lock_irqsave(&pgdat->memcg_lru.lock, flags);
 
 	VM_WARN_ON_ONCE(hlist_nulls_unhashed(&lruvec->lrugen.list));
 
@@ -4766,7 +4767,7 @@ static void lru_gen_rotate_memcg(struct
 	if (!pgdat->memcg_lru.nr_memcgs[old] && old == get_memcg_gen(pgdat->memcg_lru.seq))
 		WRITE_ONCE(pgdat->memcg_lru.seq, pgdat->memcg_lru.seq + 1);
 
-	spin_unlock(&pgdat->memcg_lru.lock);
+	spin_unlock_irqrestore(&pgdat->memcg_lru.lock, flags);
 }
 
 void lru_gen_online_memcg(struct mem_cgroup *memcg)
@@ -4779,7 +4780,7 @@ void lru_gen_online_memcg(struct mem_cgr
 		struct pglist_data *pgdat = NODE_DATA(nid);
 		struct lruvec *lruvec = get_lruvec(memcg, nid);
 
-		spin_lock(&pgdat->memcg_lru.lock);
+		spin_lock_irq(&pgdat->memcg_lru.lock);
 
 		VM_WARN_ON_ONCE(!hlist_nulls_unhashed(&lruvec->lrugen.list));
 
@@ -4790,7 +4791,7 @@ void lru_gen_online_memcg(struct mem_cgr
 
 		lruvec->lrugen.gen = gen;
 
-		spin_unlock(&pgdat->memcg_lru.lock);
+		spin_unlock_irq(&pgdat->memcg_lru.lock);
 	}
 }
 
@@ -4814,7 +4815,7 @@ void lru_gen_release_memcg(struct mem_cg
 		struct pglist_data *pgdat = NODE_DATA(nid);
 		struct lruvec *lruvec = get_lruvec(memcg, nid);
 
-		spin_lock(&pgdat->memcg_lru.lock);
+		spin_lock_irq(&pgdat->memcg_lru.lock);
 
 		VM_WARN_ON_ONCE(hlist_nulls_unhashed(&lruvec->lrugen.list));
 
@@ -4826,7 +4827,7 @@ void lru_gen_release_memcg(struct mem_cg
 		if (!pgdat->memcg_lru.nr_memcgs[gen] && gen == get_memcg_gen(pgdat->memcg_lru.seq))
 			WRITE_ONCE(pgdat->memcg_lru.seq, pgdat->memcg_lru.seq + 1);
 
-		spin_unlock(&pgdat->memcg_lru.lock);
+		spin_unlock_irq(&pgdat->memcg_lru.lock);
 	}
 }
 
_

Patches currently in -mm which might be from yuzhao@google.com are


