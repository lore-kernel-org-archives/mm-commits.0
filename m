Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F357FC47089
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiLAABX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiLAAAw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8660C87CB9
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 240E8614D0
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FADC433B5;
        Thu,  1 Dec 2022 00:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852845;
        bh=tZ3Sb65i7Udg0L/pXPTdmm9KqUJBgcq0BSu0xA0EDg4=;
        h=Date:To:From:Subject:From;
        b=Tx/NsbjdYH4PIh1ErcJ5l21MohW5xvEYX/JnkK7vnEegjhj/Eecci4tGFafZ1JY8K
         Lu/6JAxeV4ejJZtcTHnahA4T98tcUjsOiLsRayczFXVjN+U/PM1hfsH7Kzffz0kyGW
         gtVYO2A3efMZu69/WU47x9l6DgHfbmKtem5uVmRM=
Date:   Wed, 30 Nov 2022 16:00:44 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-use-kstrtobool-instead-of-strtobool.patch removed from -mm tree
Message-Id: <20221201000045.73FADC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: use kstrtobool() instead of strtobool()
has been removed from the -mm tree.  Its filename was
     mm-damon-use-kstrtobool-instead-of-strtobool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

io-mapping-move-some-code-within-the-include-guarded-section.patch

