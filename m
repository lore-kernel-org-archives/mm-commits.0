Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8805B285049
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 22:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756420833; cv=none; b=COi3lo7qfac4Ihlb272RbkEiX3g2J3y3TIqS/jBOTBOBTNoUhL0EOfo56MweS/Z24la4BnkGJEiSyUPExIvm4I47nQFxXrUnai5LCbmMmVzg4h6X8nOISL6sZDQzyFUSQcPwcx0jOGb0mxEQTqjuICJPsmhno2rNN4Gl9EVGz2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756420833; c=relaxed/simple;
	bh=ao4GKCwpo9RF3FP1tCJPfrUjbuMmTTbs5HBdHZEeq90=;
	h=Date:To:From:Subject:Message-Id; b=kazEBwusgh3rr6AM2pe24/GmnKxaLxkw78HNybPvgpYc8SxOjwgpPT/+hjHfJRxsFBWBiQcJMKxEdhpcp7sJGmQfg/7bbvqHSjVqJASXjTuJOP2ZpwrIJlNCTyH1Vv+JgN7WrILdqHM8Y2D2TmJVOq36YY5VUsIkcic75ZNRK+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YSpnhUEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YSpnhUEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B54BC4CEEB;
	Thu, 28 Aug 2025 22:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756420833;
	bh=ao4GKCwpo9RF3FP1tCJPfrUjbuMmTTbs5HBdHZEeq90=;
	h=Date:To:From:Subject:From;
	b=YSpnhUEd4pp6uyYJ9V2S2zF/80K/BqA3NRehd/MbasGEredNDXdGLl4klGEObA46b
	 WnVAwyezGOVvCe4xSYmfq+oGKaFBapBZEIZ9+YvEsQasNSjwGLudGehIk6tHG2tEW9
	 iTztrJ4Qyx4P+1ZAAxbk+B8Lfrap1YjgnBi+v7DU=
Date: Thu, 28 Aug 2025 15:40:32 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,yanquanmin1@huawei.com,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-address-unit-parameter.patch added to mm-new branch
Message-Id: <20250828224033.5B54BC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: document 'address unit' parameter
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-document-address-unit-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-address-unit-parameter.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document 'address unit' parameter
Date: Thu, 28 Aug 2025 10:12:39 -0700

Add 'addr_unit' parameter description on DAMON design document.

Link: https://lkml.kernel.org/r/20250828171242.59810-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: ze zuo <zuoze1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-address-unit-parameter
+++ a/Documentation/mm/damon/design.rst
@@ -67,7 +67,7 @@ processes, NUMA nodes, files, and backin
 Also, if some architectures or devices support special optimized access check
 features, those will be easily configurable.
 
-DAMON currently provides below three operation sets.  Below two subsections
+DAMON currently provides below three operation sets.  Below three subsections
 describe how those work.
 
  - vaddr: Monitor virtual address spaces of specific processes
@@ -135,6 +135,18 @@ the interference is the responsibility o
 conflict with the reclaim logic using ``PG_idle`` and ``PG_young`` page flags,
 as Idle page tracking does.
 
+Address Unit
+------------
+
+DAMON core layer uses ``unsinged long`` type for monitoring target address
+ranges.  In some cases, the address space for a given operations set could be
+too large to be handled with the type.  ARM (32-bit) with large physical
+address extension is an example.  For such cases, a per-operations set
+parameter called ``address unit`` is provided.  It represents the scale factor
+that need to be multiplied to the core layer's address for calculating real
+address on the given address space.  Support of ``address unit`` parameter is
+up to each operations set implementation.  ``paddr`` is the only operations set
+implementation that supports the parameter.
 
 .. _damon_core_logic:
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch
mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch
mm-damon-core-add-damon_ctx-addr_unit.patch
mm-damon-paddr-support-addr_unit-for-access-monitoring.patch
mm-damon-paddr-support-addr_unit-for-damos_pageout.patch
mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch
mm-damon-paddr-support-addr_unit-for-damos_stat.patch
mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch
docs-mm-damon-design-document-address-unit-parameter.patch
docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch
docs-abi-damon-document-addr_unit-file.patch

