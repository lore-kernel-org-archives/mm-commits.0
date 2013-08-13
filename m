From: akpm@linux-foundation.org
Subject: [folded-merged]
 pagemap-fix-buffer-overflow-in-add_page_map-fix.patch removed from -mm tree
Date: Tue, 13 Aug 2013 15:58:36 -0700
Message-ID: <520aba1c.1Kr/ZSyoUp5smN0t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab3HMW6g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Aug 2013 18:58:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, younghua.zheng@gmail.com, akpm@linux-foundation.org

Subject: [folded-merged] pagemap-fix-buffer-overflow-in-add_page_map-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,younghua.zheng@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 13 Aug 2013 15:58:35 -0700


The patch titled
     Subject: pagemap-fix-buffer-overflow-in-add_page_map-fix
has been removed from the -mm tree.  Its filename was
     pagemap-fix-buffer-overflow-in-add_page_map-fix.patch

This patch was dropped because it was folded into pagemap-fix-buffer-overflow-in-add_page_map.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: pagemap-fix-buffer-overflow-in-add_page_map-fix

document pagemapread.pos and .len units, fix PM_ENTRY_BYTES definition

Cc: Yonghua Zheng <younghua.zheng@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-fix-buffer-overflow-in-add_page_map-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-fix-buffer-overflow-in-add_page_map-fix
+++ a/fs/proc/task_mmu.c
@@ -868,7 +868,7 @@ typedef struct {
 } pagemap_entry_t;
 
 struct pagemapread {
-	int pos, len;
+	int pos, len;		/* units: PM_ENTRY_BYTES, not bytes */
 	pagemap_entry_t *buffer;
 	bool v2;
 };
@@ -876,7 +876,7 @@ struct pagemapread {
 #define PAGEMAP_WALK_SIZE	(PMD_SIZE)
 #define PAGEMAP_WALK_MASK	(PMD_MASK)
 
-#define PM_ENTRY_BYTES      sizeof(u64)
+#define PM_ENTRY_BYTES      sizeof(pagemap_entry_t)
 #define PM_STATUS_BITS      3
 #define PM_STATUS_OFFSET    (64 - PM_STATUS_BITS)
 #define PM_STATUS_MASK      (((1LL << PM_STATUS_BITS) - 1) << PM_STATUS_OFFSET)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
pagemap-fix-buffer-overflow-in-add_page_map.patch

