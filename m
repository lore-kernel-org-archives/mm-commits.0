Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C09AC54EE9
	for <mm-commits@archiver.kernel.org>; Sun, 25 Sep 2022 16:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiIYQzg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 25 Sep 2022 12:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiIYQzg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 25 Sep 2022 12:55:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091EA2B62E
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 09:55:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C68560B8D
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 16:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77FEC433C1;
        Sun, 25 Sep 2022 16:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664124934;
        bh=r6rMbWS8uk0nPDtcOLecqLeMKLsndzIBz30lAMcyxIQ=;
        h=Date:To:From:Subject:From;
        b=evwpMbi/I6ix5b6GpnWPOSCyb6rnGF8GW64ITLUwzQCpwqg2b6aL9wKysoSv2ncfb
         WpUKfe+Fv6Ys3McDXZG1GCgT/nn+dsdT601SLfU0L7TCicYmjIysmF9vo9rm4a7OLx
         Vr0daJna1Pmdn1zOGvQF+/2sbTRswYdu+r6ljPks=
Date:   Sun, 25 Sep 2022 09:55:31 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, ppbuk5246@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + damon-sysfs-fix-possible-memleak-on-damon_sysfs_add_target.patch added to mm-unstable branch
Message-Id: <20220925165533.B77FEC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: damon/sysfs: Fix possible memleak on damon_sysfs_add_target.
has been added to the -mm mm-unstable branch.  Its filename is
     damon-sysfs-fix-possible-memleak-on-damon_sysfs_add_target.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/damon-sysfs-fix-possible-memleak-on-damon_sysfs_add_target.patch

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
From: Levi Yun <ppbuk5246@gmail.com>
Subject: damon/sysfs: Fix possible memleak on damon_sysfs_add_target.
Date: Sun, 25 Sep 2022 23:02:57 +0900

When damon_sysfs_add_target couldn't find proper task, New allocated
damon_target structure isn't registered yet, So, it's impossible to free
new allocated one by damon_sysfs_destroy_targets.

By calling additional damon_free_target when find_get_pid function, Fix
possible memory leak.

Link: https://lkml.kernel.org/r/20220925140257.23431-1-ppbuk5246@gmail.com
Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/sysfs.c~damon-sysfs-fix-possible-memleak-on-damon_sysfs_add_target
+++ a/mm/damon/sysfs.c
@@ -2174,8 +2174,11 @@ static int damon_sysfs_add_target(struct
 		return -ENOMEM;
 	if (damon_target_has_pid(ctx)) {
 		t->pid = find_get_pid(sys_target->pid);
-		if (!t->pid)
+		if (!t->pid) {
+			damon_free_target(t);
+
 			goto destroy_targets_out;
+		}
 	}
 	damon_add_target(ctx, t);
 	err = damon_sysfs_set_regions(t, sys_target->regions);
_

Patches currently in -mm which might be from ppbuk5246@gmail.com are

damon-sysfs-fix-possible-memleak-on-damon_sysfs_add_target.patch

