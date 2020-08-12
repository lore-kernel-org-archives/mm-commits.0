Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58EDC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90F2E2080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266202;
	bh=XTWrB3p8e258oqJ4J7UqiPVdUXHtOemmSafkETrZrvQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=D1z9fSbleCab0icxVFSFfNjSV0CUbaZ09izQF+qmxPIi2Z+/MfZaAynlpU8kCr7ca
	 P9BQw52i433elSvwVuo0HkLzPJylFCKq1x9kXi0Y2GuHlTlEkyhQCr1yqGKKwUcHXz
	 fHh17sS0FzNQmjszaff38r3s4uQiSdaQkvW2qV+M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgHLVDW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgHLVDV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:21 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F6AA207F7;
        Wed, 12 Aug 2020 21:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266201;
        bh=XTWrB3p8e258oqJ4J7UqiPVdUXHtOemmSafkETrZrvQ=;
        h=Date:From:To:Subject:From;
        b=MaJhVcsUVkceUE4xvs3YurbtKnoYFFcYLTkN5y8tOd1lFGD6ZPj9XWgvhm6pcNKXk
         t5gVYFarchlr8pghRI4LDb4u8VchiSURwaCB4Z9wdukyqSPHr+M2Pq6Jezq1QoOCNG
         cRd8wfsa54hDzcwpwCrPeYf/kX7/NRHxnDXGcSws=
Date:   Wed, 12 Aug 2020 14:03:21 -0700
From:   akpm@linux-foundation.org
To:     deanbo422@gmail.com, geert@linux-m68k.org, green.hu@gmail.com,
        hch@lst.de, mm-commits@vger.kernel.org, nickhu@andestech.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        torvalds@linux-foundation.org
Subject:  [merged] riscv-include-asm-pgtableh-in-asm-uaccessh.patch
 removed from -mm tree
Message-ID: <20200812210321.NP-8Ya7g9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: include <asm/pgtable.h> in <asm/uaccess.h>
has been removed from the -mm tree.  Its filename was
     riscv-include-asm-pgtableh-in-asm-uaccessh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: riscv: include <asm/pgtable.h> in <asm/uaccess.h>

To ensure TASK_SIZE is defined for USER_DS.

Link: http://lkml.kernel.org/r/20200710135706.537715-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/uaccess.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/riscv/include/asm/uaccess.h~riscv-include-asm-pgtableh-in-asm-uaccessh
+++ a/arch/riscv/include/asm/uaccess.h
@@ -8,6 +8,8 @@
 #ifndef _ASM_RISCV_UACCESS_H
 #define _ASM_RISCV_UACCESS_H
 
+#include <asm/pgtable.h>		/* for TASK_SIZE */
+
 /*
  * User space memory access functions
  */
_

Patches currently in -mm which might be from hch@lst.de are


