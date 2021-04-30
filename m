Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42887C43461
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 224B0613AD
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhD3GCX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230132AbhD3GCV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:02:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC8D5613AD;
        Fri, 30 Apr 2021 06:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762494;
        bh=LMd7nWS9O77zgT8Ki3o5cZpcSqoQXOMoO0um2Qp7PXg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RZJ9/5U+8lbDYpyziyGZm3aDckUZ3GmdXgxxEP+MU0UgDm5Uik+eINUN9kGskTQmt
         yfN0qFpYwbm1DZC+LZ1HcAZpH5IPjz39HTikVkCYUlSQqfIoBIh6+Pie/d3cpySW+k
         eU7tVYMhV0zMS9gQGM50NUuinby21gOeaf5K7vFE=
Date:   Thu, 29 Apr 2021 23:01:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, geert@linux-m68k.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 163/178] mm/Kconfig: remove default
 DISCONTIGMEM_MANUAL
Message-ID: <20210430060133.tBCrv9Ere%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mm/Kconfig: remove default DISCONTIGMEM_MANUAL

Commit 214496cb18700fd7 ("ia64: make SPARSEMEM default and disable
DISCONTIGMEM") removed the last enabler of ARCH_DISCONTIGMEM_DEFAULT,
hence the memory model can no longer default to DISCONTIGMEM_MANUAL.

Link: https://lkml.kernel.org/r/20210312141208.3465520-1-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/Kconfig~mm-remove-default-discontigmem_manual
+++ a/mm/Kconfig
@@ -9,7 +9,6 @@ config SELECT_MEMORY_MODEL
 choice
 	prompt "Memory model"
 	depends on SELECT_MEMORY_MODEL
-	default DISCONTIGMEM_MANUAL if ARCH_DISCONTIGMEM_DEFAULT
 	default SPARSEMEM_MANUAL if ARCH_SPARSEMEM_DEFAULT
 	default FLATMEM_MANUAL
 	help
_
