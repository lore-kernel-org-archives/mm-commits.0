Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2AC13C80F
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292061; cv=none; b=n87NcHBQUPYSeiJJJcdLJv0teFp09zHG9r0mWk3Ss2kXW9MPwyf8mzV5bGfVBs7DCxtxrZ9xEbX78dQKBvB6l3RH3GztdeEzQFZ2XUVJQIorfdu+CkKIVl3fjD3BtA9mSmbE3QWhW53zV1WOPOvW8efDhDBkFDz9q0/EKpaVSsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292061; c=relaxed/simple;
	bh=ttIikZoE8NTRpI6P74qW88JlttOT8xdZtD5SxxigQDU=;
	h=Date:To:From:Subject:Message-Id; b=jUwWGAg7bcZLKP7IFVUkCdidqa+0AXpVmg8tUFf2D2B/wEMP+vehS07XNhl4uvHemq3XCttpEoXICeDhRDahdCjva6FKMWYJPLqz4izQX5X6vuFzCwKTJMpagx+9q2FTD896+p/QTvc10SpzyMe246NsESK4qVn6mbtXLng/xoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DIU+QKJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DIU+QKJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EA6C32781;
	Sat,  6 Jul 2024 18:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292061;
	bh=ttIikZoE8NTRpI6P74qW88JlttOT8xdZtD5SxxigQDU=;
	h=Date:To:From:Subject:From;
	b=DIU+QKJA1Upls/RpRKBOA3qFPY70tZSe2VYfd0pzzEmInYPjDnyRk7dawCY1NkTV+
	 cm9muzuVO8cKt/i9Fb9jxGI2Vmsft4W+gRppaDtzrXCuLiBjCTaemMs3IWES9wHwtj
	 a4nI0uC8/K53tK3mqwQnMZ0ujPzV3nis13vWKaTI=
Date: Sat, 06 Jul 2024 11:54:20 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,david@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-drop-checking-if-_deferred_list-is-empty-before-using-ttu_sync.patch removed from -mm tree
Message-Id: <20240706185421.14EA6C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: drop checking if _deferred_list is empty before using TTU_SYNC
has been removed from the -mm tree.  Its filename was
     mm-vmscan-drop-checking-if-_deferred_list-is-empty-before-using-ttu_sync.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm/vmscan: drop checking if _deferred_list is empty before using TTU_SYNC
Date: Sun, 30 Jun 2024 11:41:55 +1200

The optimization of list_empty(&folio->_deferred_list) aimed to prevent
increasing the PTL duration when a large folio is partially unmapped, for
example, from subpage 0 to subpage (nr - 2).

But Ryan's commit 5ed890ce5147 ("mm: vmscan: avoid split during
shrink_folio_list()") actually splits this kind of large folios.  This
makes the "optimization" useless.

Additionally, the list_empty() technically required a data_race()
annotation.

Link: https://lkml.kernel.org/r/20240629234155.53524-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-drop-checking-if-_deferred_list-is-empty-before-using-ttu_sync
+++ a/mm/vmscan.c
@@ -1291,7 +1291,7 @@ retry:
 			 * try_to_unmap acquire PTL from the first PTE,
 			 * eliminating the influence of temporary PTE values.
 			 */
-			if (folio_test_large(folio) && list_empty(&folio->_deferred_list))
+			if (folio_test_large(folio))
 				flags |= TTU_SYNC;
 
 			try_to_unmap(folio, flags);
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are


