Return-Path: <SRS0=RNAI=BY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D66C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 14 Aug 2020 23:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ABE020771
	for <mm-commits@archiver.kernel.org>; Fri, 14 Aug 2020 23:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597446454;
	bh=6MQfRjjy/MKdiuwv2djSPRtl0zfdwXUMk8T/Y0IDx5U=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gb2nkk7mhHvlriYxTGtUNaz2zQ9DIMEMqlbibuUbsXWR16CEXrvXhFRSCRqrMA5XT
	 9+PToBfG6ZvXp5Dik9sDru/UDL1mSwCJin9A5qKDR6XWXB6C2FrXCPMzx18A7WKeIi
	 MlO4Lol49OH4tHSPRgZKXCyP0BWJPeJ4XrKzXVVo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgHNXHe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Aug 2020 19:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgHNXHb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Aug 2020 19:07:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D940420771;
        Fri, 14 Aug 2020 23:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597446451;
        bh=6MQfRjjy/MKdiuwv2djSPRtl0zfdwXUMk8T/Y0IDx5U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=l/7HmDyLvcKd3nbqXMAvDYON3O9h62UJoDtBsbvjpgIHCcN7bj+sMo+crYyt+Rz8E
         sDgbeBQr7BEYxEX3lIDNM5MSRY51OxeChBv3WV6cCMEZWWpQ80TJpjDOA9w12MHsms
         FvDXfNFylm6feh2eWncrOeQxqKJIQN6XbiKbfxHY=
Date:   Fri, 14 Aug 2020 16:07:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, krzk@kernel.org, lkp@intel.com,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?iomap-constify-ioreadx-iomem-argument-as-in-generic-implemen?=
 =?US-ASCII?Q?tation-fix-fix.patch?= added to -mm tree
Message-ID: <20200814230730.dmUL1VTtT%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

