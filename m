Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE69C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbjBCGvN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbjBCGvC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AA0C154
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:50:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B5D5B82986
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC69C4339C;
        Fri,  3 Feb 2023 06:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407054;
        bh=4y5LDNkIDKlCl3RlgySv4kv/zkskKJOebYFlA/ny4eQ=;
        h=Date:To:From:Subject:From;
        b=ZUKrFHngQglrxlwy4txrEUd1UIJwUv2RSVRYSpPKrhKB+T8TgphIbLVBhjgKNO0lA
         b+F0OBO+pViwwTbJjiqLfPb2BUhzcwOf6JdurwlzU8fz1fnu8bqEEYGoj2+2zPu1hT
         /us9+IPa3taPMDVG2FUSeM/+ESfGGXx7oGzaepXU=
Date:   Thu, 02 Feb 2023 22:50:53 -0800
To:     mm-commits@vger.kernel.org, joel@joelfernandes.org,
        ribalda@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-spellingtxt-add-permitted.patch removed from -mm tree
Message-Id: <20230203065054.4DC69C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/spelling.txt: add `permitted'
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-permitted.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ricardo Ribalda <ribalda@chromium.org>
Subject: scripts/spelling.txt: add `permitted'
Date: Tue, 20 Dec 2022 23:20:30 +0100

Patch series "spelling: Fix some trivial typos".

Seems like permitted has two t's :), Lets add that to spellings to help
others.


This patch (of 3):

Add another common typo. Noticed when I sent a patch with the typo and
in kvm and of.

[ribalda@chromium.org: fix trivial typo]
  Link: https://lkml.kernel.org/r/20221220-permited-v1-2-52ea9857fa61@chromium.org
Link: https://lkml.kernel.org/r/20221220-permited-v1-1-52ea9857fa61@chromium.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/x86/kvm/emulate.c~scripts-spellingtxt-add-permitted
+++ a/arch/x86/kvm/emulate.c
@@ -2615,8 +2615,8 @@ static bool emulator_io_port_access_allo
 	return true;
 }
 
-static bool emulator_io_permited(struct x86_emulate_ctxt *ctxt,
-				 u16 port, u16 len)
+static bool emulator_io_permitted(struct x86_emulate_ctxt *ctxt,
+				  u16 port, u16 len)
 {
 	if (ctxt->perm_ok)
 		return true;
@@ -3961,7 +3961,7 @@ static int check_rdpmc(struct x86_emulat
 static int check_perm_in(struct x86_emulate_ctxt *ctxt)
 {
 	ctxt->dst.bytes = min(ctxt->dst.bytes, 4u);
-	if (!emulator_io_permited(ctxt, ctxt->src.val, ctxt->dst.bytes))
+	if (!emulator_io_permitted(ctxt, ctxt->src.val, ctxt->dst.bytes))
 		return emulate_gp(ctxt, 0);
 
 	return X86EMUL_CONTINUE;
@@ -3970,7 +3970,7 @@ static int check_perm_in(struct x86_emul
 static int check_perm_out(struct x86_emulate_ctxt *ctxt)
 {
 	ctxt->src.bytes = min(ctxt->src.bytes, 4u);
-	if (!emulator_io_permited(ctxt, ctxt->dst.val, ctxt->src.bytes))
+	if (!emulator_io_permitted(ctxt, ctxt->dst.val, ctxt->src.bytes))
 		return emulate_gp(ctxt, 0);
 
 	return X86EMUL_CONTINUE;
--- a/scripts/spelling.txt~scripts-spellingtxt-add-permitted
+++ a/scripts/spelling.txt
@@ -1121,6 +1121,7 @@ perfomring||performing
 periperal||peripheral
 peripherial||peripheral
 permissons||permissions
+permited||permitted
 peroid||period
 persistance||persistence
 persistant||persistent
_

Patches currently in -mm which might be from ribalda@chromium.org are


