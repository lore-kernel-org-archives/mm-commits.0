Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DAD3C8723
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439090; cv=none; b=je3Up5YWX+1QRI7WPs2veNDVNpZ1iqPLCFKM+OyvytnqHCjh7+J/OTZRQjFOdQAeRyM3TwvINp1r5hMNjsC7luxuD/Dx9VjX7ugvzcnbELeY8lLSD9cuzZ+97etH0BOI2cqrwPSmBta0nC1YO3JyjU6zMeCCgzLqoU27DJEcKlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439090; c=relaxed/simple;
	bh=puW0gSUc2DCTvrNXCaz83k9qWs+jcMOKr8yIqSyNGGE=;
	h=Date:To:From:Subject:Message-Id; b=iYS4SLY7+Q634qguQrL181vCsBYpSAu+ReAfLI0F84SP2Trwk3FR2rMG1yscHdMmeYfvnhun/eLEKoV/BJGs3Vo8TOwfC0wv57eCAs8Yc1PRG9fG8cGNgAxpbMU/8W0DmqQsTXE27GTRBprqJp2t7SRukMoSxRYMcM1i7kkGnXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XxdJTXmb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XxdJTXmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385FB1F00898;
	Tue,  2 Jun 2026 22:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439089;
	bh=90UnZ9FMtabNcMd3nhPhEtLoSuPfesTzVKsPuX6JVoQ=;
	h=Date:To:From:Subject;
	b=XxdJTXmb5T7HFnFale9SdEMwVACZ418U9ART3VDa0+1IoVu+Jt/LDmX5OqJFxnc0g
	 EyBDEnU5XcG99NAnVchr/7dic6xum/bdVD4wsddJV4IiHYIgs6LqseMGUrE6NjCPbj
	 8zoiFZoupqAt5/t7fOS453/FgOmwey4ocureWg5Y=
Date: Tue, 02 Jun 2026 15:24:48 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-introduce-damon_region-probe_hits.patch removed from -mm tree
Message-Id: <20260602222449.385FB1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce damon_region->probe_hits
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-damon_region-probe_hits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: introduce damon_region->probe_hits
Date: Mon, 18 May 2026 16:40:53 -0700

Add an array for the per-region per-probe positive samples count.  For
simple and efficient implementation, add a limit to the number of data
probes and set the array to support only the limited number of counters.

Link: https://lore.kernel.org/20260518234119.97569-6-sj@kernel.org
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

 include/linux/damon.h |    4 ++++
 mm/damon/core.c       |   10 ++++++++++
 2 files changed, 14 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_region-probe_hits
+++ a/include/linux/damon.h
@@ -17,6 +17,8 @@
 
 /* Minimal region size.  Every damon_region is aligned by this. */
 #define DAMON_MIN_REGION_SZ	PAGE_SIZE
+/* Maximum number of monitoring probes. */
+#define DAMON_MAX_PROBES	(4)
 /* Max priority score for DAMON-based operation schemes */
 #define DAMOS_MAX_SCORE		(99)
 
@@ -47,6 +49,7 @@ struct damon_size_range {
  * @nr_accesses:	Access frequency of this region.
  * @nr_accesses_bp:	@nr_accesses in basis point (0.01%) that updated for
  *			each sampling interval.
+ * @probe_hits:		Number of probe-positive region samples.
  * @list:		List head for siblings.
  * @age:		Age of this region.
  *
@@ -75,6 +78,7 @@ struct damon_region {
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
 	unsigned int nr_accesses_bp;
+	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
 
 	unsigned int age;
--- a/mm/damon/core.c~mm-damon-core-introduce-damon_region-probe_hits
+++ a/mm/damon/core.c
@@ -229,6 +229,7 @@ static void damon_verify_new_region(unsi
 struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 {
 	struct damon_region *region;
+	int i;
 
 	damon_verify_new_region(start, end);
 	region = kmem_cache_alloc(damon_region_cache, GFP_KERNEL);
@@ -239,6 +240,8 @@ struct damon_region *damon_new_region(un
 	region->ar.end = end;
 	region->nr_accesses = 0;
 	region->nr_accesses_bp = 0;
+	for (i = 0; i < DAMON_MAX_PROBES; i++)
+		region->probe_hits[i] = 0;
 	INIT_LIST_HEAD(&region->list);
 
 	region->age = 0;
@@ -2980,12 +2983,17 @@ static void damon_merge_two_regions(stru
 		struct damon_region *l, struct damon_region *r)
 {
 	unsigned long sz_l = damon_sz_region(l), sz_r = damon_sz_region(r);
+	int i;
 
 	l->nr_accesses = (l->nr_accesses * sz_l + r->nr_accesses * sz_r) /
 			(sz_l + sz_r);
 	l->nr_accesses_bp = l->nr_accesses * 10000;
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
+	/* todo: do this for only installed probes */
+	for (i = 0; i < DAMON_MAX_PROBES; i++)
+		l->probe_hits[i] = (l->probe_hits[i] * sz_l + r->probe_hits[i]
+				* sz_r) / (sz_l + sz_r);
 	damon_verify_merge_two_regions(l, r);
 	damon_destroy_region(r, t);
 }
@@ -3108,6 +3116,8 @@ static void damon_split_region_at(struct
 	new->last_nr_accesses = r->last_nr_accesses;
 	new->nr_accesses_bp = r->nr_accesses_bp;
 	new->nr_accesses = r->nr_accesses;
+	/* todo: do this for only installed probes */
+	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
 
 	damon_insert_region(new, r, damon_next_region(r), t);
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

