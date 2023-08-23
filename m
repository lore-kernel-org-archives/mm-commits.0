Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDE5C3DA66
	for <mm-commits@archiver.kernel.org>; Wed, 23 Aug 2023 20:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbjHWU4i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Aug 2023 16:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237202AbjHWU4e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2023 16:56:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E69A10E4;
        Wed, 23 Aug 2023 13:56:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04A7563E13;
        Wed, 23 Aug 2023 20:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F097C433C8;
        Wed, 23 Aug 2023 20:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692824186;
        bh=bhFYpfKk75jlAQtGqCHkABcacvg/A4w783AVs8GoWcM=;
        h=Date:To:From:Subject:From;
        b=g9mWYOt5bLNCLmZuCpSLVq0XVjO59ANlH0A9QhE0MgQPtw4kekZTMafdrEODnnXe4
         HIP7ZNRAAFfQMVJvDWuXzKLK3eioLQVRsL/kgFxW667BO2LiS7oPFrK5lPV3S2QS2+
         ENIHn0SiJkEsHOXfhlXdlDwscwlWiuenO81vHHZk=
Date:   Wed, 23 Aug 2023 13:56:25 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        peterx@redhat.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-fix-smaps-bug-sleeping-while-atomic.patch added to mm-hotfixes-unstable branch
Message-Id: <20230823205626.2F097C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: fix smaps BUG sleeping while atomic
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     shmem-fix-smaps-bug-sleeping-while-atomic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-fix-smaps-bug-sleeping-while-atomic.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

shmem-fix-smaps-bug-sleeping-while-atomic.patch

