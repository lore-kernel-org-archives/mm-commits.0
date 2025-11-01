Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5C8212FB3
	for <mm-commits@vger.kernel.org>; Sat,  1 Nov 2025 03:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761966540; cv=none; b=l6TZvHnNhGbOcCwlljRPSpPcf7optxWXUOANap97ScQB/FK0pHaRmbS06NAU+fGarwzj/JIzg/AXJw53/UkpIbUXrrdhU+23pQqjBS/9fpyE6Qn/RfXvZ8Npfk1N3+U2aK4c1Z4MY8DpqfYBmf+M7vCTo0HLPit92R3T+a1sc4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761966540; c=relaxed/simple;
	bh=3S3Fb4nVGH+KFpu/l5DU65bvlfYdOaVM6jjeDe3spMg=;
	h=Date:To:From:Subject:Message-Id; b=tz8pvZitD8X1akpkY5jPOkoeqEPgFQnHtnPu33So9c01SOwmiavuNfsmMogtJHrbjTMHvkjP4nf6hIPtGcRn3QeHHpIQm3Hc+aO4/vd5tblbyM6ZVZKHfJ1gLUFZxgiNp05DGcLkFxXBRK/QWk86tKMC/cFg+TUqpjoZrO656Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=apNUAypY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="apNUAypY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBE3C4CEE7;
	Sat,  1 Nov 2025 03:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761966540;
	bh=3S3Fb4nVGH+KFpu/l5DU65bvlfYdOaVM6jjeDe3spMg=;
	h=Date:To:From:Subject:From;
	b=apNUAypYOE7eWlIHRbQGL0/GrmPyoVIgszuysJJt9vJ6DEOynAfOi2ArBxisoDDRN
	 hrmpcR9wGRnZXtbFv1wlu9MzCRFG4IFBvq5ALFZGqUwZ3iu5N7KO9VqPH75KVCYGYs
	 BPUicIu7hgB1by7V88B0pJdQgxzQgS7f9VovAkKs=
Date: Fri, 31 Oct 2025 20:08:59 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-change-swap_alloc_slow-to-void.patch added to mm-new branch
Message-Id: <20251101030900.4EBE3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: change swap_alloc_slow() to void
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-change-swap_alloc_slow-to-void.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-change-swap_alloc_slow-to-void.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm: swap: change swap_alloc_slow() to void
Date: Fri, 31 Oct 2025 15:50:10 +0900

swap_alloc_slow() does not need to return a bool, as all callers handle
allocation results via the entry parameter.  Update the function signature
and remove return statements accordingly.

Link: https://lkml.kernel.org/r/20251031065011.40863-5-youngjun.park@lge.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-swap-change-swap_alloc_slow-to-void
+++ a/mm/swapfile.c
@@ -1339,7 +1339,7 @@ static bool swap_alloc_fast(swp_entry_t
 }
 
 /* Rotate the device and switch to a new cluster */
-static bool swap_alloc_slow(swp_entry_t *entry,
+static void swap_alloc_slow(swp_entry_t *entry,
 			    int order)
 {
 	unsigned long offset;
@@ -1356,10 +1356,10 @@ start_over:
 			put_swap_device(si);
 			if (offset) {
 				*entry = swp_entry(si->type, offset);
-				return true;
+				return;
 			}
 			if (order)
-				return false;
+				return;
 		}
 
 		spin_lock(&swap_avail_lock);
@@ -1378,7 +1378,6 @@ start_over:
 			goto start_over;
 	}
 	spin_unlock(&swap_avail_lock);
-	return false;
 }
 
 /*
_

Patches currently in -mm which might be from youngjun.park@lge.com are

mm-swap-fix-memory-leak-in-setup_clusters-error-path.patch
mm-swap-use-swp_solidstate-to-determine-if-swap-is-rotational.patch
mm-swap-remove-redundant-comment-for-read_swap_cache_async.patch
mm-swap-change-swap_alloc_slow-to-void.patch
mm-swap-remove-scan_swap_map_slots-references-from-comments.patch

