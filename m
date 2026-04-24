Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83573CEBB8
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 12:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777035105; cv=none; b=u/oaSpV6QlFh8NAnrZ9stHt4U36ZDl2oLpS7pHM1DEYe0PNiGxCmQ5ik6GFnOl+XqgLaUbrtHSfC8VwpiXPRSATS5KEj/Z+kVY4Ygx223A2qmcFOeKAQ3I6/cr87NGsymQUo5QZeYryVSeihfHQ06Dw+Fng+CE4omAyr8A6HxhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777035105; c=relaxed/simple;
	bh=ZSe3O5P32Bze8MW2PNBwc28SiD55MH1JeNzeIObfCZA=;
	h=Date:To:From:Subject:Message-Id; b=F66A/Z+wIBDMhrtqtCvHVqMVsyvMlYwNzKBYRhyazCvUlykZe6fw4fT3UnRGdTZ4Wc9/2sN60MsaACLq5qU4hLX7zYgFRL/XzbZGlH6rlCGszz2HbcCfGGRB2/NxGoBdQtPA78/E5sWqQPmfXMt5QqxM6BmZbR9SsW+aA3YPiRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W+VKis2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W+VKis2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C80C19425;
	Fri, 24 Apr 2026 12:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777035105;
	bh=ZSe3O5P32Bze8MW2PNBwc28SiD55MH1JeNzeIObfCZA=;
	h=Date:To:From:Subject:From;
	b=W+VKis2yN+SVH7mxIIQSLVulqu0S7ieTOX2CE9kOwEwMffM++MKMePSMMM8Y9OJET
	 7t/klrMz//wg6Eqd+Py/ZXXdmA63H3CyyM+s8Z5XBmwH3RF2EesaLAfaQBpnlx93p1
	 UDIffr/1oqlBP8ba3HU6Y1merU3G+Iyip3RkfpQE=
Date: Fri, 24 Apr 2026 05:51:44 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch added to mm-new branch
Message-Id: <20260424125145.64C80C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: add panic option for unrecoverable pages
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: mm/memory-failure: add panic option for unrecoverable pages
Date: Fri, 24 Apr 2026 05:24:00 -0700

Add a sysctl panic_on_unrecoverable_memory_failure that triggers a kernel
panic when memory_failure() encounters pages that cannot be recovered. 
This provides a clean crash with useful debug information rather than
allowing silent data corruption or a delayed crash at an unrelated code
path.

The panic is triggered for three categories of unrecoverable failures,
all requiring result == MF_IGNORED:

- MF_MSG_KERNEL: reserved pages identified via PageReserved.

- MF_MSG_KERNEL_HIGH_ORDER: pages that get_hwpoison_page() observed
  with refcount 0 but that are not in the buddy allocator (e.g. tail
  pages of a high-order kernel allocation). A buddy page being
  concurrently allocated to userspace can briefly land on this branch
  too — its refcount is 0 inside the allocator and it is no longer on
  the buddy free list — and panicking on such a page would defeat the
  standard SIGBUS recovery path. The page allocator cannot reject
  hwpoisoned buddy pages reliably either: check_new_pages() is gated by
  is_check_pages_enabled() and is a no-op when CONFIG_DEBUG_VM=n.

  Rule out the race inside panic_on_unrecoverable_mf(): yield with
  cpu_relax() so a concurrent allocator on another CPU can finish
  prep_new_page() and have its writes become visible, then re-check.
  A genuine high-order kernel tail page stays unowned (refcount 0,
  no LRU, no mapping, not in buddy); an in-flight allocation will
  have bumped the refcount, attached a mapping, or placed the page
  on an LRU by then. Only panic if the recheck still observes a
  fully unowned page. The window is narrowed, not eliminated, but
  is far below any allocator path's cost.

- MF_MSG_UNKNOWN: pages that do not match any known recoverable state
  in error_states[]. A theoretical false positive from concurrent LRU
  isolation is mitigated by identify_page_state()'s two-pass design
  which rechecks using saved page_flags.

MF_MSG_GET_HWPOISON is intentionally excluded: it covers both non-reserved
kernel memory (SLAB/SLUB, vmalloc, kernel stacks, page tables) and
transient refcount races, so panicking would risk false positives.

Link: https://lore.kernel.org/20260424-ecc_panic-v5-2-a35f4b50425c@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   91 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failure-add-panic-option-for-unrecoverable-pages
+++ a/mm/memory-failure.c
@@ -74,6 +74,8 @@ static int sysctl_memory_failure_recover
 
 static int sysctl_enable_soft_offline __read_mostly = 1;
 
