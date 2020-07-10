Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C94DC433E2
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0727E2077D
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594417665;
	bh=uoBHAZsUVxiUNZqnwCcWkHG81Md3JvGh7Ef7lgtjyb4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=v2NseJpCoZLOZUiRYlkwdYQr8mrpSAAK1w/5acVZI4dzXxw1EGVsEqzG8YstBaaMG
	 8RoqUoRSkzWyee2Zkfimhuhrvth1XZdfAP+ucpp0HAa+pSjXuXm0CP4WMkkgLjLbhW
	 6t1ReDQKRHqzvCA9JymaOP05acPsnpmUtI4siARw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgGJVro (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 17:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgGJVro (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 17:47:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD3FA20772;
        Fri, 10 Jul 2020 21:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594417664;
        bh=uoBHAZsUVxiUNZqnwCcWkHG81Md3JvGh7Ef7lgtjyb4=;
        h=Date:From:To:Subject:From;
        b=0lk0Aqh4DiIrk/hBLvoafH3usQAbDhcEDF9Ium9xQ6Ib5IgwqNCHxFjcc+sCivpjx
         gRFqDob1H6QBLLDoGcz31hTqgqBOB+knTo3jNn34S3Zm4b7Hw7dQAbm/BtPE39vAQi
         ZexTvWfB5D6A7viDeT+mnbnFGvEIzUQNar7wETAs=
Date:   Fri, 10 Jul 2020 14:47:43 -0700
From:   akpm@linux-foundation.org
To:     deanbo422@gmail.com, green.hu@gmail.com, hch@lst.de,
        mm-commits@vger.kernel.org, nickhu@andestech.com,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        torvalds@linux-foundation.org
Subject:  + riscv-include-asm-pgtableh-in-asm-uaccessh.patch added
 to -mm tree
Message-ID: <20200710214743.8R3heee-c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: include <asm/pgtable.h> in <asm/uaccess.h>
has been added to the -mm tree.  Its filename is
     riscv-include-asm-pgtableh-in-asm-uaccessh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/riscv-include-asm-pgtableh-in-asm-uaccessh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/riscv-include-asm-pgtableh-in-asm-uaccessh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: riscv: include <asm/pgtable.h> in <asm/uaccess.h>

To ensure TASK_SIZE is defined for USER_DS.

Link: http://lkml.kernel.org/r/20200710135706.537715-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
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

syscalls-use-uaccess_kernel-in-addr_limit_user_check.patch
nds32-use-uaccess_kernel-in-show_regs.patch
riscv-include-asm-pgtableh-in-asm-uaccessh.patch
uaccess-remove-segment_eq.patch
uaccess-add-force_uaccess_beginend-helpers.patch
exec-use-force_uaccess_begin-during-exec-and-exit.patch

