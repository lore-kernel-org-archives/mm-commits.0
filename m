Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD495EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 20:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjGJUaG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 16:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbjGJU3v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 16:29:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485F41B9
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 13:29:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBA09611D4
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 20:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A44C433C8;
        Mon, 10 Jul 2023 20:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689020987;
        bh=w8WTSqthDGRiGBuNdGpvAOXuuKQbesf3lqXVSIEbic0=;
        h=Date:To:From:Subject:From;
        b=SI2WGnil4egaJ4PAs7Ix0AiuxxrbExn1q+FRYbghgoHXUxvZLtmnJG6rplsVyKFet
         6rlsSLmgP3isL+z/n8vFrYLybbCDNEfVRO2F5VPsoG/qCN9ZabVWz5lokcbvJvXEgq
         /3KPAurIVrxEXuUTzCS7BXsetgnAdxteRggV9w1I=
Date:   Mon, 10 Jul 2023 13:29:46 -0700
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        azeemshaikh38@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + acct-replace-all-non-returning-strlcpy-with-strscpy.patch added to mm-nonmm-unstable branch
Message-Id: <20230710202947.31A44C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: acct: replace all non-returning strlcpy with strscpy
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     acct-replace-all-non-returning-strlcpy-with-strscpy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/acct-replace-all-non-returning-strlcpy-with-strscpy.patch

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
From: Azeem Shaikh <azeemshaikh38@gmail.com>
Subject: acct: replace all non-returning strlcpy with strscpy
Date: Mon, 10 Jul 2023 01:17:48 +0000

strlcpy() reads the entire source buffer first.  This read may exceed the
destination size limit.  This is both inefficient and can lead to linear
read overflows if a source string is not NUL-terminated [1].  In an effort
to remove strlcpy() completely [2], replace strlcpy() here with strscpy().
No return values were used, so direct replacement is safe.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89

Link: https://lkml.kernel.org/r/20230710011748.3538624-1-azeemshaikh38@gmail.com
Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/acct.c~acct-replace-all-non-returning-strlcpy-with-strscpy
+++ a/kernel/acct.c
@@ -445,7 +445,7 @@ static void fill_ac(acct_t *ac)
 	memset(ac, 0, sizeof(acct_t));
 
 	ac->ac_version = ACCT_VERSION | ACCT_BYTEORDER;
-	strlcpy(ac->ac_comm, current->comm, sizeof(ac->ac_comm));
+	strscpy(ac->ac_comm, current->comm, sizeof(ac->ac_comm));
 
 	/* calculate run_time in nsec*/
 	run_time = ktime_get_ns();
_

Patches currently in -mm which might be from azeemshaikh38@gmail.com are

acct-replace-all-non-returning-strlcpy-with-strscpy.patch

