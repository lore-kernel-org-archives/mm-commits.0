Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A8182D68
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 06:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901958; cv=none; b=LD1oHMVhhLTgjhfdKJ0A88TnZXsRSDWVkL7eqsLWeFA5bvWGqpLxdgl5Qwj6M0zPffE5oHIrGsyXk7KBYkM9zKjsXe8PB5RtqikkLcrKZNtlg06v0t+o2kZ2UlLSdrUBAgAtFzMwyCdkrPd0/d7AJTOREf2msjm+yFTYIWDxoy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901958; c=relaxed/simple;
	bh=VE4dq6noeHJeQNbbWteG+jmlKMjD3rBex0Vdl6uqgi8=;
	h=Date:To:From:Subject:Message-Id; b=jhBmtTacZSWSUi95mupCh2niNz+l1qm/DgYD1FVC/pVGGObHgowxqX6/X9IK/4742K/fKarSjrXqVQAGnvENA2M6UvQwqAfoKNtlD0TzbpYIwShHZK9dB6FlGtgsCU5qJcgMvknjqSJNPzsI4IpwK7DKRoDKLv3IrC68HF40nB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kPwp44kz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kPwp44kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15357C4AF0A;
	Tue,  2 Jul 2024 06:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719901958;
	bh=VE4dq6noeHJeQNbbWteG+jmlKMjD3rBex0Vdl6uqgi8=;
	h=Date:To:From:Subject:From;
	b=kPwp44kzL7Ck2XvCAjwZ7BAGY57oHpSp2uFeupfiHe8ZiTwwSmYbHAbcWmG6Zhsyy
	 Wf2KItLySK7uLYhNzCLcaCjGfBVoA9emCcVUDSatQ8RahIJ8xaYBesKBo0K4DU7I3F
	 1EbYA8MSDtc/zPXiu58W2XClV7NnspBtuMsLTu7U=
Date: Mon, 01 Jul 2024 23:32:37 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,david@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-drop-checking-if-_deferred_list-is-empty-before-using-ttu_sync.patch added to mm-unstable branch
Message-Id: <20240702063238.15357C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: drop checking if _deferred_list is empty before using TTU_SYNC
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-drop-checking-if-_deferred_list-is-empty-before-using-ttu_sync.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-drop-checking-if-_deferred_list-is-empty-before-using-ttu_sync.patch

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

tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch
mm-vmscan-drop-checking-if-_deferred_list-is-empty-before-using-ttu_sync.patch

