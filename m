Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AE4145B07
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 23:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041371; cv=none; b=mO7/2XW1I8htx6kaC1ygrPrPVDS+oDf4CY9d1A5sivlvzR9SaXo/+UsUuXjIsE4jKwqvp3tkVJrqodWzuJSyD9VugaRzAx4I0flWne/pPtvbpwB0Ov7HX1KVwn57ic5+WLik7UPIWoK0Wr5uPgQCpCY3DvEBcOd7Lf7XJmMQ1cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041371; c=relaxed/simple;
	bh=Nh0FFts2264q3UCz+cEdeE3plAuapVrRVMYmfaRlHgo=;
	h=Date:To:From:Subject:Message-Id; b=dvA6fM+20B3dHHeHhmCHhEi7rnSQZsZ8R4qds52L2Qi0sYEUXbpCt4ASwzCkwCk9HPQ+8MLo6jwxCqNWus91R1sy4Gl5iepjUVotx7luhDj7xSW45UuW7RxtuHFk394Uvx4ga0Iuo/LtBBITVn0Y3fOYv0OWkx8Tys9+hQsGA3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GHsYaDDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GHsYaDDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C68C433C7;
	Thu, 15 Feb 2024 23:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708041371;
	bh=Nh0FFts2264q3UCz+cEdeE3plAuapVrRVMYmfaRlHgo=;
	h=Date:To:From:Subject:From;
	b=GHsYaDDAh0RHXOWmAtTsJ/Y03DH+//8V+9W0FGVtImrFl30XOQGGdsjycs4LXDg3U
	 NBZYkOiHWt5Vgg+ajw4uuHoPPt39q5I3uhvKsqRcZRyH8hsOZbDLO+5TKJcScduSbj
	 X9aH9ahMW0XlMx5J+9z3EoyPxvt8USsD4Ws+wk54=
Date: Thu, 15 Feb 2024 15:56:10 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,rppt@kernel.org,pasha.tatashin@soleen.com,mhocko@suse.com,mgorman@techsingularity.net,kent.overstreet@linux.dev,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-document-memalloc_noreclaim_save-and-memalloc_pin_save-v2.patch added to mm-unstable branch
Message-Id: <20240215235611.84C68C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-document-memalloc_noreclaim_save-and-memalloc_pin_save-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-document-memalloc_noreclaim_save-and-memalloc_pin_save-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-document-memalloc_noreclaim_save-and-memalloc_pin_save-v2.patch

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

mm-document-memalloc_noreclaim_save-and-memalloc_pin_save.patch
mm-document-memalloc_noreclaim_save-and-memalloc_pin_save-v2.patch

