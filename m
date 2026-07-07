Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553F333F390
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 19:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783451375; cv=none; b=jr8fh9UqB1ABlqK+I7iyQsXGQu3qsKPX6GntGvyoXR84WRokDwy+HdKQwdviGl1obGtRmmH6TX1ps/VkBifw4e6f2xokkk2WNJO9aONrw3fzK4e4F59dt97yfM+4+3MYQo56DBa7pHYxtzGLFe49hGDtC/+5y4OdBivBdRf/pCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783451375; c=relaxed/simple;
	bh=Ezu/IRc9Ue9yUNwh1ta0JzY0a722YHUMJt8QlLC7T8c=;
	h=Date:To:From:Subject:Message-Id; b=M4x8vOWE3PaEL9+NhEY4rqqlgXB5f0gUuY1gSUPBhuGUiAekDXM82XVg640xS/pMv+g5EvWH6pBPNOM6EpsgkHwAw7xRrnJAeRrAK0xXiipIejW1Yqe72kK10y3idP8pJgi3TnAPLcEbmbbCokm5cD66Ozxo2kpjRkBYoXs4HHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IQltwIgV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IQltwIgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2BE1F000E9;
	Tue,  7 Jul 2026 19:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783451374;
	bh=oUWGU3hixmhkmf6lIxVq9/TJ4C8zS2PwQl5FcLS2YJw=;
	h=Date:To:From:Subject;
	b=IQltwIgViMkvpgEfKYMKcKOlWckBBB3czEbRn6Jyt32dKO58d67ItDLmcSPTLnbF0
	 UI1SvtnqXqEFoAP1RYzXTXd/hmvNrYqqiWIDjkVUE1DX19z8qGlNRTdZQAC336X6Mf
	 YobBr9pg4ustmlBNbRC75/HuKk7G8fwYW9p97J+w=
Date: Tue, 07 Jul 2026 12:09:33 -0700
To: mm-commits@vger.kernel.org,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-add-numa-node-filter.patch removed from -mm tree
Message-Id: <20260707190934.1F2BE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: add NUMA node filter
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-numa-node-filter.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zhen Ni <zhen.ni@easystack.cn>
Subject: mm/page_owner: add NUMA node filter
Date: Thu, 25 Jun 2026 12:30:59 +0800

Add NUMA node filtering functionality to page_owner to allow filtering
pages by specific NUMA node(s).  This is useful for NUMA-aware memory
allocation analysis and debugging.

The filter supports flexible input formats:
- Single node: nid=0
- Multiple nodes: nid=0,2,3
- Node range: nid=0-3
- Mixed format: nid=0,2-4,7

Example usage:
  # Using the page_owner_filter tool (recommended)
  ./page_owner_filter -n 0-3
  ./page_owner_filter -m stack_handle -n 0,2-4,7

The implementation uses per-file-descriptor filter state stored in
file->private_data, allowing each opener to have independent filter
configuration.  It uses nodemask_t for efficient multi-node filtering and
nodelist_parse() for flexible input parsing.  Node validity is verified
using nodes_subset() to reject nodes without memory.

Link: https://lore.kernel.org/20260625043101.338794-3-zhen.ni@easystack.cn
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>
Cc: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   62 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-add-numa-node-filter
+++ a/mm/page_owner.c
@@ -68,6 +68,8 @@ static const char * const page_owner_pri
 
 struct page_owner_filter_state {
 	enum page_owner_print_mode print_mode;
+	nodemask_t nid_filter;
+	bool nid_filter_enabled;
 	spinlock_t lock;
 };
 
