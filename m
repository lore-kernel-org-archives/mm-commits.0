Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0DAC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 21:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbiLUVsS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiLUVsP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 16:48:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC53248E1
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 13:48:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EC73B81B9C
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 21:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41F0C433D2;
        Wed, 21 Dec 2022 21:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671659291;
        bh=yBa8HOPaMHUZPVGmJS8zyO0BlosOTpIro5xrQ0/OPJg=;
        h=Date:To:From:Subject:From;
        b=QcI6cqJZ3GmkpRVlvYoE7GvP6GWF5svRvb2+iIXSeH8DRd5E27w4RNVY7ZEYZ0o5t
         HAdqH3Ahsjt+fWNbvJL+8F0r1VZJK9sHGpcK0/3UKzUuxpTUGoet104c1PHf4KtYLc
         jUpLpiVB6eGVhKPX3I3PX8iMESlD8SQYdPkjHHT8=
Date:   Wed, 21 Dec 2022 13:48:11 -0800
To:     mm-commits@vger.kernel.org, joel@joelfernandes.org,
        ribalda@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kvm-x86-fix-trivial-typo.patch added to mm-nonmm-unstable branch
Message-Id: <20221221214811.D41F0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: KVM: x86: fix trivial typo
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kvm-x86-fix-trivial-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kvm-x86-fix-trivial-typo.patch

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
From: Ricardo Ribalda <ribalda@chromium.org>
Subject: KVM: x86: fix trivial typo
Date: Tue, 20 Dec 2022 23:20:31 +0100

Permitted is spelled with two t.

Link: https://lkml.kernel.org/r/20221220-permited-v1-2-52ea9857fa61@chromium.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/emulate.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/emulate.c~kvm-x86-fix-trivial-typo
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
_

Patches currently in -mm which might be from ribalda@chromium.org are

scripts-spellingtxt-add-permitted.patch
kvm-x86-fix-trivial-typo.patch
of-overlay-fix-trivial-typo.patch

