Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FF7313261
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675102; cv=none; b=Md67whBOaZhVVerQdF47l6jlPW5kkZbcw6OmLmJKKdl+YwN9ipPBnIuPcyE4vmtFlmqt7XkvrvQEU3wz8gTxugTEEReUnOgT7nb+SIuG4C5yOqU1H8683KtzCsDgYJgWBy27JVEtU94G5knSO0iA1jjwa+nIUq4GNpMP3ztdhmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675102; c=relaxed/simple;
	bh=Ln11PtNZBZNbsSwA+duO92YyT4IvTo6LZcRmydqrvH4=;
	h=Date:To:From:Subject:Message-Id; b=DtO7ASts1/FLXA+hss7H4hsf5IxRc4lJzydGToYyoHr1co1s4Iqb1eYCu6Mg3jN5aR4ai6mtFKsoYsKRDQp204cKFVRlYkW9rBDiRihd2MGSHcnJMXmviNlIh4Oj7bxLq9g7qyQEIDRj8j18yTHu4gA2Un0BhE42sz+eBPcVnAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1zGrEKhx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1zGrEKhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E315C4CEF1;
	Thu, 20 Nov 2025 21:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675102;
	bh=Ln11PtNZBZNbsSwA+duO92YyT4IvTo6LZcRmydqrvH4=;
	h=Date:To:From:Subject:From;
	b=1zGrEKhxDwa0fTg3RVL/bsRsbU8XjWFnD7RpYxqjRz9qSzg/7zljjePSDT9de/vyd
	 ZXEtIcF8KAnM+lfxyzHyiErImY4SH7l0Ne7wsd9sZH2LfYA1pSLW1CJ2fiAIWu7HuV
	 NjZc2orWrMs1chukFblA2KT5n4STU0tOVpTPtZjE=
Date: Thu, 20 Nov 2025 13:45:01 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,harry.yoo@oracle.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmstat-correct-the-comment-above-preempt_disable_nested.patch removed from -mm tree
Message-Id: <20251120214502.5E315C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmstat: correct the comment above preempt_disable_nested()
has been removed from the -mm tree.  Its filename was
     mm-vmstat-correct-the-comment-above-preempt_disable_nested.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: vmstat: correct the comment above preempt_disable_nested()
Date: Mon, 10 Nov 2025 16:44:37 +0800

The comment explaining why these parts use preempt_disable_nested() is in
__mod_zone_page_state(), not in __mod_node_page_state(), so we should see
__mod_zone_page_state(). Just correct it.

Link: https://lkml.kernel.org/r/20251110084437.46701-1-qi.zheng@linux.dev
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-correct-the-comment-above-preempt_disable_nested
+++ a/mm/vmstat.c
@@ -392,7 +392,7 @@ void __mod_node_page_state(struct pglist
 		delta >>= PAGE_SHIFT;
 	}
 
-	/* See __mod_node_page_state */
+	/* See __mod_zone_page_state() */
 	preempt_disable_nested();
 
 	x = delta + __this_cpu_read(*p);
@@ -438,7 +438,7 @@ void __inc_zone_state(struct zone *zone,
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
-	/* See __mod_node_page_state */
+	/* See __mod_zone_page_state() */
 	preempt_disable_nested();
 
 	v = __this_cpu_inc_return(*p);
@@ -461,7 +461,7 @@ void __inc_node_state(struct pglist_data
 
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
-	/* See __mod_node_page_state */
+	/* See __mod_zone_page_state() */
 	preempt_disable_nested();
 
 	v = __this_cpu_inc_return(*p);
@@ -494,7 +494,7 @@ void __dec_zone_state(struct zone *zone,
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
-	/* See __mod_node_page_state */
+	/* See __mod_zone_page_state() */
 	preempt_disable_nested();
 
 	v = __this_cpu_dec_return(*p);
@@ -517,7 +517,7 @@ void __dec_node_state(struct pglist_data
 
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
-	/* See __mod_node_page_state */
+	/* See __mod_zone_page_state() */
 	preempt_disable_nested();
 
 	v = __this_cpu_dec_return(*p);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-thp-reparent-the-split-queue-during-memcg-offline.patch

