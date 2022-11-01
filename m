Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB901C4332F
	for <mm-commits@archiver.kernel.org>; Tue,  1 Nov 2022 23:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiKAXAm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Nov 2022 19:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiKAXAl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2022 19:00:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA142C2
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 16:00:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CC0361777
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 23:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B8CC433D6;
        Tue,  1 Nov 2022 23:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667343639;
        bh=r5PGl/SfXqv2HPCcCsSU9Hf9GTsTSwTzTg2g91IZC6s=;
        h=Date:To:From:Subject:From;
        b=JcvWK3hAmf+/On5F5SgNvStujKZcv/17n2ha+278XgBoMpS6Y/NTtmIpJrFAPqwsZ
         bsqNexRJPW6u+GsRqOfV9yh67OJ3JNDudH2H+W0yF+Ddf5MCR+PCPoIZ16sR1JYDmc
         osSqUrlY8/Pg6ETKnatByrfX9SY8i+h+f5ULL+e4=
Date:   Tue, 01 Nov 2022 16:00:39 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-use-kstrtobool-instead-of-strtobool.patch added to mm-unstable branch
Message-Id: <20221101230039.92B8CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: use kstrtobool() instead of strtobool()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-use-kstrtobool-instead-of-strtobool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-use-kstrtobool-instead-of-strtobool.patch

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
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: mm/damon: use kstrtobool() instead of strtobool()
Date: Tue, 1 Nov 2022 22:14:08 +0100

strtobool() is the same as kstrtobool().  However, the latter is more used
within the kernel.

In order to remove strtobool() and slightly simplify kstrtox.h, switch to
the other function name.

While at it, include the corresponding header file (<linux/kstrtox.h>)

Link: https://lkml.kernel.org/r/ed2b46489a513988688decb53850339cc228940c.1667336095.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    3 ++-
 mm/damon/reclaim.c  |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-use-kstrtobool-instead-of-strtobool
+++ a/mm/damon/lru_sort.c
@@ -8,6 +8,7 @@
 #define pr_fmt(fmt) "damon-lru-sort: " fmt
 
 #include <linux/damon.h>
+#include <linux/kstrtox.h>
 #include <linux/module.h>
 
 #include "modules-common.h"
@@ -241,7 +242,7 @@ static int damon_lru_sort_enabled_store(
 	bool enable;
 	int err;
 
-	err = strtobool(val, &enable);
+	err = kstrtobool(val, &enable);
 	if (err)
 		return err;
 
--- a/mm/damon/reclaim.c~mm-damon-use-kstrtobool-instead-of-strtobool
+++ a/mm/damon/reclaim.c
@@ -8,6 +8,7 @@
 #define pr_fmt(fmt) "damon-reclaim: " fmt
 
 #include <linux/damon.h>
+#include <linux/kstrtox.h>
 #include <linux/module.h>
 
 #include "modules-common.h"
@@ -187,7 +188,7 @@ static int damon_reclaim_enabled_store(c
 	bool enable;
 	int err;
 
-	err = strtobool(val, &enable);
+	err = kstrtobool(val, &enable);
 	if (err)
 		return err;
 
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

mm-damon-use-kstrtobool-instead-of-strtobool.patch

