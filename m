Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B393BC664
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439120; cv=none; b=mBajbeghb5rUYy2zYaDrnxt3dZgWKNCiWfUFcGKfotU+Vpmljs8K+uWX+UjP9ep0T3+ES/NqqD1U9BQGzJD+JyRqwQpa/zcYP3Ma45GqCp/tZ3/UXVnWYMGShcy/PQJ4xscGoM1mauLQUQd/NpML2uoJ1BATFtdYlXj6LwMhR0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439120; c=relaxed/simple;
	bh=VlHyVgxJ7axqJk2x7SjN385k2rFTyrF88MSKQphRetE=;
	h=Date:To:From:Subject:Message-Id; b=i0UfkIWolvs97Tuwg97IKod+Bg4cFAsw+h5IshzWoql1XiNJKSf1FkbIL8UrT+1dnJccUA4tAJjbK8JRL3M7rs+1IkUw6WNUHp9kWZYe8eTFQDCbTsMjrFC5ipwD48+z3FhLqIvpxoL9Kld8jNQMBPRvAqIM/J30IcvfYaIzRow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p7b+bHX9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p7b+bHX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B686B1F00898;
	Tue,  2 Jun 2026 22:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439118;
	bh=1IN582Yrknj/Unzh6rNOSn+38O7F3BInG9DJX/52tpA=;
	h=Date:To:From:Subject;
	b=p7b+bHX9vK5lIcfRUng9KZsOhBRvIuSKfxEC/soMo4jjH4knVDpP6P5zKENB/TMwf
	 s3+n0MoXMur4iNHxU7yv2H6vSADhdwY+XqwphFy8bVJQlG/nwoklyLgMm1EEMxsj9i
	 la2xwq5IvMXLZ9fVKt/BIuEZzqGAJWCba1EjKttI=
Date: Tue, 02 Jun 2026 15:25:18 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-update-for-memcg-damon-filter.patch removed from -mm tree
Message-Id: <20260602222518.B686B1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for memcg damon filter
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-memcg-damon-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: update for memcg damon filter
Date: Mon, 18 May 2026 16:41:16 -0700

Update DAMON usage document for the newly added belonging memory cgroup
attribute monitoring feature.

Link: https://lore.kernel.org/20260518234119.97569-29-sj@kernel.org
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

 Documentation/admin-guide/mm/damon/usage.rst |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-memcg-damon-filter
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -74,7 +74,7 @@ comma (",").
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
     │ │ │ │ │ │ │ 0/filters/nr_filters
-    │ │ │ │ │ │ │ │ 0/type,matching,allow
+    │ │ │ │ │ │ │ │ 0/type,matching,allow,path
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
@@ -289,7 +289,9 @@ the data attribute for the probe.
 In the beginning, ``filters`` directory has only one file, ``nr_filters``.
 Writing a number (``N``) to the file creates the number of child directories
 named ``0`` to ``N-1``.  Each directory represents each filter and works in a
-way similar to that for :ref:`DAMOS filter <sysfs_filters>`.
+way similar to that for :ref:`DAMOS filter <sysfs_filters>`.  When the filter
+``type`` is ``memcg``, ``path`` file acts as ``memcg_path`` for :ref:`DAMOS
+filter <sysfs_filters>`.
 
 .. _sysfs_targets:
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

