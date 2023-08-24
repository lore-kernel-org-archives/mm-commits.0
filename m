Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB47CC71145
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 22:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243794AbjHXWBA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 18:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243797AbjHXWA2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 18:00:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B871BE9;
        Thu, 24 Aug 2023 15:00:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19FA56342E;
        Thu, 24 Aug 2023 22:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726F4C433C8;
        Thu, 24 Aug 2023 22:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692914425;
        bh=Xz9nbXaPHAk0Ju9Hwdy/98Qadbv1cBQrtpctvLEvbfs=;
        h=Date:To:From:Subject:From;
        b=J2TGMip7ilbrrlYOAFfKCLzAA2JOYyroLKX+IW7bWGa47GToDbxU+JtgbH3glRXcc
         Rfn5zKdLtZEYSOtt0KPhMujr1Pr+l/fU+U+ytsLBrGBryI/G3BgDr2wf6x/8djBen1
         eTJmrAqOtYRTfcmVVKkZ/JgHrKlw7ncP9z+WoBas=
Date:   Thu, 24 Aug 2023 15:00:24 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        peterx@redhat.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] shmem-fix-smaps-bug-sleeping-while-atomic.patch removed from -mm tree
Message-Id: <20230824220025.726F4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: fix smaps BUG sleeping while atomic
has been removed from the -mm tree.  Its filename was
     shmem-fix-smaps-bug-sleeping-while-atomic.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: fix smaps BUG sleeping while atomic
Date: Tue, 22 Aug 2023 22:14:47 -0700 (PDT)

smaps_pte_hole_lookup() is calling shmem_partial_swap_usage() with page
table lock held: but shmem_partial_swap_usage() does cond_resched_rcu() if
need_resched(): "BUG: sleeping function called from invalid context".

Since shmem_partial_swap_usage() is designed to count across a range, but
smaps_pte_hole_lookup() only calls it for a single page slot, just break
out of the loop on the last or only page, before checking need_resched().

Link: https://lkml.kernel.org/r/6fe3b3ec-abdf-332f-5c23-6a3b3a3b11a9@google.com
Fixes: 230100321518 ("mm/smaps: simplify shmem handling of pte holes")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>	[5.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~shmem-fix-smaps-bug-sleeping-while-atomic
+++ a/mm/shmem.c
@@ -806,14 +806,16 @@ unsigned long shmem_partial_swap_usage(s
 	XA_STATE(xas, &mapping->i_pages, start);
 	struct page *page;
 	unsigned long swapped = 0;
+	unsigned long max = end - 1;
 
 	rcu_read_lock();
-	xas_for_each(&xas, page, end - 1) {
+	xas_for_each(&xas, page, max) {
 		if (xas_retry(&xas, page))
 			continue;
 		if (xa_is_value(page))
 			swapped++;
-
+		if (xas.xa_index == max)
+			break;
 		if (need_resched()) {
 			xas_pause(&xas);
 			cond_resched_rcu();
_

Patches currently in -mm which might be from hughd@google.com are

mm-khugepaged-fix-collapse_pte_mapped_thp-versus-uffd.patch

