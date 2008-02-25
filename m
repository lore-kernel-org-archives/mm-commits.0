From: akpm@linux-foundation.org
Subject: + cris-v10-include-mmh-instead-of-vmstath-in-kernel-timec.patch added to -mm tree
Date: Mon, 25 Feb 2008 10:52:09 -0800
Message-ID: <200802251853.m1PIr003014229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757660AbYBYSyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 13:54:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, mikael.starvik@axis.com, schwidefsky@de.ibm.com


The patch titled
     CRIS v10: Include mm.h instead of vmstat.h in kernel/time.c
has been added to the -mm tree.  Its filename is
     cris-v10-include-mmh-instead-of-vmstath-in-kernel-timec.patch

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
Subject: CRIS v10: Include mm.h instead of vmstat.h in kernel/time.c
From: Jesper Nilsson <jesper.nilsson@axis.com>

Commit 2f569afd9ced9ebec9a6eb3dbf6f83429be0a7b4
(CONFIG_HIGHPTE vs. sub-page page tables) introduced use of
inc_zone_page_state and dec_zone_page_state in include/linux/mm.h.

Those are defined in include/linux/vmstat.h, but after it includes
mm.h, making it impossible to include vmstat.h since inc_zone_page_state
and dec_zone_page_state then would be undefined.

arch/cris/arch-v10/kernel/time.c does just this, which makes the
CRIS v10 build break with the following error:

...
  CC      arch/cris/arch-v10/kernel/time.o
In file included from include/linux/vmstat.h:7,
                 from arch/cris/arch-v10/kernel/time.c:17:
include/linux/mm.h: In function 'pgtable_page_ctor':
include/linux/mm.h:902: error: implicit declaration of function 'inc_zone_page_state'
include/linux/mm.h: In function 'pgtable_page_dtor':
include/linux/mm.h:908: error: implicit declaration of function 'dec_zone_page_state'
make[2]: *** [arch/cris/arch-v10/kernel/time.o] Error 1
make[1]: *** [arch/cris/arch-v10/kernel] Error 2
make: *** [sub-make] Error 2
...

By changing kernel/time.c to include linux/mm.h, the build succeeds.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/cris/arch-v10/kernel/time.c~cris-v10-include-mmh-instead-of-vmstath-in-kernel-timec arch/cris/arch-v10/kernel/time.c
--- a/arch/cris/arch-v10/kernel/time.c~cris-v10-include-mmh-instead-of-vmstath-in-kernel-timec
+++ a/arch/cris/arch-v10/kernel/time.c
@@ -13,7 +13,7 @@
 #include <linux/swap.h>
 #include <linux/sched.h>
 #include <linux/init.h>
-#include <linux/vmstat.h>
+#include <linux/mm.h>
 #include <asm/arch/svinto.h>
 #include <asm/types.h>
 #include <asm/signal.h>
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

cris-v10-include-mmh-instead-of-vmstath-in-kernel-timec.patch
