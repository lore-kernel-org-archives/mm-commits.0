Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B19C4167B
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 16:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjKFQOj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 11:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbjKFQOj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 11:14:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7CE191
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 08:14:36 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3F2C433C8;
        Mon,  6 Nov 2023 16:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699287276;
        bh=+zf+n1lyD0xBmoXXvqnIQanypHhzXmKStM9kAI+tbyg=;
        h=Date:To:From:Subject:From;
        b=hU3zinnMnpS4dFDm2tv55fs2bbaBEiB8ReI3GnL7EuRmwWTAos5xF3+2JI8k0zFiR
         3KFZ7gx88iu8usRFHQo7mrMX9TgNvJ/rJtLSbAQiztsDP7NJnJWNaA5eUdbydsl45/
         sPJ/OGbJLQAt6hjXqp42lAsmJ4OTKufXwN3QLdww=
Date:   Mon, 06 Nov 2023 08:14:35 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        dan.carpenter@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-eliminate-potential-uninitialized-variable-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20231106161436.4D3F2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: eliminate potential uninitialized variable warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-eliminate-potential-uninitialized-variable-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-eliminate-potential-uninitialized-variable-warning.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: mm/damon/sysfs: eliminate potential uninitialized variable warning
Date: Mon, 6 Nov 2023 17:07:40 +0300

The "err" variable is not initialized if damon_target_has_pid(ctx) is
false and sys_target->regions->nr is zero.

Link: https://lkml.kernel.org/r/739e6aaf-a634-4e33-98a8-16546379ec9f@moroto.mountain
Fixes: 0bcd216c4741 ("mm/damon/sysfs: update monitoring target regions for online input commit")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-eliminate-potential-uninitialized-variable-warning
+++ a/mm/damon/sysfs.c
@@ -1172,7 +1172,7 @@ static int damon_sysfs_update_target(str
 		struct damon_ctx *ctx,
 		struct damon_sysfs_target *sys_target)
 {
-	int err;
+	int err = 0;
 
 	if (damon_target_has_pid(ctx)) {
 		err = damon_sysfs_update_target_pid(target, sys_target->pid);
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

mm-damon-sysfs-eliminate-potential-uninitialized-variable-warning.patch

