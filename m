Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DB32E7372
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 19:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783452016; cv=none; b=lxQTwTB1CsO+KEb9NSlYRaHAcXldSEPAQVeG9LwASWkYEUzVrwWNBmuei/QtlrZ8Ds2+9RWdiipS3RJlD0h2Ehsi5Rl7hl2+S2CgG9GI9S5ovKhORnDkHFv7NDWYRIGwu15fNxmmZaZYlozebSm1q8AJD1WjMWfShIqcihii3lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783452016; c=relaxed/simple;
	bh=bIhqlcbIWuQMhhwJUFGwz7V9lEHrNo9OULti35fKwqM=;
	h=Date:To:From:Subject:Message-Id; b=kbjcMNB5O1yDjhCCaEQVznRd43sv1rm6bpf8ph/0cnMq94XH6084j9R3gsaS7nhdw2/FzDTOlq851Y7scx1iloseG4U7RjtzG8I00xVH4OLwqRim2CIbOa4BL16bIngaVmuf4JPFmZU6vcXFOdxcvLIlH+BDfuG160Xb4R9KnYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rkGDwmEv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rkGDwmEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D921F000E9;
	Tue,  7 Jul 2026 19:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783452014;
	bh=cSqGLNO5n3pzs/hThV5p9vpYoPLDgxHkiSuLWZIO3Co=;
	h=Date:To:From:Subject;
	b=rkGDwmEv23TAX2GDhPE+K7uzXkadX4iovO4bl0linTWvaQ7sk2eMy+Xjuz9iOVD0Q
	 TwQrmFWJxhPmbDmrtUnCyxvZn+tLVMxt/7SEbOmrzudoCpfauCzy8foloOc203m0aI
	 nc6POCr6YUTBWWCEU1Z2Ym7n/4gKrXYM7MMREhck=
Date: Tue, 07 Jul 2026 12:20:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-numa-node-filter.patch added to mm-unstable branch
Message-Id: <20260707192014.65D921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: add NUMA node filter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-add-numa-node-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-numa-node-filter.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
@@ -799,6 +801,21 @@ read_page_owner(struct file *file, char
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
 
@@ -808,6 +825,7 @@ read_page_owner(struct file *file, char
 				&page_owner_tmp, handle, state);
 ext_put_continue:
 		page_ext_put(page_ext);
+		cond_resched();
 	}
 
 	return 0;
@@ -903,6 +921,8 @@ static int page_owner_open(struct inode
 		return -ENOMEM;
 
 	state->print_mode = PAGE_OWNER_PRINT_STACK;
+	nodes_clear(state->nid_filter);
+	state->nid_filter_enabled = false;
 	file->private_data = state;
 	return 0;
 }
@@ -923,12 +943,17 @@ static ssize_t page_owner_write(struct f
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
@@ -938,6 +963,8 @@ static ssize_t page_owner_write(struct f
 	orig = kbuf;
 
 	new_print_mode = state->print_mode;
+	new_nid_filter = state->nid_filter;
+	new_nid_filter_enabled = state->nid_filter_enabled;
 
 	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
 		if (*token == '\0')
@@ -949,13 +976,36 @@ static ssize_t page_owner_write(struct f
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

mm-page_owner-add-print_mode-filter.patch
mm-page_owner-add-numa-node-filter.patch
tools-mm-add-page_owner_filter-userspace-tool.patch
mm-page_owner-document-page_owner-filter.patch

