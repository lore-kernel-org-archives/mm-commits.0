Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07053C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 02:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8DF160F58
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 02:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238670AbhI1CpL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Sep 2021 22:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238594AbhI1CpL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Sep 2021 22:45:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9944A61156;
        Tue, 28 Sep 2021 02:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632797012;
        bh=yBPyhEtWP12TTI2auUeizJUdauw6qiBe9H7pzSTLdMg=;
        h=Date:From:To:Subject:From;
        b=vVo8hBlNtJGXml9mryzlnaXO2wdnLe4iCsC3VL3hfs0Q8uUy4dTvgULn3kZJlP9J5
         X9ODZJXTnxGwoBhRq7SyxXqKyXTMoRUiLfAUwNwjCUf3qcqQdtBJrPFW50AWK29lLU
         tDZF5a1Ni3qHPoUK02Mk/ObAf4YLdUr/+Hc3u7k0=
Date:   Mon, 27 Sep 2021 19:43:32 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org,
        sven@narfation.org
Subject:  +
 scripts-spellingtxt-fix-mistake-version-of-synchronization.patch added to
 -mm tree
Message-ID: <20210928024332.aO37pWulR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: fix "mistake" version of "synchronization"
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-fix-mistake-version-of-synchronization.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-fix-mistake-version-of-synchronization.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-fix-mistake-version-of-synchronization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sven Eckelmann <sven@narfation.org>
Subject: scripts/spelling.txt: fix "mistake" version of "synchronization"

If both "mistake" version and "correction" version are the same, a warning
message is created by checkpatch which is impossible to fix.  But it was
noticed that Colan Ian King created a commit e6c0a0889b80 ("ALSA: aloop:
Fix spelling mistake "synchronization" -> "synchronization"") which
suggests that this spelling mistake was fixed by replacing the word
"synchronization" with itself.  But the actual diff shows that the mistake
in the code was "sychronization".  It is rather likely that the "mistake"
in spelling.txt should have been the latter.

Link: https://lkml.kernel.org/r/20210926065529.6880-1-sven@narfation.org
Fixes: 2e74c9433ba8 ("scripts/spelling.txt: add more spellings to spelling.txt")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Reviewed-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/spelling.txt~scripts-spellingtxt-fix-mistake-version-of-synchronization
+++ a/scripts/spelling.txt
@@ -1450,7 +1450,7 @@ syfs||sysfs
 symetric||symmetric
 synax||syntax
 synchonized||synchronized
-synchronization||synchronization
+sychronization||synchronization
 synchronuously||synchronously
 syncronize||synchronize
 syncronized||synchronized
_

Patches currently in -mm which might be from sven@narfation.org are

scripts-spellingtxt-fix-mistake-version-of-synchronization.patch

