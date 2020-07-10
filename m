Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87457C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D7232075D
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594417659;
	bh=lPgOMfgtDPhBYfon0Xdj7ue0dTcW0JZ9D1PznCzpSCs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Dg8GSBlNIcRv+ald8U76MjTZnEV61OQw8xjixW6H62aWioRirON8o1Pi2lAcomEf+
	 IvgclgLnH640YVOtfxtc7ozLb049b6su0KF/vr49CeiFw4nZ31CW+V7gX6bGiFZ3or
	 kIxxzAIA+R4XvBb3QW4Oo5k3GO8hxvC4hDmwmN1w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgGJVrj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 17:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgGJVri (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 17:47:38 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6ABB206E2;
        Fri, 10 Jul 2020 21:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594417658;
        bh=lPgOMfgtDPhBYfon0Xdj7ue0dTcW0JZ9D1PznCzpSCs=;
        h=Date:From:To:Subject:From;
        b=YyZ/1XSea1pZNUFltyg2EE4dhc6vzBr7nha1T9/EDLhlPU+W7AU+flDg5FEViK4/J
         WKnStQe+0ZCDm+0oqoijFWo7pV6fxMaKH5ck1Z/SXWkPRHbDzyvIbU3KDR+7I4sX9i
         rRjQmBOhcWEb9DrQGNAWotix7JIIbSUuTcsrSqts=
Date:   Fri, 10 Jul 2020 14:47:37 -0700
From:   akpm@linux-foundation.org
To:     deanbo422@gmail.com, green.hu@gmail.com, hch@lst.de,
        mm-commits@vger.kernel.org, nickhu@andestech.com,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        torvalds@linux-foundation.org
Subject:  +
 syscalls-use-uaccess_kernel-in-addr_limit_user_check.patch added to -mm
 tree
Message-ID: <20200710214737.1w6H_hwJx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: syscalls: use uaccess_kernel in addr_limit_user_check
has been added to the -mm tree.  Its filename is
     syscalls-use-uaccess_kernel-in-addr_limit_user_check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/syscalls-use-uaccess_kernel-in-addr_limit_user_check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/syscalls-use-uaccess_kernel-in-addr_limit_user_check.patch

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
Subject: syscalls: use uaccess_kernel in addr_limit_user_check

Patch series "clean up address limit helpers".

In preparation for eventually phasing out direct use of set_fs(), this
series removes the segment_eq() arch helper that is only used to implement
or duplicate the uaccess_kernel() API, and then adds descriptive helpers
to force the kernel address limit.


This patch (of 6):

Use the uaccess_kernel helper instead of duplicating it.

Link: http://lkml.kernel.org/r/20200710135706.537715-1-hch@lst.de
Link: http://lkml.kernel.org/r/20200710135706.537715-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/syscalls.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/syscalls.h~syscalls-use-uaccess_kernel-in-addr_limit_user_check
+++ a/include/linux/syscalls.h
@@ -263,7 +263,7 @@ static inline void addr_limit_user_check
 		return;
 #endif
 
-	if (CHECK_DATA_CORRUPTION(!segment_eq(get_fs(), USER_DS),
+	if (CHECK_DATA_CORRUPTION(uaccess_kernel(),
 				  "Invalid address limit on user-mode return"))
 		force_sig(SIGKILL);
 
_

Patches currently in -mm which might be from hch@lst.de are

syscalls-use-uaccess_kernel-in-addr_limit_user_check.patch
nds32-use-uaccess_kernel-in-show_regs.patch
riscv-include-asm-pgtableh-in-asm-uaccessh.patch
uaccess-remove-segment_eq.patch
uaccess-add-force_uaccess_beginend-helpers.patch
exec-use-force_uaccess_begin-during-exec-and-exit.patch

