Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 324B7C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377932AbiATVaf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:30:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60184 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377931AbiATVaf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:30:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05BA6B81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9395BC340E0;
        Thu, 20 Jan 2022 21:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714232;
        bh=fxs8+/EDZsdiz7FRb9AgoTkWkc9VNAvZrkxvrKdyVzc=;
        h=Date:From:To:Subject:From;
        b=UuiXyYTMq67oK8DOZ+KGaeQ3aMfjSmCmxHOSclFwMKshIoSU0b96C321YFWfwf54L
         5rM77BoSuvCJyH+i0oynyHzO0Mv6hw5SE6ZdDzgoKyRHZfdyG9VN5yofcqRuIyYGn8
         9mYAK8jsyHf+0JqAtiB4/V5wyEMKMpYCrqOR2GHg=
Date:   Thu, 20 Jan 2022 13:30:32 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, isabbasso@riseup.net,
        mm-commits@vger.kernel.org
Subject:  [merged] hashh-remove-unused-define-directive-fix.patch
 removed from -mm tree
Message-ID: <20220120213032.hlzVyWU9T%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/infiniband/sw/rxe/rxe_qp.c: fix for "hash.h: remove unused define directive"
has been removed from the -mm tree.  Its filename was
     hashh-remove-unused-define-directive-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
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

