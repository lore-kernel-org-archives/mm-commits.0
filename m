Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8030BC25B08
	for <mm-commits@archiver.kernel.org>; Sat, 13 Aug 2022 05:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbiHMF6v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 13 Aug 2022 01:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiHMF6t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 13 Aug 2022 01:58:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2137C41D20
        for <mm-commits@vger.kernel.org>; Fri, 12 Aug 2022 22:58:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AED060BBD
        for <mm-commits@vger.kernel.org>; Sat, 13 Aug 2022 05:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF48DC433D6;
        Sat, 13 Aug 2022 05:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660370328;
        bh=eHm32UHgeVxY0eOPBRz/IaOn0nqUJrE3DhEFST+UzWU=;
        h=Date:To:From:Subject:From;
        b=pSD/ju5T1te88NBk2UrE5OkQefEj/ajvuSl2UWpaZrC3oYpxNyAarlX8Zu+rX0r6y
         G+79m8D1B2Wkb9t3QubiYzVoxHOxGDkSnjm3WA3lCV7pBw4Y7efYBs2+Et+L/vZ/oH
         SsE0ADhFn5dd+pLNz/XdlP7G92Wq41s3kiUE7bmo=
Date:   Fri, 12 Aug 2022 22:58:47 -0700
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn,
        yuhongf@szu.edu.cn, yejiajian2018@email.szu.edu.cn, vbabka@suse.cz,
        lmark@codeaurora.org, iamjoonsoo.kim@lge.com,
        georgi.djakov@linaro.org, caoyixuan2019@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-page_owner_sort-fix-f-option.patch added to mm-unstable branch
Message-Id: <20220813055847.EF48DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort: fix -f option
has been added to the -mm mm-unstable branch.  Its filename is
     tools-vm-page_owner_sort-fix-f-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-vm-page_owner_sort-fix-f-option.patch

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

tools-vm-page_owner_sort-fix-f-option.patch

