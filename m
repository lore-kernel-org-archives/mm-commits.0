From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-totalram_pages-instead-of-num_physpages-at-runtime.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:26:50 -0700
Message-ID: <51db127a.ljkq3wSuA3L0Qc21%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3GHT0v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yoshfuji@linux-ipv6.org, miklos@szeredi.hu, kuznet@ms2.inr.ac.ru, kaber@trash.net, jmorris@namei.org, jiang.liu@huawei.com, davem@davemloft.net, liuj97@gmail.com

Subject: [merged] mm-use-totalram_pages-instead-of-num_physpages-at-runtime.patch removed from -mm tree
To: liuj97@gmail.com,davem@davemloft.net,jiang.liu@huawei.com,jmorris@namei.org,kaber@trash.net,kuznet@ms2.inr.ac.ru,miklos@szeredi.hu,yoshfuji@linux-ipv6.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:50 -0700


The patch titled
     Subject: mm: use totalram_pages instead of num_physpages at runtime
has been removed from the -mm tree.  Its filename was
     mm-use-totalram_pages-instead-of-num_physpages-at-runtime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: use totalram_pages instead of num_physpages at runtime

The global variable num_physpages is scheduled to be removed, so use
totalram_pages instead of num_physpages at runtime.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c          |    2 +-
 kernel/power/snapshot.c  |    4 ++--
 net/ipv4/inet_fragment.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/fuse/inode.c~mm-use-totalram_pages-instead-of-num_physpages-at-runtime fs/fuse/inode.c
--- a/fs/fuse/inode.c~mm-use-totalram_pages-instead-of-num_physpages-at-runtime
+++ a/fs/fuse/inode.c
@@ -785,7 +785,7 @@ static const struct super_operations fus
 static void sanitize_global_limit(unsigned *limit)
 {
 	if (*limit == 0)
-		*limit = ((num_physpages << PAGE_SHIFT) >> 13) /
+		*limit = ((totalram_pages << PAGE_SHIFT) >> 13) /
 			 sizeof(struct fuse_req);
 
 	if (*limit >= 1 << 16)
diff -puN kernel/power/snapshot.c~mm-use-totalram_pages-instead-of-num_physpages-at-runtime kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~mm-use-totalram_pages-instead-of-num_physpages-at-runtime
+++ a/kernel/power/snapshot.c
@@ -1651,7 +1651,7 @@ unsigned long snapshot_get_image_size(vo
 static int init_header(struct swsusp_info *info)
 {
 	memset(info, 0, sizeof(struct swsusp_info));
-	info->num_physpages = num_physpages;
+	info->num_physpages = get_num_physpages();
 	info->image_pages = nr_copy_pages;
 	info->pages = snapshot_get_image_size();
 	info->size = info->pages;
@@ -1795,7 +1795,7 @@ static int check_header(struct swsusp_in
 	char *reason;
 
 	reason = check_image_kernel(info);
-	if (!reason && info->num_physpages != num_physpages)
+	if (!reason && info->num_physpages != get_num_physpages())
 		reason = "memory size";
 	if (reason) {
 		printk(KERN_ERR "PM: Image mismatch: %s\n", reason);
diff -puN net/ipv4/inet_fragment.c~mm-use-totalram_pages-instead-of-num_physpages-at-runtime net/ipv4/inet_fragment.c
--- a/net/ipv4/inet_fragment.c~mm-use-totalram_pages-instead-of-num_physpages-at-runtime
+++ a/net/ipv4/inet_fragment.c
@@ -93,7 +93,7 @@ void inet_frags_init(struct inet_frags *
 	}
 	rwlock_init(&f->lock);
 
-	f->rnd = (u32) ((num_physpages ^ (num_physpages>>7)) ^
+	f->rnd = (u32) ((totalram_pages ^ (totalram_pages >> 7)) ^
 				   (jiffies ^ (jiffies >> 6)));
 
 	setup_timer(&f->secret_timer, inet_frag_secret_rebuild,
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

