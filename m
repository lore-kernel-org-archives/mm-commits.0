Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B227C2BA12
	for <mm-commits@archiver.kernel.org>; Sat, 16 Sep 2023 20:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbjIPUPQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Sep 2023 16:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233681AbjIPUPF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Sep 2023 16:15:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1874F1B5
        for <mm-commits@vger.kernel.org>; Sat, 16 Sep 2023 13:15:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1F1C433C7;
        Sat, 16 Sep 2023 20:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694895299;
        bh=y3LnN7RnTowWaL3xqoMEcglF/1veC3J3MnygFVNPDBI=;
        h=Date:To:From:Subject:From;
        b=ELRECGKrLJ4/KOakVo9Pq2+I/ZSeWtH42S9RhwJhLq5/bJSoc7UjjyTM7Ocrhwvxv
         LKUFMat9rzBucsvl7dqrodVCz0arcxSm1JthOFdXs71mIiEcNNLBpA4WjEEqz7sb/u
         cCfVBvt+iJ3I7Z0lTE6EEPiFu0EVl8GR8hxbc37w=
Date:   Sat, 16 Sep 2023 13:14:59 -0700
To:     mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kstrtox-remove-strtobool.patch added to mm-nonmm-unstable branch
Message-Id: <20230916201459.8D1F1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kstrtox: remove strtobool()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kstrtox-remove-strtobool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kstrtox-remove-strtobool.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: kstrtox: remove strtobool()
Date: Sat, 16 Sep 2023 17:50:11 +0200

The conversion from strtobool() to kstrtobool() is completed.  So
strtobool() can now be removed.

Link: https://lkml.kernel.org/r/87e3cc2547df174cd5af1fadbf866be4ef9e8e45.1694878151.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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

kstrtox-remove-strtobool.patch

