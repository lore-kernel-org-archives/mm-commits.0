Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE3BC433E0
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD69E224B8
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbhAQVlN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 16:41:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:55500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbhAQVlM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 16:41:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAC2220791;
        Sun, 17 Jan 2021 21:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610919632;
        bh=Tgo6KO1aEOrq7DJyDNr6OlyoBpvvuhLW2HU1v3fD8tU=;
        h=Date:From:To:Subject:From;
        b=x79i4lkO0ILN41G4rM8EoIjv0jtighj/PzO6gHAoRd36HO8Mi9YYxN+Vhw2Y1lef4
         LqxEP3DY3xRc8j8bczj+n8nMJer3dWPwb79znuR5QmVr7y9quiJDMKM+uIYcvS5+H8
         OTzj19BLkYz74FEG4y4Sc0Vyj9Fgu8iuf7pL9Skg=
Date:   Sun, 17 Jan 2021 13:40:30 -0800
From:   akpm@linux-foundation.org
To:     bcain@codeaurora.org, gregkh@linuxfoundation.org,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  +
 hexagon-remove-config_experimental-from-defconfigs.patch added to -mm tree
Message-ID: <20210117214030.NNrQdTfLO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: remove CONFIG_EXPERIMENTAL from defconfigs
has been added to the -mm tree.  Its filename is
     hexagon-remove-config_experimental-from-defconfigs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hexagon-remove-config_experimental-from-defconfigs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hexagon-remove-config_experimental-from-defconfigs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: hexagon: remove CONFIG_EXPERIMENTAL from defconfigs

Since CONFIG_EXPERIMENTAL was removed in 2013, go ahead and drop it
from any defconfig files.

Link: https://lkml.kernel.org/r/20210115010011.29483-1-rdunlap@infradead.org
Fixes: 3d374d09f16f ("final removal of CONFIG_EXPERIMENTAL")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Brian Cain <bcain@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/configs/comet_defconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/hexagon/configs/comet_defconfig~hexagon-remove-config_experimental-from-defconfigs
+++ a/arch/hexagon/configs/comet_defconfig
@@ -1,7 +1,6 @@
 CONFIG_SMP=y
 CONFIG_DEFAULT_MMAP_MIN_ADDR=0
 CONFIG_HZ_100=y
-CONFIG_EXPERIMENTAL=y
 CONFIG_CROSS_COMPILE="hexagon-"
 CONFIG_LOCALVERSION="-smp"
 # CONFIG_LOCALVERSION_AUTO is not set
_

Patches currently in -mm which might be from rdunlap@infradead.org are

hexagon-remove-config_experimental-from-defconfigs.patch
fs-delete-repeated-words-in-comments.patch
mm-zswap-clean-up-confusing-comment.patch
alpha-remove-config_experimental-from-defconfigs.patch

