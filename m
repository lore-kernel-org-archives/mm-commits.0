Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1053F44D5
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525398; cv=none; b=cWGXnTiBS1epB9QV15GoloaIHWZRGTWZtrRZrMrwaMdOxRAcBYBxAkPUvfMMt32IrKYdVUXFnUgl3h0OWqx6b24C2Aec0G2rIZ4X7SLPkYyZjqXHI7YPZ4IouqTjkdKPI3ujE1SAk2MW4dLxV1e3+rslbZxOStRPg1WpjyXScSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525398; c=relaxed/simple;
	bh=FIfFhBsztFSqWOFUqPynoxWIk8OjVGmkBAMQevhRRek=;
	h=Date:To:From:Subject:Message-Id; b=G/j8RoLDuvljbsjBHTk+tykN2zBjYGqyT23EQVqTpfhD4g6d9MDdl8uvr7/+XAcHYEW4tUwELKGA7dukpoNN29O37NfO5VTwGi2pe21YNRnEzFRSD5Fnkg0nByvBM5JSgr6PPcqw+9d4dAduC1k9yCYk8hQ4FO3UhY64sJJWS8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0qWzPydo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0qWzPydo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20BC1F00898;
	Fri,  9 Oct 2026 05:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525396;
	bh=Ip2IrgH/I1jtVMCBH7GU3XytLJTWnsoPDt4IVf/KBn8=;
	h=Date:To:From:Subject;
	b=0qWzPydoDuh9BQJzGfmw26+qKFc3YSuHVuR4ZNdxbSLHm4GJvDY1r224Pt2vvy3pD
	 FnHcy2WMF6JGEdSVUEleQm2VeoI1lgqIWRnL+x6PpJ79aeEmmYnZXNfabtJlRCgbX2
	 A+IEI4J3JIztFxDWIqeZlhD+CcOELdAF9cEXGCxU=
Date: Thu, 08 Oct 2026 22:56:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pagewriteback.patch removed from -mm tree
Message-Id: <20261009055636.D20BC1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PageWriteback
has been removed from the -mm tree.  Its filename was
     mm-remove-pagewriteback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove PageWriteback
Date: Sat, 05 Sep 2026 15:08:30 -0400

The last caller of PageWriteback() was removed in commit f75987e543c2
("libceph: remove pinning assertion in ceph_msg_data_iter_next()").  This
flag is now only used on folios, so we can remove all the page accessors. 
folio_test_clear_writeback() is not used, so don't add
FOLIO_TEST_CLEAR_FLAG() for it.

Link: https://lore.kernel.org/20260905-remove-pagewriteback-v1-1-06f41c00db03@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pagewriteback
+++ a/include/linux/page-flags.h
@@ -588,8 +588,8 @@ FOLIO_FLAG(owner_2, FOLIO_HEAD_PAGE)
  * Only test-and-set exist for PG_writeback.  The unconditional operators are
  * risky: they bypass page accounting.
  */
-TESTPAGEFLAG(Writeback, writeback, PF_NO_TAIL)
-	TESTSCFLAG(Writeback, writeback, PF_NO_TAIL)
+FOLIO_TEST_FLAG(writeback, FOLIO_HEAD_PAGE)
+	FOLIO_TEST_SET_FLAG(writeback, FOLIO_HEAD_PAGE)
 FOLIO_FLAG(mappedtodisk, FOLIO_HEAD_PAGE)
 
 /* PG_readahead is only used for reads; PG_reclaim is only for writes */
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch
mm-memcontrol-constify-obj_cgroup_memcg-and-friends.patch
mm-memcontrol-constify-the-lruvec-helpers.patch
mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch
mm-memcontrol-constify-the-mem_cgroup-accessors.patch
mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch
mm-memcontrol-constify-the-reclaim-protection-helpers.patch
mm-memcontrol-constify-the-memcg-and-lruvec-stat-readers.patch
mm-memcontrol-constify-the-swap-accounting-helpers.patch
mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch
mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch
vmcore-convert-mmap_vmcore_fault-to-use-folios.patch

