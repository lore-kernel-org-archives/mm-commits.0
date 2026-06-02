Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F343BE17C
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439113; cv=none; b=bYRGWnkjfLo3jH2+MOi/Y4/r0/xNSl0zMoKJd8YbknsAsooJ1ta5VaVeSRlh2xUMqnS4vedDF1Yrft1LfQ3eREH59b7UZmEA73JTOmEntHVSoO95gsPmBv8kQs/ejV32QyuCvDgqWxMbfXySvv63m/kxDxutWzbW9HJa+jZj0QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439113; c=relaxed/simple;
	bh=RAsfmG7sNpzH5+TGjmOFnj0pnrCwS+EYLPwSKDO5v7M=;
	h=Date:To:From:Subject:Message-Id; b=MWZ9saEA36halIi1gTNREbZzc9ZLCTZiNN61OIHWWZ+riG04t/mgPiixdGuMuh4lEBeuPVsVyGQvS3ywWEgf6D7H1zTyax8+omA3Z9tqO3CT461KMKpQKeGcyWc+OscraunWANdq1wmTQOIo293EXMQs0shp5EI/l26Xbjrqk/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y/yGNKNC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y/yGNKNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A65A1F00893;
	Tue,  2 Jun 2026 22:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439112;
	bh=Hf8mAkps6+xDMRYIZAbruc+hGdTvhpfcrtbcwKbmBEw=;
	h=Date:To:From:Subject;
	b=y/yGNKNChFsniRo3YG3rnyjneSA9OwOjpL2obMIKKFWHjP1oYdftYvKwuilgBfPkH
	 Upjns9O1QwjX3wRsG7KR7EfObcrqgTIkiZ9TKRqPBC32h4QFSDPQTpM/RuZGyHtZdY
	 wnPUKNGP2RBdo9vRYbd5ub9ZlN2S/xwYC7RdoGVI=
Date: Tue, 02 Jun 2026 15:25:11 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-support-damon_filter_type_memcg.patch removed from -mm tree
Message-Id: <20260602222512.5A65A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: support DAMON_FILTER_TYPE_MEMCG
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-support-damon_filter_type_memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: support DAMON_FILTER_TYPE_MEMCG
Date: Mon, 18 May 2026 16:41:11 -0700

Implement the support of DAMON_FILTER_TYPE_MEMCG on the DAMON operation
set implementation for the physical address space.

Link: https://lore.kernel.org/20260518234119.97569-24-sj@kernel.org
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

 mm/damon/paddr.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-damon_filter_type_memcg
+++ a/mm/damon/paddr.c
@@ -124,6 +124,7 @@ static bool damon_pa_filter_match(struct
 		struct folio *folio)
 {
 	bool matched = false;
+	struct mem_cgroup *memcg;
 
 	switch (filter->type) {
 	case DAMON_FILTER_TYPE_ANON:
@@ -133,6 +134,19 @@ static bool damon_pa_filter_match(struct
 		}
 		matched = folio_test_anon(folio);
 		break;
+	case DAMON_FILTER_TYPE_MEMCG:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		rcu_read_lock();
+		memcg = folio_memcg_check(folio);
+		if (!memcg)
+			matched = false;
+		else
+			matched = filter->memcg_id == mem_cgroup_id(memcg);
+		rcu_read_unlock();
+		break;
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

