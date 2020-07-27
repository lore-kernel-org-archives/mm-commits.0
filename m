Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FE6C433E4
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 18:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9F1A2074F
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 18:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595874473;
	bh=BIuFaRpzvUNhphy48j9HMA0/ibc0Xm+rUQRKlu/QVVk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=bpkRwk/VG1IceD8t8S2C2XUjcjd2KA1IxxpF9NKvJoFb7v2zTplBXNZb7o6sWC0dd
	 cFFZD/OFGpjQtgmSgxP8AwhvdZhfrYTZR2XPG21fBSpg4tWLLhxUL/MXjxOzogfDg0
	 UwcnKVB7NTUkFX/RGdEH4/VJRr/PI/dT7kJgW8H8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbgG0S1x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 14:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729267AbgG0S1x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 14:27:53 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AC602073E;
        Mon, 27 Jul 2020 18:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595874472;
        bh=BIuFaRpzvUNhphy48j9HMA0/ibc0Xm+rUQRKlu/QVVk=;
        h=Date:From:To:Subject:From;
        b=THnDJF7l+8RWv1R8lVYzhLgaGxG9OYvwI5Mot8HgdjhNUlMHaN/HdlGjXBXis/rpK
         BFD53szyfV5F6bSR9HedbFY0J0y3E7bf0BI/jN+ArAiGJn4uHZvnPLIbyILHBJnCPH
         HVNcF1M8M984PQwihOH6Lg4LbgnueXO459AXDqho=
Date:   Mon, 27 Jul 2020 11:27:52 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dalias@libc.org,
        dave.hansen@linux.intel.com, davem@davemloft.net, david@redhat.com,
        hpa@zytor.com, luto@kernel.org, mingo@elte.hu,
        mm-commits@vger.kernel.org, nivedita@alum.mit.edu,
        peterz@infradead.org, tglx@linutronix.de,
        ysato@users.sourceforge.jp
Subject:  [merged] x86-mm-drop-unused-max_physaddr_bits.patch
 removed from -mm tree
Message-ID: <20200727182752.ZW-5i_vB5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/mm: drop unused MAX_PHYSADDR_BITS
has been removed from the -mm tree.  Its filename was
     x86-mm-drop-unused-max_physaddr_bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

sh-mm-drop-unused-max_physaddr_bits.patch
sparc-drop-unused-max_physaddr_bits.patch

