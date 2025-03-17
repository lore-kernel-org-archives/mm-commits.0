Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74929215771
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188278; cv=none; b=X4nw421eVAjiOooIwLkF4ssxQZO0W4TPRJIUiqFS06uyEliqFpo9LowTMgrhHb4kbN5FHpAJT/EgEy9UGP6XGIPXQ0nHIzt85JedFDHrbaSJqUqZa5+EmV4Cgukl47jJx+j756iN5xFZ6cx0+cZmy3sdX/bUwJRAKygk1SyWj0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188278; c=relaxed/simple;
	bh=KpImmHCCS6Vhyg3ScFM7/SGvGQXLf2+p7CvJg13gU+4=;
	h=Date:To:From:Subject:Message-Id; b=DVtRG++pWGuIy0rdV+qdzz8JdJf5UXXjn9FTIxL4zmRdPKXoRvHmbaENaDrTn+ZK2Xx0sNeNUNKQeJXefWYhfkqOZ/OwcRe1AKPsOC5Yva8HnNkzWBSlJW4vjRDtYFAKL4Aaleb/LrpTsjXGla65S73468axnPqJUW2Zn29kyxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RZeSXdqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RZeSXdqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C71C4CEED;
	Mon, 17 Mar 2025 05:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188278;
	bh=KpImmHCCS6Vhyg3ScFM7/SGvGQXLf2+p7CvJg13gU+4=;
	h=Date:To:From:Subject:From;
	b=RZeSXdqvP7Vkndo6fLoGjRpD8DuYC6eUDvI8z9RC00xpXxfrn/5p3PAufZW5a8vao
	 fyWrHqRhwZ7cmW/jKAeMNG/t34HBSq+0oDz88B+ihhyRzrY41IDT9pIRlJrfHJqXYu
	 hvNHrbkofR/tATOSBil+iLIOjrH9La9lTkZqwETk=
Date: Sun, 16 Mar 2025 22:11:17 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,hannes@cmpxchg.org,david@redhat.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-document-hugepage_size-filter-type.patch removed from -mm tree
Message-Id: <20250317051118.49C71C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document hugepage_size filter type
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-document-hugepage_size-filter-type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: Docs/admin-guide/mm/damon/usage: document hugepage_size filter type
Date: Tue, 11 Feb 2025 12:43:43 +0000

This includes both the 'hugepage_size' filter type and the min/max files
used to decide range of sizes to filter on.

Link: https://lkml.kernel.org/r/20250211124437.278873-5-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-hugepage_size-filter-type
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -83,7 +83,7 @@ comma (",").
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`filters <sysfs_filters>`/nr_filters
-    │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx
+    │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx,min,max
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
@@ -406,13 +406,14 @@ number (``N``) to the file creates the n
 to ``N-1``.  Each directory represents each filter.  The filters are evaluated
 in the numeric order.
 
-Each filter directory contains seven files, namely ``type``, ``matching``,
-``allow``, ``memcg_path``, ``addr_start``, ``addr_end``, and ``target_idx``.
-To ``type`` file, you can write one of five special keywords: ``anon`` for
-anonymous pages, ``memcg`` for specific memory cgroup, ``young`` for young
-pages, ``addr`` for specific address range (an open-ended interval), or
-``target`` for specific DAMON monitoring target filtering.  Meaning of the
-types are same to the description on the :ref:`design doc
+Each filter directory contains nine files, namely ``type``, ``matching``,
+``allow``, ``memcg_path``, ``addr_start``, ``addr_end``, ``min``, ``max``
+and ``target_idx``.  To ``type`` file, you can write one of six special
+keywords: ``anon`` for anonymous pages, ``memcg`` for specific memory cgroup,
+``young`` for young pages, ``addr`` for specific address range (an open-ended
+interval), ``hugepage_size`` for large folios of a specific size range [``min``,
+``max``] or ``target`` for specific DAMON monitoring target filtering.  Meaning
+of the types are same to the description on the :ref:`design doc
 <damon_design_damos_filters>`.
 
 In case of the memory cgroup filtering, you can specify the memory cgroup of
_

Patches currently in -mm which might be from usamaarif642@gmail.com are


