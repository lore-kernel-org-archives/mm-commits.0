Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D51C4321E
	for <mm-commits@archiver.kernel.org>; Mon, 28 Nov 2022 22:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbiK1WVi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Nov 2022 17:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiK1WVi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2022 17:21:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5B930568
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 14:21:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12530B81034
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 22:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC07C433C1;
        Mon, 28 Nov 2022 22:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669674094;
        bh=Pblp5y2PpWd5jy3YjX6ohibPfBPzR6+/EWeMLGfpHj0=;
        h=Date:To:From:Subject:From;
        b=sCsb/1O587cYDro1ZLN8O627HKXTCCBz+zGvL7iMZXWMGcoSMQS6BaoEGC3vMsKUy
         d+AxdR2uZvNIpJBV5EYoKmPWr18AzU9S0KvSUSLY39PN+/ychc5IN5YNxTamPGkaFn
         W2VXGwZkfEX6s+Y0C1fQWTeP1J8N69ZaeQpq4v+s=
Date:   Mon, 28 Nov 2022 14:21:34 -0800
To:     mm-commits@vger.kernel.org, zhang.songyi@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + include-linux-pgtableh-remove-redundant-pte-variable.patch added to mm-unstable branch
Message-Id: <20221128222134.BFC07C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/pgtable.h: : remove redundant pte variable
has been added to the -mm mm-unstable branch.  Its filename is
     include-linux-pgtableh-remove-redundant-pte-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-linux-pgtableh-remove-redundant-pte-variable.patch

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
From: zhang songyi <zhang.songyi@zte.com.cn>
Subject: include/linux/pgtable.h: : remove redundant pte variable
Date: Mon, 28 Nov 2022 21:07:43 +0800 (CST)

Return value from ptep_get_and_clear_full() directly instead of taking
this in another redundant variable.

Link: https://lkml.kernel.org/r/202211282107437343474@zte.com.cn
Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/pgtable.h~include-linux-pgtableh-remove-redundant-pte-variable
+++ a/include/linux/pgtable.h
@@ -425,9 +425,7 @@ static inline pte_t ptep_get_and_clear_f
 					    unsigned long address, pte_t *ptep,
 					    int full)
 {
-	pte_t pte;
-	pte = ptep_get_and_clear(mm, address, ptep);
-	return pte;
+       return ptep_get_and_clear(mm, address, ptep);
 }
 #endif
 
_

Patches currently in -mm which might be from zhang.songyi@zte.com.cn are

include-linux-pgtableh-remove-redundant-pte-variable.patch

