From: akpm@linux-foundation.org
Subject: + md-balance-braces-in-raid5-debug-code.patch added to -mm tree
Date: Fri, 07 Dec 2007 14:34:59 -0800
Message-ID: <200712072235.lB7MYxme007020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56512 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755334AbXLGWfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 17:35:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, dan.j.williams@intel.com


The patch titled
     md: balance braces in raid5 debug code
has been added to the -mm tree.  Its filename is
     md-balance-braces-in-raid5-debug-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: balance braces in raid5 debug code
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This patch fixes the compilation breakage.  Normally you don't see that as
this piece of code is under #ifdef DEBUG.  This was introduced by
git-md-accel.patch at line 3179.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/raid5.c~md-balance-braces-in-raid5-debug-code drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-balance-braces-in-raid5-debug-code
+++ a/drivers/md/raid5.c
@@ -4972,7 +4972,7 @@ static void print_sh (struct seq_file *s
 	seq_printf(seq, "sh %llu,  count %d.\n",
 		   (unsigned long long)sh->sector, atomic_read(&sh->count));
 	seq_printf(seq, "sh %llu, ", (unsigned long long)sh->sector);
-	for (i = 0; i < sh->sq->disks; i++) {
+	for (i = 0; i < sh->sq->disks; i++)
 		seq_printf(seq, "(cache%d: %p %ld) ",
 			   i, sh->dev[i].page, sh->dev[i].flags);
 	seq_printf(seq, "\n");
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

md-balance-braces-in-raid5-debug-code.patch
git-mmc.patch
config_highpte-vs-sub-page-page-tables-fix-2.patch
reiser4.patch
