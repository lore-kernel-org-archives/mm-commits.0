Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1773B5E01
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896562; cv=none; b=Ny6Mcg/p4ja2mUdXfEJaquwUEgC1ckwRLk6kYB79PrdThVpZTCbJIQ0a+ghE/fP6vDrhH2bTMTyDzFyt4KCchTBL+AEvStmpZP7uaksfIavCDod8hZJlX7Il59wI79dSdpSftqRlZ/nabdZZOT4UDPoHzWrMnJTxRYdl3N41FoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896562; c=relaxed/simple;
	bh=pNSKtWvtQbXG1nGRiHNbr3f20DkO8WI2l4iwBocTRWw=;
	h=Date:To:From:Subject:Message-Id; b=LC/MjvoK53m12AYiJV2Xl2eLgJVzcLQxKx7bSV4uxlZC+xG/GbZrBMu4CK0RfbMj9wEuslOBubVmHYpC0iZ958czukU1+IwB2wnF7HbcclkT4PiKYiyNCp8Nu81CK25kVcUrn/hJru0UJwgaOPegqky7JdrO4Quxlmal+esyCRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s2+LN7pq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s2+LN7pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE8F1F000E9;
	Wed,  5 Aug 2026 02:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896560;
	bh=ez4Q1eado1SE65xkYq7R2UKUG8Tw7Pn2PVkFWoZkgGA=;
	h=Date:To:From:Subject;
	b=s2+LN7pqwzV/J+14DtfEF14blYqgCG0a9Clte7a5EiOdf1LaH2f8f6Q22CVoI4gP8
	 4HLWLE7Fa5Htj5qKpnbOhQJtiuoM+ZtRHP1gvYdDivA+CypmCPB2IozU0wDgUHBff5
	 PqUemsmoBXAgnqPza+3pE0LkXD/nbKVD52oXBQ6w=
Date: Tue, 04 Aug 2026 19:22:40 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,nao.horiguchi@gmail.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch removed from -mm tree
Message-Id: <20260805022240.CAE8F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: add panic option for unrecoverable pages
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/memory-failure: add panic option for unrecoverable pages
Date: Tue, 30 Jun 2026 05:46:07 -0700

Add a sysctl panic_on_unrecoverable_memory_failure (disabled by default)
that triggers a kernel panic when memory_failure() encounters pages that
cannot be recovered.  This provides a clean crash with useful debug
information rather than allowing silent data corruption or a delayed crash
at an unrelated code path.

Panic eligibility is intentionally narrow: only MF_MSG_KERNEL with result
== MF_IGNORED panics.  After the previous patch, MF_MSG_KERNEL covers
PG_reserved pages and the kernel-owned pages promoted from
get_hwpoison_page() via -ENOTRECOVERABLE (slab, page tables,
large-kmalloc).

All other action types are excluded:

- MF_MSG_GET_HWPOISON and MF_MSG_KERNEL_HIGH_ORDER can be reached by
  transient refcount races with the page allocator (an in-flight buddy
  allocation has refcount 0 and is no longer on the buddy free list,
  briefly), and panicking on them would risk killing the box for what
  is actually a recoverable userspace page.

- MF_MSG_UNKNOWN means identify_page_state() could not classify the
  page; that is precisely the wrong basis for a panic decision.

Link: https://lore.kernel.org/20260630-ecc_panic-v10-4-c6ed5b62eea2@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failure-add-panic-option-for-unrecoverable-pages
+++ a/mm/memory-failure.c
@@ -75,6 +75,8 @@ static int sysctl_memory_failure_recover
 
 static int sysctl_enable_soft_offline __read_mostly = 1;
 
+static int sysctl_panic_on_unrecoverable_mf __read_mostly;
+
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
 static bool hw_memory_failure __read_mostly;
@@ -156,6 +158,15 @@ static const struct ctl_table memory_fai
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
 
@@ -1256,6 +1267,15 @@ static void update_per_node_mf_stats(uns
 	++mf_stats->total;
 }
 
+static bool panic_on_unrecoverable_mf(enum mf_action_page_type type,
+				      enum mf_result result)
+{
+	if (!sysctl_panic_on_unrecoverable_mf)
+		return false;
+
+	return type == MF_MSG_KERNEL && result == MF_IGNORED;
+}
+
 /*
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
@@ -1273,6 +1293,9 @@ static int action_result(unsigned long p
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
+	if (panic_on_unrecoverable_mf(type, result))
+		panic("Memory failure: %#lx: unrecoverable page", pfn);
+
 	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-migrate-report-rcu-tasks-quiescent-states-in-migrate_pages_batch.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch
radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch
mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan.patch
documentation-kmemleak-document-the-conditional-min_unref_scans-default.patch
selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments.patch

