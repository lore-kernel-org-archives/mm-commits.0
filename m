Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8EB5C761A6
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 20:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbjDDUUA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 16:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236069AbjDDUTx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 16:19:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558C740FD
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 13:19:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E586762F51
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 20:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A530C4339B;
        Tue,  4 Apr 2023 20:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680639590;
        bh=PhMoQ76fAIfeeV+fkkhxgjFGCHZ9otZhx/MbgKw358c=;
        h=Date:To:From:Subject:From;
        b=AEsAaj68Y3yysL2g/LSXna5lply5etncyvPbxu/aJqc4DlzdIv0Yk5JbnqMoX9jQo
         KTH/g0XwLPN3W0gw8DDxIIsWmKfbeQEIeayOksBx/fvuGEH/NjyK5Rqd0WVe7P2fFZ
         8DqOR1xrfMv8IQjilxD8/iExZlH0VIiNRej+9VVo=
Date:   Tue, 04 Apr 2023 13:19:49 -0700
To:     mm-commits@vger.kernel.org, geert@linux-m68k.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + m68k-mm-use-correct-bit-number-in-_page_swp_exclusive-comment.patch added to mm-unstable branch
Message-Id: <20230404201950.4A530C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k/mm: use correct bit number in _PAGE_SWP_EXCLUSIVE comment
has been added to the -mm mm-unstable branch.  Its filename is
     m68k-mm-use-correct-bit-number-in-_page_swp_exclusive-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/m68k-mm-use-correct-bit-number-in-_page_swp_exclusive-comment.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: m68k/mm: use correct bit number in _PAGE_SWP_EXCLUSIVE comment
Date: Tue, 4 Apr 2023 10:56:36 +0200

As noticed by Geert, commit b5c88f21531c ("microblaze/mm: support
__HAVE_ARCH_PTE_SWP_EXCLUSIVE") modified m68k code by accident.  While
replacing 0x080 by CF_PAGE_NOCACHE is correct, although it should have
been part of commit ed4154067a08 ("m68k/mm: support
__HAVE_ARCH_PTE_SWP_EXCLUSIVE"), replacing "bit 7" by "bit 24" in the
comment was wrong.

Let's revert to the previous, correct, comment.

Link: https://lkml.kernel.org/r/20230404085636.121409-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/mcf_pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/m68k/include/asm/mcf_pgtable.h~m68k-mm-use-correct-bit-number-in-_page_swp_exclusive-comment
+++ a/arch/m68k/include/asm/mcf_pgtable.h
@@ -46,7 +46,7 @@
 #define _CACHEMASK040		(~0x060)
 #define _PAGE_GLOBAL040		0x400   /* 68040 global bit, used for kva descs */
 
-/* We borrow bit 24 to store the exclusive marker in swap PTEs. */
+/* We borrow bit 7 to store the exclusive marker in swap PTEs. */
 #define _PAGE_SWP_EXCLUSIVE	CF_PAGE_NOCACHE
 
 /*
_

Patches currently in -mm which might be from david@redhat.com are

m68k-mm-use-correct-bit-number-in-_page_swp_exclusive-comment.patch

