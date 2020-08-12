Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C3DC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29D57206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195965;
	bh=FcBP87iNqBkk9jR3M7VhGJ17GTq+o/JiGzgINu/B2TM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=kPA9ku07axWWTKxs4o6vv5X43TK828tAVcl0XIpVd6ZjZkzrooMhhH7QzH+KP9b+6
	 vkblldpR5erQyki217B9GIbFVwbcZF0EN1ilFh8pzmAp+wRMP67ciKpRxeEjzFlHlx
	 WNPU/E3HAOnCQuohn4KdAwgQozcRrXLZpGVNDB1Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHLBco (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:32:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBco (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:32:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9F812076C;
        Wed, 12 Aug 2020 01:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195964;
        bh=FcBP87iNqBkk9jR3M7VhGJ17GTq+o/JiGzgINu/B2TM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MqRI4PJBwVu+q18XLUE01o/HF5Gj/KcmlPX38WniIQJxWp3osf6bF8QwhEozuanJe
         aWJxS0xsBriyuIr/5VGZKfQKtsZ0rbSm4u9S+2Lta+srXj137kyDgcla0VrH5Xruqa
         E6nwU6pPtWeVJDaWiENRbrOXBNkcOlinHendBXDc=
Date:   Tue, 11 Aug 2020 18:32:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dave.hansen@linux.intel.com,
        david@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        nivedita@alum.mit.edu, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 046/165] sh/mm: drop unused MAX_PHYSADDR_BITS
Message-ID: <20200812013243.TEj9JjvNu%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