@@ -732,6 +734,7 @@ read_page_owner(struct file *file, char
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
 	struct page_owner_filter_state *state = file->private_data;
+	unsigned long flags;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -803,6 +806,27 @@ read_page_owner(struct file *file, char
 		if (!handle)
 			goto ext_put_continue;
 
+		spin_lock_irqsave(&state->lock, flags);
+		if (state->nid_filter_enabled) {
+			int nid;
+			memdesc_flags_t page_flags = READ_ONCE(page->flags);
+
+			/*
+			 * Bypass PF_POISONED_CHECK() in page_to_nid() to avoid
+			 * VM_BUG_ON when accessing poisoned pages.
+			 */
+			if (page_flags.f == PAGE_POISON_PATTERN) {
+				spin_unlock_irqrestore(&state->lock, flags);
+				goto ext_put_continue;
+			}
+			nid = memdesc_nid(page_flags);
+			if (!node_isset(nid, state->nid_filter)) {
+				spin_unlock_irqrestore(&state->lock, flags);
+				goto ext_put_continue;
+			}
+		}
+		spin_unlock_irqrestore(&state->lock, flags);
+
 		/* Record the next PFN to read in the file offset */
 		*ppos = pfn + 1;
 
@@ -812,6 +836,7 @@ read_page_owner(struct file *file, char
 				&page_owner_tmp, handle, state);
 ext_put_continue:
 		page_ext_put(page_ext);
+		cond_resched();
 	}
 
 	return 0;
@@ -908,6 +933,8 @@ static int page_owner_open(struct inode
 
 	spin_lock_init(&state->lock);
 	state->print_mode = PAGE_OWNER_PRINT_STACK;
+	nodes_clear(state->nid_filter);
+	state->nid_filter_enabled = false;
 	file->private_data = state;
 	return 0;
 }
@@ -927,14 +954,20 @@ static ssize_t page_owner_write(struct f
 	char *token;
 	int ret;
 	struct page_owner_filter_state *state = file->private_data;
+	nodemask_t new_nid_filter;
+	bool new_nid_filter_enabled;
 	enum page_owner_print_mode new_print_mode;
 	unsigned long flags;
 
 	/*
 	 * Maximum input length for filter commands:
-	 * 32: print_mode command max length is 17 ("mode=stack_handle").
+	 * - 32: print_mode command max length is 17 ("mode=stack_handle")
+	 *        with sufficient buffer
+	 * - 6 * MAX_NUMNODES: worst case for nid list
+	 *   Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6
+	 *   bytes
 	 */
-	if (count > 32)
+	if (count > 32 + 6 * MAX_NUMNODES)
 		return -EINVAL;
 
 	kbuf = memdup_user_nul(buf, count);
@@ -945,6 +978,8 @@ static ssize_t page_owner_write(struct f
 
 	spin_lock_irqsave(&state->lock, flags);
 	new_print_mode = state->print_mode;
+	new_nid_filter = state->nid_filter;
+	new_nid_filter_enabled = state->nid_filter_enabled;
 	spin_unlock_irqrestore(&state->lock, flags);
 
 	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
@@ -957,14 +992,37 @@ static ssize_t page_owner_write(struct f
 			if (ret < 0)
 				goto out_free;
 			new_print_mode = ret;
+		} else if (!strncmp(token, "nid=", 4)) {
+			ret = nodelist_parse(token + 4, new_nid_filter);
+			if (ret < 0)
+				goto out_free;
+
+			if (nodes_empty(new_nid_filter)) {
+				ret = -EINVAL;
+				goto out_free;
+			}
+
+			/*
+			 * We want to filter memory allocations by numa nodes, so make sure
+			 * that the specified nodes have memory.
+			 */
+			if (!nodes_subset(new_nid_filter, node_states[N_MEMORY])) {
+				ret = -EINVAL;
+				goto out_free;
+			}
+
+			new_nid_filter_enabled = true;
 		} else {
 			ret = -EINVAL;
 			goto out_free;
 		}
 	}
 
+	/* Commit all filter changes */
 	spin_lock_irqsave(&state->lock, flags);
 	state->print_mode = new_print_mode;
+	state->nid_filter = new_nid_filter;
+	state->nid_filter_enabled = new_nid_filter_enabled;
 	spin_unlock_irqrestore(&state->lock, flags);
 
 	ret = count;
_

Patches currently in -mm which might be from zhen.ni@easystack.cn are

tools-mm-add-page_owner_filter-userspace-tool.patch
mm-page_owner-document-page_owner-filter.patch

