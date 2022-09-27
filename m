Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B81E0C07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiI0Cs5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiI0Cr4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59D26C113
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 772C1B81902
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3352CC433D6;
        Tue, 27 Sep 2022 02:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246868;
        bh=UKqAwRtqNSOJzH70khxFfoSQehJMUeknLzoLpm+laHk=;
        h=Date:To:From:Subject:From;
        b=QnNLt9yfWwBlPrrXdG9gJp/bBTtPBjKAdP8p3p+gAmvfvam+RGKG+w8HVtsVeKyHC
         a03i0jxw0xjGq6pdPgb0AY+2CYaNTQDlbgv7YOd5yZrj2CXXcLCrJM5aCIcWv4Zm3C
         ZChrp2ShXK4r4EhItimWEOyxE4Qz/q+iXcUYv/WQ=
Date:   Mon, 26 Sep 2022 19:47:47 -0700
To:     mm-commits@vger.kernel.org, wang.yong12@zte.com.cn,
        ran.xiaokai@zte.com.cn, iamjoonsoo.kim@lge.com, cgel.zte@gmail.com,
        yang.yang29@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-count-submission-time-as-thrashing-delay-for-delayacct.patch removed from -mm tree
Message-Id: <20220927024748.3352CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_io: count submission time as thrashing delay for delayacct
has been removed from the -mm tree.  Its filename was
     mm-page_io-count-submission-time-as-thrashing-delay-for-delayacct.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: mm/page_io: count submission time as thrashing delay for delayacct
Date: Mon, 15 Aug 2022 07:28:37 +0000

Once upon a time, we only support accounting thrashing of page cache. 
Then Joonsoo introduced workingset detection for anonymous pages and we
gained the ability to account thrashing of them[1].

Likes PSI, we count submission time as thrashing delay because when the
device is congested, or the submitting cgroup IO-throttled, submission can
be a significant part of overall IO time.

Without this patch, swap thrashing through frontswap or some block
device supporting rw_page operation isn't measured correctly.

This patch is based on "delayacct: support re-entrance detection of
thrashing accounting".

[1] commit aae466b0052e ("mm/swap: implement workingset detection for anonymous LRU")

Link: https://lkml.kernel.org/r/20220815072835.74876-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
Reviewed-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: wangyong <wang.yong12@zte.com.cn>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/page_io.c~mm-page_io-count-submission-time-as-thrashing-delay-for-delayacct
+++ a/mm/page_io.c
@@ -452,18 +452,21 @@ int swap_readpage(struct page *page, boo
 	struct swap_info_struct *sis = page_swap_info(page);
 	bool workingset = PageWorkingset(page);
 	unsigned long pflags;
+	bool in_thrashing;
 
 	VM_BUG_ON_PAGE(!PageSwapCache(page) && !synchronous, page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageUptodate(page), page);
 
 	/*
-	 * Count submission time as memory stall. When the device is congested,
-	 * or the submitting cgroup IO-throttled, submission can be a
-	 * significant part of overall IO time.
+	 * Count submission time as memory stall and delay. When the device
+	 * is congested, or the submitting cgroup IO-throttled, submission
+	 * can be a significant part of overall IO time.
 	 */
-	if (workingset)
+	if (workingset) {
+		delayacct_thrashing_start(&in_thrashing);
 		psi_memstall_enter(&pflags);
+	}
 	delayacct_swapin_start();
 
 	if (frontswap_load(page) == 0) {
@@ -512,8 +515,10 @@ int swap_readpage(struct page *page, boo
 	bio_put(bio);
 
 out:
-	if (workingset)
+	if (workingset) {
+		delayacct_thrashing_end(&in_thrashing);
 		psi_memstall_leave(&pflags);
+	}
 	delayacct_swapin_end();
 	return ret;
 }
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are


