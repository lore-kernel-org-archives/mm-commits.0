Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E635B2F7AAC
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025854; cv=none; b=MY4qRGy0HakhxQhzTcI7v4K/x5psNjm+o2HUybsbWa+gKnc0VrC/6RF/6ImTrYt8bVLDX8P464R6kzOVkDhtVmnt5HJZGi3UWjL20n42uQgYV3nOjELUKGaSC366DUBBXAdtnEe7rD8arBJmzh84QOatLMElwVGaL8jlksODFl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025854; c=relaxed/simple;
	bh=DpQH22N6HfPEviuedF030eHptMHBMCUkv52XvrxR1So=;
	h=Date:To:From:Subject:Message-Id; b=RBpqjK7fK0DTEXVyBY4nlQrs73LPQlkPC0x7toyt9EQx0lY0JEpytD/1O01MoR/s9Tgn7pOLCed2HspD74/24OYeSYX6NDRzDAsF4NbQko53xk5tlhCryLCrF9gqBtlEKR2OOV7EWJIDGHHyTBr0wolXrTMCmLS3pISm0JTifyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O176mpQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O176mpQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB92AC4CEF1;
	Mon, 24 Nov 2025 23:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025853;
	bh=DpQH22N6HfPEviuedF030eHptMHBMCUkv52XvrxR1So=;
	h=Date:To:From:Subject:From;
	b=O176mpQL2GxR0JfIW70d0T9YklABWx5ZW+8kuBSEyFGWhMJy1k0gmoXkQGL85HlJn
	 3e4tD6RskChGuYXg0ua4IXtcjsrJJ7u8JgpcfJb4OuZZk12eHocgfzve3vsdJktkh+
	 CEcOp/0Ji50hzRU9MWpDcyX1Syz/qHbm01Xkdm0M=
Date: Mon, 24 Nov 2025 15:10:53 -0800
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,dan.j.williams@intel.com,peng8420.li@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-gup_test-fix-comment-regarding-origin-of-foll_write.patch removed from -mm tree
Message-Id: <20251124231053.BB92AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: gup_test: fix comment regarding origin of FOLL_WRITE
has been removed from the -mm tree.  Its filename was
     selftests-mm-gup_test-fix-comment-regarding-origin-of-foll_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Li <peng8420.li@gmail.com>
Subject: selftests/mm: gup_test: fix comment regarding origin of FOLL_WRITE
Date: Mon, 17 Nov 2025 23:40:12 +0800

The 'FOLL_WRITE' of the copied source is located in mm_types.h of mm, not
mm.h, so fix it.

Link: https://lkml.kernel.org/r/20251117154012.197499-2-peng8420.li@gmail.com
Signed-off-by: Peng Li <peng8420.li@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/gup_test.c~selftests-mm-gup_test-fix-comment-regarding-origin-of-foll_write
+++ a/tools/testing/selftests/mm/gup_test.c
@@ -17,7 +17,7 @@
 
 #define MB (1UL << 20)
 
-/* Just the flags we need, copied from mm.h: */
+/* Just the flags we need, copied from the kernel internals. */
 #define FOLL_WRITE	0x01	/* check pte is writable */
 
 #define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
_

Patches currently in -mm which might be from peng8420.li@gmail.com are


