Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F1C6C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiJCVLp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiJCVJv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:09:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F152450529
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CB88B81123
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFDAC433D7;
        Mon,  3 Oct 2022 21:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831207;
        bh=1aKSBCO45KF95oCIPRNM7s2WJGsR+q0k0MiJFfAhr8o=;
        h=Date:To:From:Subject:From;
        b=VGEhgVx0cdqUzcrhaXRvlsFwAbNQ2y/oHieXNvVWal5XaDhuz0g5UwY3QW6v87ggb
         NpXikAEhjf7DMmwMwNi9zq/RRxVA+7paV0zutDVz0iU98OuvaDDI8+Wbjqvly8z8nh
         2LZY4cIsJOwjq4vTP8dHtezoKMzYcVw+uA8q9Uks=
Date:   Mon, 03 Oct 2022 14:06:46 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch removed from -mm tree
Message-Id: <20221003210647.0EFDAC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/vaddr: add a comment for 'default' case in damon_va_apply_scheme()
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon/vaddr: add a comment for 'default' case in damon_va_apply_scheme()
Date: Thu, 8 Sep 2022 11:13:17 +0800

The switch case 'DAMOS_STAT' and switch case 'default' have same return
value in damon_va_apply_scheme(), and the 'default' case is for DAMOS
actions that not supported by 'vaddr'.  It might make sense to add a
comment here.

[akpm@linux-foundation.org: fx comment grammar]
Link: https://lkml.kernel.org/r/1662606797-23534-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme
+++ a/mm/damon/vaddr.c
@@ -658,6 +658,9 @@ static unsigned long damon_va_apply_sche
 	case DAMOS_STAT:
 		return 0;
 	default:
+		/*
+		 * DAMOS actions that are not yet supported by 'vaddr'.
+		 */
 		return 0;
 	}
 
_

Patches currently in -mm which might be from kaixuxia@tencent.com are


