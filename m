Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B7B9C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3B2B20774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266167;
	bh=Q3kx6fk4nq/hzvl+0bvwowpykaBhhpD+tkPXeD7y+gk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xU5zYNjfd0xCKTJeo66N0CIjuPio9picaTKcoBpYpTLU0t3j1ydnUgHbi4LUyXU4R
	 R6QCoz5Oh7C9WQjL2q6FndefkZZDUl3MRaeIhge5ezI9sPGJTkhvVj5EAwyG/uk9ye
	 KjTCs12F6Wx1opIeH+MHq9P5WowWB1RUew9n+R8A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgHLVCq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgHLVCq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:46 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FE5F207F7;
        Wed, 12 Aug 2020 21:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266165;
        bh=Q3kx6fk4nq/hzvl+0bvwowpykaBhhpD+tkPXeD7y+gk=;
        h=Date:From:To:Subject:From;
        b=bh+U4chv18DMVZPmJaFG6HSc/vBBCopTA+haR232a/MzOXP/DXOk6h53CInYTnMsq
         sVtnDzdd5lhCJwH2APqSPpJAP1SvDTLlaWWNefAgPxbjfdyc70cNOCb/6sbHEw7iii
         PT/pwTxXR6Y81mAUjB2FvxRcVyyUkkISIr56zxBM=
Date:   Wed, 12 Aug 2020 14:02:45 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dave.hansen@linux.intel.com,
        davem@davemloft.net, david@redhat.com, mm-commits@vger.kernel.org,
        nivedita@alum.mit.edu, rppt@linux.ibm.com
Subject:  [merged] sparc-drop-unused-max_physaddr_bits.patch
 removed from -mm tree
Message-ID: <20200812210245.oLVhqT-1Q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: drop unused MAX_PHYSADDR_BITS
has been removed from the -mm tree.  Its filename was
     sparc-drop-unused-max_physaddr_bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from nivedita@alum.mit.edu are


