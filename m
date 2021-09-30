Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A893C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 20:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1D7F61A52
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 20:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347836AbhI3UcF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 16:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347637AbhI3UcB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 16:32:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4C9661A52;
        Thu, 30 Sep 2021 20:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633033819;
        bh=1Y30dT91J9Svv+Vunz4fSojkjxxA9S+aWXRl1n/ngkQ=;
        h=Date:From:To:Subject:From;
        b=bDC6rXN5+0+6F8ZVjznEqpOpugDTYhX9wja7ueLRbXdEVqQapL4V3lVjVnKKA1pFO
         lKChuLEcEXhqfUDzO5LBycS7XQyly2O9q4z59MCYG75dvFsl0L2pidDXnp5MC0SIQA
         97gosIQ6R7sxjzKFnbMKdhYVoj5/bbrMcryJX4Yw=
Date:   Thu, 30 Sep 2021 13:30:18 -0700
From:   akpm@linux-foundation.org
To:     christophe.leroy@csgroup.eu, jgross@suse.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        Shahab.Vahedi@synopsys.com
Subject:  +
 xen-x86-free_p2m_page-use-memblock_free_ptr-to-free-a-virtual-pointer.patch
 added to -mm tree
Message-ID: <20210930203018.YQx_7KTnr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xen/x86: free_p2m_page: use memblock_free_ptr() to free a virtual pointer
has been added to the -mm tree.  Its filename is
     xen-x86-free_p2m_page-use-memblock_free_ptr-to-free-a-virtual-pointer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/xen-x86-free_p2m_page-use-memblock_free_ptr-to-free-a-virtual-pointer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/xen-x86-free_p2m_page-use-memblock_free_ptr-to-free-a-virtual-pointer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch_numa-simplify-numa_distance-allocation.patch
xen-x86-free_p2m_page-use-memblock_free_ptr-to-free-a-virtual-pointer.patch
memblock-drop-memblock_free_early_nid-and-memblock_free_early.patch
memblock-stop-aliasing-__memblock_free_late-with-memblock_free_late.patch
memblock-rename-memblock_free-to-memblock_phys_free.patch
memblock-use-memblock_free-for-freeing-virtual-pointers.patch

