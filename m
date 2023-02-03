Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBB8C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjBCGqP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjBCGpr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:45:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347B5928D8
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:43:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C71A461DB3
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280FBC433D2;
        Fri,  3 Feb 2023 06:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406607;
        bh=QLqnMQIsw7UMhjq9Ohy7B/KKwDk3pzNG28YWq1f2HmY=;
        h=Date:To:From:Subject:From;
        b=qudAkcFKl3/X/ZuOJmv6coyGB8xCtWnsrEWze/4OKWc7tBJTIuSTOalHyVdRVfrEi
         gabsSFkZQqBJDFf56Nc3NHiOk1hI9j3YdIWZx8Tci8E83ittvVLvH6U9gTYwEOPF+4
         lPIDFVUGd2Cg+U4gUyLRZfruyMPpEeVqdK6H5P2U=
Date:   Thu, 02 Feb 2023 22:43:26 -0800
To:     mm-commits@vger.kernel.org, joel@joelfernandes.org,
        ribalda@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kvm-x86-fix-trivial-typo.patch removed from -mm tree
Message-Id: <20230203064327.280FBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: KVM: x86: fix trivial typo
has been removed from the -mm tree.  Its filename was
     kvm-x86-fix-trivial-typo.patch

This patch was dropped because it was folded into scripts-spellingtxt-add-permitted.patch

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
documentation-sysctl-correct-kexec_load_disabled.patch
kexec-factor-out-kexec_load_permitted.patch
kexec-introduce-sysctl-parameters-kexec_load_limit_.patch

