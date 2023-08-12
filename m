Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29F1C04A94
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjHLWFR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjHLWFP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5521994
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9017460F60
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E672CC433C8;
        Sat, 12 Aug 2023 22:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877918;
        bh=ROQFF5vZmp96VJnmgFThqgAb/WSgrO94VBSOH10GwHU=;
        h=Date:To:From:Subject:From;
        b=jOa8sDPjFIZLCxS7qOk3bvjWfoc6XLQXZ58Uf4AJu0fi+xwlG302o4HSxJax6QUul
         W/qHRK5NcPj07KE5FunYewDYk8xUEkq8V8zfviGCimKqEo41GS07auFKx7j8Dz+wPg
         rOz/xKYbRKYzc946RZVfXcorzR4nPNA0ksJFXHNA=
Date:   Sat, 12 Aug 2023 15:05:17 -0700
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        azeemshaikh38@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] acct-replace-all-non-returning-strlcpy-with-strscpy.patch removed from -mm tree
Message-Id: <20230812220517.E672CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: acct: replace all non-returning strlcpy with strscpy
has been removed from the -mm tree.  Its filename was
     acct-replace-all-non-returning-strlcpy-with-strscpy.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


