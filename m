From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-separate-swap_info-allocation.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:18 -0700
Message-ID: <201103232040.p2NKesNU028570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933393Ab1CWUlb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:41:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: separate swap_info allocation
has been removed from the -mm tree.  Its filename was
     sys_swapon-separate-swap_info-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: separate swap_info allocation
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Move the swap_info allocation to its own function. Only code movement,
no functional changes.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   57 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-separate-swap_info-allocation mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-separate-swap_info-allocation
+++ a/mm/swapfile.c
@@ -1844,33 +1844,15 @@ static int __init max_swapfiles_check(vo
 late_initcall(max_swapfiles_check);
 #endif
 
-SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
+static struct swap_info_struct *alloc_swap_info(void)
 {
 	struct swap_info_struct *p;
-	char *name = NULL;
-	struct block_device *bdev = NULL;
-	struct file *swap_file = NULL;
-	struct address_space *mapping;
 	unsigned int type;
-	int i, prev;
 	int error;
-	union swap_header *swap_header;
-	unsigned int nr_good_pages;
-	int nr_extents = 0;
-	sector_t span;
-	unsigned long maxpages;
-	unsigned long swapfilepages;
-	unsigned char *swap_map = NULL;
-	struct page *page = NULL;
-	struct inode *inode = NULL;
-	int did_down = 0;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	spin_lock(&swap_lock);
 	for (type = 0; type < nr_swapfiles; type++) {
@@ -1906,6 +1888,41 @@ SYSCALL_DEFINE2(swapon, const char __use
 	p->next = -1;
 	spin_unlock(&swap_lock);
 
+	return p;
+
+out:
+	return ERR_PTR(error);
+}
+
+SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
+{
+	struct swap_info_struct *p;
+	char *name = NULL;
+	struct block_device *bdev = NULL;
+	struct file *swap_file = NULL;
+	struct address_space *mapping;
+	int i, prev;
+	int error;
+	union swap_header *swap_header;
+	unsigned int nr_good_pages;
+	int nr_extents = 0;
+	sector_t span;
+	unsigned long maxpages;
+	unsigned long swapfilepages;
+	unsigned char *swap_map = NULL;
+	struct page *page = NULL;
+	struct inode *inode = NULL;
+	int did_down = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	p = alloc_swap_info();
+	if (IS_ERR(p)) {
+		error = PTR_ERR(p);
+		goto out;
+	}
+
 	name = getname(specialfile);
 	error = PTR_ERR(name);
 	if (IS_ERR(name)) {
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch

