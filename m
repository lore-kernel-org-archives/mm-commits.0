Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA0BC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 20:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344280AbiC1UO1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 16:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344229AbiC1UO0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 16:14:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24495373C
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 13:12:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 597E4B81106
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 20:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB17EC340ED;
        Mon, 28 Mar 2022 20:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648498361;
        bh=cxzq0QkkYsaXwLXsCeZ6bN+fhZh5oqvUlr6bT2Hr3AI=;
        h=Date:To:From:Subject:From;
        b=u48rViKChbw79UjaJYdy+C+WWjFILr0W2ks1EcXxDX5hS3g3n6g4NWYVHk0bBRomn
         MS2Lgeik1UPtxTghZqyPnl9+6oQAGlZnYAbHVQSAuwsk4eTyv93+0J/4mvOoFPPe5K
         xfSxlWJybSrvyGaHvnKEm8qcA7QQeo06V6iMTW7g=
Date:   Mon, 28 Mar 2022 13:12:40 -0700
To:     mm-commits@vger.kernel.org, benni@stuerz.xyz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-replace-comments-with-c99-initializers.patch added to -mm tree
Message-Id: <20220328201240.EB17EC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: Replace comments with C99 initializers
has been added to the -mm tree.  Its filename is
     ia64-replace-comments-with-c99-initializers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-replace-comments-with-c99-initializers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-replace-comments-with-c99-initializers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Benjamin Stürz <benni@stuerz.xyz>
Subject: ia64: Replace comments with C99 initializers

This replaces comments with C99's designated initializers because the
kernel supports them now.

Link: https://lkml.kernel.org/r/20220326165909.506926-3-benni@stuerz.xyz
Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/kprobes.c |   64 +++++++++++++++++------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

--- a/arch/ia64/kernel/kprobes.c~ia64-replace-comments-with-c99-initializers
+++ a/arch/ia64/kernel/kprobes.c
@@ -29,38 +29,38 @@ struct kretprobe_blackpoint kretprobe_bl
 
 enum instruction_type {A, I, M, F, B, L, X, u};
 static enum instruction_type bundle_encoding[32][3] = {
-  { M, I, I },				/* 00 */
-  { M, I, I },				/* 01 */
-  { M, I, I },				/* 02 */
-  { M, I, I },				/* 03 */
-  { M, L, X },				/* 04 */
-  { M, L, X },				/* 05 */
-  { u, u, u },  			/* 06 */
-  { u, u, u },  			/* 07 */
-  { M, M, I },				/* 08 */
-  { M, M, I },				/* 09 */
-  { M, M, I },				/* 0A */
-  { M, M, I },				/* 0B */
-  { M, F, I },				/* 0C */
-  { M, F, I },				/* 0D */
-  { M, M, F },				/* 0E */
-  { M, M, F },				/* 0F */
-  { M, I, B },				/* 10 */
-  { M, I, B },				/* 11 */
-  { M, B, B },				/* 12 */
-  { M, B, B },				/* 13 */
-  { u, u, u },  			/* 14 */
-  { u, u, u },  			/* 15 */
-  { B, B, B },				/* 16 */
-  { B, B, B },				/* 17 */
-  { M, M, B },				/* 18 */
-  { M, M, B },				/* 19 */
-  { u, u, u },  			/* 1A */
-  { u, u, u },  			/* 1B */
-  { M, F, B },				/* 1C */
-  { M, F, B },				/* 1D */
-  { u, u, u },  			/* 1E */
-  { u, u, u },  			/* 1F */
+	[0x00] = { M, I, I },
+	[0x01] = { M, I, I },
+	[0x02] = { M, I, I },
+	[0x03] = { M, I, I },
+	[0x04] = { M, L, X },
+	[0x05] = { M, L, X },
+	[0x06] = { u, u, u },
+	[0x07] = { u, u, u },
+	[0x08] = { M, M, I },
+	[0x09] = { M, M, I },
+	[0x0A] = { M, M, I },
+	[0x0B] = { M, M, I },
+	[0x0C] = { M, F, I },
+	[0x0D] = { M, F, I },
+	[0x0E] = { M, M, F },
+	[0x0F] = { M, M, F },
+	[0x10] = { M, I, B },
+	[0x11] = { M, I, B },
+	[0x12] = { M, B, B },
+	[0x13] = { M, B, B },
+	[0x14] = { u, u, u },
+	[0x15] = { u, u, u },
+	[0x16] = { B, B, B },
+	[0x17] = { B, B, B },
+	[0x18] = { M, M, B },
+	[0x19] = { M, M, B },
+	[0x1A] = { u, u, u },
+	[0x1B] = { u, u, u },
+	[0x1C] = { M, F, B },
+	[0x1D] = { M, F, B },
+	[0x1E] = { u, u, u },
+	[0x1F] = { u, u, u },
 };
 
 /* Insert a long branch code */
_

Patches currently in -mm which might be from benni@stuerz.xyz are

ia64-replace-comments-with-c99-initializers.patch

