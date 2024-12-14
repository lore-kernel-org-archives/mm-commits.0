Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1523208
	for <mm-commits@vger.kernel.org>; Sat, 14 Dec 2024 00:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734136448; cv=none; b=NPbmwhFLlW1DKpPj8tT8ZnrJYDWBk7+LBWYe+cWn5SbHkFa1OyCiepFi/itoeEx/0eMdFX67ocS/ty3SzPrWHbgcuM/82GA2T/OdL0XvbCttFI3BXntnPArszevPMeOCcf82OlwgWeRkx7uQImHjiNjlwrAZ4109heoYdIy62cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734136448; c=relaxed/simple;
	bh=FXHStf09VS3P9UXhRgOxqAsOqiegPApjO4BHetC+rY4=;
	h=Date:To:From:Subject:Message-Id; b=B7G9xs7cLlX9dypLChcyNMghQAM6s7dof/hYlvGq4OLOit24Ui/pNcU8HixM7XWOOwrn1ClMYulND3M4x7xqaVqY/oyJWCwSRRoPZhRLo8amWAOsiTd+6oH40E2Om+LNZzJLhdukJ2oUMcyCi5BW7BbRVNoFZ7GEUSM/TOwBUp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BkBLakDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BkBLakDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BB0C4CED0;
	Sat, 14 Dec 2024 00:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734136447;
	bh=FXHStf09VS3P9UXhRgOxqAsOqiegPApjO4BHetC+rY4=;
	h=Date:To:From:Subject:From;
	b=BkBLakDAQhXeqmrfFf2FHtKZ6RBa/lAId1seKwCYQLfAp3VYWU/XFrJAhgIk5mZFl
	 daNoArJoV/BvInxCwbKNXS7d6YfP2+4L3D/KIm2ngLJZXhm3I/f9mfDw1VuzrEJSrA
	 lK1E4AaT+p5E9bnvZki023avoafsUFDSgpBQWU7U=
Date: Fri, 13 Dec 2024 16:34:07 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,mszeredi@redhat.com,josef@toxicpanda.com,jefflexu@linux.alibaba.com,bernd.schubert@fastmail.fm,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-skip-reclaiming-folios-in-legacy-memcg-writeback-indeterminate-contexts.patch added to mm-unstable branch
Message-Id: <20241214003407.D0BB0C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: skip reclaiming folios in legacy memcg writeback indeterminate contexts
has been added to the -mm mm-unstable branch.  Its filename is
     mm-skip-reclaiming-folios-in-legacy-memcg-writeback-indeterminate-contexts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-skip-reclaiming-folios-in-legacy-memcg-writeback-indeterminate-contexts.patch

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
From: Joanne Koong <joannelkoong@gmail.com>
Subject: mm: skip reclaiming folios in legacy memcg writeback indeterminate contexts
Date: Fri, 22 Nov 2024 15:23:56 -0800

Currently in shrink_folio_list(), reclaim for folios under writeback falls
into 3 different cases:

1) Reclaim is encountering an excessive number of folios under
   writeback and this folio has both the writeback and reclaim flags
   set
2) Dirty throttling is enabled (this happens if reclaim through cgroup
   is not enabled, if reclaim through cgroupv2 memcg is enabled, or
   if reclaim is on the root cgroup), or if the folio is not marked for
   immediate reclaim, or if the caller does not have __GFP_FS (or
   __GFP_IO if it's going to swap) set
3) Legacy cgroupv1 encounters a folio that already has the reclaim flag
   set and the caller did not have __GFP_FS (or __GFP_IO if swap) set

In cases 1) and 2), we activate the folio and skip reclaiming it while in
case 3), we wait for writeback to finish on the folio and then try to
reclaim the folio again.  In case 3, we wait on writeback because cgroupv1
does not have dirty folio throttling, as such this is a mitigation against
the case where there are too many folios in writeback with nothing else to
reclaim.

For filesystems where writeback may take an indeterminate amount of time
to write to disk, this has the possibility of stalling reclaim.

In this commit, if legacy memcg encounters a folio with the reclaim flag
set (eg case 3) and the folio belongs to a mapping that has the
AS_WRITEBACK_INDETERMINATE flag set, the folio will be activated and skip
reclaim (eg default to behavior in case 2) instead.

Link: https://lkml.kernel.org/r/20241122232359.429647-3-joannelkoong@gmail.com
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-skip-reclaiming-folios-in-legacy-memcg-writeback-indeterminate-contexts
+++ a/mm/vmscan.c
@@ -1165,8 +1165,9 @@ retry:
 		 * 2) Global or new memcg reclaim encounters a folio that is
 		 *    not marked for immediate reclaim, or the caller does not
 		 *    have __GFP_FS (or __GFP_IO if it's simply going to swap,
-		 *    not to fs). In this case mark the folio for immediate
-		 *    reclaim and continue scanning.
+		 *    not to fs), or the writeback may take an indeterminate
+		 *    amount of time to complete. In this case mark the folio
+		 *    for immediate reclaim and continue scanning.
 		 *
 		 *    Require may_enter_fs() because we would wait on fs, which
 		 *    may not have submitted I/O yet. And the loop driver might
@@ -1191,6 +1192,8 @@ retry:
 		 * takes to write them to disk.
 		 */
 		if (folio_test_writeback(folio)) {
+			mapping = folio_mapping(folio);
+
 			/* Case 1 above */
 			if (current_is_kswapd() &&
 			    folio_test_reclaim(folio) &&
@@ -1201,7 +1204,8 @@ retry:
 			/* Case 2 above */
 			} else if (writeback_throttling_sane(sc) ||
 			    !folio_test_reclaim(folio) ||
-			    !may_enter_fs(folio, sc->gfp_mask)) {
+			    !may_enter_fs(folio, sc->gfp_mask) ||
+			    (mapping && mapping_writeback_indeterminate(mapping))) {
 				/*
 				 * This is slightly racy -
 				 * folio_end_writeback() might have
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

mm-add-as_writeback_indeterminate-mapping-flag.patch
mm-skip-reclaiming-folios-in-legacy-memcg-writeback-indeterminate-contexts.patch
fs-writeback-in-wait_sb_inodes-skip-wait-for-as_writeback_indeterminate-mappings.patch
mm-migrate-skip-migrating-folios-under-writeback-with-as_writeback_indeterminate-mappings.patch
fuse-remove-tmp-folio-for-writebacks-and-internal-rb-tree.patch

