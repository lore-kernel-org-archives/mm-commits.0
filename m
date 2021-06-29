Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285EAC11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 135B261D10
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhF2Cm3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231768AbhF2Cm3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:42:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B713661D0C;
        Tue, 29 Jun 2021 02:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934403;
        bh=OhbioMAAdauUGjTAPryoLTTLuyBjIwurSWVhx+zWMd8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PTG3EIFDYCwe26Y+o0b2ZSyzIR1/u4ohUIB8aY1cYjyWfwwJtUU7BB+yJNfOGbVBe
         xkE+f50pArwFP2aL677ske4Yx7WbBXWOURFnCF0RxnV9PZfSvoEp6Y+yvTakN6OrIn
         xFjZcFdfkrcHvT+XaGmunQf9PQjs4L3kqGFQF92o=
Date:   Mon, 28 Jun 2021 19:40:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jrdr.linux@gmail.com,
        linux-mm@kvack.org, lkp@intel.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, torvalds@linux-foundation.org,
        ysato@users.sourceforge.jp
Subject:  [patch 129/192] h8300: remove unused variable
Message-ID: <20210629024002.dSR4vfhfg%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: h8300: remove unused variable

Kernel test robot throws below warning ->

>> arch/h8300/kernel/setup.c:72:26:
warning: Unused variable: region [unusedVariable]
    struct memblock_region *region;

Fixed it by removing unused variable.

Link: https://lkml.kernel.org/r/20210602185431.11416-1-jrdr.linux@gmail.com
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/setup.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/h8300/kernel/setup.c~h8300-remove-unused-variable
+++ a/arch/h8300/kernel/setup.c
@@ -69,8 +69,6 @@ void __init h8300_fdt_init(void *fdt, ch
 
 static void __init bootmem_init(void)
 {
-	struct memblock_region *region;
-
 	memory_end = memory_start = 0;
 
 	/* Find main memory where is the kernel */
_
