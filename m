Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9FCC433F5
	for <mm-commits@archiver.kernel.org>; Sat,  7 May 2022 18:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446750AbiEGSFE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 May 2022 14:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446748AbiEGSFD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 7 May 2022 14:05:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9092CE11
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 11:01:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2841761376
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 18:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B111C385A5;
        Sat,  7 May 2022 18:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651946475;
        bh=hlwD2vW9dNI/GiVR+LwBOvLxml0yJmfT1wE5nMy6JfM=;
        h=Date:To:From:Subject:From;
        b=WtbyFeLpFJYYReFsiLwbP+kxoYDuclxKHU44RbsmUKOWo8+OLgNMhUoit8B77xICQ
         20Gyzou7QB8/SUvZ/mLkT1l4vHcW8qM59HHPSiDKTWETbtnZ00w/aC4NtsfIeLC8iB
         n5XE4DR8M9rf/rAbWQaVMwHvVahzi0AfNAph6a40=
Date:   Sat, 07 May 2022 11:01:14 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, abaci@linux.alibaba.com,
        jiapeng.chong@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-use-resource_size-function-on-resource-object.patch added to mm-unstable branch
Message-Id: <20220507180115.7B111C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/reclaim: use resource_size function on resource object
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-reclaim-use-resource_size-function-on-resource-object.patch

This patch should soon appear in the mm-unstable branch at
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
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: mm/damon/reclaim: use resource_size function on resource object

Fix the following coccicheck warnings:

./mm/damon/reclaim.c:241:30-33: WARNING: Suspicious code. resource_size is maybe missing with res.

Link: https://lkml.kernel.org/r/20220507032512.129598-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-resource_size-function-on-resource-object
+++ a/mm/damon/reclaim.c
@@ -238,7 +238,7 @@ static int walk_system_ram(struct resour
 {
 	struct damon_reclaim_ram_walk_arg *a = arg;
 
-	if (a->end - a->start < res->end - res->start) {
+	if (a->end - a->start < resource_size(res)) {
 		a->start = res->start;
 		a->end = res->end;
 	}
_

Patches currently in -mm which might be from jiapeng.chong@linux.alibaba.com are

mm-damon-reclaim-use-resource_size-function-on-resource-object.patch

