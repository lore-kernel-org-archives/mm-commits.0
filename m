From: akpm@linux-foundation.org
Subject: +
 powerpc-add-explicit-include-asm-asm-compath-for-jump-label.patch added to
 -mm tree
Date: Mon, 25 Jan 2016 14:16:17 -0800
Message-ID: <56a69eb1.1dHD5aUz1KJN7jkP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbcAYWQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 17:16:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, benh@kernel.crashing.org, joe@perches.com, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: add explicit #include <asm/asm-compat.h> for jump label
has been added to the -mm tree.  Its filename is
     powerpc-add-explicit-include-asm-asm-compath-for-jump-label.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-add-explicit-include-asm-asm-compath-for-jump-label.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-add-explicit-include-asm-asm-compath-for-jump-label.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Baron <jbaron@akamai.com>
Subject: powerpc: add explicit #include <asm/asm-compat.h> for jump label

The stringify_in_c() macro may not be included. Make the dependency
explicit.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/jump_label.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/include/asm/jump_label.h~powerpc-add-explicit-include-asm-asm-compath-for-jump-label arch/powerpc/include/asm/jump_label.h
--- a/arch/powerpc/include/asm/jump_label.h~powerpc-add-explicit-include-asm-asm-compath-for-jump-label
+++ a/arch/powerpc/include/asm/jump_label.h
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 
 #include <asm/feature-fixups.h>
+#include <asm/asm-compat.h>
 
 #define JUMP_ENTRY_TYPE		stringify_in_c(FTR_ENTRY_LONG)
 #define JUMP_LABEL_NOP_SIZE	4
_

Patches currently in -mm which might be from jbaron@akamai.com are

jump_label-create-jump_label_branchh.patch
powerpc-add-explicit-include-asm-asm-compath-for-jump-label.patch

