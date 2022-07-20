Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D9EC43334
	for <mm-commits@archiver.kernel.org>; Wed, 20 Jul 2022 16:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiGTQXf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Jul 2022 12:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiGTQXf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jul 2022 12:23:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB3354C84
        for <mm-commits@vger.kernel.org>; Wed, 20 Jul 2022 09:23:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADC9AB81FF0
        for <mm-commits@vger.kernel.org>; Wed, 20 Jul 2022 16:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3B4C341C7;
        Wed, 20 Jul 2022 16:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658334211;
        bh=8qDok7QfxFk3zhWvhVcJ2ltQqSfW+Mct6codUelya00=;
        h=Date:To:From:Subject:From;
        b=OgtOETP6r0fiDIPuZQd8944QSvqS3ioyjgSj56fcNKQfg+WrFHyjQzRoMGxRsxJUC
         G2BOADFNXzD+dDwol1MOkalBEkf2zDyxvVCP6rSSupKRTlwmx8Zx1ovbjVtF37bXRD
         bAjOHCtyfZ/zZXyhHFuT6LYbqzQSbrWHoYsiNHjE=
Date:   Wed, 20 Jul 2022 09:23:30 -0700
To:     mm-commits@vger.kernel.org,
        syzbot+8b481578352d4637f510@syzkaller.appspotmail.com,
        roman.gushchin@linux.dev, penguin-kernel@I-love.SAKURA.ne.jp,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinkers-fix-double-kfree-on-shrinker-name.patch added to mm-unstable branch
Message-Id: <20220720162331.3E3B4C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shrinkers: fix double kfree on shrinker name
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinkers-fix-double-kfree-on-shrinker-name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinkers-fix-double-kfree-on-shrinker-name.patch

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
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm: shrinkers: fix double kfree on shrinker name
Date: Wed, 20 Jul 2022 23:47:55 +0900

syzbot is reporting double kfree() at free_prealloced_shrinker() [1], for
destroy_unused_super() calls free_prealloced_shrinker() even if
prealloc_shrinker() returned an error.  Explicitly clear shrinker name
when prealloc_shrinker() called kfree().

Link: https://syzkaller.appspot.com/bug?extid=8b481578352d4637f510 [1]
Link: https://lkml.kernel.org/r/ffa62ece-6a42-2644-16cf-0d33ef32c676@I-love.SAKURA.ne.jp
Fixes: e33c267ab70de424 ("mm: shrinkers: provide shrinkers with names")
Reported-by: syzbot <syzbot+8b481578352d4637f510@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-shrinkers-fix-double-kfree-on-shrinker-name
+++ a/mm/vmscan.c
@@ -704,8 +704,10 @@ int register_shrinker(struct shrinker *s
 		return -ENOMEM;
 
 	err = __register_shrinker(shrinker);
-	if (err)
+	if (err) {
 		kfree_const(shrinker->name);
+		shrinker->name = NULL;
+	}
 	return err;
 }
 #else
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

mm-shrinkers-fix-double-kfree-on-shrinker-name.patch

