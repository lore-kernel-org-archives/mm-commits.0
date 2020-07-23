Return-Path: <SRS0=ssb3=BC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B90C433E1
	for <mm-commits@archiver.kernel.org>; Thu, 23 Jul 2020 23:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB513207C4
	for <mm-commits@archiver.kernel.org>; Thu, 23 Jul 2020 23:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595548240;
	bh=jeA7EFYZNDzGcjTvTfbLhefrriI2fhOx5IeX8mtxLhw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Ehgl1zQh7JOo206yILvkQKKnEb3+EDOYALk4IyqtNlQJY2A6wb3QAW50G14qbEzoU
	 u1cn9pZ3268lBKUBL5QF8viKRSP+lGImrWhb6W3qQN9pQ+xl+1nawFrAWWG3oa2Iuu
	 47Lk+MQkmJ64PRgFNCJPJ0XrJJh16svBy/mpk4ug=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgGWXuk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Jul 2020 19:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgGWXuk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jul 2020 19:50:40 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 106E32071A;
        Thu, 23 Jul 2020 23:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595548239;
        bh=jeA7EFYZNDzGcjTvTfbLhefrriI2fhOx5IeX8mtxLhw=;
        h=Date:From:To:Subject:From;
        b=UqPyejHd0gZtMaiCSnstuI0V2GB38e3r2vRJsUg5wuLYj5yFfrR8aBRjUm/CmGlQ4
         7EEr64xiqkwLTSJinbN45uvITucjhVPSzzKCamtlPz308WISddaQQsbutKMHAknYyz
         V+uvXjtB1yP/V4WgJuNJmdHL14QLPchYQGExuKi8=
Date:   Thu, 23 Jul 2020 16:50:38 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dalias@libc.org,
        dave.hansen@linux.intel.com, davem@davemloft.net, hpa@zytor.com,
        luto@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org,
        nivedita@alum.mit.edu, peterz@infradead.org, tglx@linutronix.de,
        ysato@users.sourceforge.jp
Subject:  + x86-mm-drop-unused-max_physaddr_bits.patch added to -mm
 tree
Message-ID: <20200723235038.byyR-jyU8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/mm: drop unused MAX_PHYSADDR_BITS
has been added to the -mm tree.  Its filename is
     x86-mm-drop-unused-max_physaddr_bits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-drop-unused-max_physaddr_bits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-drop-unused-max_physaddr_bits.patch

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
Subject: x86/mm: drop unused MAX_PHYSADDR_BITS

Patch series "Drop unused MAX_PHYSADDR_BITS".

This #define is not used anywhere, and has the wrong value on x86_64.

I tried digging into the history a bit, but it seems to have been unused
0even in the initial merge of sparsemem in v2.6.13, when it was first
defined.


This patch (of 3):

The macro is not used anywhere, and has an incorrect value (going by the
comment) on x86_64 since commit
  c898faf91b3e ("x86: 46 bit physical address support on 64 bits")

To avoid confusion, just remove the definition.

Link: http://lkml.kernel.org/r/20200723231544.17274-1-nivedita@alum.mit.edu
Link: http://lkml.kernel.org/r/20200723231544.17274-2-nivedita@alum.mit.edu
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/sparsemem.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/arch/x86/include/asm/sparsemem.h~x86-mm-drop-unused-max_physaddr_bits
+++ a/arch/x86/include/asm/sparsemem.h
@@ -10,24 +10,20 @@
  *    field of the struct page
  *
  * SECTION_SIZE_BITS		2^n: size of each section
- * MAX_PHYSADDR_BITS		2^n: max size of physical address space
- * MAX_PHYSMEM_BITS		2^n: how much memory we can have in that space
+ * MAX_PHYSMEM_BITS		2^n: max size of physical address space
  *
  */
 
 #ifdef CONFIG_X86_32
 # ifdef CONFIG_X86_PAE
 #  define SECTION_SIZE_BITS	29
-#  define MAX_PHYSADDR_BITS	36
 #  define MAX_PHYSMEM_BITS	36
 # else
 #  define SECTION_SIZE_BITS	26
-#  define MAX_PHYSADDR_BITS	32
 #  define MAX_PHYSMEM_BITS	32
 # endif
 #else /* CONFIG_X86_32 */
 # define SECTION_SIZE_BITS	27 /* matt - 128 is convenient right now */
-# define MAX_PHYSADDR_BITS	(pgtable_l5_enabled() ? 52 : 44)
 # define MAX_PHYSMEM_BITS	(pgtable_l5_enabled() ? 52 : 46)
 #endif
 
_

Patches currently in -mm which might be from nivedita@alum.mit.edu are

x86-mm-drop-unused-max_physaddr_bits.patch
sh-mm-drop-unused-max_physaddr_bits.patch
sparc-drop-unused-max_physaddr_bits.patch

