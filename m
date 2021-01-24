Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C56C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D34F22D07
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbhAXBPl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:15:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbhAXBPk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:15:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDAC422D07;
        Sun, 24 Jan 2021 01:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611450900;
        bh=FZgzn4Qwl88RkoqqQ1rvBEvNfd9VKVZs1Tksd9Da5s0=;
        h=Date:From:To:Subject:From;
        b=PcfBSFRKWqTw/yP3EMvi/xb3jbbjQ2nQ6o9X2dC41BCS59K3x7ihh84/NPNPYF+GF
         1aVfAt6x0BwDXfDT85e1fztymRKOYIoPYBUJKwHebWchNl5kpPRTjGL0rFQZCxvU3G
         uzNIIP7DFK+PG/4XxDJWoV4lIT/4GuwUvhunTVeU=
Date:   Sat, 23 Jan 2021 17:14:59 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stephenzhangzsd@gmail.com
Subject:  + mm-swapfilec-fix-debugging-information-problem.patch
 added to -mm tree
Message-ID: <20210124011459.3maqWP_O0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: fix debugging information problem
has been added to the -mm tree.  Its filename is
     mm-swapfilec-fix-debugging-information-problem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swapfilec-fix-debugging-information-problem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfilec-fix-debugging-information-problem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Zhang <stephenzhangzsd@gmail.com>
Subject: mm/swapfile.c: fix debugging information problem

Once the function name is changed, it may be easy to forget to modify the
corresponding code here.

Link: https://lkml.kernel.org/r/1611369120-2276-1-git-send-email-stephenzhangzsd@gmail.com
Signed-off-by: Stephen Zhang <stephenzhangzsd@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-fix-debugging-information-problem
+++ a/mm/swapfile.c
@@ -1158,13 +1158,13 @@ static struct swap_info_struct *__swap_i
 	return p;
 
 bad_offset:
-	pr_err("swap_info_get: %s%08lx\n", Bad_offset, entry.val);
+	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	goto out;
 bad_device:
-	pr_err("swap_info_get: %s%08lx\n", Unused_file, entry.val);
+	pr_err("%s: %s%08lx\n", __func__, Unused_file, entry.val);
 	goto out;
 bad_nofile:
-	pr_err("swap_info_get: %s%08lx\n", Bad_file, entry.val);
+	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
 out:
 	return NULL;
 }
@@ -1181,7 +1181,7 @@ static struct swap_info_struct *_swap_in
 	return p;
 
 bad_free:
-	pr_err("swap_info_get: %s%08lx\n", Unused_offset, entry.val);
+	pr_err("%s: %s%08lx\n", __func__, Unused_offset, entry.val);
 out:
 	return NULL;
 }
_

Patches currently in -mm which might be from stephenzhangzsd@gmail.com are

mm-swapfilec-fix-debugging-information-problem.patch
mm-early_ioremapc-use-__func__-instead-of-function-name.patch

