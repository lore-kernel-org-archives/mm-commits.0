Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D8219E7E2
	for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2025 23:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755905822; cv=none; b=DfH38rd/etDLd1hoNAm8yIPxjXiD7YznzrTHRG4sRRzz4O9otBsWGF5K5+eMvIcHHYlOpjkBO4NqNK2ml2mlDeDUDJeHUwEH9k9LVK0GaUMzOtzRuQXnJXIUdYBAJFt7TJEfKMiwzjFJdTCjVx9601Fh7wzI+zk+p6WH1bYONVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755905822; c=relaxed/simple;
	bh=puq5OVZBcjJGrFStJk5d7C9PnWt5l62CyxQ5rlTYSEY=;
	h=Date:To:From:Subject:Message-Id; b=DPaZ+e4NzbVatQ8WFAZc1Hlu//i1lKFSe5M/mzkVsRLDXNU2gF6mOvZkFoojuqyARJ0OuZuqARvb+rEOYfo0oCcu6GjZiThL+rgfilDds5UO0iupOSKB3aWIlKA/mghQRYeClwANwe7+bxpn0KqS4OOtpj0VlL8YnaaHyFT0C7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HSZ/e2Ku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HSZ/e2Ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A21C4CEED;
	Fri, 22 Aug 2025 23:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755905820;
	bh=puq5OVZBcjJGrFStJk5d7C9PnWt5l62CyxQ5rlTYSEY=;
	h=Date:To:From:Subject:From;
	b=HSZ/e2KuQcJKvgG8oigN1L1ujb11VA2Tw3wONnfuvJuOtCH4P5eCncve4IziDV93z
	 SmYwvOd/MCUNHerG6qzsoCNRersaXqcYm28fj5IuAdGiLhwLh+beknte6qknFktdXU
	 UQNxrF3hJdGgKVCWy+T2KqRiyciS9gSPganaMD1g=
Date: Fri, 22 Aug 2025 16:36:59 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,yanquanmin1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-damon_ctx-addr_unit.patch added to mm-new branch
Message-Id: <20250822233700.77A21C4CEED@smtp.kernel.org>
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
Date: Fri, 22 Aug 2025 17:34:09 +0800

Patch series "mm/damon: support ARM32 with LPAE", v2.

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

Link: https://lkml.kernel.org/r/20250822093420.2103803-2-yanquanmin1@huawei.com
Link: https://lore.kernel.org/20250408075553.959388-1-zuoze1@huawei.com [1]
Link: https://lore.kernel.org/all/20250416042551.158131-1-sj@kernel.org/ [2]
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
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

