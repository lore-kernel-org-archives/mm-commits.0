Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266BE1B87C3
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837211; cv=none; b=uSplSGfcZtfh+FMAVhwpRMffPMis93EWy+ouKarR0ejIk+1/F2HthWpO02x7E1OFMzAbB2gdOEuIRgfhYPHbp7fLpCVB8NMAQQ01h66WhpFBz3POTweuC7OGq+mzIItsOcF+vludBybELHkuTwcUhIoTgZ9Wsf+NvwX9ffMheiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837211; c=relaxed/simple;
	bh=pQVTHBobWBNMJLzb49zF/BrBeasKmtIVCHXjDnPa/yo=;
	h=Date:To:From:Subject:Message-Id; b=MtHM1yInOTT1SYytRhn0Y54zn76XPpgucHmQXUbKSJh7UY2aTXa4V1jvqDITmx4T2X51IgRHaLaBrCaDXayy4eK+eJOm84tCzbnIz3XR05wrU8DM+tr+nUZw5eqVZCfn2NRGymyxmNeYocRHjbxPhuCm67OSZz/HpodRr/HWZT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qsx/3TjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qsx/3TjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14F8C4CEDD;
	Tue, 14 Jan 2025 06:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837211;
	bh=pQVTHBobWBNMJLzb49zF/BrBeasKmtIVCHXjDnPa/yo=;
	h=Date:To:From:Subject:From;
	b=qsx/3TjJE+C1yae7xjKrSkZuHNPD71QyFDlf2MrvrMdgejoLfamA1A5gtJAhq68SX
	 58YTRBlIvz0jQpXfQ6XOXIMsnJMRKAwjKZJ4HQm+5WU54znTJwgtOloG9XPbXxG0lk
	 9eYTJiAuHaEr3cN066Gz0/zDKKuEMp9Te6OrwHes=
Date: Mon, 13 Jan 2025 22:46:50 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-omit-damos-filter-details-in-favor-of-design-doc.patch removed from -mm tree
Message-Id: <20250114064650.F14F8C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: omit DAMOS filter details in favor of design doc
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-omit-damos-filter-details-in-favor-of-design-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: omit DAMOS filter details in favor of design doc
Date: Thu, 9 Jan 2025 09:51:25 -0800

DAMON usage document is describing some details about DAMOS filters, which
are also documented on the design doc.  Deduplicate the details in favor
of the design doc.

Link: https://lkml.kernel.org/r/20250109175126.57878-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   29 ++++++++---------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-omit-damos-filter-details-in-favor-of-design-doc
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -411,13 +411,17 @@ Each filter directory contains six files
 file, you can write one of five special keywords: ``anon`` for anonymous pages,
 ``memcg`` for specific memory cgroup, ``young`` for young pages, ``addr`` for
 specific address range (an open-ended interval), or ``target`` for specific
-DAMON monitoring target filtering.  In case of the memory cgroup filtering, you
-can specify the memory cgroup of the interest by writing the path of the memory
-cgroup from the cgroups mount point to ``memcg_path`` file.  In case of the
-address range filtering, you can specify the start and end address of the range
-to ``addr_start`` and ``addr_end`` files, respectively.  For the DAMON
-monitoring target filtering, you can specify the index of the target between
-the list of the DAMON context's monitoring targets list to ``target_idx`` file.
+DAMON monitoring target filtering.  Meaning of the types are same to the
+description on the :ref:`design doc <damon_design_damos_filters>`.
+
+In case of the memory cgroup filtering, you can specify the memory cgroup of
+the interest by writing the path of the memory cgroup from the cgroups mount
+point to ``memcg_path`` file.  In case of the address range filtering, you can
+specify the start and end address of the range to ``addr_start`` and
+``addr_end`` files, respectively.  For the DAMON monitoring target filtering,
+you can specify the index of the target between the list of the DAMON context's
+monitoring targets list to ``target_idx`` file.
+
 You can write ``Y`` or ``N`` to ``matching`` file to filter out pages that does
 or does not match to the type, respectively.  Then, the scheme's action will
 not be applied to the pages that specified to be filtered out.
@@ -434,14 +438,9 @@ pages of all memory cgroups except ``/ha
     echo /having_care_already > 1/memcg_path
     echo Y > 1/matching
 
-Note that ``anon`` and ``memcg`` filters are currently supported only when
-``paddr`` :ref:`implementation <sysfs_context>` is being used.
-
-Also, memory regions that are filtered out by ``addr`` or ``target`` filters
-are not counted as the scheme has tried to those, while regions that filtered
-out by other type filters are counted as the scheme has tried to.  The
-difference is applied to :ref:`stats <damos_stats>` and
-:ref:`tried regions <sysfs_schemes_tried_regions>`.
+Refer to the :ref:`DAMOS filters design documentation
+<damon_design_damos_filters>` for more details including when each of the
+filters are supported and differences on stats.
 
 .. _sysfs_schemes_stats:
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

