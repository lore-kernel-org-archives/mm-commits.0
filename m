Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AF33BED27
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896702; cv=none; b=uv6rJBLZDRqSilmJjZNOt/IDm6S75YeM/acTAT2BrFjJ0j5cqxx/uYzZiqBJKe+WyJ8+pfb5MtoIJGQfW9e9zcYHWLbUfZKiM2IJ+VVInEiaIdeqb41Pvf9sQEVWJNsZY9ikOpBiyGvPIh1eoZ2ccRqYUbOnmREI063t7Nt8PA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896702; c=relaxed/simple;
	bh=DhECJ5pLK4TVanqIVWT5cDwhkGYwZi6fiZHqn5J7OnU=;
	h=Date:To:From:Subject:Message-Id; b=IK4/dgAt/x+n/cn4bZYSeUjR2rwY6PjWE1btei0cT92ezJQRRJ8UIpXk0U7XVM7neUuOFPbGTaNpDfVBUOZqNvb727dhuknyW/bF27u/eXAWHPKx7W/AyQHEkNvvJEHOs2iOyin/r8bGusoc6tWKtt3lwTYYp+Oe16Sf8DlibXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LjH2gwlI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LjH2gwlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB381F00A3A;
	Wed,  5 Aug 2026 02:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896700;
	bh=fOhztdApfA3UYrTOoxlXWmp5/3QSdK2y9gE0iOylIzQ=;
	h=Date:To:From:Subject;
	b=LjH2gwlIZqAIi72f74PzJeAcvx9dxQ4qEnzbKWgDRzi6idTOBJoGBq8pA97O812hz
	 2pAiMyMoHLQ+qwfF76u6+kyRoHKoTNhDcd3F1Qm3SGamY1cgIFgHyZ3dMFxrIfNPhQ
	 NlnjwjYETYaHyZ24CBlurJ2fcF/yCdCNdTMzqN2Q=
Date: Tue, 04 Aug 2026 19:24:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sj@kernel.org,jack@suse.cz,david@kernel.org,anshuman.khandual@arm.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-wb_writeout_inc.patch removed from -mm tree
Message-Id: <20260805022500.4EB381F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove wb_writeout_inc
has been removed from the -mm tree.  Its filename was
     mm-remove-wb_writeout_inc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove wb_writeout_inc
Date: Fri, 10 Jul 2026 07:10:52 +0200

Remove this entirely unused but exported function.

Link: https://lore.kernel.org/20260710051052.1839523-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: SJ Park <sj@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    2 --
 mm/page-writeback.c         |   10 ----------
 2 files changed, 12 deletions(-)

--- a/include/linux/backing-dev.h~mm-remove-wb_writeout_inc
+++ a/include/linux/backing-dev.h
@@ -76,8 +76,6 @@ static inline s64 wb_stat_sum(struct bdi
 	return percpu_counter_sum_positive(&wb->stat[item]);
 }
 
-extern void wb_writeout_inc(struct bdi_writeback *wb);
-
 /*
  * maximal error of a stat counter.
  */
--- a/mm/page-writeback.c~mm-remove-wb_writeout_inc
+++ a/mm/page-writeback.c
@@ -584,16 +584,6 @@ static inline void __wb_writeout_add(str
 				       wb->bdi->max_prop_frac, nr);
 }
 
-void wb_writeout_inc(struct bdi_writeback *wb)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__wb_writeout_add(wb, 1);
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL_GPL(wb_writeout_inc);
-
 /*
  * On idle system, we can be called long after we scheduled because we use
  * deferred timers so count with missed periods.
_

Patches currently in -mm which might be from hch@lst.de are

shmem-provide-a-shmem_write_folio-wrapper.patch
mm-swap-introduce-struct-swap_io_ctx.patch
mm-swap-also-use-struct-swap_iocb-for-block-i-o.patch
mm-swap-remove-count_swpout_vm_event.patch
mm-swap-use-swap_ops-to-register-swap-devices-methods.patch
mm-swap-remove-swp_fs_ops.patch
mm-vmstat-add-nrswpinout-counters.patch

