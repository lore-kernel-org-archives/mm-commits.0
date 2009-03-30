From: akpm@linux-foundation.org
Subject: [merged] mtd-fix-a-bad-dependency-in-the-blackfin-code.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:06:56 -0700
Message-ID: <200903301906.n2UJ6uti019217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759440AbZC3TLc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:11:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bernd.schmidt@analog.com, dhowells@redhat.com, dwmw2@infradead.org, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     mtd: fix a bad dependency in the Blackfin code
has been removed from the -mm tree.  Its filename was
     mtd-fix-a-bad-dependency-in-the-blackfin-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

