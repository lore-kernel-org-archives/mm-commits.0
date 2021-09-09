Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BDAC4332F
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BFA8611C4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347439AbhIIVFf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347758AbhIIVEb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:04:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A555611C9;
        Thu,  9 Sep 2021 21:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221401;
        bh=XaEKRhqweEheBKBsP4QZ2yGPDhC7ZOd0pTtSIVRnL1c=;
        h=Date:From:To:Subject:From;
        b=G2iwVcVGpEImy6TIwcAdGsetZEX/BurNeGFbuX6YsgzUd6hXS2SOqz3ESX6BK7Vt1
         p959Tpf+ggezT4EuQkw0ZQT2YhRpT2TG7Tgp2IBBgEN598acF3aBVKLwkvIZEqjst7
         9uzrL1kLAS63vQpu3qBIGKCEqgZq9d3MIWTZOkAQ=
Date:   Thu, 09 Sep 2021 14:03:21 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, dennis@kernel.org, gregkh@linuxfoundation.org,
        hch@lst.de, mm-commits@vger.kernel.org, tj@kernel.org
Subject:  [merged] percpu-remove-export-of-pcpu_base_addr.patch
 removed from -mm tree
Message-ID: <20210909210321.hVR11wBvl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: percpu: remove export of pcpu_base_addr
has been removed from the -mm tree.  Its filename was
     percpu-remove-export-of-pcpu_base_addr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: percpu: remove export of pcpu_base_addr

This is not needed by any modules, so remove the export.

Link: https://lkml.kernel.org/r/20210722185814.504541-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/percpu.c~percpu-remove-export-of-pcpu_base_addr
+++ a/mm/percpu.c
@@ -146,7 +146,6 @@ static unsigned int pcpu_high_unit_cpu _
 
 /* the address of the first chunk which starts with the kernel static area */
 void *pcpu_base_addr __ro_after_init;
-EXPORT_SYMBOL_GPL(pcpu_base_addr);
 
 static const int *pcpu_unit_map __ro_after_init;		/* cpu -> unit */
 const unsigned long *pcpu_unit_offsets __ro_after_init;	/* cpu -> unit offset */
_

Patches currently in -mm which might be from gregkh@linuxfoundation.org are


