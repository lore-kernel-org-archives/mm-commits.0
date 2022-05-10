Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE65C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236272AbiEJEXl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236264AbiEJEVw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:21:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48231AF8C5
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 649726176D
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3D1C385C5;
        Tue, 10 May 2022 04:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156242;
        bh=EMYeixzOZScHIYkwj8SD1VlfWto6EG/mrorllOFHyag=;
        h=Date:To:From:Subject:From;
        b=d1Kb577tv5vi8MfLzh6khL0UzHYA8qRn8RHaKzWUhKLH5UYdi0gF9i3tEixx5njx6
         FGsqRHsZ0/U9v7o9DDt2Zo4MVqQ/MUlK80TLGVooCib8nLlYRBCq22ahn0ah048Slo
         t4yzd0dIskpob1tz6R4XpLMI0OhthEQILUYrfwso=
Date:   Mon, 09 May 2022 21:17:22 -0700
To:     mm-commits@vger.kernel.org, benni@stuerz.xyz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ia64-replace-comments-with-c99-initializers.patch removed from -mm tree
Message-Id: <20220510041722.BB3D1C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64: replace comments with C99 initializers
has been removed from the -mm tree.  Its filename was
     ia64-replace-comments-with-c99-initializers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Benjamin Stürz <benni@stuerz.xyz>
Subject: ia64: replace comments with C99 initializers

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


