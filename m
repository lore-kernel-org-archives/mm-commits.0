Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA5BC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91BB52065D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881556;
	bh=JMy/nbHMdmEbbJRa2wbtcSJQ2Jc1n2jf04V3f5ZOI1s=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LUJbDfz8lFhYXMGXCKPzhzP49iSARkJWsvOuCfpdIt7Voh562Gh3+xLG5Jjml4Kci
	 llqkf8ALbgvRVocO4lTaY8WJdxJoIUJ77iuqft4zhp0Yjl2g8zfczl9rImBLN7O+Y2
	 amvYZ1G5j0ysfMNAjG0QgPXv2xya0oTedc6Luz1M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408734AbgJPUwg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408456AbgJPUwf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:35 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B278120657;
        Fri, 16 Oct 2020 20:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881554;
        bh=JMy/nbHMdmEbbJRa2wbtcSJQ2Jc1n2jf04V3f5ZOI1s=;
        h=Date:From:To:Subject:From;
        b=uXrB4EopxubTbJwNn0KnnHQvFfPnxJTh5BU0JN+lZJ+s3vYvuckZUBWPDgX5m6E6D
         SvEOMY2kmdC0+7Ce88pdv1h+vicsBeT3qYycdT9Z9ki/IHkTwVWW3Es8OAU3mgJva6
         W6TgXJLuafmr8Pu+eHDP6K3ELPuHRCEB0Fhu2XZU=
Date:   Fri, 16 Oct 2020 13:52:34 -0700
From:   akpm@linux-foundation.org
To:     liao.pingfang@zte.com.cn, mm-commits@vger.kernel.org,
        wang.yi59@zte.com.cn
Subject:  [merged]
 =?US-ASCII?Q?kernel-sysc-replace-do=5Fbrk-with-do=5Fbrk=5Fflags-in-comme?=
 =?US-ASCII?Q?nt-of-prctl=5Fset=5Fmm=5Fmap.patch?= removed from -mm tree
Message-ID: <20201016205234.QE1cbEV-4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: replace do_brk with do_brk_flags in comment of prctl_set_mm_map()
has been removed from the -mm tree.  Its filename was
     kernel-sysc-replace-do_brk-with-do_brk_flags-in-comment-of-prctl_set_mm_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


