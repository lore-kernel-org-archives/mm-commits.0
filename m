Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB6D3CCFAC
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439102; cv=none; b=u47zaQWWvBLLAOk2RayGKEjctU80jehK3vR4n8TpLrNxW+WaIKgZmXNzsWTW6RZLSU2+O2YR+acvMm03pa0JSkXpSZOXv+ye6ABG8G36S6b1lIS9JmpYoH9Q6EcgIDWW4wYgvoGqZQnB8c8r3IONJBVmaPqRi8+5vpwI/A7W7UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439102; c=relaxed/simple;
	bh=ZoxHUswT9i/ZIVN4WkZYj+Y93SBWmlEwTWME9mwmkSI=;
	h=Date:To:From:Subject:Message-Id; b=C2sfjBKTNKej+BVuAnxzjJChx8FJIQAPWzg+8sLtDWbhMYebivw2+GikAXurUZvp333pkslLuEkwUBJ4Nw7qHnsbScoRYLxLZy6gWDKNVj3051KHqszs4SnOj/JDaIDFTN4iGYFzP2f1mg4YRYDpzJnLtsgffqsEZkNAN3am/kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zpe0W5g6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zpe0W5g6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19231F00898;
	Tue,  2 Jun 2026 22:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439100;
	bh=6J3hopTkN/tJpymEiP41B2C6FRlAyrg7grjWjMg2Suo=;
	h=Date:To:From:Subject;
	b=zpe0W5g6Z6QkceDQ3UTy+Fc6eGCY7rT/eJ26LCvBZExb5ItLGKBVyBT0g6eHlB+fV
	 5C/Dck0q4PUHskiZYUQdtpRqwnCdxMl1M/KUtporbXHTz3aqYdU1/l768OBVSpcBpt
	 IHILvkpsHdE4UkhTcNxvD+mG9qmc4GOTY1EESaRo=
Date: Tue, 02 Jun 2026 15:25:00 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-setup-probes-on-damon-core-api-parameters.patch removed from -mm tree
Message-Id: <20260602222500.C19231F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: setup probes on DAMON core API parameters
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-setup-probes-on-damon-core-api-parameters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: setup probes on DAMON core API parameters
Date: Mon, 18 May 2026 16:41:02 -0700

Add user-installed data probes to DAMON core API parameters, so that user
inputs for data probes are passed to DAMON core.

Link: https://lore.kernel.org/20260518234119.97569-15-sj@kernel.org
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

 mm/damon/sysfs.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-setup-probes-on-damon-core-api-parameters
+++ a/mm/damon/sysfs.c
@@ -1855,6 +1855,40 @@ static int damon_sysfs_set_attrs(struct
 	return damon_set_attrs(ctx, &attrs);
 }
 
+static int damon_sysfs_set_probes(struct damon_ctx *ctx,
+		struct damon_sysfs_probes *sys_probes)
+{
+	int i;
+
+	for (i = 0; i < sys_probes->nr; i++) {
+		struct damon_sysfs_filters *sys_filters =
+			sys_probes->probes_arr[i]->filters;
+		struct damon_probe *c;
+		int j;
+
+		if (!sys_filters)
+			continue;
+		c = damon_new_probe();
+		if (!c)
+			return -ENOMEM;
+		damon_add_probe(ctx, c);
+
+		for (j = 0; j < sys_filters->nr; j++) {
+			struct damon_sysfs_filter *sys_filter =
+				sys_filters->filters_arr[j];
+			struct damon_filter *filter;
+
+			filter = damon_new_filter(sys_filter->type,
+					sys_filter->matching,
+					sys_filter->allow);
+			if (!filter)
+				return -ENOMEM;
+			damon_add_filter(c, filter);
+		}
+	}
+	return 0;
+}
+
 static int damon_sysfs_set_regions(struct damon_target *t,
 		struct damon_sysfs_regions *sysfs_regions,
 		unsigned long min_region_sz)
@@ -1969,6 +2003,9 @@ static int damon_sysfs_apply_inputs(stru
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
+	err = damon_sysfs_set_probes(ctx, sys_ctx->attrs->probes);
+	if (err)
+		return err;
 	err = damon_sysfs_add_targets(ctx, sys_ctx->targets);
 	if (err)
 		return err;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

