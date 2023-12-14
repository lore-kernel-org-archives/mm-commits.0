Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1C52C682
	for <mm-commits@vger.kernel.org>; Thu, 14 Dec 2023 22:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ohGVsv2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2797EC433C8;
	Thu, 14 Dec 2023 22:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702592623;
	bh=qoi++B/TUWpnt2s6cs0eC4yVK4yKyIHerUy36lFyG8s=;
	h=Date:To:From:Subject:From;
	b=ohGVsv2G7nPqL0RoXtWRPyqrNECKgPTN8UvLSIWZWNaxV7ooNo8OKNdWFIdSwbyvC
	 xhKiCaeQ0JRGkRaL/tb90PUM8r47AZsfkGnLB+zqWj/uMFaeRnm/+GRFzzqToeR17I
	 jAeInTkaTBTPMk/PD/yUCgZkVYSdwp5/YSsVK/WE=
Date: Thu, 14 Dec 2023 14:23:42 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,hannes@cmpxchg.org,ddstreet@ieee.org,chriscli@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-cleanup-zswap_reclaim_entry-fix.patch added to mm-unstable branch
Message-Id: <20231214222343.2797EC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-zswap-cleanup-zswap_reclaim_entry-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-cleanup-zswap_reclaim_entry-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-cleanup-zswap_reclaim_entry-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-zswap-cleanup-zswap_reclaim_entry-fix
Date: Thu Dec 14 02:21:39 PM PST 2023

retain comment, per Yosry

Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Chris Li <chriscli@google.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-cleanup-zswap_reclaim_entry-fix
+++ a/mm/zswap.c
@@ -1457,8 +1457,14 @@ static int zswap_writeback_entry(struct
 	mpol = get_task_policy(current);
 	page = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
 				NO_INTERLEAVE_INDEX, &page_was_allocated, true);
-	if (!page)
+	if (!page) {
+		/*
+		 * If we get here because the page is already in swapcache, a
+		 * load may be happening concurrently. It is safe and okay to
+		 * not free the entry. It is also okay to return !0.
+		 */
 		return -ENOMEM;
+	}
 
 	/* Found an existing page, we raced with load/swapin */
 	if (!page_was_allocated) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-maple_treec-fix-build-error-due-to-hotfix-alteration.patch
mm-list_lruc-remove-unused-list_lru_from_kmem.patch
mm-memcg-restore-subtree-stats-flushing-fix.patch
mm-zswap-cleanup-zswap_reclaim_entry-fix.patch
mips-fix-r3k_cache_init-build-regression-fix.patch

