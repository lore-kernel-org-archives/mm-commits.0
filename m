Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62E11F942D
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 23:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736809895; cv=none; b=mI25uo01HVes8QyNVvDMKP8ZrjbR2iCqBlpzeeFe9rRyjare/xy1y3H0gmKkHXqMdpvwl1q6yLvuYl7aYixRwpJu3J5tfF8DZzBT2ReEibDZBhQsMwy1YqALdqGPF7x7tkHXYDqJhMcmhvBoJmLATiyDu6eIi2Y8Pyk8Q1m+/Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736809895; c=relaxed/simple;
	bh=uBfSjeYT7PvPb/B2xKWAzs4spOSh4J3mzgpzDly3qq0=;
	h=Date:To:From:Subject:Message-Id; b=DJc43E6Vr5CLP63rh/boDiEmVUbfFUQH1f3DVROYHNI3VfXznkrHlnqU+ZQw58wTL6k9N7GXQnkhcWdUq9yMjEqzZWijCN0GZXAxMqVxqujNRr66iEwM71xv5e8mj3XYS4U06UCeIm4VLnZ4s2SNEaeT+J0rAubv09qq5t6nnCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0LCrTjf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0LCrTjf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C148C4CED6;
	Mon, 13 Jan 2025 23:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736809895;
	bh=uBfSjeYT7PvPb/B2xKWAzs4spOSh4J3mzgpzDly3qq0=;
	h=Date:To:From:Subject:From;
	b=0LCrTjf8M5TNH8GWxWxgoBK8R12CijFIj/4eYwdZST1BI+vXqrZaPQlo1n6B0oMNW
	 TbMiYXqS94b8b/7RHJrx6eWsgddBh/6bekp7/IjylMOpFkIg4twb7XJvv9SbLYjupr
	 D0yOMVEP9G1YPL214Cy4+TVGLXCliEWK53sKSeBc=
Date: Mon, 13 Jan 2025 15:11:34 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,mszeredi@redhat.com,josef@toxicpanda.com,jefflexu@linux.alibaba.com,bernd.schubert@fastmail.fm,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-skip-reclaiming-folios-in-legacy-memcg-writeback-indeterminate-contexts.patch removed from -mm tree
Message-Id: <20250113231135.4C148C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: skip reclaiming folios in legacy memcg writeback indeterminate contexts
has been removed from the -mm tree.  Its filename was
     mm-skip-reclaiming-folios-in-legacy-memcg-writeback-indeterminate-contexts.patch

This patch was dropped because it was withdrawn

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
@@ -1137,8 +1137,9 @@ retry:
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
@@ -1163,6 +1164,8 @@ retry:
 		 * takes to write them to disk.
 		 */
 		if (folio_test_writeback(folio)) {
+			mapping = folio_mapping(folio);
+
 			/* Case 1 above */
 			if (current_is_kswapd() &&
 			    folio_test_reclaim(folio) &&
@@ -1173,7 +1176,8 @@ retry:
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

fs-writeback-in-wait_sb_inodes-skip-wait-for-as_writeback_indeterminate-mappings.patch
mm-migrate-skip-migrating-folios-under-writeback-with-as_writeback_indeterminate-mappings.patch
fuse-remove-tmp-folio-for-writebacks-and-internal-rb-tree.patch

