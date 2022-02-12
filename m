Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B9ACC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 12 Feb 2022 00:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbiBLAc2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 19:32:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346048AbiBLAc1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 19:32:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4CBD7F
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 16:32:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF41DB82DCE
        for <mm-commits@vger.kernel.org>; Sat, 12 Feb 2022 00:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DA0C340E9;
        Sat, 12 Feb 2022 00:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644625943;
        bh=Ii6CJdn+ZXTJ8g78+Oc9EAcGtBjX9EXN10RNwwQN4hQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=c+f2Fw6r9EEN1KyU8jiaDFKuYZWNjsRECEQy79AcTGrGFSMO0Rc14/zARKjK+L85N
         2xt4zRGpf/H7sqk8mTJ50Cc+lyv6bCu81NekJlPxzPro4xkkJ+n8d2mkSuOFCa/XN+
         BA6xyRXu0Ob1vhWbSpBLx7ZCXd2ag0pgBvO3N53U=
Date:   Fri, 11 Feb 2022 16:32:22 -0800
To:     viro@zeniv.linux.org.uk, rsalvaterra@gmail.com,
        keescook@chromium.org, hjl.tools@gmail.com, ebiederm@xmission.com,
        rppt@linux.ibm.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
Subject: [patch 1/5] fs/binfmt_elf: fix PT_LOAD p_align values for loaders
Message-Id: <20220212003223.62DA0C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: fs/binfmt_elf: fix PT_LOAD p_align values for loaders

Rui Salvaterra reported that Aisleroit solitaire crashes with "Wrong
__data_start/_end pair" assertion from libgc after update to v5.17-rc1.

Bisection pointed to commit 9630f0d60fec ("fs/binfmt_elf: use PT_LOAD
p_align values for static PIE") that fixed handling of static PIEs, but
made the condition that guards load_bias calculation to exclude loader
binaries.

Restoring the check for presence of interpreter fixes the problem.

Link: https://lkml.kernel.org/r/20220202121433.3697146-1-rppt@kernel.org
Fixes: 9630f0d60fec ("fs/binfmt_elf: use PT_LOAD p_align values for static PIE")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: Rui Salvaterra <rsalvaterra@gmail.com>
Tested-by: Rui Salvaterra <rsalvaterra@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/binfmt_elf.c~fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders
+++ a/fs/binfmt_elf.c
@@ -1117,7 +1117,7 @@ out_free_interp:
 			 * without MAP_FIXED nor MAP_FIXED_NOREPLACE).
 			 */
 			alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum);
-			if (alignment > ELF_MIN_ALIGN) {
+			if (interpreter || alignment > ELF_MIN_ALIGN) {
 				load_bias = ELF_ET_DYN_BASE;
 				if (current->flags & PF_RANDOMIZE)
 					load_bias += arch_mmap_rnd();
_
