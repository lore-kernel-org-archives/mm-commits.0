Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63BD1C433DB
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 143F764E67
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240402AbhCCN2t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:28:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234637AbhCBX6B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 18:58:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9475964EFC;
        Tue,  2 Mar 2021 23:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614729429;
        bh=7zjU9AUha53iA8s+VVDFog5uryGlFFoBStq5GFTTBeo=;
        h=Date:From:To:Subject:From;
        b=hFyoOq2GFiUmOwuKluxetUCRob8Jo6UnmdE6a9zKKI/OFW+gyQVLzaBWS77VQLsxp
         6B1kypllyoAY5gf7kg1u4PpPsDH4NwXy18XYgAeDHS1f8/B1S6vyYBE+nvFISj9FKj
         kjSNQOZ5rBcISzGuyrK8YFh2STlLQdgwpQ60VG44=
Date:   Tue, 02 Mar 2021 15:57:09 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, unixbhaskar@gmail.com
Subject:  + lib-fix-a-typo-in-the-file-bchc.patch added to -mm tree
Message-ID: <20210302235709.KXexKHd-Q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bch.c: fix a typo in the file bch.c
has been added to the -mm tree.  Its filename is
     lib-fix-a-typo-in-the-file-bchc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-fix-a-typo-in-the-file-bchc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-fix-a-typo-in-the-file-bchc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: lib/bch.c: fix a typo in the file bch.c

s/buid/build/

Link: https://lkml.kernel.org/r/20210301123129.18754-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bch.c~lib-fix-a-typo-in-the-file-bchc
+++ a/lib/bch.c
@@ -584,7 +584,7 @@ static int find_affine4_roots(struct bch
 	k = a_log(bch, a);
 	rows[0] = c;
 
-	/* buid linear system to solve X^4+aX^2+bX+c = 0 */
+	/* build linear system to solve X^4+aX^2+bX+c = 0 */
 	for (i = 0; i < m; i++) {
 		rows[i+1] = bch->a_pow_tab[4*i]^
 			(a ? bch->a_pow_tab[mod_s(bch, k)] : 0)^
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are

lib-fix-a-typo-in-the-file-bchc.patch

