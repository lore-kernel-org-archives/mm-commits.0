Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4627E3BB112
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439112; cv=none; b=k3iBeH8d0MdT/EmOWl/75jOCaLK0HRMvATWO+isxBWqF+GuBrWrq1Jm7bYYQiAJGbR0f7LcovEiHHRAtIzqpM26WzPl1RUmBJLpuEYxbppHE7Jrk2T6H0Jj4cZjGp09tVsi/YCDCzYbpR+pEJ2frgKVz9YnKoJ+cEhEkFHgiQvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439112; c=relaxed/simple;
	bh=zZL0xe9giV8G1gFG9a2BExwIZF6oT+CyJkKsw5W1xKo=;
	h=Date:To:From:Subject:Message-Id; b=Ka2oYkGbCQocNg3aywAhtPOCkzZoe3TsLL0oVIsMMo+5sz2MkGV6+oORltt2iHBsuGzd5pspWbvWuOh9zL4O7bZqSjdxJKRx6auSv8ZfVsUTDw4v7LoXCFsi3u6NAR0zw6CxoWLlPf8P4019NDPl5CbcWnFDN7bZ00IduYSB3WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YzHoIIyM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YzHoIIyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B5E1F00898;
	Tue,  2 Jun 2026 22:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439111;
	bh=i1AdrjJHm/qJvK/JBA9j1RXp7KNynolrrpYCp5/dBYA=;
	h=Date:To:From:Subject;
	b=YzHoIIyMoWP0u5KozB0gotoBskajILq2vFsw4uY0BzOR2wl6igWAfR7sn0Q/o4SZX
	 C6+k0NU2eccMvdfJDKRdwoNNcsCH01Xx/NeheN++1qXZGa60IOLY5dpgbEV5O6WOBB
	 lQ/G9PVOyHGVFEN9smkxaeG7GJTKVAbx8Iz7r54I=
Date: Tue, 02 Jun 2026 15:25:10 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-introduce-damon_filter_type_memcg.patch removed from -mm tree
Message-Id: <20260602222511.18B5E1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce DAMON_FILTER_TYPE_MEMCG
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-damon_filter_type_memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: introduce DAMON_FILTER_TYPE_MEMCG
Date: Mon, 18 May 2026 16:41:10 -0700

Belonging memory cgoup is another data attribute that can be useful to
monitor.  Introduce a new DAMON filter type, namely
DAMON_FILTER_TYPE_MEMCG, for monitoring of this attribute.

Link: https://lore.kernel.org/20260518234119.97569-23-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    6 ++++++
 mm/damon/core.c       |   14 ++++++++++++++
 2 files changed, 20 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_filter_type_memcg
+++ a/include/linux/damon.h
@@ -742,9 +742,11 @@ struct damon_intervals_goal {
  * enum damon_filter_type - Type of &struct damon_filter
  *
  * @DAMON_FILTER_TYPE_ANON:	Anonymous pages.
+ * @DAMON_FILTER_TYPE_MEMCG:	Specific memcg's pages.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
+	DAMON_FILTER_TYPE_MEMCG,
 };
 
 /**
@@ -753,12 +755,16 @@ enum damon_filter_type {
  * @type:	Type of the region.
  * @matching:	Whether this filter is for the type-matching ones.
  * @allow:	Whether the @type-@matching ones should pass this filter.
+ * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
  * @list:	Siblings list.
  */
 struct damon_filter {
 	enum damon_filter_type type;
 	bool matching;
 	bool allow;
+	union {
+		u64 memcg_id;
+	};
 	struct list_head list;
 };
 
--- a/mm/damon/core.c~mm-damon-core-introduce-damon_filter_type_memcg
+++ a/mm/damon/core.c
@@ -1430,6 +1430,13 @@ static void damon_commit_filter(struct d
 	dst->type = src->type;
 	dst->matching = src->matching;
 	dst->allow = src->allow;
+	switch (dst->type) {
+	case DAMON_FILTER_TYPE_MEMCG:
+		dst->memcg_id = src->memcg_id;
+		break;
+	default:
+		break;
+	}
 }
 
 static int damon_commit_filters(struct damon_probe *dst,
@@ -1454,6 +1461,13 @@ static int damon_commit_filters(struct d
 				src_filter->matching, src_filter->allow);
 		if (!new_filter)
 			return -ENOMEM;
+		switch (src_filter->type) {
+		case DAMON_FILTER_TYPE_MEMCG:
+			new_filter->memcg_id = src_filter->memcg_id;
+			break;
+		default:
+			break;
+		}
 		damon_add_filter(dst, new_filter);
 	}
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

