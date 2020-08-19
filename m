Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65343C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AE54208E4
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597865266;
	bh=nvRLxbg1Rd/JUbRdWZAiYCGDYLu+zuGAQdhb9DMhSEw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=NulQQqiUQkNrGwbIrzxPc2F/sG33Y3f6Zt5kpUJV0NyffI/rEvja8ENnuMc772jf+
	 pCHsOpKDnJXe9XdGIGWBEL2ciruksBp1sW+nqnnGsIboiHxBr3P91kp3g/knsvpzkm
	 uQSlJBf4Ds1XP2FBawJoUrdOHXbsLjZvQZ2z4oRw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgHST1p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 15:27:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbgHST1p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 15:27:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDB53208E4;
        Wed, 19 Aug 2020 19:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597865264;
        bh=nvRLxbg1Rd/JUbRdWZAiYCGDYLu+zuGAQdhb9DMhSEw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Am/bu2iTpHwz/hy6+m+zg+V4CSt/L/geuUSlCNPUx/6zo7aETBGK4ghlIy7I60/HI
         4F4Xtvulx7GEVzKFrROihm4IStBUiU0ZsTqJaaFm+FQ9yXZ4ixNM4ZxvBBBnO4D1hU
         hSIXkFxdS6uiiwS2AAfWd14Hn1kIYAG5R0rYU+fs=
Date:   Wed, 19 Aug 2020 12:27:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  +
 memblock-make-memblock_debug-and-related-functionality-private-fix.patch
 added to -mm tree
Message-ID: <20200819192744.3BxiVkmrJ%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock-make-memblock_debug-and-related-functionality-private-fix
has been added to the -mm tree.  Its filename is
     memblock-make-memblock_debug-and-related-functionality-private-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memblock-make-memblock_debug-and-related-functionality-private-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memblock-make-memblock_debug-and-related-functionality-private-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memblock-make-memblock_debug-and-related-functionality-private-fix

make memblock_dbg() safer and neater

Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/memblock.c~memblock-make-memblock_debug-and-related-functionality-private-fix
+++ a/mm/memblock.c
@@ -137,8 +137,11 @@ struct memblock_type physmem = {
 	     i < memblock_type->cnt;					\
 	     i++, rgn = &memblock_type->regions[i])
 
-#define memblock_dbg(fmt, ...) \
-	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define memblock_dbg(fmt, ...)						\
+	do {								\
+		if (memblock_debug)					\
+			pr_info(fmt, ##__VA_ARGS__);			\
+	} while (0)
 
 static int memblock_debug __initdata_memblock;
 static bool system_has_some_mirror __initdata_memblock = false;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

