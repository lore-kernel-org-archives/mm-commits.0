Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C1B0C5479D
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 23:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235128AbjAIXwj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbjAIXwi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 18:52:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D971CFEC
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 15:52:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63C22B810AB
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 23:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0516FC433D2;
        Mon,  9 Jan 2023 23:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673308355;
        bh=LgbyDYBGzTZB+wt66WsPr0y1wei9/l9o01uwfTCobvU=;
        h=Date:To:From:Subject:From;
        b=qCfyJN6IYfZOIKbINt3Q5/9h8n+XV2/PfgTe+XDBxm/B/5qHgPW0KWz9NJ3zXM05o
         RZeRExK9AjU/umxWjMMPGMK+Ng66etDjUNkTDg11S6TQZL8jyK0Kogs1U4csFFdnHN
         wfB8RTAMoq5+F/bux++lpGRv4gA6mbFufvz+/c08=
Date:   Mon, 09 Jan 2023 15:52:34 -0800
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn, sj@kernel.org,
        xu.panda@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-use-strscpy-to-instead-of-strncpy.patch added to mm-unstable branch
Message-Id: <20230109235235.0516FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: use strscpy() to instead of strncpy()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-use-strscpy-to-instead-of-strncpy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-use-strscpy-to-instead-of-strncpy.patch

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
From: Xu Panda <xu.panda@zte.com.cn>
Subject: mm/damon/sysfs-schemes: use strscpy() to instead of strncpy()
Date: Mon, 9 Jan 2023 19:46:55 +0800 (CST)

The implementation of strscpy() is more robust and safer.
That's now the recommended way to copy NUL-terminated strings.

Link: https://lkml.kernel.org/r/202301091946553770006@zte.com.cn
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-use-strscpy-to-instead-of-strncpy
+++ a/mm/damon/sysfs-schemes.c
@@ -353,8 +353,7 @@ static ssize_t memcg_path_store(struct k
 	if (!path)
 		return -ENOMEM;
 
-	strncpy(path, buf, count);
-	path[count] = '\0';
+	strscpy(path, buf, count + 1);
 	filter->memcg_path = path;
 	return count;
 }
_

Patches currently in -mm which might be from xu.panda@zte.com.cn are

selftests-vm-ksm_functional_tests-fix-a-typo-in-comment.patch
mm-damon-sysfs-schemes-use-strscpy-to-instead-of-strncpy.patch

