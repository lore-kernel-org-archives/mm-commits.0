Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EE736130
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 02:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728008784; cv=none; b=rxZP1QzbN3mqfbuvTvIo4kIUlv8uxfXRzwDmHse6gdS+tiAhOFLQqCo59q+UAlsdUCFZv/LgoMTUedroBT0pWB3MFqTn5QpTD1fqWvHL5mv3NJXL5F9yU6YCymtQ6pHvtgEYr5bdUh3MQNk1ri0rgg7h6DCyW5a7Blse0u4S9lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728008784; c=relaxed/simple;
	bh=/9/dENof3FV+wo1y9AbGOlrUWtjoxtrfGh/fIeVTFxc=;
	h=Date:To:From:Subject:Message-Id; b=fuIis7/+gV3DjXCWBLUCGAKXTsMfZLJg2tRUYkGHwBC7S3oaMKJwdFMAyxlTA73R4l5zBb/bRVi1MH9mgQlSCxE3d4GtoopMe7oIieg+6KzNeMLyN/Qwm+mOs1wkGM32t1clvAFCJ/Ke+hCX1MhPIDOOjvKoNR2W5tuh/5sHX1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AhIGEEU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AhIGEEU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F374C4CEC5;
	Fri,  4 Oct 2024 02:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728008784;
	bh=/9/dENof3FV+wo1y9AbGOlrUWtjoxtrfGh/fIeVTFxc=;
	h=Date:To:From:Subject:From;
	b=AhIGEEU0B97VeuJkweHDEvoM1MKWEsAvkKk+7ChEBWGimnpnSKx5Wpu1V8Fe8ys2M
	 cdiMHGMYwijIqnunOk/Vhx9y56iQ/Ia87dmdvohzaIxEeqaDJYT/zkw1mzG3PvGfWS
	 HLkBeCXCvKUjlYNH7gzpV0epfN+lhpYaVkDj95eU=
Date: Thu, 03 Oct 2024 19:26:23 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,wajdi.k.feghali@intel.com,usamaarif642@gmail.com,ryan.roberts@arm.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zswap-delete-comments-for-value-member-of-struct-zswap_entry.patch removed from -mm tree
Message-Id: <20241004022624.4F374C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: delete comments for "value" member of 'struct zswap_entry'.
has been removed from the -mm tree.  Its filename was
     mm-zswap-delete-comments-for-value-member-of-struct-zswap_entry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: mm: zswap: delete comments for "value" member of 'struct zswap_entry'.
Date: Wed, 2 Oct 2024 12:42:13 -0700

Made a minor edit in the comments for 'struct zswap_entry' to delete the
description of the 'value' member that was deleted in commit 20a5532ffa53
("mm: remove code to handle same filled pages").

Link: https://lkml.kernel.org/r/20241002194213.30041-1-kanchana.p.sridhar@intel.com
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Fixes: 20a5532ffa53 ("mm: remove code to handle same filled pages")
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Usama Arif <usamaarif642@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-delete-comments-for-value-member-of-struct-zswap_entry
+++ a/mm/zswap.c
@@ -190,7 +190,6 @@ static struct shrinker *zswap_shrinker;
  *              section for context.
  * pool - the zswap_pool the entry's data is in
  * handle - zpool allocation handle that stores the compressed page data
- * value - value of the same-value filled pages which have same content
  * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
  */
_

Patches currently in -mm which might be from kanchana.p.sridhar@intel.com are

mm-define-obj_cgroup_get-if-config_memcg-is-not-defined.patch
mm-zswap-modify-zswap_compress-to-accept-a-page-instead-of-a-folio.patch
mm-zswap-rename-zswap_pool_get-to-zswap_pool_tryget.patch
mm-change-count_objcg_event-to-count_objcg_events-for-batch-event-updates.patch
mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t.patch
mm-zswap-support-large-folios-in-zswap_store.patch
mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats.patch
mm-zswap-zswap_store_page-will-initialize-entry-after-adding-to-xarray.patch
mm-swap-make-some-count_mthp_stat-call-sites-be-thp-agnostic.patch

