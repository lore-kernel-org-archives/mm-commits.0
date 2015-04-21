From: akpm@linux-foundation.org
Subject: + frv-remove-unused-inline-function-is_in_rom.patch added to -mm
 tree
Date: Tue, 21 Apr 2015 15:36:31 -0700
Message-ID: <5536d0ef.lxkYPoQs/aJLMLqn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbbDUWgc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Apr 2015 18:36:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: Remove unused inline function is_in_rom()
has been added to the -mm tree.  Its filename is
     frv-remove-unused-inline-function-is_in_rom.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/frv-remove-unused-inline-function-is_in_rom.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/frv-remove-unused-inline-function-is_in_rom.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tobias Klauser <tklauser@distanz.ch>
Subject: frv: Remove unused inline function is_in_rom()

The function is not used anywhere in the tree (anymore) and this is the last
remaining instance, so remove it.

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
