Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AC544B693
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 20:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782852617; cv=none; b=fS55wWxfPGxP9ljYtOStoE7EihJnM7ad2NE3N6oiSiAeK0mvzdoy3XVqDYR5Ii7FAdMIyEZKvMaYhuDOf+52cK0BrFKwzD3Ta7ET/+87Lzv8Ov7yoCUMZDQI96fYrDuJk3+sBf7gcq4o+1B0DbtIsTBGOk05uSz2g9V9bDKARyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782852617; c=relaxed/simple;
	bh=OPToWmVxyxWcPtJSRtoMcMkvOnkq6GN3Zaci18P7rns=;
	h=Date:To:From:Subject:Message-Id; b=MadeLuNRIdl3bqLVqyb/4+0SQiBgMhyy/ZcrWeKTMzzpsx+nZY0wDeBWuTgeWkplRhaPB3qjrwSw20Q9QOmwdqDaQuHeIMNsYBWhCxtnsHLFtEoyYlLh2URgRfhZKEHPbUmrDIBbXUuIDPQbTpMwLdlt0UuWQlhRISn2481em6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wn4ynqws; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wn4ynqws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2CE1F00A3A;
	Tue, 30 Jun 2026 20:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782852615;
	bh=0QJ4ptErKGgPOFqKdBN8WeiHE/RrQoOPDmR9nd4c+ZM=;
	h=Date:To:From:Subject;
	b=Wn4ynqwsug1C9fPHDXKGEzZLpZMiZbbqaYUOM8jpmFkZsOVO4SF4jbUGFPy3VKqiN
	 5keOcbCWV/PvN37TBl78c+zF8TA8K/Ko1H2ZE1/VqqFV08+88vp5mNjNEN1I/6BxMZ
	 +ew6xfTmlj/Dpf5YFgM25/EpH6fMtfx1oUZ5mu3Y=
Date: Tue, 30 Jun 2026 13:50:15 -0700
To: mm-commits@vger.kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch removed from -mm tree
Message-Id: <20260630205015.7E2CE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: add panic option for unrecoverable pages
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/memory-failure: add panic option for unrecoverable pages
Date: Fri, 26 Jun 2026 08:33:18 -0700

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

Link: https://lore.kernel.org/20260626-ecc_panic-v10-4-6dacb8ad024d@debian.org
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
@@ -74,6 +74,8 @@ static int sysctl_memory_failure_recover
 
 static int sysctl_enable_soft_offline __read_mostly = 1;
 
+static int sysctl_panic_on_unrecoverable_mf __read_mostly;
+
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
 static bool hw_memory_failure __read_mostly;
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
 
@@ -1255,6 +1266,15 @@ static void update_per_node_mf_stats(uns
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
@@ -1272,6 +1292,9 @@ static int action_result(unsigned long p
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
+	if (panic_on_unrecoverable_mf(type, result))
+		panic("Memory failure: %#lx: unrecoverable page", pfn);
+
 	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-avoid-soft-lockup-when-scanning-task-stacks.patch
mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch
mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch
a.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-add-hwpoison-panic-destructive-test.patch
mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch

