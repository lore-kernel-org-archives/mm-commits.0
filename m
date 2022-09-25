Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC77C04A95
	for <mm-commits@archiver.kernel.org>; Sun, 25 Sep 2022 19:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiIYTPH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 25 Sep 2022 15:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbiIYTO6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 25 Sep 2022 15:14:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0565B30F4F
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 12:14:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98A1A61046
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 19:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E3BC433C1;
        Sun, 25 Sep 2022 19:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664133267;
        bh=kDwHezgFI9DHYDI+Z3fMwuSMh1+p4+i+ZLYlR7ZTzI0=;
        h=Date:To:From:Subject:From;
        b=2eLWEwu7iva8jVRKCROc9/uxq/hh99p7xrsd+9LRkLaEuf2oQq9W4A3LVlqM5WJNA
         kI9n/xzOFaLvVBnLMu7O8Kh4znSVS9Knd5ch+7xDsExCmTCZwRHM3O15kmyYKUCgMs
         sN3W9ayicuOSmTO22AnnpvFiCzNCCYXIEkRcnguc=
Date:   Sun, 25 Sep 2022 12:14:25 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, ppbuk5246@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] damon-sysfs-fix-possible-memleak-on-damon_sysfs_add_target.patch removed from -mm tree
Message-Id: <20220925191426.C9E3BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: damon/sysfs: Fix possible memleak on damon_sysfs_add_target.
has been removed from the -mm tree.  Its filename was
     damon-sysfs-fix-possible-memleak-on-damon_sysfs_add_target.patch

This patch was dropped because an updated version will be merged

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


