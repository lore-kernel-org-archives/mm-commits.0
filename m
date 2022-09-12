Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3BAFECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiILDaA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiILD2x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5680A27CE6
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FB8BB80C6E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1619C433D6;
        Mon, 12 Sep 2022 03:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953326;
        bh=eNDzOxH73OfNEGSBBGnxZSqUnbTjGCML36QrPdj4ZwU=;
        h=Date:To:From:Subject:From;
        b=bsKBZNO97rlGvbgjrcbZnwVmn+J2PGL/z+xPXQncczg2HlH2CI387tfwOcLHYJzsd
         0r0tturuSe5bjh38GxbensOEF/Le23tfuGSGpckiRwvIMPAS/NjEStuw7cmtaNnR4X
         RXkV0nyXMLaLgeaU4XCzd1JzKEMgdPudqn2RtjDs=
Date:   Sun, 11 Sep 2022 20:28:46 -0700
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn,
        yuhongf@szu.edu.cn, yejiajian2018@email.szu.edu.cn, vbabka@suse.cz,
        lmark@codeaurora.org, iamjoonsoo.kim@lge.com,
        georgi.djakov@linaro.org, caoyixuan2019@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-vm-page_owner_sort-fix-f-option.patch removed from -mm tree
Message-Id: <20220912032846.C1619C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/vm/page_owner_sort: fix -f option
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sort-fix-f-option.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort: fix -f option
Date: Fri, 12 Aug 2022 23:55:15 +0800

The -f option is to filter out the information of blocks whose memory has
not been released, I noticed some blocks should not be filtered out.

Commit 9cc7e96aa846 ("mm/page_owner: record timestamp and pid") records
the allocation timestamp (ts_nsec) of all pages.

Commit 866b48526217 ("mm/page_owner: record the timestamp of all pages
during free") records the free timestamp (free_ts_nsec) of all pages. 
When the page is allocated for the first time, the initial value of
free_ts_nsec is 0, and the corresponding time will be obtained when the
page is released.  But during reallocation the free_ts_nsec will not reset
to 0 again.  In particular, when page migration occurs, these two
timestamps will be the same.

Now page_owner_sort removes all text blocks whose free_ts_nsec is not 0
when using -f option.  However, this way can only select pages allocated
for the first time.  If a freed page is reallocated, free_ts_nsec will be
less than ts_nsec; if page migration occurs, the two timestamps will be
equal.  These cases should be considered as pages are not released.

So I fix the function is_need() to keep text blocks that meet the above
two conditions when using -f option.

Link: https://lkml.kernel.org/r/20220812155515.30846-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Cc: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Yuhong Feng <yuhongf@szu.edu.cn>
Cc: Liam Mark <lmark@codeaurora.org>
Cc: Georgi Djakov <georgi.djakov@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sort-fix-f-option
+++ a/tools/vm/page_owner_sort.c
@@ -470,7 +470,12 @@ static bool match_str_list(const char *s
 
 static bool is_need(char *buf)
 {
-	if ((filter & FILTER_UNRELEASE) && get_free_ts_nsec(buf) != 0)
+	__u64 ts_nsec, free_ts_nsec;
+
+	ts_nsec = get_ts_nsec(buf);
+	free_ts_nsec = get_free_ts_nsec(buf);
+
+	if ((filter & FILTER_UNRELEASE) && free_ts_nsec != 0 && ts_nsec < free_ts_nsec)
 		return false;
 	if ((filter & FILTER_PID) && !match_num_list(get_pid(buf), fc.pids, fc.pids_size))
 		return false;
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are


