Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2802C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 18:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbjKFS2r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 13:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbjKFS2q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 13:28:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA2AD47;
        Mon,  6 Nov 2023 10:28:44 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F4AC433C8;
        Mon,  6 Nov 2023 18:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699295323;
        bh=cfLKtmPTASsY/mXd3KyqzMORK9r2N0qAhcYDQEPAbGY=;
        h=Date:To:From:Subject:From;
        b=U4tdbuyNCC0Q1Djfzq6vrIDtxl85IwplXHVapwIhIXfG/x/EL8gZbaETayZbdeTcc
         Mi4vixzCN8HAlry7IocJ8ueo1sCCSs4K72h9Hr2BOWsToQPELdvHdmP2D8+qigialO
         DBvqokhAkOHVKm+3ZfCLIkjmPHJQH0KP70m7Tn34=
Date:   Mon, 06 Nov 2023 10:28:43 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org, shr@devkernel.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-for-negative-counter-nr_file_hugepages.patch added to mm-hotfixes-unstable branch
Message-Id: <20231106182843.A9F4AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix for negative counter: nr_file_hugepages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-for-negative-counter-nr_file_hugepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-for-negative-counter-nr_file_hugepages.patch

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
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: fix for negative counter: nr_file_hugepages
Date: Mon, 6 Nov 2023 10:19:18 -0800

While qualifiying the 6.4 release, the following warning was detected in
messages:

vmstat_refresh: nr_file_hugepages -15664

The warning is caused by the incorrect updating of the NR_FILE_THPS
counter in the function split_huge_page_to_list.  The if case is checking
for folio_test_swapbacked, but the else case is missing the check for
folio_test_pmd_mappable.  The other functions that manipulate the counter
like __filemap_add_folio and filemap_unaccount_folio have the
corresponding check.

I have a test case, which reproduces the problem. It can be found here:
  https://github.com/sroeschus/testcase/blob/main/vmstat_refresh/madv.c

The test case reproduces on an XFS filesystem. Running the same test
case on a BTRFS filesystem does not reproduce the problem.

AFAIK version 6.1 until 6.6 are affected by this problem.

Link: https://lkml.kernel.org/r/20231106181918.1091043-1-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Co-debugged-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-fix-for-negative-counter-nr_file_hugepages
+++ a/mm/huge_memory.c
@@ -2772,7 +2772,8 @@ int split_huge_page_to_list(struct page
 			if (folio_test_swapbacked(folio)) {
 				__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS,
 							-nr);
-			} else {
+			} else if (folio_test_pmd_mappable(folio)) {
+
 				__lruvec_stat_mod_folio(folio, NR_FILE_THPS,
 							-nr);
 				filemap_nr_thps_dec(mapping);
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-fix-for-negative-counter-nr_file_hugepages.patch

