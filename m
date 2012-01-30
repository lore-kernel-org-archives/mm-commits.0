From: akpm@linux-foundation.org
Subject: [folded] drivers-base-memoryc-fix-memory_dev_init-long-delay-v2.patch removed from -mm tree
Date: Mon, 30 Jan 2012 13:55:50 -0800
Message-ID: <20120130215550.C86EEA00B1@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:56682 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2A3Vzv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2012 16:55:51 -0500
Received: by ggnk1 with SMTP id k1so446270ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2012 13:55:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, gregkh@suse.de, holt@sgi.com, kay.sievers@vrfy.org, nfont@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-base-memoryc-fix-memory_dev_init-long-delay-v2
has been removed from the -mm tree.  Its filename was
     drivers-base-memoryc-fix-memory_dev_init-long-delay-v2.patch

This patch was dropped because it was folded into drivers-base-memoryc-fix-memory_dev_init-long-delay.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: drivers-base-memoryc-fix-memory_dev_init-long-delay-v2

-v2: check the sections_per_block, and update cc list

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/base/memory.c~drivers-base-memoryc-fix-memory_dev_init-long-delay-v2 drivers/base/memory.c
--- a/drivers/base/memory.c~drivers-base-memoryc-fix-memory_dev_init-long-delay-v2
+++ a/drivers/base/memory.c
@@ -579,8 +579,9 @@ static int add_memory_section(int nid, s
 
 	mutex_lock(&mem_sysfs_mutex);
 
-	/* don't need to find memory block for BOOT */
-	if (context != BOOT)
+	if (context == BOOT && sections_per_block == 1) {
+		/* don't need to find memory block in this case */
+	} else
 		mem = find_memory_block(section);
 
 	if (mem) {
_

Patches currently in -mm which might be from yinghai@kernel.org are

linux-next.patch
drivers-base-memoryc-fix-memory_dev_init-long-delay.patch
x86-mm-fix-the-size-calculation-of-mapping-tables.patch

