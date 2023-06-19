Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF4FEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 20:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjFSUV7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjFSUV7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 16:21:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC451D3
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 13:21:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7263A60C74
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 20:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9760C433C0;
        Mon, 19 Jun 2023 20:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687206116;
        bh=QxL6iF3a8bdRB1uy2ELgDZTODdMH6C4ehWN1cAx+sKQ=;
        h=Date:To:From:Subject:From;
        b=WI+9O6LcV/1eXTJ4kZXZQU7In0CtFRh7xfGb/YZtF9Kyhf041ANrwX/WDK/yUh14l
         Ge+S8R3tpUWrNxroLwfhhLzzKqfIqzLNuedOzTuhYA3/enLm76qHmi/fs2pUVhImU6
         +adUk1FHAzKFDk7ejdOTggbLG4ose0cEEFrlLRCY=
Date:   Mon, 19 Jun 2023 13:21:56 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-make-memcg_lru-lock-irq-safe.patch added to mm-hotfixes-unstable branch
Message-Id: <20230619202156.C9760C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mglru: make memcg_lru->lock irq safe
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mglru-make-memcg_lru-lock-irq-safe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-make-memcg_lru-lock-irq-safe.patch

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
Subject: mm/mglru: make memcg_lru->lock irq safe
Date: Mon, 19 Jun 2023 13:38:21 -0600

lru_gen_rotate_memcg() can happen in softirq if memory.soft_limit_in_bytes
is set.  This requires memcg_lru->lock to be irq safe.

This problem only affects memcg v1.

Link: https://lkml.kernel.org/r/20230619193821.2710944-1-yuzhao@google.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: syzbot+87c490fd2be656269b6a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=87c490fd2be656269b6a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/vmscan.c~mm-mglru-make-memcg_lru-lock-irq-safe
+++ a/mm/vmscan.c
@@ -4743,10 +4743,11 @@ static void lru_gen_rotate_memcg(struct
 {
 	int seg;
 	int old, new;
+	unsigned long flags;
 	int bin = get_random_u32_below(MEMCG_NR_BINS);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	spin_lock(&pgdat->memcg_lru.lock);
+	spin_lock_irqsave(&pgdat->memcg_lru.lock, flags);
 
 	VM_WARN_ON_ONCE(hlist_nulls_unhashed(&lruvec->lrugen.list));
 
@@ -4781,7 +4782,7 @@ static void lru_gen_rotate_memcg(struct
 	if (!pgdat->memcg_lru.nr_memcgs[old] && old == get_memcg_gen(pgdat->memcg_lru.seq))
 		WRITE_ONCE(pgdat->memcg_lru.seq, pgdat->memcg_lru.seq + 1);
 
-	spin_unlock(&pgdat->memcg_lru.lock);
+	spin_unlock_irqrestore(&pgdat->memcg_lru.lock, flags);
 }
 
 void lru_gen_online_memcg(struct mem_cgroup *memcg)
@@ -4794,7 +4795,7 @@ void lru_gen_online_memcg(struct mem_cgr
 		struct pglist_data *pgdat = NODE_DATA(nid);
 		struct lruvec *lruvec = get_lruvec(memcg, nid);
 
-		spin_lock(&pgdat->memcg_lru.lock);
+		spin_lock_irq(&pgdat->memcg_lru.lock);
 
 		VM_WARN_ON_ONCE(!hlist_nulls_unhashed(&lruvec->lrugen.list));
 
@@ -4805,7 +4806,7 @@ void lru_gen_online_memcg(struct mem_cgr
 
 		lruvec->lrugen.gen = gen;
 
-		spin_unlock(&pgdat->memcg_lru.lock);
+		spin_unlock_irq(&pgdat->memcg_lru.lock);
 	}
 }
 
@@ -4829,7 +4830,7 @@ void lru_gen_release_memcg(struct mem_cg
 		struct pglist_data *pgdat = NODE_DATA(nid);
 		struct lruvec *lruvec = get_lruvec(memcg, nid);
 
-		spin_lock(&pgdat->memcg_lru.lock);
+		spin_lock_irq(&pgdat->memcg_lru.lock);
 
 		VM_WARN_ON_ONCE(hlist_nulls_unhashed(&lruvec->lrugen.list));
 
@@ -4841,7 +4842,7 @@ void lru_gen_release_memcg(struct mem_cg
 		if (!pgdat->memcg_lru.nr_memcgs[gen] && gen == get_memcg_gen(pgdat->memcg_lru.seq))
 			WRITE_ONCE(pgdat->memcg_lru.seq, pgdat->memcg_lru.seq + 1);
 
-		spin_unlock(&pgdat->memcg_lru.lock);
+		spin_unlock_irq(&pgdat->memcg_lru.lock);
 	}
 }
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-mglru-make-memcg_lru-lock-irq-safe.patch

