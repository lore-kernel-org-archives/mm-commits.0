Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6969712CD85
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 23:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559420; cv=none; b=Eg1FFHQx8aq4Bsvh9xx2XYDQbzZdbAkUkm+qUG23ATx+SBxIdvJ4bOJCG+5bbsWFNnEa55vlrDPQPPekKSPw5jMzFB4hOijGzPjwLh0wHZsUyBWigIHZAcbd3QN+TOlCMjQZbPdaeTv0f6wSE7AXU+ITVLUxrfWKZs6qa7rAkQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559420; c=relaxed/simple;
	bh=RQfiEcjVxZC57t5c7tFbp2fmzQOa22GYo7jleErpLzo=;
	h=Date:To:From:Subject:Message-Id; b=ViIggQo7IDHhQP3GZHvAolGAmiBgI9mkAES6/H5EtPUh5Uz0i7LxInnxT2aW2r2TAcCMrw/mrvU2/1t2+p4MQfbB32jrTveWeZ2E0GKvXsjpW+G4kczPiAoMBFXS5XBPlOteTiU2FTfPiMx3yszjHC+owrZr5VkWBaiCCNORFkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZdOJgp7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZdOJgp7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF1EC43390;
	Wed, 21 Feb 2024 23:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708559420;
	bh=RQfiEcjVxZC57t5c7tFbp2fmzQOa22GYo7jleErpLzo=;
	h=Date:To:From:Subject:From;
	b=ZdOJgp7SWhJ89cwo9j/swUDkdlFD3dcN6XqTI6w0ItbVOCYvH9QFxRIQCYGuMq7/S
	 mxGk0OPEL7FABZI+arr8zMO3YDsIN2S76VDLUsywGoq6EXFbdFPK2Y6uIOfBSmOhrr
	 s4ZPna7qLQ3RM6pMyI0q7kAg+63DcHJlY00HmIss=
Date: Wed, 21 Feb 2024 15:50:19 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,rppt@kernel.org,pasha.tatashin@soleen.com,mhocko@suse.com,mgorman@techsingularity.net,kent.overstreet@linux.dev,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-document-memalloc_noreclaim_save-and-memalloc_pin_save-v2.patch removed from -mm tree
Message-Id: <20240221235020.2FF1EC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-document-memalloc_noreclaim_save-and-memalloc_pin_save-v2
has been removed from the -mm tree.  Its filename was
     mm-document-memalloc_noreclaim_save-and-memalloc_pin_save-v2.patch

This patch was dropped because it was folded into mm-document-memalloc_noreclaim_save-and-memalloc_pin_save.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-document-memalloc_noreclaim_save-and-memalloc_pin_save-v2
Date: Thu, 15 Feb 2024 10:58:28 +0100

fix issues that Mike pointed out

Link: https://lkml.kernel.org/r/20240215095827.13756-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/include/linux/sched/mm.h~mm-document-memalloc_noreclaim_save-and-memalloc_pin_save-v2
+++ a/include/linux/sched/mm.h
@@ -315,7 +315,8 @@ static inline void might_alloc(gfp_t gfp
  * point of view. Use memalloc_noio_restore to end the scope with flags
  * returned by this function.
  *
- * This function is safe to be used from any context.
+ * Context: This function is safe to be used from any context.
+ * Return: The saved flags to be passed to memalloc_noio_restore.
  */
 static inline unsigned int memalloc_noio_save(void)
 {
@@ -346,7 +347,8 @@ static inline void memalloc_noio_restore
  * point of view. Use memalloc_nofs_restore to end the scope with flags
  * returned by this function.
  *
- * This function is safe to be used from any context.
+ * Context: This function is safe to be used from any context.
+ * Return: The saved flags to be passed to memalloc_nofs_restore.
  */
 static inline unsigned int memalloc_nofs_save(void)
 {
@@ -371,7 +373,7 @@ static inline void memalloc_nofs_restore
 /**
  * memalloc_noreclaim_save - Marks implicit __GFP_MEMALLOC scope.
  *
- * This functions marks the beginning of the __GFP_MEMALLOC allocation scope.
+ * This function marks the beginning of the __GFP_MEMALLOC allocation scope.
  * All further allocations will implicitly add the __GFP_MEMALLOC flag, which
  * prevents entering reclaim and allows access to all memory reserves. This
  * should only be used when the caller guarantees the allocation will allow more
@@ -386,8 +388,10 @@ static inline void memalloc_nofs_restore
  *
  * Individual allocations under the scope can opt out using __GFP_NOMEMALLOC
  *
- * This function should not be used in an interrupt context as that one does not
- * give PF_MEMALLOC access to reserves, see __gfp_pfmemalloc_flags().
+ * Context: This function should not be used in an interrupt context as that one
+ *          does not give PF_MEMALLOC access to reserves.
+ *          See __gfp_pfmemalloc_flags().
+ * Return: The saved flags to be passed to memalloc_noreclaim_restore.
  */
 static inline unsigned int memalloc_noreclaim_save(void)
 {
@@ -412,10 +416,12 @@ static inline void memalloc_noreclaim_re
 /**
  * memalloc_pin_save - Marks implicit ~__GFP_MOVABLE scope.
  *
- * This functions marks the beginning of the ~__GFP_MOVABLE allocation scope.
+ * This function marks the beginning of the ~__GFP_MOVABLE allocation scope.
  * All further allocations will implicitly remove the __GFP_MOVABLE flag, which
  * will constraint the allocations to zones that allow long term pinning, i.e.
  * not ZONE_MOVABLE zones.
+ *
+ * Return: The saved flags to be passed to memalloc_pin_restore.
  */
 static inline unsigned int memalloc_pin_save(void)
 {
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-vmscan-prevent-infinite-loop-for-costly-gfp_noio-__gfp_retry_mayfail-allocations.patch
mm-document-memalloc_noreclaim_save-and-memalloc_pin_save.patch

