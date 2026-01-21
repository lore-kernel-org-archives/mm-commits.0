Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133D2363C60
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966118; cv=none; b=kn+LnpTG6f0y+psDTvI9c8InfuQ/1Y9pS3fqeDVHqG2WjTDa7I8klnVJOSy4MiuyT8Ayy5Sb+EvZJCxBC3UXF1AyKPaZtlWHLPJyWKpuWvYJBhn375svvhqTrMeUfPGaQnWl5Zrd5wyvYXEhP1FMbhSSm6zLVdnFE95QiVHQYIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966118; c=relaxed/simple;
	bh=Yx3RNUb5/A93avAKUWmfia2uV5sJMj8U0Ee11T08pHA=;
	h=Date:To:From:Subject:Message-Id; b=jMvsuy3QjwlW6c07RmH1zjlqQXU+OeNip/xvCMj6PehZ0bLmWT9SkiIcpSOIvEcv+zkYJGJdSnVB1HNod/R5CtR897agkh6oB+IZOAJ1tIUvti1+kBTY0NCisr8BZDVLkcRw3m58N9zEbq435nFLPKNabtM0/lw7oVjYRmNUszA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ovsG5GNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ovsG5GNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1B9C16AAE;
	Wed, 21 Jan 2026 03:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966117;
	bh=Yx3RNUb5/A93avAKUWmfia2uV5sJMj8U0Ee11T08pHA=;
	h=Date:To:From:Subject:From;
	b=ovsG5GNziimG4hAMWStFHDBRfh6DCTs4GSeiy2W8uHphqLJtipYw0CW6DrTn7sief
	 unwrxwyCdovISQCsBXec/DgAjd/BefChpXdF3KTQg4F//aqaudw8hSKlEO7jjngs0b
	 NSBOT9/ZdEDihfIMH0Pjq8ZD8gLWYgUmFS5RUEE4=
Date: Tue, 20 Jan 2026 19:28:37 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,joshua.hahnjy@gmail.com,david@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmstat-remove-unused-node-and-zone-state-helpers.patch removed from -mm tree
Message-Id: <20260121032837.8D1B9C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmstat: remove unused node and zone state helpers
has been removed from the -mm tree.  Its filename was
     mm-vmstat-remove-unused-node-and-zone-state-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/vmstat: remove unused node and zone state helpers
Date: Thu, 25 Dec 2025 21:02:13 +0000

Several helper functions for managing node and zone states have become
obsolete and no longer have any callers within the kernel.

  inc_node_state()
  inc_zone_state()
  dec_zone_state()

This commit removes the dead code.

Link: https://lkml.kernel.org/r/20251225210213.2553-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    6 ------
 mm/vmstat.c            |   15 ---------------
 2 files changed, 21 deletions(-)

--- a/include/linux/vmstat.h~mm-vmstat-remove-unused-node-and-zone-state-helpers
+++ a/include/linux/vmstat.h
@@ -286,10 +286,8 @@ void mod_node_page_state(struct pglist_d
 void inc_node_page_state(struct page *, enum node_stat_item);
 void dec_node_page_state(struct page *, enum node_stat_item);
 
-extern void inc_node_state(struct pglist_data *, enum node_stat_item);
 extern void __inc_zone_state(struct zone *, enum zone_stat_item);
 extern void __inc_node_state(struct pglist_data *, enum node_stat_item);
-extern void dec_zone_state(struct zone *, enum zone_stat_item);
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 extern void __dec_node_state(struct pglist_data *, enum node_stat_item);
 
@@ -394,10 +392,6 @@ static inline void __dec_node_page_state
 #define dec_node_page_state __dec_node_page_state
 #define mod_node_page_state __mod_node_page_state
 
-#define inc_zone_state __inc_zone_state
-#define inc_node_state __inc_node_state
-#define dec_zone_state __dec_zone_state
-
 #define set_pgdat_percpu_threshold(pgdat, callback) { }
 
 static inline void refresh_zone_stat_thresholds(void) { }
--- a/mm/vmstat.c~mm-vmstat-remove-unused-node-and-zone-state-helpers
+++ a/mm/vmstat.c
@@ -672,11 +672,6 @@ void mod_node_page_state(struct pglist_d
 }
 EXPORT_SYMBOL(mod_node_page_state);
 
-void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
-{
-	mod_node_state(pgdat, item, 1, 1);
-}
-
 void inc_node_page_state(struct page *page, enum node_stat_item item)
 {
 	mod_node_state(page_pgdat(page), item, 1, 1);
@@ -725,16 +720,6 @@ void dec_zone_page_state(struct page *pa
 }
 EXPORT_SYMBOL(dec_zone_page_state);
 
-void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__inc_node_state(pgdat, item);
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL(inc_node_state);
-
 void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
 					long delta)
 {
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


