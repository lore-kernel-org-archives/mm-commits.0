From: akpm@linux-foundation.org
Subject: [merged] gru-support-64-bit-gru-addresses.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:29 -0800
Message-ID: <200912162040.nBGKeTV5013645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935510AbZLPUkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: support 64-bit GRU addresses
has been removed from the -mm tree.  Its filename was
     gru-support-64-bit-gru-addresses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: support 64-bit GRU addresses
From: Jack Steiner <steiner@sgi.com>

Increase the maximum address supported by the SGI GRU driver to a full 64
bits.  Note that GRU addresses are not always the same as socket virtual
addresses.  Sockets may not necessarily support the full 64 bits.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grutables.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/misc/sgi-gru/grutables.h~gru-support-64-bit-gru-addresses drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-support-64-bit-gru-addresses
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -293,13 +293,7 @@ extern struct mcs_op_statistic mcs_op_st
 #define ASID_INC	8	/* number of regions */
 
 /* Generate a GRU asid value from a GRU base asid & a virtual address. */
-#if defined CONFIG_IA64
 #define VADDR_HI_BIT		64
-#elif defined CONFIG_X86_64
-#define VADDR_HI_BIT		48
-#else
-#error "Unsupported architecture"
-#endif
 #define GRUREGION(addr)		((addr) >> (VADDR_HI_BIT - 3) & 3)
 #define GRUASID(asid, addr)	((asid) + GRUREGION(addr))
 
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

