Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A4A261B6E
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 22:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756420818; cv=none; b=hQuUgGJU9CoML+WqdCNOVoLS4g7iXU3uCMpB5RdQx7K2oYNi2zNKoluByF2lec3O20QLU6aC7swr0WFTF6OuqID6wHKP0gSnZvx7Lc9a1H6ZRiQNKrZLwLoX1fMfjey6nVmt9suREMVOjeT9TeinHNMZlwBdbL6Ysb8EyciJHcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756420818; c=relaxed/simple;
	bh=5uKFSV6UUqHAeaqtgyXI8XvfE4uVP383QqbN4+Okbsg=;
	h=Date:To:From:Subject:Message-Id; b=JpvE/u0VPzukZZ9Fbxeu0n9jL7iDVcB9dgOBVjXwk7rJhY3zsRk2JjEJPDbo9OVh7KDUr2LkPTD6PzkUfG3zlbEk0PrfQyNwR1Wd2qxRyBPervdIknAKAIekr7/JEKrufrX692JHqWod/9YEjKwXjtJPjyYQDCfUgcJvxJ7NW24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vsk+oFk8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vsk+oFk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56490C4CEEB;
	Thu, 28 Aug 2025 22:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756420818;
	bh=5uKFSV6UUqHAeaqtgyXI8XvfE4uVP383QqbN4+Okbsg=;
	h=Date:To:From:Subject:From;
	b=vsk+oFk84+kE4Q/THjf16CkRXGBauVjjRQdyi5MwuYj1/TZ3vkfZRtuAUYkIjdB23
	 mi+nNl7+ffWZgTHc+TkY+WYHftrFbw2ljWjOCTNGW+ldGq/aVDCxzcu5ZLii0xrSTX
	 drr9EXbRS/wgbpZ5kCoOmm64CJsnX9pKcAmMNoIk=
Date: Thu, 28 Aug 2025 15:40:17 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,yanquanmin1@huawei.com,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-damon_ctx-addr_unit.patch added to mm-new branch
Message-Id: <20250828224018.56490C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: add damon_ctx->addr_unit
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-add-damon_ctx-addr_unit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-damon_ctx-addr_unit.patch

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
Subject: mm/damon/core: add damon_ctx->addr_unit
Date: Thu, 28 Aug 2025 10:12:32 -0700

Patch series "mm/damon: support ARM32 with LPAE", v3.

Previously, DAMON's physical address space monitoring only supported
memory ranges below 4GB on LPAE-enabled systems.  This was due to the use
of 'unsigned long' in 'struct damon_addr_range', which is 32-bit on ARM32
even with LPAE enabled[1].

To add DAMON support for ARM32 with LPAE enabled, a new core layer
parameter called 'addr_unit' was introduced[2].  Operations set layer can
translate a core layer address to the real address by multiplying the
parameter value to the core layer address.  Support of the parameter is up
to each operations layer implementation, though.  For example, operations
set implementations for virtual address space can simply ignore the
parameter.  Add the support on paddr, which is the DAMON operations set
implementation for the physical address space, as we have a clear use case
for that.


This patch (of 11):

In some cases, some of the real address that handled by the underlying
operations set cannot be handled by DAMON since it uses only 'unsinged
long' as the address type.  Using DAMON for physical address space
monitoring of 32 bit ARM devices with large physical address extension
(LPAE) is one example[1].

Add a parameter name 'addr_unit' to core layer to help such cases.  DAMON
core API callers can set it as the scale factor that will be used by the
operations set for translating the core layer's addresses to the real
address by multiplying the parameter value to the core layer address. 
Support of the parameter is up to each operations set layer.  The support
from the physical address space operations set (paddr) will be added with
following commits.

Link: https://lkml.kernel.org/r/20250828171242.59810-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250828171242.59810-2-sj@kernel.org
Link: https://lore.kernel.org/20250408075553.959388-1-zuoze1@huawei.com [1]
Link: https://lore.kernel.org/all/20250416042551.158131-1-sj@kernel.org/ [2]
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

 include/linux/damon.h |    3 ++-
 mm/damon/core.c       |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-add-damon_ctx-addr_unit
+++ a/include/linux/damon.h
@@ -746,7 +746,7 @@ struct damon_attrs {
  * Accesses to other fields must be protected by themselves.
  *
  * @ops:	Set of monitoring operations for given use cases.
- *
+ * @addr_unit:	Scale factor for core to ops address conversion.
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
  */
@@ -788,6 +788,7 @@ struct damon_ctx {
 	struct mutex kdamond_lock;
 
 	struct damon_operations ops;
+	unsigned long addr_unit;
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
--- a/mm/damon/core.c~mm-damon-core-add-damon_ctx-addr_unit
+++ a/mm/damon/core.c
@@ -544,6 +544,8 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.min_nr_regions = 10;
 	ctx->attrs.max_nr_regions = 1000;
 
+	ctx->addr_unit = 1;
+
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
 
@@ -1245,6 +1247,7 @@ int damon_commit_ctx(struct damon_ctx *d
 			return err;
 	}
 	dst->ops = src->ops;
+	dst->addr_unit = src->addr_unit;
 
 	return 0;
 }
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

