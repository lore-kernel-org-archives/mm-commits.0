From: akpm@linux-foundation.org
Subject: + mtd-fix-a-bad-dependency-in-the-blackfin-code.patch added to -mm tree
Date: Thu, 19 Feb 2009 11:52:46 -0800
Message-ID: <200902191952.n1JJqlCh018461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753894AbZBSTxX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:53:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bernd.schmidt@analog.com, dhowells@redhat.com, dwmw2@infradead.org, gerg@snapgear.com


The patch titled
     mtd: fix a bad dependency in the Blackfin code
has been added to the -mm tree.  Its filename is
     mtd-fix-a-bad-dependency-in-the-blackfin-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: fix a bad dependency in the Blackfin code
From: Bernd Schmidt <bernd.schmidt@analog.com>

Fix a bad dependency in the Blackfin code on a RomFS config symbol that
doesn't exist upstream.

Signed-off-by: Bernd Schmidt <bernd.schmidt@analog.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Bernd Schmidt <bernd.schmidt@analog.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/blackfin/kernel/process.c~mtd-fix-a-bad-dependency-in-the-blackfin-code arch/blackfin/kernel/process.c
--- a/arch/blackfin/kernel/process.c~mtd-fix-a-bad-dependency-in-the-blackfin-code
+++ a/arch/blackfin/kernel/process.c
@@ -337,7 +337,7 @@ int _access_ok(unsigned long addr, unsig
 	if (addr >= memory_mtd_end && (addr + size) <= physical_mem_end)
 		return 1;
 
-#ifdef CONFIG_ROMFS_MTD_FS
+#ifdef CONFIG_ROMFS_ON_MTD
 	/* For XIP, allow user space to use pointers within the ROMFS.  */
 	if (addr >= memory_mtd_start && (addr + size) <= memory_mtd_end)
 		return 1;
_

Patches currently in -mm which might be from bernd.schmidt@analog.com are

nommu-present-backing-device-capabilities-for-mtd-chardevs.patch
nommu-add-support-for-direct-mapping-through-mtdconcat-if-possible.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly.patch
mtd-fix-a-bad-dependency-in-the-blackfin-code.patch

