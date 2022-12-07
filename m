Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0355EC4708D
	for <mm-commits@archiver.kernel.org>; Wed,  7 Dec 2022 21:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiLGV2s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Dec 2022 16:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiLGV2r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2022 16:28:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4575A5C760
        for <mm-commits@vger.kernel.org>; Wed,  7 Dec 2022 13:28:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1DC7B82050
        for <mm-commits@vger.kernel.org>; Wed,  7 Dec 2022 21:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F11EC433D6;
        Wed,  7 Dec 2022 21:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670448520;
        bh=u86QQuEGWriJMqcVco4uzugiNnjWz1GjCPXdtBTr0X4=;
        h=Date:To:From:Subject:From;
        b=HvGoOUFu836L6d7P7MOHTjFRt+MJhs+UDEc9odVcgX3J1BHG//XGVMFGyAEdgVAgL
         Tq2RbVZseoJjIbdaIXwlwuF3HxV65Np/4mMPXcO43H3/ZIKcKqrSyI3UEagE9Sy1F6
         u3DaDfeCoYipNXdDgSwmeEORtEwAG07UhBPjDqWA=
Date:   Wed, 07 Dec 2022 13:28:39 -0800
To:     mm-commits@vger.kernel.org, yongw.kernel@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-typo-in-struct-pglist_data-code-comment.patch added to mm-unstable branch
Message-Id: <20221207212840.7F11EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix typo in struct pglist_data code comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-typo-in-struct-pglist_data-code-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-typo-in-struct-pglist_data-code-comment.patch

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
From: Wang Yong <yongw.kernel@gmail.com>
Subject: mm: fix typo in struct pglist_data code comment
Date: Wed, 7 Dec 2022 07:40:11 +0000

change "stat" to "start".

Link: https://lkml.kernel.org/r/20221207074011.GA151242@cloud
Fixes: c959924b0dc5 ("memory tiering: adjust hot threshold automatically")
Signed-off-by: Wang Yong <yongw.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mmzone.h~mm-fix-typo-in-struct-pglist_data-code-comment
+++ a/include/linux/mmzone.h
@@ -1200,7 +1200,7 @@ typedef struct pglist_data {
 	/* start time in ms of current promote threshold adjustment period */
 	unsigned int nbp_th_start;
 	/*
-	 * number of promote candidate pages at stat time of current promote
+	 * number of promote candidate pages at start time of current promote
 	 * threshold adjustment period
 	 */
 	unsigned long nbp_th_nr_cand;
_

Patches currently in -mm which might be from yongw.kernel@gmail.com are

mm-fix-typo-in-struct-pglist_data-code-comment.patch

