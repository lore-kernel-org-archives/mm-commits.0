Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F15C4707A
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 19:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbiBGTCO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 14:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235940AbiBGS6z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 13:58:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8BCC0401DC
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 10:58:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA8ADB81157
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 18:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91899C004E1;
        Mon,  7 Feb 2022 18:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644260332;
        bh=AX87vbSp500EOPoA9La321n6cwLbu494WwbD28yjS3E=;
        h=Date:From:To:Subject:From;
        b=A3uSRHApjXero8+142q6fn2gjj+ES2tbg+ErZPp30+Tnjfiz/rgY4EgvKfsR3z/pT
         eRTCrA+c02SeRQjYRBDuAmcQKWKbKo5VQMDaKiY7OHpUCh+dWRHL6mWpUwNinhJzpc
         3nWQLbiuU38uUBZfDlsH8Uo4K9N535MFWVCkXoKs=
Date:   Mon, 07 Feb 2022 10:58:51 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20220207185851.NWgg9Gq3V%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/ax25.h  |    9 ---------
 net/ax25/ax25_dev.c |    4 ----
 2 files changed, 13 deletions(-)

--- a/include/net/ax25.h~linux-next-git-rejects
+++ a/include/net/ax25.h
@@ -282,19 +282,10 @@ static __inline__ void ax25_cb_put(ax25_
 	}
 }
 
-<<<<<<< HEAD
-static inline void ax25_dev_hold(ax25_dev *ax25_dev)
-{
-	refcount_inc(&ax25_dev->refcount);
-}
-
-static inline void ax25_dev_put(ax25_dev *ax25_dev)
-=======
 #define ax25_dev_hold(__ax25_dev) \
 	refcount_inc(&((__ax25_dev)->refcount))
 
 static __inline__ void ax25_dev_put(ax25_dev *ax25_dev)
->>>>>>> linux-next/akpm-base
 {
 	if (refcount_dec_and_test(&ax25_dev->refcount)) {
 		kfree(ax25_dev);
--- a/net/ax25/ax25_dev.c~linux-next-git-rejects
+++ a/net/ax25/ax25_dev.c
@@ -165,10 +165,6 @@ int ax25_fwd_ioctl(unsigned int cmd, str
 		}
 		ax25_dev->forward = fwd_dev->dev;
 		ax25_dev_put(fwd_dev);
-<<<<<<< HEAD
-		ax25_dev_put(ax25_dev);
-=======
->>>>>>> linux-next/akpm-base
 		break;
 
 	case SIOCAX25DELFWD:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes.patch
mm-move-page-writeback-sysctls-to-is-own-file-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

