From: akpm@linux-foundation.org
Subject: [merged] x86-64-remove-dead-debugging-code-for-pse-setups.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:48:10 -0700
Message-ID: <20130430184810.9ED975A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:51453 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3SsM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:48:12 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so85084vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:48:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, Bernhard.Schmidt@lrz.de, ben@decadent.org.uk, benh@kernel.crashing.org, davem@davemloft.net, heiko.carstens@de.ibm.com, hpa@zytor.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-64: remove dead debugging code for !pse setups
has been removed from the -mm tree.  Its filename was
     x86-64-remove-dead-debugging-code-for-pse-setups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: x86-64: remove dead debugging code for !pse setups

No need to maintain addr_end and p_end when they are never actually read
anywhere on !pse setups.  Remove the dead code.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Bernhard Schmidt <Bernhard.Schmidt@lrz.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/x86/mm/init_64.c~x86-64-remove-dead-debugging-code-for-pse-setups arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-64-remove-dead-debugging-code-for-pse-setups
+++ a/arch/x86/mm/init_64.c
@@ -1311,9 +1311,6 @@ int __meminit vmemmap_populate(unsigned
 
 			if (!p)
 				return -ENOMEM;
