Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C8738F65C
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298443; cv=none; b=UoBNvqW+ZdFB7vqzg1dxDcx2YNu0ei7tB1SFOsgkUEOtpNYocwKbH7kIWXlxiTBsxsprxcMRp7TbImSk2hx2Sc4zV8l1bTdl7gIS8J3CTHV6sXv8rWK3nz9I/h2qg7iQoSirr8WtHc+uZu7Ycrmu9UepDtYjM7D2N9iJl4qp74M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298443; c=relaxed/simple;
	bh=cLwJR9l85m6DdXaDZKQlooSKfImHjtqoWMg2pkB/xxE=;
	h=Date:To:From:Subject:Message-Id; b=CcUv4KSSOH765b0g22V6LflKyqLuVojyMVunI3nfhQPDKuaBTEzq8OtTArx8d+LdMBh7f+j/9y1RFXpTM3WkLJADOkzipYaK7PCGMF6WWVcEzKIbw493+MsXu+9eJxNZfshv0YWx8qZxiIFhlrh6ELo+jo7mf0NPEQyfoDvbb/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XWq8UKgo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XWq8UKgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A011F00A3A;
	Wed, 29 Jul 2026 04:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298442;
	bh=T2a6PfYj3Week91Xm970rNm4WqcTjr6rqdAk3l5N2fA=;
	h=Date:To:From:Subject;
	b=XWq8UKgoyM1+vxAKat0aAAQTJmUr/FgnqBMrDCmXDcqmEtpQjUuppM8NjePS5F88u
	 bmxsoyXP2laI8SRP0V8h1FnM56s1LDBaCDi69OFyWrhK4sKxfCIG3oq21V5TY9a82Q
	 QLyHy2a22YLFMpWkVIPsIOb0rANLEwkfSIftFYoU=
Date: Tue, 28 Jul 2026 21:14:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-add-numa-node-filter.patch removed from -mm tree
Message-Id: <20260729041401.E9A011F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: add NUMA node filter
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-numa-node-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhen Ni <zhen.ni@easystack.cn>
Subject: mm/page_owner: add NUMA node filter
Date: Tue, 7 Jul 2026 19:54:09 +0800

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

Link: https://lore.kernel.org/20260707115411.1714314-3-zhen.ni@easystack.cn
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   54 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-add-numa-node-filter
+++ a/mm/page_owner.c
@@ -68,6 +68,8 @@ static const char * const page_owner_pri
 
 struct page_owner_filter_state {
 	enum page_owner_print_mode print_mode;
+	nodemask_t nid_filter;
+	bool nid_filter_enabled;
 };
 
 static bool page_owner_enabled __initdata;
@@ -803,6 +805,21 @@ read_page_owner(struct file *file, char
 		if (!handle)
 			goto ext_put_continue;
 
+		if (state->nid_filter_enabled) {
+			int nid;
+			memdesc_flags_t page_flags = READ_ONCE(page->flags);
+
+			/*
+			 * Bypass PF_POISONED_CHECK() in page_to_nid() to avoid
+			 * VM_BUG_ON when accessing poisoned pages.
+			 */
+			if (page_flags.f == PAGE_POISON_PATTERN)
+				goto ext_put_continue;
+			nid = memdesc_nid(page_flags);
+			if (!node_isset(nid, state->nid_filter))
+				goto ext_put_continue;
+		}
+
 		/* Record the next PFN to read in the file offset */
 		*ppos = pfn + 1;
 
@@ -812,6 +829,7 @@ read_page_owner(struct file *file, char
 				&page_owner_tmp, handle, state);
 ext_put_continue:
 		page_ext_put(page_ext);
+		cond_resched();
 	}
 
 	return 0;
@@ -907,6 +925,8 @@ static int page_owner_open(struct inode
 		return -ENOMEM;
 
 	state->print_mode = PAGE_OWNER_PRINT_STACK;
+	nodes_clear(state->nid_filter);
+	state->nid_filter_enabled = false;
 	file->private_data = state;
 	return 0;
 }
@@ -927,12 +947,17 @@ static ssize_t page_owner_write(struct f
 	int ret;
 	struct page_owner_filter_state *state = file->private_data;
 	enum page_owner_print_mode new_print_mode;
+	nodemask_t new_nid_filter;
+	bool new_nid_filter_enabled;
 
 	/*
 	 * Maximum input length for filter commands:
-	 * 32: print_mode command max length is 17 ("mode=stack_handle").
+	 * - 32: print_mode command max length is 17 ("mode=stack_handle")
+	 *        with sufficient buffer
+	 * - 6 * MAX_NUMNODES: worst case for nid list
+	 *   Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes
 	 */
-	if (count > 32)
+	if (count > 32 + 6 * MAX_NUMNODES)
 		return -EINVAL;
 
 	kbuf = memdup_user_nul(buf, count);
@@ -942,6 +967,8 @@ static ssize_t page_owner_write(struct f
 	orig = kbuf;
 
 	new_print_mode = state->print_mode;
+	new_nid_filter = state->nid_filter;
+	new_nid_filter_enabled = state->nid_filter_enabled;
 
 	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
 		if (*token == '\0')
@@ -953,13 +980,36 @@ static ssize_t page_owner_write(struct f
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
 	state->print_mode = new_print_mode;
+	state->nid_filter = new_nid_filter;
+	state->nid_filter_enabled = new_nid_filter_enabled;
 
 	ret = count;
 
_

Patches currently in -mm which might be from zhen.ni@easystack.cn are


