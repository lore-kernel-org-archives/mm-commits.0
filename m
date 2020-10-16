Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012EEC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8947620897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602814891;
	bh=dfsg5qp/P08r02YW7GmXv7T8gKLmDxQfQcxnfrS+7CQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=RRnh/bPkUnXnJ87p9m6CFRy58BBOyvMG02NXGSagR3skjlJWnkiXKtqDArk22yufk
	 t8jZ+9RGGdBJY9HO7e+GRXkphXND2570F/BGu61nA9+zJvUpBVu1J3HanYLOmtxtaw
	 YuMhUXthK8vx43qUn3J9OunFbI9zCQROH/59GmCg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393701AbgJPCVb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393700AbgJPCVa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:21:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98A1D20878;
        Fri, 16 Oct 2020 02:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602814888;
        bh=dfsg5qp/P08r02YW7GmXv7T8gKLmDxQfQcxnfrS+7CQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wH8NteJy1hjy/aYju/pLrPKmvI8LRkMdhlVtsiknDcGostD8GKCdCnHyLtqVr59Cx
         XveP5l4YSUmlAdIixqsRWBnOmdr1wNgg7MiL78EzpsHjtuClhyFB/ZihK2kxRBPA63
         QgqHZkuferMHv3k063LcTPWRjAOpQZzNBsuF84Ro=
Date:   Thu, 15 Oct 2020 19:21:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ckennelly@google.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?fs-binfmt=5Felf-use-pt=5Fload-p=5Falign-values-for-suitable?=
 =?US-ASCII?Q?-start-address-fix.patch?= removed from -mm tree
Message-ID: <20201016022127.pGvFwjB6w%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch

This patch was dropped because it was folded into fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix

fix max() warning

Cc: Chris Kennelly <ckennelly@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/binfmt_elf.c~fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix
+++ a/fs/binfmt_elf.c
@@ -429,10 +429,12 @@ static unsigned long maximum_alignment(s
 
 	for (i = 0; i < nr; i++) {
 		if (cmds[i].p_type == PT_LOAD) {
+			unsigned long p_align = cmds[i].p_align;
+
 			/* skip non-power of two alignments */
-			if (!is_power_of_2(cmds[i].p_align))
+			if (!is_power_of_2(p_align))
 				continue;
-			alignment = max(alignment, cmds[i].p_align);
+			alignment = max(alignment, p_align);
 		}
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

