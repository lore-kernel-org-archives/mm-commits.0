From: akpm@linux-foundation.org
Subject: + iscsi_ibft_find-fix-modpost-warning.patch added to -mm tree
Date: Mon, 28 Jul 2008 19:40:09 -0700
Message-ID: <200807290240.m6T2e99K010058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbYG2CvK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 22:51:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, konradr@linux.vnet.ibm.com, mingo@elte.hu


The patch titled
     iscsi_ibft_find: fix modpost warning
has been added to the -mm tree.  Its filename is
     iscsi_ibft_find-fix-modpost-warning.patch

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
Subject: iscsi_ibft_find: fix modpost warning
From: "Jan Beulich" <jbeulich@novell.com>

Exporting __init functions is wrong.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/iscsi_ibft_find.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/firmware/iscsi_ibft_find.c~iscsi_ibft_find-fix-modpost-warning drivers/firmware/iscsi_ibft_find.c
--- a/drivers/firmware/iscsi_ibft_find.c~iscsi_ibft_find-fix-modpost-warning
+++ a/drivers/firmware/iscsi_ibft_find.c
@@ -81,4 +81,3 @@ void __init reserve_ibft_region(void)
 	if (ibft_addr)
 		reserve_bootmem(pos, PAGE_ALIGN(len), BOOTMEM_DEFAULT);
 }
-EXPORT_SYMBOL_GPL(reserve_ibft_region);
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
iscsi_ibft_find-fix-modpost-warning.patch

