Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82582CD68E2
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 00:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379246AbjJJAxa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Oct 2023 20:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379287AbjJJAx3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2023 20:53:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55ADB0
        for <mm-commits@vger.kernel.org>; Mon,  9 Oct 2023 17:53:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4540C433C7;
        Tue, 10 Oct 2023 00:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696899207;
        bh=XQdI2cFrNm/ReizhdEgQMU+CN+2/Xe4Lpx6wkl1p8Rk=;
        h=Date:To:From:Subject:From;
        b=TP8EleGU1glqR/jnJ6rxRgiMqTEhtLFn2vt4QVeoDL0TFx+XMBpYkhpmS2UMf6+FU
         DDuQRbsn8NOHEUynCRFA9nKztQVAm8Hdya0L990c6dPX6DBzcZyYZts+Au3J7WvhUG
         mlRglDHZVkgmfps6FgmRJdCxxqWm8BBoE1g32sok=
Date:   Mon, 09 Oct 2023 17:53:13 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        lucymielke@icloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-printf-attribute-to-shrinker_debugfs_name_alloc.patch added to mm-unstable branch
Message-Id: <20231010005323.B4540C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add printf attribute to shrinker_debugfs_name_alloc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-printf-attribute-to-shrinker_debugfs_name_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-printf-attribute-to-shrinker_debugfs_name_alloc.patch

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
From: Lucy Mielke <lucymielke@icloud.com>
Subject: mm: add printf attribute to shrinker_debugfs_name_alloc
Date: Fri, 6 Oct 2023 22:30:51 +0200

This fixes a compiler warning when compiling an allyesconfig with W=1:

mm/internal.h:1235:9: error: function might be a candidate for `gnu_printf'
format attribute [-Werror=suggest-attribute=format]

Link: https://lkml.kernel.org/r/ZSBue-3kM6gI6jCr@mainframe
Fixes: c42d50aefd17 ("mm: shrinker: add infrastructure for dynamically allocating shrinker")
Signed-off-by: Lucy Mielke <lucymielke@icloud.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/internal.h~mm-add-printf-attribute-to-shrinker_debugfs_name_alloc
+++ a/mm/internal.h
@@ -1235,8 +1235,8 @@ unsigned long shrink_slab(gfp_t gfp_mask
 			  int priority);
 
 #ifdef CONFIG_SHRINKER_DEBUG
-static inline int shrinker_debugfs_name_alloc(struct shrinker *shrinker,
-					      const char *fmt, va_list ap)
+static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
+			struct shrinker *shrinker, const char *fmt, va_list ap)
 {
 	shrinker->name = kvasprintf_const(GFP_KERNEL, fmt, ap);
 
_

Patches currently in -mm which might be from lucymielke@icloud.com are

mm-add-printf-attribute-to-shrinker_debugfs_name_alloc.patch

