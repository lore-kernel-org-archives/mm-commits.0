Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3924C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C933B61247
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbhKKCtH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:49:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhKKCtH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:49:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 964A161108;
        Thu, 11 Nov 2021 02:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598778;
        bh=yhPM4LgVhjcZle3yE1cssqclCkQY+lFr1zRBqPzPPTI=;
        h=Date:From:To:Subject:From;
        b=yx85rxLAd6VaKaa/iTMns7F5OLShZ61kLCDWbbtXzweYpRuVbRyLlxDT87zbWXa3g
         6Un9/8DNnCTbly6jQBqpkM/PrA65BPkkXZ9A4SptkGKJ2q1nPDxAkTaJy0psqdy+WF
         qzXMi3qzcUdLB/EtQBFaYZZQk6C+o4xN/Se9BB3Q=
Date:   Wed, 10 Nov 2021 18:46:18 -0800
From:   akpm@linux-foundation.org
To:     christophe.leroy@csgroup.eu, jgross@suse.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        Shahab.Vahedi@synopsys.com
Subject:  [merged]
 xen-x86-free_p2m_page-use-memblock_free_ptr-to-free-a-virtual-pointer.patch
 removed from -mm tree
Message-ID: <20211111024618.d-eQLo5mi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xen/x86: free_p2m_page: use memblock_free_ptr() to free a virtual pointer
has been removed from the -mm tree.  Its filename was
     xen-x86-free_p2m_page-use-memblock_free_ptr-to-free-a-virtual-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rppt@linux.ibm.com are


