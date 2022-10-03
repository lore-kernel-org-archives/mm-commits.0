Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49BEFC43219
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiJCVPY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiJCVN4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D9954665
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1C7DB815E2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7058AC433D7;
        Mon,  3 Oct 2022 21:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831357;
        bh=7kMs2PlZXG4wx+tleVW9X/oK6B7PfDYibrfJXp5Ojgo=;
        h=Date:To:From:Subject:From;
        b=aYBM9l7qXNoOnNSPTJuuV3dnesEf3eIXysNVsaUkb9hVe11FsKh8KUADNCcFkvFnU
         DdqeUMwdtzNWgnTWE1nr3zNJEQoArsFPg72RJjlRoYmW1uqBDs4VlmjNf9FhHzsc2H
         U+zjr3gaqkERrCzsGcDY2iqMroLBmCyAHVL9fSlA=
Date:   Mon, 03 Oct 2022 14:09:16 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly.patch removed from -mm tree
Message-Id: <20221003210917.7058AC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: avoid call damon_target_has_pid() repeatedly
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon/sysfs: avoid call damon_target_has_pid() repeatedly
Date: Thu, 15 Sep 2022 22:22:36 +0800

In damon_sysfs_destroy_targets(), we call damon_target_has_pid() to check
whether the 'ctx' include a valid pid, but there no need to call
damon_target_has_pid() to check repeatedly, just need call it once.

[xhao@linux.alibaba.com: more simplified code calls damon_target_has_pid()]
  Link: https://lkml.kernel.org/r/20220916133535.7428-1-xhao@linux.alibaba.com
Link: https://lkml.kernel.org/r/20220915142237.92529-1-xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly
+++ a/mm/damon/sysfs.c
@@ -2143,9 +2143,10 @@ static int damon_sysfs_set_attrs(struct
 static void damon_sysfs_destroy_targets(struct damon_ctx *ctx)
 {
 	struct damon_target *t, *next;
+	bool has_pid = damon_target_has_pid(ctx);
 
 	damon_for_each_target_safe(t, next, ctx) {
-		if (damon_target_has_pid(ctx))
+		if (has_pid)
 			put_pid(t->pid);
 		damon_destroy_target(t);
 	}
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-move-sz_damon_region-to-damon_sz_region.patch
mm-damon-use-damon_sz_region-in-appropriate-place.patch

