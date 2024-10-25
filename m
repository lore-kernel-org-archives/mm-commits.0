Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296AB20F3E3
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 20:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729887521; cv=none; b=e5uGajT1PqD1/YIXtI13Hp0zgfLcf6hlHe2XNDvWNR4CSyWINwT9zc+fjgazshzvhG62lYDcoItbfN9p23j1JTDrSdgf2zdURkzrJh3slAIAiiWBfFiC94qYaNQNIiE7ngDTQ+XFfs/Ii+Gc+v8h5y+zzdRuRl9Qkr7B07v3RAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729887521; c=relaxed/simple;
	bh=XK2HCscZ4+wJSg5rQIgl5mIfQJl/z/Xew9tO4g+HRgI=;
	h=Date:To:From:Subject:Message-Id; b=ZytG1z73zKXdOotqzSLJ8XOvxtOLdbkWtwdhA/SofbUwD5bp+oEaZoRiDe99mt+WY5o1gT+VdiIlt5SyZ2ZBXHcwb2UONKelh5dEcAy3jlOSRsNfL19ZBcPBw5nYU4IBrS6jNSybRnfLkLn1wMBWjzRGr+GYuH8WTXCPeWalbW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kz1T8Ix7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kz1T8Ix7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F80C4CEC3;
	Fri, 25 Oct 2024 20:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729887519;
	bh=XK2HCscZ4+wJSg5rQIgl5mIfQJl/z/Xew9tO4g+HRgI=;
	h=Date:To:From:Subject:From;
	b=kz1T8Ix7ni2jeZNgmQQgRw6/kiwBoIAXv6KYKmiLumPt3k9NV+UsZJbVzleRFgpT7
	 ZGmjA42/DEbj/flS2BbT+Eqz9Uee3XDZCdJ/COnIhmFTd6iEEDoP51XbDHLL3WoMPF
	 9ln5fhXH9srHQ9532PCfXMTwk9aaeVQ6KyzFiNhk=
Date: Fri, 25 Oct 2024 13:18:38 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-v1-no-need-for-memcg-locking-for-writeback-tracking.patch added to mm-unstable branch
Message-Id: <20241025201839.97F80C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-v1: no need for memcg locking for writeback tracking
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-v1-no-need-for-memcg-locking-for-writeback-tracking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-v1-no-need-for-memcg-locking-for-writeback-tracking.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg-v1: no need for memcg locking for writeback tracking
Date: Thu, 24 Oct 2024 18:23:01 -0700

During the era of memcg charge migration, the kernel has to be make
sure that the writeback stat updates do not race with the charge
migration.  Otherwise it might update the writeback stats of the wrong
memcg.  Now with the memcg charge migration gone, there is no more race
for writeback stat updates and the previous locking can be removed.

Link: https://lkml.kernel.org/r/20241025012304.2473312-5-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/page-writeback.c~memcg-v1-no-need-for-memcg-locking-for-writeback-tracking
+++ a/mm/page-writeback.c
@@ -3083,7 +3083,6 @@ bool __folio_end_writeback(struct folio
 	struct address_space *mapping = folio_mapping(folio);
 	bool ret;
 
-	folio_memcg_lock(folio);
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
@@ -3114,7 +3113,6 @@ bool __folio_end_writeback(struct folio
 	lruvec_stat_mod_folio(folio, NR_WRITEBACK, -nr);
 	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
 	node_stat_mod_folio(folio, NR_WRITTEN, nr);
-	folio_memcg_unlock(folio);
 
 	return ret;
 }
@@ -3127,7 +3125,6 @@ void __folio_start_writeback(struct foli
 
 	VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
 
-	folio_memcg_lock(folio);
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		XA_STATE(xas, &mapping->i_pages, folio_index(folio));
 		struct inode *inode = mapping->host;
@@ -3168,7 +3165,6 @@ void __folio_start_writeback(struct foli
 
 	lruvec_stat_mod_folio(folio, NR_WRITEBACK, nr);
 	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
-	folio_memcg_unlock(folio);
 
 	access_ret = arch_make_folio_accessible(folio);
 	/*
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-optimize-truncation-of-shadow-entries.patch
mm-optimize-invalidation-of-shadow-entries.patch
mm-truncate-reset-xa_has_values-flag-on-each-iteration.patch
memcg-add-tracing-for-memcg-stat-updates.patch
memcg-add-tracing-for-memcg-stat-updates-v2.patch
memcg-v1-fully-deprecate-move_charge_at_immigrate.patch
memcg-v1-remove-charge-move-code.patch
memcg-v1-no-need-for-memcg-locking-for-dirty-tracking.patch
memcg-v1-no-need-for-memcg-locking-for-writeback-tracking.patch
memcg-v1-no-need-for-memcg-locking-for-mglru.patch
memcg-v1-remove-memcg-move-locking-code.patch

