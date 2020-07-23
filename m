Return-Path: <SRS0=ssb3=BC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE40C433E1
	for <mm-commits@archiver.kernel.org>; Thu, 23 Jul 2020 23:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE9BB2080D
	for <mm-commits@archiver.kernel.org>; Thu, 23 Jul 2020 23:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595548243;
	bh=VzrqAXcMIqiRaMuEM2vl1G70m9PhjWqkcpc438KpdcY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=t57oHrUTJIU3L1NBEUgr9P1cWai2YufHEscXjnJU7YapepbfoeryXmG/IIDl803bI
	 RGcjfE/qktTiICikdefcru2m+PySs4gcuDofx9fAKUancZ1c8V9TuM5AC0AaZTNFIl
	 OjPbeLh48lGqbxbtGpD9oyaXVpJu8JgqZLIhj0GM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgGWXum (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Jul 2020 19:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgGWXum (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jul 2020 19:50:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C20A7207C4;
        Thu, 23 Jul 2020 23:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595548241;
        bh=VzrqAXcMIqiRaMuEM2vl1G70m9PhjWqkcpc438KpdcY=;
        h=Date:From:To:Subject:From;
        b=JeUQcqgEtrSoJNv9Mb4B8KoVWueEIPmfXpTaHoybcOKDbZPPP3U+fViKG7QElut1W
         RNGkiEcSnuYGFATPQrmMpK89yS5a4Ot2da/EycTvo/l12/dYamHVVwpXnJqhNydZNe
         DbByhzsSR1dbHH9i9OCdNEzRbAwEJhPU3dOZclLI=
Date:   Thu, 23 Jul 2020 16:50:41 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        nivedita@alum.mit.edu
Subject:  + sh-mm-drop-unused-max_physaddr_bits.patch added to -mm
 tree
Message-ID: <20200723235041.vbuxESCQZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh/mm: drop unused MAX_PHYSADDR_BITS
has been added to the -mm tree.  Its filename is
     sh-mm-drop-unused-max_physaddr_bits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-mm-drop-unused-max_physaddr_bits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-mm-drop-unused-max_physaddr_bits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arvind Sankar <nivedita@alum.mit.edu>
Subject: sh/mm: drop unused MAX_PHYSADDR_BITS

The macro is not used anywhere, so remove the definition.

Link: http://lkml.kernel.org/r/20200723231544.17274-3-nivedita@alum.mit.edu
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
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

x86-mm-drop-unused-max_physaddr_bits.patch
sh-mm-drop-unused-max_physaddr_bits.patch
sparc-drop-unused-max_physaddr_bits.patch

