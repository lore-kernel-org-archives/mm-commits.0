Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AD3C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 14 Feb 2022 22:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiBNWso (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Feb 2022 17:48:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbiBNWsm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Feb 2022 17:48:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE91A139128
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 14:48:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B79A614DD
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 22:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9C3C340E9;
        Mon, 14 Feb 2022 22:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644878912;
        bh=Nhin5eTMeZuPsCsjpbS8Pg6ozhAE2Fmdmsg6VdDDKIc=;
        h=Date:To:From:Subject:From;
        b=s5aGATF++aa3RbixoTIT0Lybgdrx9mQYn8srHhUWlinLdgpJQHACmRN1O2HItzExv
         kDqGeHOgzENqX/4gwVZ7Bbk0GQ1uuCP1kOr/FM5SVP+zhbGvSCGufYE2f1W88vP2+R
         q08g1xczfpUz4ZbRsbVEPNcfc5qSOJadp+kVMFNc=
Date:   Mon, 14 Feb 2022 14:48:32 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, minchan@google.com,
        iamjoonsoo.kim@lge.com, cgel.zte@gmail.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-fix-psi-memory-pressure-error-on-cold-swapins.patch added to -mm tree
Message-Id: <20220214224832.9E9C3C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_io: fix psi memory pressure error on cold swapins
has been added to the -mm tree.  Its filename is
     mm-page_io-fix-psi-memory-pressure-error-on-cold-swapins.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_io-fix-psi-memory-pressure-error-on-cold-swapins.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_io-fix-psi-memory-pressure-error-on-cold-swapins.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_io: fix psi memory pressure error on cold swapins

Once upon a time, all swapins counted toward memory pressure[1].  Then
Joonsoo introduced workingset detection for anonymous pages and we gained
the ability to distinguish hot from cold swapins[2][3].  But we failed to
update swap_readpage() accordingly, and now we account partial memory
pressure in the swapin path of cold memory.

Not for all situations - which adds more inconsistency: paths using the
conventional submit_bio() and lock_page() route will not see much pressure
- unless storage itself is heavily congested and the bio submissions
stall.  ZRAM and ZSWAP do most of the work directly from swap_readpage()
and will see all swapins reflected as pressure.

Restore consistency by making all swapin stall accounting conditional on
the page actually being part of the workingset.

[1] commit 937790699be9 ("mm/page_io.c: annotate refault stalls from swap_readpage")
[2] commit aae466b0052e ("mm/swap: implement workingset detection for anonymous LRU")
[3] commit cad8320b4b39 ("mm/swap: don't SetPageWorkingset unconditionally during swapin")

Link: https://lkml.kernel.org/r/20220214214921.419687-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: CGEL <cgel.zte@gmail.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/page_io.c~mm-page_io-fix-psi-memory-pressure-error-on-cold-swapins
+++ a/mm/page_io.c
@@ -359,6 +359,7 @@ int swap_readpage(struct page *page, boo
 	struct bio *bio;
 	int ret = 0;
 	struct swap_info_struct *sis = page_swap_info(page);
+	bool workingset = PageWorkingset(page);
 	unsigned long pflags;
 
 	VM_BUG_ON_PAGE(!PageSwapCache(page) && !synchronous, page);
@@ -370,7 +371,8 @@ int swap_readpage(struct page *page, boo
 	 * or the submitting cgroup IO-throttled, submission can be a
 	 * significant part of overall IO time.
 	 */
-	psi_memstall_enter(&pflags);
+	if (workingset)
+		psi_memstall_enter(&pflags);
 	delayacct_swapin_start();
 
 	if (frontswap_load(page) == 0) {
@@ -433,7 +435,8 @@ int swap_readpage(struct page *page, boo
 	bio_put(bio);
 
 out:
-	psi_memstall_leave(&pflags);
+	if (workingset)
+		psi_memstall_leave(&pflags);
 	delayacct_swapin_end();
 	return ret;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_io-fix-psi-memory-pressure-error-on-cold-swapins.patch

