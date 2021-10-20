Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A060C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 22:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D21561212
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 22:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhJTWgF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Oct 2021 18:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhJTWgF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 Oct 2021 18:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 062366115B;
        Wed, 20 Oct 2021 22:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634769230;
        bh=gGL9APCKTVhM72N8SAwO2ItuBv2UwTn0lJ/22cx2PsE=;
        h=Date:From:To:Subject:From;
        b=AoZubUYEm4cYcEfmw8XAk1Oi0+G4kXbC85Spgo/mQ7zyXgvSDSU6V97+nqD27LdD3
         mi3mC+1IjDEdQrQVcT8KyKp6zT9rebME0eEfQr1VkbzhKVtoKLg3H2mE8OxuNxdum5
         BpdYz70/jQTB1u88QQOKrBeGbzKyeGaN9ViPCeoM=
Date:   Wed, 20 Oct 2021 15:33:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com
Subject:  +
 mm-damon-remove-unnecessary-variable-initialization.patch added to -mm tree
Message-ID: <20211020223349.1o6R9syIg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove unnecessary variable initialization
has been added to the -mm tree.  Its filename is
     mm-damon-remove-unnecessary-variable-initialization.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-remove-unnecessary-variable-initialization.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-remove-unnecessary-variable-initialization.patch

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
Subject: mm/damon: remove unnecessary variable initialization

Patch series "mm/damon: Fix some small bugs", v4.


This patch (of 2):

In 'damon_va_apply_three_regions', There is no need to set variable 'i' as
0

Link: https://lkml.kernel.org/r/b7df8d3dad0943a37e01f60c441b1968b2b20354.1634720326.git.xhao@linux.alibaba.com
Link: https://lkml.kernel.org/r/cover.1634720326.git.xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-remove-unnecessary-variable-initialization
+++ a/mm/damon/vaddr.c
@@ -306,7 +306,7 @@ static void damon_va_apply_three_regions
 		struct damon_addr_range bregions[3])
 {
 	struct damon_region *r, *next;
-	unsigned int i = 0;
+	unsigned int i;
 
 	/* Remove regions which are not in the three big regions now */
 	damon_for_each_region_safe(r, next, t) {
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-remove-unnecessary-variable-initialization.patch
mm-damon-dbgfs-add-adaptive_targets-list-check-before-enable-monitor_on.patch

