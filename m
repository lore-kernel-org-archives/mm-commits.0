Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7360764A8D
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 06:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453164; cv=none; b=CxGt8XKXKZOysdpXz6Hh//Gw3EQBqjHweYcbmVTXv6s8AP6rXv4/vmgP8Cxo3V/xsO9LLLzDSB/0Ex/UjSqxLRukMBNDJ7jpBEiJ5iSI0psYtGiUkIeyBBWFJTq2qapJvcVW0DqxStdF4OPcHbp4lGZf82XJb2uwmdZhJ97iz5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453164; c=relaxed/simple;
	bh=q8W6BkHkphkpEEvNLv5lpP9hVZSYL+UEVuykkFBSJrM=;
	h=Date:To:From:Subject:Message-Id; b=fZsYSAgZBBtw8YytaPh421NcSvVgqN2VT0aYkIFoy6gGSeZ/ZsyhPOiBRfuUKZI0tpM0cPvQX/HTfxelNWD7K7caAUzfmVh3eHGbslYwO3/XauCn9QazZzVhyscAjp2rXzZGPubNfrpBX4+KQEzVidwCaK2RnFTyldC+DhyzFKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o5pcxTbG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o5pcxTbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22601F000FF;
	Tue, 15 Sep 2026 06:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789453163;
	bh=ANFmYyg1wfk/nZ39HTwGiADcmtBcDRYXp/ewT4p591E=;
	h=Date:To:From:Subject;
	b=o5pcxTbG+fKtfSWxeZs2GSce58YNAwRqlXBSZCisrdYF7kYAs73pZAG7hMVqvqF8f
	 e/cuEBLtstEfYz9hlIa9GniPhZr9qOwi2UabrqwIy6mLpytBMgU+rxXt609W4OOVb+
	 HlG+SD3YOHEMs3wKftaIdA8hAfXBQUr48ZFr4x1s=
Date: Mon, 14 Sep 2026 23:19:22 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dev.jain@arm.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch removed from -mm tree
Message-Id: <20260915061922.E22601F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: extract show_busy_info from vmalloc_info_show
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/vmalloc: extract show_busy_info from vmalloc_info_show
Date: Mon, 14 Sep 2026 11:34:02 +0800

Patch series "mm/vmalloc: minor cleanups".

Small cleanup series for mm/vmalloc.c, no functional changes:

- Group xa_init() with the other vmap_block_queue field initializations
  in vmalloc_init(), instead of after the unrelated vfree_deferred setup.

- Extract vmap_insert_free_area() helper to deduplicate the allocate-
  and-insert pattern that appeared both inside the loop body and after
  the loop in vmap_init_free_space().

- Extract show_busy_info() from vmalloc_info_show(), mirroring the
  existing show_purge_info() pattern, so the top-level show function
  only orchestrates the two data sources.


This patch (of 3):

Extract the busy vmap area iteration into show_busy_info, mirroring the
existing show_purge_info pattern.

Link: https://lore.kernel.org/20260914-vmalloc_study-v1-0-526f68559706@linux.dev
Link: https://lore.kernel.org/20260914-vmalloc_study-v1-3-526f68559706@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---

 mm/vmalloc.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show
+++ a/mm/vmalloc.c
@@ -5345,12 +5345,12 @@ static void show_purge_info(struct seq_f
 	}
 }
 
-static int vmalloc_info_show(struct seq_file *m, void *p)
+static void show_busy_info(struct seq_file *m)
 {
 	struct vmap_node *vn;
 	struct vmap_area *va;
 	struct vm_struct *v;
-	unsigned int *counters;
+	unsigned int *counters = NULL;
 
 	if (IS_ENABLED(CONFIG_NUMA))
 		counters = kmalloc_array(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
@@ -5415,12 +5415,18 @@ static int vmalloc_info_show(struct seq_
 		spin_unlock(&vn->busy.lock);
 	}
 
+	if (IS_ENABLED(CONFIG_NUMA))
+		kfree(counters);
+}
+
+static int vmalloc_info_show(struct seq_file *m, void *p)
+{
+	show_busy_info(m);
+
 	/*
 	 * As a final step, dump "unpurged" areas.
 	 */
 	show_purge_info(m);
-	if (IS_ENABLED(CONFIG_NUMA))
-		kfree(counters);
 	return 0;
 }
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure.patch
tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch
tools-mm-page_owner_sort-add-module-name-sort-cull-filter-support.patch
tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch
mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc.patch
mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max.patch
mm-page_table_check-add-explicit-pmd_none-check-in-pte_clear_range.patch
mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch
mm-vmalloc-extract-vmap_insert_free_area-helper.patch

