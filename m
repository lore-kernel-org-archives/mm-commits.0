Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5FA2874F5
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 16:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763657673; cv=none; b=uZSY+NZHDxBfT4FclWn/kmEGdqJeQ8v3uV0lN5YBVU76rid7gkaVO7+V+M1VMMe5ifn4YlfKYaYG/M0RVI9v7+VVRfSO+4dmBGU0aKsyN6ByBtgTuEQ4F14VIEKrQc69a5tRZC11tVq3h6/l7Qaa6mMZ6a9H1SFltTmdL2CZ3YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763657673; c=relaxed/simple;
	bh=a3UP+vKbRNwiyvANmUt1pxcGrBRj17IqWkD+KUS4Bac=;
	h=Date:To:From:Subject:Message-Id; b=k8glj8eqroP2EqNGK1eCBm9OzCfo0EwswFcqlL9Oy/H8CcZ+FIRaN4zo7tsvN3aqru4cp6ocYp29j/EPgTnJi6Zbv+jiU+ClkdPy/bXUy+Eb4acCX7yxZezWvX+VQHIGXCEc4EXed71kOggK/SVrfMrSb1r7tkFyg02hc/4CCOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aplYx6GV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aplYx6GV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAEEC4CEF1;
	Thu, 20 Nov 2025 16:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763657673;
	bh=a3UP+vKbRNwiyvANmUt1pxcGrBRj17IqWkD+KUS4Bac=;
	h=Date:To:From:Subject:From;
	b=aplYx6GVSrRFkhH0+fhQWiM7tGVqLnaGiBVuwnOgLBZgTV0FpJiynHAHnVKhUohow
	 jzkNx0LJ4kZ4Fo3hIUm/SUbldY3soCVMb9ZFfne3MpLwEiVspzM4ozzmw9mkLTRPRT
	 T6zUXhfIOoNFQIgyioqkQvg9nGtKPc+Xv94/MbrA=
Date: Thu, 20 Nov 2025 08:54:32 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-change-swap_alloc_slow-to-void.patch added to mm-new branch
Message-Id: <20251120165432.DDAEEC4CEF1@smtp.kernel.org>
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
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Barry Song <baohua@kernel.org>
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

mm-swap-remove-duplicate-nr_swap_pages-decrement-in-get_swap_page_of_type.patch
mm-swap-fix-wrong-plist-empty-check-in-swap_alloc_slow.patch
mm-swap-fix-memory-leak-in-setup_clusters-error-path.patch
mm-swap-use-swp_solidstate-to-determine-if-swap-is-rotational.patch
mm-swap-remove-redundant-comment-for-read_swap_cache_async.patch
mm-swap-change-swap_alloc_slow-to-void.patch
mm-swap-remove-scan_swap_map_slots-references-from-comments.patch

