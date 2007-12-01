From: akpm@linux-foundation.org
Subject: - partitions-use-kasprintf.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:07:52 -0800
Message-ID: <200712010007.lB107qjJ031292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47706 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756216AbXLAAH7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:07:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     partitions: use kasprintf
has been removed from the -mm tree.  Its filename was
     partitions-use-kasprintf.patch

This patch was dropped because make_block_name() got deleted in Greg's driver tree

------------------------------------------------------
Subject: partitions: use kasprintf
From: Akinobu Mita <akinobu.mita@gmail.com>

Use kasprintf instead of kmalloc()-strcpy()-strcat().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/check.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN fs/partitions/check.c~partitions-use-kasprintf fs/partitions/check.c
--- a/fs/partitions/check.c~partitions-use-kasprintf
+++ a/fs/partitions/check.c
@@ -409,16 +409,11 @@ void add_partition(struct gendisk *disk,
 static char *make_block_name(struct gendisk *disk)
 {
 	char *name;
-	static char *block_str = "block:";
-	int size;
 	char *s;
 
-	size = strlen(block_str) + strlen(disk->disk_name) + 1;
-	name = kmalloc(size, GFP_KERNEL);
+	name = kasprintf(GFP_KERNEL, "block:%s", disk->disk_name);
 	if (!name)
 		return NULL;
-	strcpy(name, block_str);
-	strcat(name, disk->disk_name);
 	/* ewww... some of these buggers have / in name... */
 	s = strchr(name, '/');
 	if (s)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

git-net.patch
git-battery.patch
fs-use-hlist_unhashed.patch
partitions-use-kasprintf.patch
fs-use-list_for_each_entry_reverse-and-kill-sb_entry.patch
