Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06C63101A7
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 05:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782625275; cv=none; b=uQrEDaVto9arxzznv2kAt8o3rkCdNWCJEsJcAFqhyHs5ojtnQFGZx1+kZCa3ybiHU/SjumU5J9M1v6axFD3EwGP58Bgs0aYvsDmAvJg0H+cihfFXE3fb+I2TQSragAaJSvakzScrYhcfNhtrFz9WNhFKv9/eaLok67EJb3flH34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782625275; c=relaxed/simple;
	bh=DLN3H80cHS+g2GvY/KvcT03nH2nTlc0RhmXKNuTi7oE=;
	h=Date:To:From:Subject:Message-Id; b=XaDBJKC7Lyto/W4zCiToZhi9u0rEfG/khX/AddY4XdwG8/yXOVno5tQj8wqeF9XbJxxd2+GP68AwNu6fWWZyhFDn9kl/PZBhKA2oS1J11BcvX5kbqYSn9oEcEDcrPYqxuj7CTr+BCgFPgVsZpMyNVpM6MgVtyskqYbAehUde/8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EiFV9D0g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EiFV9D0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E1E1F000E9;
	Sun, 28 Jun 2026 05:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782625273;
	bh=GMI7ZY4Gq+PcKd8qk84s1MToDUaGtvydgZCOBuEgz/s=;
	h=Date:To:From:Subject;
	b=EiFV9D0g+25rTw0XCr5D5rkMv6jj8dbjn0kXBVEe+l03R/M6P6SOn8TBojosn0GqA
	 ko4xYUDHWqqujZlZjyqqZ1Go8clhxKOvMdAolfTuLkntnRH0j1DhEaTnXntyEhWzUD
	 6naAaRajOCtmXfUS4dB5++RgjkFnuqBL99AClTO8=
Date: Sat, 27 Jun 2026 22:41:12 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,ritesh.list@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + include-linux-swaph-remove-unused-leftovers.patch added to mm-new branch
Message-Id: <20260628054113.66E1E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: include/linux/swap.h: remove unused leftovers
has been added to the -mm mm-new branch.  Its filename is
     include-linux-swaph-remove-unused-leftovers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-linux-swaph-remove-unused-leftovers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: include/linux/swap.h: remove unused leftovers
Date: Thu, 11 Jun 2026 08:39:32 +0530

This removed unused leftovers, most of them are forward structure
declarations.  Also removes SWAP_BATCH macro which isn't used any where in
the code.

Found these during manual code review.

Link: https://lore.kernel.org/68591daf0d679e5a0072d63751f187d14613e2b0.1781146877.git.ritesh.list@gmail.com
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/include/linux/swap.h~include-linux-swaph-remove-unused-leftovers
+++ a/include/linux/swap.h
@@ -16,10 +16,6 @@
 #include <uapi/linux/mempolicy.h>
 #include <asm/page.h>
 
-struct notifier_block;
-
-struct bio;
-
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
 #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */
@@ -29,7 +25,6 @@ struct bio;
 #define SWAP_FLAGS_VALID	(SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER | \
 				 SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE | \
 				 SWAP_FLAG_DISCARD_PAGES)
-#define SWAP_BATCH 64
 
 static inline int current_is_kswapd(void)
 {
@@ -175,7 +170,6 @@ static inline void mm_account_reclaimed_
 
 struct address_space;
 struct sysinfo;
-struct writeback_control;
 struct zone;
 
 /*
@@ -442,7 +436,6 @@ extern sector_t swapdev_block(int, pgoff
 extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
-struct backing_dev_info;
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
 sector_t swap_folio_sector(struct folio *folio);
 
_

Patches currently in -mm which might be from ritesh.list@gmail.com are

include-linux-swaph-remove-unused-leftovers.patch

