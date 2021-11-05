Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDB0C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC65D61356
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbhKEUpv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233648AbhKEUpv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:45:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 602586128E;
        Fri,  5 Nov 2021 20:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144991;
        bh=eM5N+pm1njP5X63INnwBElbqxszRLEi2R6ykway0H8I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zwvHcDi7wRZBEX9/2stJt81QJ0NQgqdrOtrX9V6WjW80F37V8x41WgZzp96NdweAH
         eL8vSUOinhIo4kqZRVPWfDh8lDfJq9tTsgCCjHhkOwhO3/pz8IO4CdoL9UAsze8UWt
         5A7yF1FypTwnjWeFl90qMXNq/+nt9ydNGpqy/+50=
Date:   Fri, 05 Nov 2021 13:43:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christophe.leroy@csgroup.eu,
        jgross@suse.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, Shahab.Vahedi@synopsys.com,
        torvalds@linux-foundation.org
Subject:  [patch 163/262] xen/x86: free_p2m_page: use
 memblock_free_ptr() to free a virtual pointer
Message-ID: <20211105204310.GVV96aqm6%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: xen/x86: free_p2m_page: use memblock_free_ptr() to free a virtual pointer

free_p2m_page() wrongly passes a virtual pointer to memblock_free() that
treats it as a physical address.

Call memblock_free_ptr() instead that gets a virtual address to free the
memory.

Link: https://lkml.kernel.org/r/20210930185031.18648-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Shahab Vahedi <Shahab.Vahedi@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/p2m.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/xen/p2m.c~xen-x86-free_p2m_page-use-memblock_free_ptr-to-free-a-virtual-pointer
+++ a/arch/x86/xen/p2m.c
@@ -197,7 +197,7 @@ static void * __ref alloc_p2m_page(void)
 static void __ref free_p2m_page(void *p)
 {
 	if (unlikely(!slab_is_available())) {
-		memblock_free((unsigned long)p, PAGE_SIZE);
+		memblock_free_ptr(p, PAGE_SIZE);
 		return;
 	}
 
_
