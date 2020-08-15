Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7D7C433E1
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 00:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84E7C207DA
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 00:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597450499;
	bh=9iRDxv0OkxXS3FZHWh9KKgTTt93uT+qrVVZYHLQ2FR0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=y+6TPg6gs8oq2sU/q7RIcjO7bsE6AdJZ9BUQ3puzZc7Vai8o9cFNv4iqklef2hutK
	 f5m8uLx8MzPMZxhFW7YIp5/gylIIE2AeI6Z+OEMpDasZ9QHhIqNmlCFK4Otvw553m3
	 bYu8vjnYKTd02utOtiStKUMaaUXPTKt5sqh+6Jkw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgHOAO7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Aug 2020 20:14:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgHOAO7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Aug 2020 20:14:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D8FA20838;
        Sat, 15 Aug 2020 00:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597450498;
        bh=9iRDxv0OkxXS3FZHWh9KKgTTt93uT+qrVVZYHLQ2FR0=;
        h=Date:From:To:Subject:From;
        b=bWD4t+m3t9xDfnKKvo65KhesChBmqBmm+870aQvKPvn4V3nKnZcXW2oIMYLRSkkfW
         T7GFdRkX34HizeYhAkYW893jOHmSMDEZkhuvb3MtaV54kHRQh8l0ZrwSR4iO/PLD2W
         AmPxKgMejwXCwiU19zgczPmyqQ1xAF1Qrf0KZvK8=
Date:   Fri, 14 Aug 2020 17:14:58 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, krzk@kernel.org, lkp@intel.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?iomap-constify-ioreadx-iomem-argument-as-in-generic-implemen?=
 =?US-ASCII?Q?tation-fix-fix.patch?= removed from -mm tree
Message-ID: <20200815001458.Mrc9QaqGU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix-fix
has been removed from the -mm tree.  Its filename was
     iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix-fix.patch

This patch was dropped because it was folded into iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix-fix

fix drivers/mailbox/bcm-pdc-mailbox.c

Link: http://lkml.kernel.org/r/202007132209.Rxmv4QyS%25lkp@intel.com
Reported-by: kernel test robot <lkp@intel.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mailbox/bcm-pdc-mailbox.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mailbox/bcm-pdc-mailbox.c~iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix-fix
+++ a/drivers/mailbox/bcm-pdc-mailbox.c
@@ -679,7 +679,7 @@ pdc_receive(struct pdc_state *pdcs)
 
 	/* read last_rx_curr from register once */
 	pdcs->last_rx_curr =
-	    (ioread32(&pdcs->rxregs_64->status0) &
+	    (ioread32((const void __iomem *)&pdcs->rxregs_64->status0) &
 	     CRYPTO_D64_RS0_CD_MASK) / RING_ENTRY_SIZE;
 
 	do {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

