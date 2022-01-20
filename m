Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8EFC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 01:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345656AbiATBw4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 20:52:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57902 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239740AbiATBw4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 20:52:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F28676154E
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 01:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFD5C004E1;
        Thu, 20 Jan 2022 01:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642643575;
        bh=ji5azLvJhzy/21sg0BDtKT3XYLTuGo+cJJPBPyrPank=;
        h=Date:From:To:Subject:From;
        b=E7JkVKnxpRxOQRdB1UzwngoPXiiWI50FLLYl7S6PelQMTrf/08+hHkYN/AaAuPczv
         3xNd4qiZS+rg3FhaLRhuHZO50Uo9dsqi0zXpsXCy03aEFfxxzcoUvYcd5cs44bz9Vf
         o/O9LUMFvAGz6buFWcBuI5dyWq8DPU1iuhPIKyzY=
Date:   Wed, 19 Jan 2022 17:52:54 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, isabbasso@riseup.net,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 hashh-remove-unused-define-directive-fix.patch removed from -mm tree
Message-ID: <20220120015254.UQ-eD-z0Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/infiniband/sw/rxe/rxe_qp.c: fix for "hash.h: remove unused define directive"
has been removed from the -mm tree.  Its filename was
     hashh-remove-unused-define-directive-fix.patch

This patch was dropped because it was folded into hashh-remove-unused-define-directive.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/infiniband/sw/rxe/rxe_qp.c: fix for "hash.h: remove unused define directive"

hash_32_generic() becomes hash_32()

Cc: Isabella Basso <isabbasso@riseup.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/sw/rxe/rxe_qp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/infiniband/sw/rxe/rxe_qp.c~hashh-remove-unused-define-directive-fix
+++ a/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -217,8 +217,7 @@ static int rxe_qp_init_req(struct rxe_de
 	 * the port number must be in the Dynamic Ports range
 	 * (0xc000 - 0xffff).
 	 */
-	qp->src_port = RXE_ROCE_V2_SPORT +
-		(hash_32_generic(qp_num(qp), 14) & 0x3fff);
+	qp->src_port = RXE_ROCE_V2_SPORT + (hash_32(qp_num(qp), 14) & 0x3fff);
 	qp->sq.max_wr		= init->cap.max_send_wr;
 
 	/* These caps are limited by rxe_qp_chk_cap() done by the caller */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hashh-remove-unused-define-directive.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-remove-cleancache-fix.patch
mm-simplify-try_to_unuse-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

