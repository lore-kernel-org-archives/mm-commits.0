Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8E2C32772
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 19:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237202AbiHQTHc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 15:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241290AbiHQTH3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 15:07:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CA7A060D
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 12:07:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62424CE1E77
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 19:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B3BC433C1;
        Wed, 17 Aug 2022 19:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660763240;
        bh=NEQPxdpPiAUS5jj9Vcy82dDNroYOegYuVdI7b/Pl08A=;
        h=Date:To:From:Subject:From;
        b=dVnKoTnZOaIEhh/VQ/qPlkuc8LmddxUqalBlsbvAjKC23BvN7NuUvSMXyEXJRaKEj
         KI7Pexa1sp/E0JNBPzUCf8LGF6YDr6Enk9Qcvu6QGXkWxTbPmBjQf4QoPK8HeILbuK
         hFKLFnBl8hXlBl6gr2dppNfr71xP/7Cv0wlSdgGM=
Date:   Wed, 17 Aug 2022 12:07:19 -0700
To:     mm-commits@vger.kernel.org, wang.yong12@zte.com.cn,
        ran.xiaokai@zte.com.cn, iamjoonsoo.kim@lge.com, cgel.zte@gmail.com,
        yang.yang29@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-count-submission-time-as-thrashing-delay-for-delayacct.patch added to mm-unstable branch
Message-Id: <20220817190720.81B3BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io: count submission time as thrashing delay for delayacct
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_io-count-submission-time-as-thrashing-delay-for-delayacct.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_io-count-submission-time-as-thrashing-delay-for-delayacct.patch

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
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: mm/page_io: count submission time as thrashing delay for delayacct
Date: Mon, 15 Aug 2022 07:28:37 +0000

Once upon a time, we only support accounting thrashing of page cache. 
Then Joonsoo introduced workingset detection for anonymous pages and we
gained the ability to account thrashing of them[1].

Likes PSI, we count submission time as thrashing delay because when the
device is congested, or the submitting cgroup IO-throttled, submission can
be a significant part of overall IO time.

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

mm-vmscan-define-macros-for-refaults-in-struct-lruvec.patch
filemap-make-the-accounting-of-thrashing-more-consistent.patch
mm-vmscan-make-the-annotations-of-refaults-code-at-the-right-place.patch
delayacct-support-re-entrance-detection-of-thrashing-accounting.patch
mm-page_io-count-submission-time-as-thrashing-delay-for-delayacct.patch

