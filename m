Return-Path: <SRS0=09mD=BO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07172C433DF
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C0C8206DA
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596511286;
	bh=ZyfDez/QYD1AR3TqFBoKNpTov5q4CpW+bV3mdBJA7dM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wpCj1nlysHbMy+QNr0B3YMk3utb7Ih/eTBLWUTEt6T1tCy3h2TRJ+9pxT/l+MhHQN
	 6ECcM0ghfhfsatJUt3Q53Li0hZvX/He90+1y8Fzka9Z7yQ93HH84aW+gliLPw7Eh/4
	 9RKEWGMqGQgcHzRF/d5OBRTWHNub5PH6oer7xWl8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729848AbgHDDVZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Aug 2020 23:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbgHDDVZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Aug 2020 23:21:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8A5D2068F;
        Tue,  4 Aug 2020 03:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596511285;
        bh=ZyfDez/QYD1AR3TqFBoKNpTov5q4CpW+bV3mdBJA7dM=;
        h=Date:From:To:Subject:From;
        b=xbxJyILGsjirHEfUJbKi4q3Xfhew2y9nglJul9Z3+hPbLVIgOrQTmhCnBdsB1Jyc8
         p/VqnNpTRimlQmeCgJtCVCgWxd7BIKROV6UeZSEBA9YRUX0hCm8fZh1LCZTNBs0AA4
         pHm0egLaPVm4G/btmP3FzPFGkYZH+xdECMSd/4no=
Date:   Mon, 03 Aug 2020 20:21:24 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  + mm-hmmc-delete-duplicated-word.patch added to -mm tree
Message-ID: <20200804032124.OHiD2Wzvm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm.c: delete duplicated word
has been added to the -mm tree.  Its filename is
     mm-hmmc-delete-duplicated-word.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmmc-delete-duplicated-word.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmmc-delete-duplicated-word.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/hmm.c: delete duplicated word

Drop the repeated word "pages".

Link: http://lkml.kernel.org/r/20200801173822.14973-4-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hmm.c~mm-hmmc-delete-duplicated-word
+++ a/mm/hmm.c
@@ -242,7 +242,7 @@ static int hmm_vma_handle_pte(struct mm_
 		swp_entry_t entry = pte_to_swp_entry(pte);
 
 		/*
-		 * Never fault in device private pages pages, but just report
+		 * Never fault in device private pages, but just report
 		 * the PFN even if not present.
 		 */
 		if (hmm_is_device_private_entry(range, entry)) {
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ocfs2-suballoch-delete-a-duplicated-word.patch
mm-drop-duplicated-words-in-linux-pgtableh.patch
mm-drop-duplicated-words-in-linux-mmh.patch
highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch
frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment.patch
memcontrol-drop-duplicate-word-and-fix-spello-in-linux-memcontrolh.patch
mm-compactionc-delete-duplicated-word.patch
mm-filemapc-delete-duplicated-word.patch
mm-hmmc-delete-duplicated-word.patch
mm-hugetlbc-delete-duplicated-words.patch
mm-memcontrolc-delete-duplicated-words.patch
mm-memoryc-delete-duplicated-words.patch
mm-migratec-delete-duplicated-word.patch
mm-nommuc-delete-duplicated-words.patch
mm-page_allocc-delete-or-fix-duplicated-words.patch
mm-shmemc-delete-duplicated-word.patch
mm-slab_commonc-delete-duplicated-word.patch
mm-usercopyc-delete-duplicated-word.patch
mm-vmscanc-delete-or-fix-duplicated-words.patch
mm-zpoolc-delete-duplicated-word-and-fix-grammar.patch
mm-zsmallocc-fix-duplicated-words.patch
clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch
linux-exportfsh-drop-duplicated-word-in-a-comment.patch
linux-async_txh-drop-duplicated-word-in-a-comment.patch
xz-drop-duplicated-word-in-linux-xzh.patch
autofs-fix-doubled-word.patch

