Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06B7C41513
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjJRVnt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjJRVnt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:43:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2826B11B
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:43:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2F3C433C9;
        Wed, 18 Oct 2023 21:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697665426;
        bh=dh2aMbhN9L2i8YBZlwGdCmSL1gpCrKl4fddQWIWV8Tw=;
        h=Date:To:From:Subject:From;
        b=HEahd0ooje0jhX9gUEykXiNc4MkcvRwQV8tYvVg2Xnl7qsvO1j+T0DYaKiGRQllh9
         Z+NUKvkszRx+jh8w7Oimg4ukkEiIx4xmZPX0krNytGACNaVq8W1kNJXrb43AkGrzVj
         OOv4NnG/WnBUyRQMVFOw+prNsX1truxvuckifvrg=
Date:   Wed, 18 Oct 2023 14:43:46 -0700
To:     mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kstrtox-remove-strtobool.patch removed from -mm tree
Message-Id: <20231018214346.BC2F3C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kstrtox: remove strtobool()
has been removed from the -mm tree.  Its filename was
     kstrtox-remove-strtobool.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: kstrtox: remove strtobool()
Date: Sat, 16 Sep 2023 17:50:11 +0200

The conversion from strtobool() to kstrtobool() is completed.  So
strtobool() can now be removed.

Link: https://lkml.kernel.org/r/87e3cc2547df174cd5af1fadbf866be4ef9e8e45.1694878151.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kstrtox.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/kstrtox.h~kstrtox-remove-strtobool
+++ a/include/linux/kstrtox.h
@@ -147,9 +147,4 @@ extern long simple_strtol(const char *,c
 extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
 extern long long simple_strtoll(const char *,char **,unsigned int);
 
-static inline int strtobool(const char *s, bool *res)
-{
-	return kstrtobool(s, res);
-}
-
 #endif	/* _LINUX_KSTRTOX_H */
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are


