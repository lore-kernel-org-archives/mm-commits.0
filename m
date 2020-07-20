Return-Path: <SRS0=eezP=A7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67224C433E2
	for <mm-commits@archiver.kernel.org>; Mon, 20 Jul 2020 20:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F3DD20773
	for <mm-commits@archiver.kernel.org>; Mon, 20 Jul 2020 20:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595277750;
	bh=KDVX9jp8U7yqO7+QDNqBGNvPPONiyDX+9roNYdIzsAs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=D16q/xSclS9CcEJ+KkrwXaZanIH8VIqSxhz/3PIW/zNPSYkwMDT9VYCdAZSvqd9l8
	 EofjuOD4it2vTdQuPxR9Pc44vE9huVEGw7hWiKiCZJTMFRUDt80NfPVocPMi8PGRuB
	 XVRMubtDLQD4oOfG6MByEnACqCe7BW+fA3s8wFpQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgGTUma (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Jul 2020 16:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgGTUm3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Jul 2020 16:42:29 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 196A820773;
        Mon, 20 Jul 2020 20:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595277749;
        bh=KDVX9jp8U7yqO7+QDNqBGNvPPONiyDX+9roNYdIzsAs=;
        h=Date:From:To:Subject:From;
        b=R6Rd5wrCxGh72rMvX3Jp/GJAkCnPY2Ql1RNGDNS2NdTmp8i4buCwrlAzyt7KzlUHM
         fOkBLPdh3K838fu2PUnQervNRT88UlSDIZuNpLuAKU5AApYYVDswreSe8Ji4i+thY+
         lbhzqe6eL0DxUhe8RDkR8Bxedtt9XlYf+MOXOESw=
Date:   Mon, 20 Jul 2020 13:42:28 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20200720204228.uG13C4mjn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
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

 drivers/spi/spi-sun6i.c |    3 ---
 fs/io_uring.c           |   16 ----------------
 2 files changed, 19 deletions(-)

--- a/drivers/spi/spi-sun6i.c~linux-next-git-rejects
+++ a/drivers/spi/spi-sun6i.c
@@ -282,10 +282,7 @@ static int sun6i_spi_transfer_one(struct
 	div_cdr2 = DIV_ROUND_UP(div_cdr1, 2);
 	if (div_cdr2 <= (SUN6I_CLK_CTL_CDR2_MASK + 1)) {
 		reg = SUN6I_CLK_CTL_CDR2(div_cdr2 - 1) | SUN6I_CLK_CTL_DRS;
-<<<<<<< HEAD
-=======
 		tfr->effective_speed_hz = mclk_rate / (2 * div_cdr2);
->>>>>>> linux-next/akpm-base
 	} else {
 		div = min(SUN6I_CLK_CTL_CDR1_MASK, order_base_2(div_cdr1));
 		reg = SUN6I_CLK_CTL_CDR1(div);
--- a/fs/io_uring.c~linux-next-git-rejects
+++ a/fs/io_uring.c
@@ -4190,28 +4190,12 @@ static int io_recvmsg(struct io_kiocb *r
 	else if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
-<<<<<<< HEAD
-		ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.msg,
-						kmsg->uaddr, flags);
-		if (force_nonblock && ret == -EAGAIN) {
-			ret = io_setup_async_msg(req, kmsg);
-			if (ret != -EAGAIN)
-				kfree(kbuf);
-			return ret;
-		}
-		if (ret == -ERESTARTSYS)
-			ret = -EINTR;
-		if (kbuf)
-			kfree(kbuf);
-	}
-=======
 	ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
 					kmsg->uaddr, flags);
 	if (force_nonblock && ret == -EAGAIN)
 		return io_setup_async_msg(req, kmsg);
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
->>>>>>> linux-next/akpm-base
 
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch
linux-next-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

