Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F046EC4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 18:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFE87238D6
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 18:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600798479;
	bh=PdBZYbpR0xpu90HivOGpafm+3EKRabweOxHl6EPMDTM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gQyauYHy6caCHg1s1Z4Ot32yX/ByFldOlZASERMdm2wlpgAZ8j2aW3mC3ISuknoqU
	 aLMACtkpS/QufKWSXVUoiW8dSEsFXyPoMg5JtVN9PuoJf+bnbO94cdT3WZb4VisVQA
	 hLbcxf504VHh6RaGOStDuSFoY4vxHAtgTVHNyIT8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgIVSOj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 14:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgIVSOj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 14:14:39 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA5E1238A1;
        Tue, 22 Sep 2020 18:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600798478;
        bh=PdBZYbpR0xpu90HivOGpafm+3EKRabweOxHl6EPMDTM=;
        h=Date:From:To:Subject:From;
        b=xU+LZu8X91DV3OaZktwHZDuwySiskFE7zdcxXzkr8SgkEdof5TtuHLtUMipGYOTmT
         8srwJIUBC073j3jGPO5agVtjvit+ERhnMaIK2k8Q6Mgz8+dA52DfrbJsTwFO6tXyWb
         msLi2YfUqnWZ+TliJjIBdpz6ArTDmJlVlV7cZoSA=
Date:   Tue, 22 Sep 2020 11:14:38 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wang.yi59@zte.com.cn,
        liao.pingfang@zte.com.cn
Subject:  +
 =?us-ascii?Q?kernel-sysc-replace-do=5Fbrk-with-do=5Fbrk=5Fflags-in-comme?=
 =?us-ascii?Q?nt-of-prctl=5Fset=5Fmm=5Fmap.patch?= added to -mm tree
Message-ID: <20200922181438.ogXJ-%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: replace do_brk with do_brk_flags in comment of prctl_set_mm_map()
has been added to the -mm tree.  Its filename is
     kernel-sysc-replace-do_brk-with-do_brk_flags-in-comment-of-prctl_set_mm_map.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-sysc-replace-do_brk-with-do_brk_flags-in-comment-of-prctl_set_mm_map.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-sysc-replace-do_brk-with-do_brk_flags-in-comment-of-prctl_set_mm_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liao Pingfang <liao.pingfang@zte.com.cn>
Subject: kernel/sys.c: replace do_brk with do_brk_flags in comment of prctl_set_mm_map()

Replace do_brk with do_brk_flags in comment of prctl_set_mm_map(), since
do_brk was removed in following commit.

Link: https://lkml.kernel.org/r/1600650751-43127-1-git-send-email-wang.yi59@zte.com.cn
Fixes: bb177a732c4369 ("mm: do not bug_on on incorrect length in __mm_populate()")
Signed-off-by: Liao Pingfang <liao.pingfang@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sys.c~kernel-sysc-replace-do_brk-with-do_brk_flags-in-comment-of-prctl_set_mm_map
+++ a/kernel/sys.c
@@ -2034,7 +2034,7 @@ static int prctl_set_mm_map(int opt, con
 	 * VMAs already unmapped and kernel uses these members for statistics
 	 * output in procfs mostly, except
 	 *
-	 *  - @start_brk/@brk which are used in do_brk but kernel lookups
+	 *  - @start_brk/@brk which are used in do_brk_flags but kernel lookups
 	 *    for VMAs when updating these memvers so anything wrong written
 	 *    here cause kernel to swear at userspace program but won't lead
 	 *    to any problem in kernel itself
_

Patches currently in -mm which might be from liao.pingfang@zte.com.cn are

kernel-sysc-replace-do_brk-with-do_brk_flags-in-comment-of-prctl_set_mm_map.patch

