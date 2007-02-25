From: akpm@linux-foundation.org
Subject: + mtd-chips-oops-in-cfi_amdstd_sync.patch added to -mm tree
Date: Sun, 25 Feb 2007 05:08:07 -0800
Message-ID: <200702251308.l1PD892A029959@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36116 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964962AbXBYNWP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 08:22:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vsampath@gmail.com, dwmw2@infradead.org, joern@lazybastard.org, jwboyer@linux.vnet.ibm.com


The patch titled
     mtd: CHIPS: oops in cfi_amdstd_sync
has been added to the -mm tree.  Its filename is
     mtd-chips-oops-in-cfi_amdstd_sync.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mtd: CHIPS: oops in cfi_amdstd_sync
From: Vijay Sampath <vsampath@gmail.com>

The files cfi_cmdset_0002.c and cfi_cmdset_0020.c do not initialize their
wait queues like is done in cfi_cmdset_0001.c.  This causes an oops when
the wait queue is accessed.  I have copied the code from cfi_cmdset_0001.c
that is pertinent to initialization of the wait queue.

Signed-off-by: Vijay Sampath <vsampath@gmail.com>
Acked-by: Joern Engel <joern@lazybastard.org>
Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/cfi_cmdset_0002.c |    2 ++
 drivers/mtd/chips/cfi_cmdset_0020.c |    2 ++
 2 files changed, 4 insertions(+)

diff -puN drivers/mtd/chips/cfi_cmdset_0002.c~mtd-chips-oops-in-cfi_amdstd_sync drivers/mtd/chips/cfi_cmdset_0002.c
--- a/drivers/mtd/chips/cfi_cmdset_0002.c~mtd-chips-oops-in-cfi_amdstd_sync
+++ a/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -359,6 +359,8 @@ struct mtd_info *cfi_cmdset_0002(struct 
 		cfi->chips[i].word_write_time = 1<<cfi->cfiq->WordWriteTimeoutTyp;
 		cfi->chips[i].buffer_write_time = 1<<cfi->cfiq->BufWriteTimeoutTyp;
 		cfi->chips[i].erase_time = 1<<cfi->cfiq->BlockEraseTimeoutTyp;
+		cfi->chips[i].ref_point_counter = 0;
+		init_waitqueue_head(&(cfi->chips[i].wq));
 	}
 
 	map->fldrv = &cfi_amdstd_chipdrv;
diff -puN drivers/mtd/chips/cfi_cmdset_0020.c~mtd-chips-oops-in-cfi_amdstd_sync drivers/mtd/chips/cfi_cmdset_0020.c
--- a/drivers/mtd/chips/cfi_cmdset_0020.c~mtd-chips-oops-in-cfi_amdstd_sync
+++ a/drivers/mtd/chips/cfi_cmdset_0020.c
@@ -158,6 +158,8 @@ struct mtd_info *cfi_cmdset_0020(struct 
 		cfi->chips[i].word_write_time = 128;
 		cfi->chips[i].buffer_write_time = 128;
 		cfi->chips[i].erase_time = 1024;
+		cfi->chips[i].ref_point_counter = 0;
+		init_waitqueue_head(&(cfi->chips[i].wq));
 	}
 
 	return cfi_staa_setup(map);
_

Patches currently in -mm which might be from vsampath@gmail.com are

mtd-chips-oops-in-cfi_amdstd_sync.patch
