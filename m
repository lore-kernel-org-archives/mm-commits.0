Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4862C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  4 Mar 2022 01:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbiCDB4c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Mar 2022 20:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbiCDB4b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Mar 2022 20:56:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600D313D553
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 17:55:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 085F961797
        for <mm-commits@vger.kernel.org>; Fri,  4 Mar 2022 01:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC2DC004E1;
        Fri,  4 Mar 2022 01:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646358944;
        bh=05n+CYLqno0jlg23y0YuJR857KFUQLZ7PiDuoW6bgJc=;
        h=Date:To:From:Subject:From;
        b=2qHDyekuWwJa+HVo2J+PUEleE/2VRYzg8poxWNQDfSniCqku4FHH4mlWS9Z/NmkT+
         yl3CgGLmtz2glOIDsPJSn7M1SrV4ZMlsELJmCoTrhqDMHwFjRlDuqwv+M/VZCrXu4t
         Xu/pS4QClSLYzeWShnJ4SIrVcuEl7tat3Pe6XfSo=
Date:   Thu, 03 Mar 2022 17:55:43 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-remove-repeat-container_of-in-damon_sysfs_kdamond_release.patch added to -mm tree
Message-Id: <20220304015544.5FC2DC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: remove repeat container_of() in damon_sysfs_kdamond_release()
has been added to the -mm tree.  Its filename is
     mm-damon-sysfs-remove-repeat-container_of-in-damon_sysfs_kdamond_release.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-sysfs-remove-repeat-container_of-in-damon_sysfs_kdamond_release.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-sysfs-remove-repeat-container_of-in-damon_sysfs_kdamond_release.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon/sysfs: remove repeat container_of() in damon_sysfs_kdamond_release()

In damon_sysfs_kdamond_release(), we have use container_of() to get
"kdamond" pointer, so there no need to get it once again.

Link: https://lkml.kernel.org/r/20220303075314.22502-1-xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-repeat-container_of-in-damon_sysfs_kdamond_release
+++ a/mm/damon/sysfs.c
@@ -2345,7 +2345,7 @@ static void damon_sysfs_kdamond_release(
 
 	if (kdamond->damon_ctx)
 		damon_destroy_ctx(kdamond->damon_ctx);
-	kfree(container_of(kobj, struct damon_sysfs_kdamond, kobj));
+	kfree(kdamond);
 }
 
 static struct kobj_attribute damon_sysfs_kdamond_state_attr =
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-sysfs-remove-repeat-container_of-in-damon_sysfs_kdamond_release.patch