+static int sysctl_panic_on_unrecoverable_mf __read_mostly;
+
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
 static bool hw_memory_failure __read_mostly = false;
@@ -155,6 +157,15 @@ static const struct ctl_table memory_fai
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "panic_on_unrecoverable_memory_failure",
+		.data		= &sysctl_panic_on_unrecoverable_mf,
+		.maxlen		= sizeof(sysctl_panic_on_unrecoverable_mf),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
 	}
 };
 
@@ -1282,6 +1293,75 @@ static void update_per_node_mf_stats(uns
 }
 
 /*
+ * Determine whether to panic on an unrecoverable memory failure.
+ *
+ * Panics on three categories of failures (all requiring result == MF_IGNORED):
+ *
+ * - MF_MSG_KERNEL: Reserved pages (PageReserved) that belong to the kernel.
+ *
+ * - MF_MSG_KERNEL_HIGH_ORDER: Pages that get_hwpoison_page() observed with
+ *   refcount 0 but that are not in the buddy allocator (e.g. tail pages of
+ *   a high-order kernel allocation). A buddy page being concurrently
+ *   allocated could also reach this branch — its refcount is briefly 0
+ *   inside the allocator and it is no longer on the buddy free list — and
+ *   such a page may be destined for userspace, where the standard hwpoison
+ *   path would recover it via SIGBUS. The page allocator cannot reject
+ *   hwpoisoned buddy pages reliably either: check_new_pages() is gated by
+ *   is_check_pages_enabled() and is a no-op when CONFIG_DEBUG_VM=n. The
+ *   recheck below rules out this race before panicking.
+ *
+ * - MF_MSG_UNKNOWN: Pages that reached identify_page_state() but matched no
+ *   recoverable state in error_states[]. A theoretical false positive from
+ *   concurrent LRU isolation is mitigated by identify_page_state()'s
+ *   two-pass design which rechecks using saved page_flags.
+ *
+ * MF_MSG_GET_HWPOISON is intentionally excluded: it covers dynamically
+ * allocated kernel memory (SLAB/SLUB, vmalloc, kernel stacks, page tables)
+ * which shares the return path with transient refcount races, so panicking
+ * would risk false positives.
+ */
+static bool panic_on_unrecoverable_mf(unsigned long pfn,
+				      enum mf_action_page_type type,
+				      enum mf_result result)
+{
+	struct page *p;
+
+	if (!sysctl_panic_on_unrecoverable_mf || result != MF_IGNORED)
+		return false;
+
+	switch (type) {
+	case MF_MSG_KERNEL:
+	case MF_MSG_UNKNOWN:
+		return true;
+	case MF_MSG_KERNEL_HIGH_ORDER:
+		/*
+		 * Rule out a concurrent buddy allocation: give the
+		 * allocator a moment to finish prep_new_page() and
+		 * re-check. A genuine high-order kernel tail page stays
+		 * unowned; an in-flight allocation will have bumped the
+		 * refcount, attached a mapping, or placed the page on
+		 * an LRU by now.
+		 */
+		p = pfn_to_online_page(pfn);
+		if (!p)
+			return true;
+		/*
+		 * Yield so a concurrent allocator on another CPU can
+		 * finish prep_new_page() and have its writes become
+		 * visible before we resample the page state.
+		 */
+		cpu_relax();
+		return page_count(p) == 0 &&
+		       !PageLRU(p) &&
+		       !page_mapped(p) &&
+		       !page_folio(p)->mapping &&
+		       !is_free_buddy_page(p);
+	default:
+		return false;
+	}
+}
+
+/*
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
  */
@@ -1298,6 +1378,9 @@ static int action_result(unsigned long p
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
+	if (panic_on_unrecoverable_mf(pfn, type, result))
+		panic("Memory failure: %#lx: unrecoverable page", pfn);
+
 	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }
 
@@ -2428,6 +2511,14 @@ try_again:
 			}
 			res = action_result(pfn, MF_MSG_BUDDY, res);
 		} else {
+			/*
+			 * The page has refcount 0 but is not in the buddy
+			 * allocator — typically a tail page of a high-order
+			 * kernel allocation. A buddy page being concurrently
+			 * allocated to userspace can also briefly land here;
+			 * panic_on_unrecoverable_mf() rechecks to rule that
+			 * out before triggering a panic.
+			 */
 			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 		}
 		goto unlock_mutex;
_

Patches currently in -mm which might be from leitao@debian.org are

kho-fix-error-handling-in-kho_add_subtree.patch
mm-memory-failure-report-mf_msg_kernel-for-reserved-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-regression-test-for-panic_on_unrecoverable_memory_failure.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

