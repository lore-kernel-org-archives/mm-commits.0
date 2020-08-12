Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D81C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BCF1207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195968;
	bh=t5ydRvkdrf2IF1kdTtkjKKfXCthwf0WHmbcbkN/Vt70=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=eQ6SsrLgpVBf79uPfJue6lkHpL7cE/1x4d3rxh6eku2m6b4HpRmmqAXDZD6kc6OS1
	 ShZIHqwLOoq20KTsFWxZHVXGWOctRqfyGuFr/ohJde1fRJD3bCn0bAeRNuzAmHffqN
	 6aF66vHwOpTUQu0n+5EcOv+9P2hPS3Q5VQYn7fxc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgHLBcr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgHLBcr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:32:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01F23206B2;
        Wed, 12 Aug 2020 01:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195967;
        bh=t5ydRvkdrf2IF1kdTtkjKKfXCthwf0WHmbcbkN/Vt70=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=epjkciRHDu+A/D95MDOhgD3awH5DZiGIsrTzYLBMBVtztbHPeoF8U7tB5dOEHfy1n
         lEyB4muoG9lXaR/2gPKWH2BonR0UTUxo1eC79f1dz88H3Gpt9robEiwqgHAcmrmCz+
         IQm6l3XZc5tqXIncn1iMZ95qXi7H7gdXyWolcqII=
Date:   Tue, 11 Aug 2020 18:32:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dave.hansen@linux.intel.com,
        davem@davemloft.net, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, nivedita@alum.mit.edu,
        rppt@linux.ibm.com, torvalds@linux-foundation.org
Subject:  [patch 047/165] sparc: drop unused MAX_PHYSADDR_BITS
Message-ID: <20200812013246.q7fyQLpAF%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>
Subject: sparc: drop unused MAX_PHYSADDR_BITS

The macro is not used anywhere, so remove the definition.

Link: http://lkml.kernel.org/r/20200723231544.17274-4-nivedita@alum.mit.edu
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/sparsemem.h |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/sparc/include/asm/sparsemem.h~sparc-drop-unused-max_physaddr_bits
+++ a/arch/sparc/include/asm/sparsemem.h
@@ -7,7 +7,6 @@
 #include <asm/page.h>
 
 #define SECTION_SIZE_BITS       30
-#define MAX_PHYSADDR_BITS       MAX_PHYS_ADDRESS_BITS
 #define MAX_PHYSMEM_BITS        MAX_PHYS_ADDRESS_BITS
 
 #endif /* !(__KERNEL__) */
_
