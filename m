Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4680272908
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 23:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739315441; cv=none; b=W5k8OviMl+tOJ/rmf9BdqwJ1FOJ9QFy7jTWirjgg2CRnSBZQuQLs98vfl4d5r6ilCIiBZhxqiBu7Mffq8Z+4m9O+I4XEptiUwiRGTir2B5AnIGT7gQES6ur8A5a1hA+lI2gHC1tI8jmDh2LT6mjIZ5xt5TOpb40v7mrhE95pT84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739315441; c=relaxed/simple;
	bh=G4CJf985elgCrBnBFG6Z2axJ0Zeg00gF/vKnUgs1dF8=;
	h=Date:To:From:Subject:Message-Id; b=LyTz4fB94zSW+dMB5pcNrghy7eNr1NujU/z00LM7DUpN5xXl2oaNqndaf57GZmI3OepenhE7v4ngwWmyw3hH3U8ntaQbQHQy2IbscWl9OEAUYvyzx0X1O9nO2ojE6zbG5kob+90uimYNIVO2jghWoiYrbQW+O7PMZkyFVOU0TVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wqNI8+4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wqNI8+4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4722BC4CEE6;
	Tue, 11 Feb 2025 23:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739315440;
	bh=G4CJf985elgCrBnBFG6Z2axJ0Zeg00gF/vKnUgs1dF8=;
	h=Date:To:From:Subject:From;
	b=wqNI8+4PUUYyH1XcgItAo/Pz5pIiOc3jLtlpteQc6pxvGnBcbJYIuLsxqG6o/cW/X
	 U/AJlbCIyD/YBBNlJtKnWfC3WPR9EFypdi5bWzX4AKHbrFkp+h36baZP48pvUTv/L6
	 CjyH9tUF9+zXzdAaAF8hVXsWn2/hGHZjT6STz+yI=
Date: Tue, 11 Feb 2025 15:10:39 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,hannes@cmpxchg.org,david@redhat.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-hugepage_size-filter-type.patch added to mm-unstable branch
Message-Id: <20250211231040.4722BC4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document hugepage_size filter type
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-hugepage_size-filter-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-hugepage_size-filter-type.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-damon-ops-have-damon_get_folio-return-folio-even-for-tail-pages.patch
mm-damon-introduce-damos-filter-type-hugepage_size.patch
mm-damon-sysfs-schemes-add-files-for-setting-damos_filter-sz_range.patch
docs-abi-damon-document-damos-sysfs-files-to-set-the-min-max-folio_size.patch
docs-admin-guide-mm-damon-usage-document-hugepage_size-filter-type.patch

