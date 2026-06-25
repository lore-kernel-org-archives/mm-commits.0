Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF1A2F8EBC
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 04:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782363362; cv=none; b=s4+sjAnbvCEztDplAmkdJGC5WXXX5wQXGLhmJvr0A01ao+s0DhuFgttnFVDHfzC+MphpkEyt2Ecs9gn50W/In/AsdvDmhFflH59X9aTzdWKETy87wODgLg2xmir4qdKKl9U7Zc09AGE4/F1v6/7VYXQHhgFn58b0H0cWXAqBZuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782363362; c=relaxed/simple;
	bh=MAjHX1tYwAvCiro0B4kYnLRZ1gtmJ5QxFkmwJOVdK+o=;
	h=Date:To:From:Subject:Message-Id; b=KtHsworaU5evMHcuKSSJIWVUibQTDG+2E/auPr7eTjsYW2jfzdifMN9Z/MvujBiMQFYli5HhjpfuMwpAW4b//IyZny/Iq672wSi+SWsmmOyAObCbsJejf3BCWDk1oiarKBt2tfAQssngmdLjh2PEG9Y2zACccHa3A1XK9vB5XiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kDY+42rh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kDY+42rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529881F000E9;
	Thu, 25 Jun 2026 04:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782363360;
	bh=ji1R0XppoaffOqVFwlYSK4eoj8mcakRY4/FhDYskvEw=;
	h=Date:To:From:Subject;
	b=kDY+42rhK+JVbMDfgxT77pKDC3Qe/l/SBKjcbtFV1KVM+vZJyPEDRIEr6xK+qqQ82
	 MTBa7sJYGzs2VQaUjoBa4Vd1Zsn7j0DXtBJrmkpResgC9bu3GUvTQr56wYwjzILKWT
	 xWZ8ps8DQ99HZZH3NOr5kLFaWhZDUifsvygtyxfc=
Date: Wed, 24 Jun 2026 21:55:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ye.liu@linux.dev,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,corbet@lwn.net,chenyichong@uniontech.com,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-numa-node-filter.patch added to mm-new branch
Message-Id: <20260625045600.529881F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: add NUMA node filter
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-add-numa-node-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-numa-node-filter.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   61 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-add-numa-node-filter
+++ a/mm/page_owner.c
@@ -75,6 +75,8 @@ static const char * const page_owner_pri
 
 struct page_owner_filter_state {
 	enum page_owner_print_mode print_mode;
+	nodemask_t nid_filter;
+	bool nid_filter_enabled;
 	spinlock_t lock;
 };
 
@@ -739,6 +741,7 @@ read_page_owner(struct file *file, char
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
 	struct page_owner_filter_state *state = file->private_data;
+	unsigned long flags;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -810,6 +813,27 @@ read_page_owner(struct file *file, char
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
 
@@ -819,6 +843,7 @@ read_page_owner(struct file *file, char
 				&page_owner_tmp, handle, state);
 ext_put_continue:
 		page_ext_put(page_ext);
+		cond_resched();
 	}
 
 	return 0;
@@ -915,6 +940,8 @@ static int page_owner_open(struct inode
 
 	spin_lock_init(&state->lock);
 	state->print_mode = PAGE_OWNER_PRINT_STACK;
+	nodes_clear(state->nid_filter);
+	state->nid_filter_enabled = false;
 	file->private_data = state;
 	return 0;
 }
@@ -936,13 +963,18 @@ static ssize_t page_owner_write(struct f
 	size_t max_input_len;
 	struct page_owner_filter_state *state = file->private_data;
 	enum page_owner_print_mode new_print_mode;
+	nodemask_t new_nid_filter;
+	bool new_nid_filter_enabled;
 	unsigned long flags;
 
 	/*
 	 * Maximum input length for filter commands:
-	 * 32: print_mode command max length is 17 ("mode=stack_handle").
+	 * - 32: print_mode command max length is 17 ("mode=stack_handle")
+	 *        with sufficient buffer
+	 * - 6 * MAX_NUMNODES: worst case for nid list
+	 *   Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes
 	 */
-	max_input_len = 32;
+	max_input_len = 32 + 6 * MAX_NUMNODES;
 
 	if (count > max_input_len)
 		return -EINVAL;
@@ -955,6 +987,8 @@ static ssize_t page_owner_write(struct f
 
 	spin_lock_irqsave(&state->lock, flags);
 	new_print_mode = state->print_mode;
+	new_nid_filter = state->nid_filter;
+	new_nid_filter_enabled = state->nid_filter_enabled;
 	spin_unlock_irqrestore(&state->lock, flags);
 
 	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
@@ -967,14 +1001,37 @@ static ssize_t page_owner_write(struct f
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

mm-page_owner-add-print_mode-filter.patch
mm-page_owner-add-numa-node-filter.patch
tools-mm-add-page_owner_filter-userspace-tool.patch
mm-page_owner-document-page_owner-filter.patch

