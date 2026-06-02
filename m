Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A933BC664
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439117; cv=none; b=qREf/oEw+W3LtcqY47zAXa6zGfWQFKZx9wSFP+srrSbG9gsjkYQIVr38hs3B3xFeDXuzTCkLJK/9JP1VPvZcL6NEX1MFPgXqzU03jOxgtjJK48UfM9TBsvKQRoU7Wng7zFjZJcvg8BToO7DZWaR+Jpf68zpV9xPfTrvkapW36Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439117; c=relaxed/simple;
	bh=8D5oNTSkiX8LqXgBbyG3Mcz0DL/YsM4CuTPEnmtoNi8=;
	h=Date:To:From:Subject:Message-Id; b=dqBHkfN12KupzOALGna6gmGb7Xi04c/xCWlZE0Q8XTCQJRjWZidAxW1BHSBYAJiQy66QUPAvSg2ME6BTiB69I5pahh/xMacbrtfFvMDw0Q9Mtr+4BCRQaqGxG5FD9wCckeGZ9NQq80t8ecuCvss26jbV262SfhdfIHrEh9ByKGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j649ZzGz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j649ZzGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C1A1F00898;
	Tue,  2 Jun 2026 22:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439116;
	bh=wAfZl+4jOeALWF/BHKch2E9tkaGWQy6W8cwdMhK0YXs=;
	h=Date:To:From:Subject;
	b=j649ZzGzVnMtBcvdAmAUP+8/V3yUuA93dgKMS6LRcFXJgbMtIcFYuG8XwEIIRx4Fw
	 iZk4PmmKZgvl7HQOkJXrUYHUNBQg6o+2giieoNZdW4zdEc/IH1ZBT9undSeIR83t5j
	 6Ght+SBxyAsJICWdtCJOtN1UHFYW8ImLqojtH/6Q=
Date: Tue, 02 Jun 2026 15:25:15 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-setup-damon_filter-memcg_id-from-path.patch removed from -mm tree
Message-Id: <20260602222516.32C1A1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: setup damon_filter->memcg_id from path
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-setup-damon_filter-memcg_id-from-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: setup damon_filter->memcg_id from path
Date: Mon, 18 May 2026 16:41:14 -0700

Find and set the memcg_id for damon_filter from the user-passed memory
cgroup path when updating the DAMON input parameters.

Link: https://lore.kernel.org/20260518234119.97569-27-sj@kernel.org
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

 include/linux/damon.h |    1 +
 mm/damon/core.c       |    2 +-
 mm/damon/sysfs.c      |   11 +++++++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-sysfs-setup-damon_filter-memcg_id-from-path
+++ a/include/linux/damon.h
@@ -1006,6 +1006,7 @@ static inline unsigned long damon_sz_reg
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow);
 void damon_add_filter(struct damon_probe *probe, struct damon_filter *f);
+void damon_destroy_filter(struct damon_filter *f);
 
 struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
--- a/mm/damon/core.c~mm-damon-sysfs-setup-damon_filter-memcg_id-from-path
+++ a/mm/damon/core.c
@@ -143,7 +143,7 @@ static void damon_free_filter(struct dam
 	kfree(f);
 }
 
-static void damon_destroy_filter(struct damon_filter *f)
+void damon_destroy_filter(struct damon_filter *f)
 {
 	damon_del_filter(f);
 	damon_free_filter(f);
--- a/mm/damon/sysfs.c~mm-damon-sysfs-setup-damon_filter-memcg_id-from-path
+++ a/mm/damon/sysfs.c
@@ -1927,6 +1927,17 @@ static int damon_sysfs_set_probes(struct
 					sys_filter->allow);
 			if (!filter)
 				return -ENOMEM;
+			if (filter->type == DAMON_FILTER_TYPE_MEMCG) {
+				int err;
+
+				err = damon_sysfs_memcg_path_to_id(
+						sys_filter->path,
+						&filter->memcg_id);
+				if (err) {
+					damon_destroy_filter(filter);
+					return err;
+				}
+			}
 			damon_add_filter(c, filter);
 		}
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

