From: akpm@linux-foundation.org
Subject: - mm-swapfilec-make-code-static.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:18:18 -0700
Message-ID: <200807262118.m6QLIIoo020079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758041AbYGZVS2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:18:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm/swapfile.c: make code static
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-make-code-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/swapfile.c: make code static
From: Adrian Bunk <bunk@kernel.org>

This patch makes the following needlessly global code static:
- swap_lock
- nr_swapfiles
- struct swap_list

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    3 ---
 mm/swapfile.c        |    6 +++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN include/linux/swap.h~mm-swapfilec-make-code-static include/linux/swap.h
--- a/include/linux/swap.h~mm-swapfilec-make-code-static
+++ a/include/linux/swap.h
@@ -237,7 +237,6 @@ extern struct page *swapin_readahead(swp
 
 /* linux/mm/swapfile.c */
 extern long total_swap_pages;
-extern unsigned int nr_swapfiles;
 extern void si_swapinfo(struct sysinfo *);
 extern swp_entry_t get_swap_page(void);
 extern swp_entry_t get_swap_page_of_type(int);
@@ -254,8 +253,6 @@ extern int can_share_swap_page(struct pa
 extern int remove_exclusive_swap_page(struct page *);
 struct backing_dev_info;
 
-extern spinlock_t swap_lock;
-
 /* linux/mm/thrash.c */
 extern struct mm_struct * swap_token_mm;
 extern void grab_swap_token(void);
diff -puN mm/swapfile.c~mm-swapfilec-make-code-static mm/swapfile.c
--- a/mm/swapfile.c~mm-swapfilec-make-code-static
+++ a/mm/swapfile.c
@@ -33,8 +33,8 @@
 #include <asm/tlbflush.h>
 #include <linux/swapops.h>
 
-DEFINE_SPINLOCK(swap_lock);
-unsigned int nr_swapfiles;
+static DEFINE_SPINLOCK(swap_lock);
+static unsigned int nr_swapfiles;
 long total_swap_pages;
 static int swap_overflow;
 static int least_priority;
@@ -44,7 +44,7 @@ static const char Unused_file[] = "Unuse
 static const char Bad_offset[] = "Bad swap offset entry ";
 static const char Unused_offset[] = "Unused swap offset entry ";
 
-struct swap_list_t swap_list = {-1, -1};
+static struct swap_list_t swap_list = {-1, -1};
 
 static struct swap_info_struct swap_info[MAX_SWAPFILES];
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

