From: akpm@linux-foundation.org
Subject: + arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch added to -mm tree
Date: Mon, 10 Mar 2008 22:54:19 -0700
Message-ID: <200803110554.m2B5sJnB025136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753478AbYCKFyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 01:54:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, rmk@arm.linux.org.uk


The patch titled
     arm: remove redundant display of free swap space in show_mem()
has been added to the -mm tree.  Its filename is
     arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: remove redundant display of free swap space in show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/arm/mm/init.c~arm-remove-redundant-display-of-free-swap-space-in-show_mem arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~arm-remove-redundant-display-of-free-swap-space-in-show_mem
+++ a/arch/arm/mm/init.c
@@ -48,8 +48,6 @@ void show_mem(void)
 
 	printk("Mem-info:\n");
 	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
