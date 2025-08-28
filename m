Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FF02264A3
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 22:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756420822; cv=none; b=rdrN24tNybuzRRHsSLpGO+4drqRv51q6guxKZorgrs3OSKZCQ4r1JeFKbyYhbNWLZYgwFktvEyzbhkhdFGJ9X/ReZJEsCuvtzk8gCxqEBaTAC8mVpCN5Hcakm10vummurJPqXcEdBJIpt7K471gTcmhIllGkrv9Yt01Ev0yvhfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756420822; c=relaxed/simple;
	bh=oW0NYnoTwtx/rS8kIazfDaN6id5n5pwIkrs7UwvdGsQ=;
	h=Date:To:From:Subject:Message-Id; b=q0YySKC1saJYuXGmfwb2632bvALvJAvv8rwPROjtciy9bxUGdmAkomRPm0XwA67XkCU++x1kAOyDJOTpFVtXZU/K31ccrz/dq7Qd5ymJPcqxWIiRJEYmqVRaT2yNY17YwPVmOlNNDOhNYl9Bm9EQ8+5q6UiH1AAU28sgTGvepNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W7hlBMWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W7hlBMWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8E5C4CEF4;
	Thu, 28 Aug 2025 22:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756420820;
	bh=oW0NYnoTwtx/rS8kIazfDaN6id5n5pwIkrs7UwvdGsQ=;
	h=Date:To:From:Subject:From;
	b=W7hlBMWCv9uBXucLktk07woEjGKIba6xVy3QOOk6vsDDboe0mNk06PTXSaaoyPCWp
	 glR+RnMC06Ks3TRmXiZBIrvLbAZBhE7i2Wll8ryIEwQbcCDxYFjhlLMwjDgKVjNWIH
	 S+HGlWvxfsQyb53AhgLbta0IuCRAOdCsq3SOQ2Tg=
Date: Thu, 28 Aug 2025 15:40:20 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,yanquanmin1@huawei.com,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-support-addr_unit-for-access-monitoring.patch added to mm-new branch
Message-Id: <20250828224020.CB8E5C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: support addr_unit for access monitoring
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-paddr-support-addr_unit-for-access-monitoring.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-support-addr_unit-for-access-monitoring.patch

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
Subject: mm/damon/paddr: support addr_unit for access monitoring
Date: Thu, 28 Aug 2025 10:12:33 -0700

Add support of addr_unit paramer for access monitoing operations of paddr.

Link: https://lkml.kernel.org/r/20250828171242.59810-3-sj@kernel.org
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

 mm/damon/paddr.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-addr_unit-for-access-monitoring
+++ a/mm/damon/paddr.c
@@ -18,7 +18,13 @@
 #include "../internal.h"
 #include "ops-common.h"
 
-static void damon_pa_mkold(unsigned long paddr)
+static phys_addr_t damon_pa_phys_addr(
+		unsigned long addr, unsigned long addr_unit)
+{
+	return (phys_addr_t)addr * addr_unit;
+}
+
+static void damon_pa_mkold(phys_addr_t paddr)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 
@@ -29,11 +35,12 @@ static void damon_pa_mkold(unsigned long
 	folio_put(folio);
 }
 
-static void __damon_pa_prepare_access_check(struct damon_region *r)
+static void __damon_pa_prepare_access_check(struct damon_region *r,
+		unsigned long addr_unit)
 {
 	r->sampling_addr = damon_rand(r->ar.start, r->ar.end);
 
-	damon_pa_mkold(r->sampling_addr);
+	damon_pa_mkold(damon_pa_phys_addr(r->sampling_addr, addr_unit));
 }
 
 static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
@@ -43,11 +50,11 @@ static void damon_pa_prepare_access_chec
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t)
-			__damon_pa_prepare_access_check(r);
+			__damon_pa_prepare_access_check(r, ctx->addr_unit);
 	}
 }
 
-static bool damon_pa_young(unsigned long paddr, unsigned long *folio_sz)
+static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 	bool accessed;
@@ -62,23 +69,25 @@ static bool damon_pa_young(unsigned long
 }
 
 static void __damon_pa_check_access(struct damon_region *r,
-		struct damon_attrs *attrs)
+		struct damon_attrs *attrs, unsigned long addr_unit)
 {
-	static unsigned long last_addr;
+	static phys_addr_t last_addr;
 	static unsigned long last_folio_sz = PAGE_SIZE;
 	static bool last_accessed;
+	phys_addr_t sampling_addr = damon_pa_phys_addr(
+			r->sampling_addr, addr_unit);
 
 	/* If the region is in the last checked page, reuse the result */
 	if (ALIGN_DOWN(last_addr, last_folio_sz) ==
-				ALIGN_DOWN(r->sampling_addr, last_folio_sz)) {
+				ALIGN_DOWN(sampling_addr, last_folio_sz)) {
 		damon_update_region_access_rate(r, last_accessed, attrs);
 		return;
 	}
 
-	last_accessed = damon_pa_young(r->sampling_addr, &last_folio_sz);
+	last_accessed = damon_pa_young(sampling_addr, &last_folio_sz);
 	damon_update_region_access_rate(r, last_accessed, attrs);
 
-	last_addr = r->sampling_addr;
+	last_addr = sampling_addr;
 }
 
 static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
@@ -89,7 +98,8 @@ static unsigned int damon_pa_check_acces
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t) {
-			__damon_pa_check_access(r, &ctx->attrs);
+			__damon_pa_check_access(
+					r, &ctx->attrs, ctx->addr_unit);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
 		}
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

