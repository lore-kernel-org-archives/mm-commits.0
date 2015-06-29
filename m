From: akpm@linux-foundation.org
Subject: [merged] frv-remove-unused-inline-function-is_in_rom.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:46:43 -0700
Message-ID: <5591aeb3.LzFz/mBKgbLxrNY4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbbF2Uqo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:46:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: remove unused inline function is_in_rom()
has been removed from the -mm tree.  Its filename was
     frv-remove-unused-inline-function-is_in_rom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tobias Klauser <tklauser@distanz.ch>
Subject: frv: remove unused inline function is_in_rom()

The function is not used anywhere in the tree (anymore) and this is the
last remaining instance, so remove it.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/sections.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN arch/frv/include/asm/sections.h~frv-remove-unused-inline-function-is_in_rom arch/frv/include/asm/sections.h
--- a/arch/frv/include/asm/sections.h~frv-remove-unused-inline-function-is_in_rom
+++ a/arch/frv/include/asm/sections.h
@@ -35,12 +35,6 @@ extern unsigned long __nongprelbss memor
 extern unsigned long __nongprelbss memory_end;
 extern unsigned long __nongprelbss rom_length;
 
-/* determine if we're running from ROM */
-static inline int is_in_rom(unsigned long addr)
-{
-	return 0; /* default case: not in ROM */
-}
