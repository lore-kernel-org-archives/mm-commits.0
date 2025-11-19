Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837892580E4
	for <mm-commits@vger.kernel.org>; Wed, 19 Nov 2025 22:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763592727; cv=none; b=bUU+XFCXp17SSpj5lOeHk7T5cN+j881PVM6q0JGbqvmcrhsHMoQ+ctWuMqllypzd1FHcMYb+H7w1DScNcV5XeZhnxfZ0QNsypew6+u4B6rBtpKHAy5yRsIb3dgXEQnn4eAy9qeDS52xYAEDpkb7O+3+i5QTtLP/hZvTBECpBLQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763592727; c=relaxed/simple;
	bh=wsSungIwy1Dl4ZmzHI9KQw0dQSMQIIWyyo0T3K51Nm0=;
	h=Date:To:From:Subject:Message-Id; b=KH3589UoLYQdLF/tLBWJq1w+ovJNXd/jQN2p1NgS8kz5sN86n366DozAoXc6LK2gwSOlj6dv9ZbNSoSCfAycDo+X0xG3Fx9UR5VSWJJK8KlwgwX1tfmNudjAQoc43RlmBk9cfY36XvvOdQlVFXQj0GlKD+YGMvkfryT5Ai98XbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ttc5CgZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ttc5CgZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B623AC4CEF5;
	Wed, 19 Nov 2025 22:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763592723;
	bh=wsSungIwy1Dl4ZmzHI9KQw0dQSMQIIWyyo0T3K51Nm0=;
	h=Date:To:From:Subject:From;
	b=Ttc5CgZxbQwcwGTDXpTHBzSFP0xX36M3ZdNb4a4kwwSjo0jh6NwYoG3CASdTFV0r0
	 noAF/0MxxXLmqZsXQvZO/8wLxBoFgsqdt1FzTCOdMnmur1i9HQ3/D2uue2tgGLHO83
	 a6z8A1133plWwJ5IJ5MhlxSXKaQ3FJB7f81KOad0=
Date: Wed, 19 Nov 2025 14:52:03 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-wrong-plist-empty-check-in-swap_alloc_slow.patch added to mm-new branch
Message-Id: <20251119225203.B623AC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: fix wrong plist empty check in swap_alloc_slow()
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-fix-wrong-plist-empty-check-in-swap_alloc_slow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-wrong-plist-empty-check-in-swap_alloc_slow.patch

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
Subject: mm/swap: fix wrong plist empty check in swap_alloc_slow()
Date: Wed, 19 Nov 2025 20:41:36 +0900

swap_alloc_slow() was checking `si->avail_list` instead of
`next->avail_list` when verifying if the next swap device is still in the
list, which could cause unnecessary restarts during allocation.

Link: https://lkml.kernel.org/r/20251119114136.594108-1-youngjun.park@lge.com
Fixes: 8e689f8ea45ff ("mm/swap: do not choose swap device according to numa node")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-fix-wrong-plist-empty-check-in-swap_alloc_slow
+++ a/mm/swapfile.c
@@ -1374,7 +1374,7 @@ start_over:
 		 * still in the swap_avail_head list then try it, otherwise
 		 * start over if we have not gotten any slots.
 		 */
-		if (plist_node_empty(&si->avail_list))
+		if (plist_node_empty(&next->avail_list))
 			goto start_over;
 	}
 	spin_unlock(&swap_avail_lock);
_

Patches currently in -mm which might be from youngjun.park@lge.com are

mm-swap-remove-duplicate-nr_swap_pages-decrement-in-get_swap_page_of_type.patch
mm-swap-fix-wrong-plist-empty-check-in-swap_alloc_slow.patch

