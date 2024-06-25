Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBF714431C
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291724; cv=none; b=dSRMUCmGxWjd6+VXHbs9+uVDQUlnB47pt6r2WSV3QwbW+FPhTq0Ef9bndT4JSI9Pj64cnITWAzgWi966plmZ5d11bKNZw6lnTm3cg+YXGwdUsUvBGuxxri1YEBRGjO43vfxlqcFRRLNK+DZ6Z8P0IraGLT8fg0AQtzupTv3SZWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291724; c=relaxed/simple;
	bh=yPIob0gyXh5rNo5mW/Gs4VLOcYuhQ7C2hqYoimWEbgM=;
	h=Date:To:From:Subject:Message-Id; b=bm7FSPASs8ir2C/E8kLDvPVl5lVlQk6+XFv/yY1FeuJTT4BVYgEKnFI7iHNzs3+8UjL2Cr6jwUw+S+EV+xdpCM7YjYSH+QzXr93MZzGWeeN6DkbeFJ/3j9Dm/hMUs/wmBTheSXkAsr8x4MKMpmVt7dyucnYZc/yvM5RfgjADRUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aibyh5gR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aibyh5gR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8435C32782;
	Tue, 25 Jun 2024 05:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291723;
	bh=yPIob0gyXh5rNo5mW/Gs4VLOcYuhQ7C2hqYoimWEbgM=;
	h=Date:To:From:Subject:From;
	b=aibyh5gR8K5b+hsq58W4m1dgy0QL+aplz4tKNNTQz84NqZZT+ztM8UTcgsb5FniiC
	 /h/wWjQKjU1zcFyno8Gup93FGd1MgSswj4TPELDXuELoSVY+Sfje8plLtgTTCV1131
	 ZRcdrUoT2sAWUtBb6NQ1BLIt5UWllFD0/TkxpvY0=
Date: Mon, 24 Jun 2024 22:02:03 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rostedt@goodmis.org,rakie.kim@sk.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,hyeongtak.ji@sk.com,gregory.price@memverge.com,42.hyeyoo@gmail.com,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch removed from -mm tree
Message-Id: <20240625050203.D8435C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename alloc_demote_folio to alloc_migrate_folio
has been removed from the -mm tree.  Its filename was
     mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Honggyu Kim <honggyu.kim@sk.com>
Subject: mm: rename alloc_demote_folio to alloc_migrate_folio
Date: Fri, 14 Jun 2024 12:00:04 +0900

The alloc_demote_folio can also be used for general migration including
both demotion and promotion so it'd be better to rename it from
alloc_demote_folio to alloc_migrate_folio.

Link: https://lkml.kernel.org/r/20240614030010.751-3-honggyu.kim@sk.com
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Gregory Price <gregory.price@memverge.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 mm/vmscan.c   |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/internal.h~mm-rename-alloc_demote_folio-to-alloc_migrate_folio
+++ a/mm/internal.h
@@ -1093,7 +1093,7 @@ extern unsigned long  __must_check vm_mm
         unsigned long, unsigned long);
 
 extern void set_pageblock_order(void);
-struct folio *alloc_demote_folio(struct folio *src, unsigned long private);
+struct folio *alloc_migrate_folio(struct folio *src, unsigned long private);
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *folio_list);
--- a/mm/vmscan.c~mm-rename-alloc_demote_folio-to-alloc_migrate_folio
+++ a/mm/vmscan.c
@@ -919,7 +919,7 @@ static void folio_check_dirty_writeback(
 		mapping->a_ops->is_dirty_writeback(folio, dirty, writeback);
 }
 
-struct folio *alloc_demote_folio(struct folio *src, unsigned long private)
+struct folio *alloc_migrate_folio(struct folio *src, unsigned long private)
 {
 	struct folio *dst;
 	nodemask_t *allowed_mask;
@@ -982,7 +982,7 @@ static unsigned int demote_folio_list(st
 	node_get_allowed_targets(pgdat, &allowed_mask);
 
 	/* Demotion ignores all cpuset and mempolicy settings */
-	migrate_pages(demote_folios, alloc_demote_folio, NULL,
+	migrate_pages(demote_folios, alloc_migrate_folio, NULL,
 		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
 		      &nr_succeeded);
 
_

Patches currently in -mm which might be from honggyu.kim@sk.com are


