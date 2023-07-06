Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC8AEB64D9
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 20:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjGFUI2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Jul 2023 16:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjGFUI2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2023 16:08:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D339410EA
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 13:08:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F7E6612C3
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 20:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B6AC433C8;
        Thu,  6 Jul 2023 20:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688674104;
        bh=uC/BivqyQyE/hXFh3jlDf1+6eRcuidSFfrbSBV7w1nc=;
        h=Date:To:From:Subject:From;
        b=TbRpdAy6U7aci0M9Fh4n2+FNdy+puseQnFrvJRg9K3vhg0MQm5s1XqyCe+kRbMzjh
         WIWM/Z1t4D4ncxmZhoDlKmsqCDfu3eWDySJFSxTArmHkzOog48GPOMAnj6umjvrJL1
         NlaTn3qjenj7JGDec1N2ZpR1UILAdol57kXtOcvo=
Date:   Thu, 06 Jul 2023 13:08:24 -0700
To:     mm-commits@vger.kernel.org, pintu.ping@gmail.com,
        minchan@kernel.org, quic_pintu@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-print-cma-name-as-well-in-cma_alloc-debug.patch added to mm-unstable branch
Message-Id: <20230706200824.C3B6AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: print cma name as well in cma_alloc debug
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-print-cma-name-as-well-in-cma_alloc-debug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-print-cma-name-as-well-in-cma_alloc-debug.patch

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
From: Pintu Kumar <quic_pintu@quicinc.com>
Subject: mm: cma: print cma name as well in cma_alloc debug
Date: Fri, 7 Jul 2023 00:03:34 +0530

CMA allocation can happen either from global cma or from dedicated cma
region.

Thus it is helpful to print cma name as well during initial
debugging to confirm cma regions were getting initialized or not.

Link: https://lkml.kernel.org/r/1688668414-12350-1-git-send-email-quic_pintu@quicinc.com
Signed-off-by: Pintu Kumar <quic_pintu@quicinc.com>
Signed-off-by: Pintu Agarwal <pintu.ping@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/cma.c~mm-cma-print-cma-name-as-well-in-cma_alloc-debug
+++ a/mm/cma.c
@@ -436,8 +436,8 @@ struct page *cma_alloc(struct cma *cma,
 	if (!cma || !cma->count || !cma->bitmap)
 		goto out;
 
-	pr_debug("%s(cma %p, count %lu, align %d)\n", __func__, (void *)cma,
-		 count, align);
+	pr_debug("%s(cma %p, name: %s, count %lu, align %d)\n", __func__,
+		(void *)cma, cma->name, count, align);
 
 	if (!count)
 		goto out;
_

Patches currently in -mm which might be from quic_pintu@quicinc.com are

mm-cma-print-cma-name-as-well-in-cma_alloc-debug.patch

