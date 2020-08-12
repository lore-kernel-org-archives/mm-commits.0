Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B29C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6A33207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266165;
	bh=Yd1XvXI3UTyp6RuHhMb2gYe8umeDgeHEceEIgPyqinw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tohgrDXEKjo3qj9BqL5IOOOg9XV4X06aK/RPk2MqaWwXzZt04+kJNP7KH8jMXPExP
	 XMwycmhiwBPahAh6taQXHQN1jKCRXsh+rYLqqGeevtLzaI0VJ7427HRy90D1xBzQLr
	 WUv0p2yvqOuutcbNvdRypzshpZBTqPs9FfWvxqlQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgHLVCo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgHLVCo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:44 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8067120774;
        Wed, 12 Aug 2020 21:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266163;
        bh=Yd1XvXI3UTyp6RuHhMb2gYe8umeDgeHEceEIgPyqinw=;
        h=Date:From:To:Subject:From;
        b=VZ7QaC3CSLv5pF7eZULWYyFDoGIIY07gwUibFc7dCSLBE9vCt3qXhHB0ioa8Yoimk
         QmbjuQPoxDlKwb4U5akGeETXyDGr642WfJZKgELcOCtfpwq2eJ0mxs2jDNDvV2CfxB
         Puqw5/XqpcpGJg+MnLA6yH8TW61HjuWUtuvPhXcc=
Date:   Wed, 12 Aug 2020 14:02:43 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dave.hansen@linux.intel.com,
        david@redhat.com, mm-commits@vger.kernel.org,
        nivedita@alum.mit.edu, rppt@linux.ibm.com
Subject:  [merged] sh-mm-drop-unused-max_physaddr_bits.patch
 removed from -mm tree
Message-ID: <20200812210243.sxb8NMN-B%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh/mm: drop unused MAX_PHYSADDR_BITS
has been removed from the -mm tree.  Its filename was
     sh-mm-drop-unused-max_physaddr_bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arvind Sankar <nivedita@alum.mit.edu>
Subject: sh/mm: drop unused MAX_PHYSADDR_BITS

The macro is not used anywhere, so remove the definition.

Link: http://lkml.kernel.org/r/20200723231544.17274-3-nivedita@alum.mit.edu
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/sparsemem.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/sh/include/asm/sparsemem.h~sh-mm-drop-unused-max_physaddr_bits
+++ a/arch/sh/include/asm/sparsemem.h
@@ -5,11 +5,9 @@
 #ifdef __KERNEL__
 /*
  * SECTION_SIZE_BITS		2^N: how big each section will be
- * MAX_PHYSADDR_BITS		2^N: how much physical address space we have
- * MAX_PHYSMEM_BITS		2^N: how much memory we can have in that space
+ * MAX_PHYSMEM_BITS		2^N: how much physical address space we have
  */
 #define SECTION_SIZE_BITS	26
-#define MAX_PHYSADDR_BITS	32
 #define MAX_PHYSMEM_BITS	32
 
 #endif
_

Patches currently in -mm which might be from nivedita@alum.mit.edu are


