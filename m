From: akpm@linux-foundation.org
Subject: [merged] mm-swapfilec-convert-to-pr_foo.patch removed from -mm
 tree
Date: Thu, 12 Sep 2013 12:42:17 -0700
Message-ID: <52321919.layPduAjENQ5CzdY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab3ILTmR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, akpm@linux-foundation.org

Subject: [merged] mm-swapfilec-convert-to-pr_foo.patch removed from -mm tree
To: akpm@linux-foundation.org,hughd@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:17 -0700


The patch titled
     Subject: mm/swapfile.c: convert to pr_foo()
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-convert-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/swapfile.c: convert to pr_foo()

A few 80-col gymnastics were cleaned up as a result.

Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff -puN mm/swapfile.c~mm-swapfilec-convert-to-pr_foo mm/swapfile.c
--- a/mm/swapfile.c~mm-swapfilec-convert-to-pr_foo
+++ a/mm/swapfile.c
@@ -527,16 +527,16 @@ static struct swap_info_struct *swap_inf
 	return p;
 
 bad_free:
-	printk(KERN_ERR "swap_free: %s%08lx\n", Unused_offset, entry.val);
+	pr_err("swap_free: %s%08lx\n", Unused_offset, entry.val);
 	goto out;
 bad_offset:
-	printk(KERN_ERR "swap_free: %s%08lx\n", Bad_offset, entry.val);
+	pr_err("swap_free: %s%08lx\n", Bad_offset, entry.val);
 	goto out;
 bad_device:
-	printk(KERN_ERR "swap_free: %s%08lx\n", Unused_file, entry.val);
+	pr_err("swap_free: %s%08lx\n", Unused_file, entry.val);
 	goto out;
 bad_nofile:
-	printk(KERN_ERR "swap_free: %s%08lx\n", Bad_file, entry.val);
+	pr_err("swap_free: %s%08lx\n", Bad_file, entry.val);
 out:
 	return NULL;
 }
@@ -1929,7 +1929,7 @@ static unsigned long read_swap_header(st
 	unsigned long last_page;
 
 	if (memcmp("SWAPSPACE2", swap_header->magic.magic, 10)) {
-		printk(KERN_ERR "Unable to find swap-space signature\n");
+		pr_err("Unable to find swap-space signature\n");
 		return 0;
 	}
 
@@ -1943,9 +1943,8 @@ static unsigned long read_swap_header(st
 	}
 	/* Check the swap header's sub-version */
 	if (swap_header->info.version != 1) {
-		printk(KERN_WARNING
-		       "Unable to handle swap header version %d\n",
-		       swap_header->info.version);
+		pr_warn("Unable to handle swap header version %d\n",
+			swap_header->info.version);
 		return 0;
 	}
 
@@ -1971,8 +1970,7 @@ static unsigned long read_swap_header(st
 			swp_entry_to_pte(swp_entry(0, ~0UL)))) + 1;
 	last_page = swap_header->info.last_page;
 	if (last_page > maxpages) {
-		printk(KERN_WARNING
-			"Truncating oversized swap area, only using %luk out of %luk\n",
+		pr_warn("Truncating oversized swap area, only using %luk out of %luk\n",
 			maxpages << (PAGE_SHIFT - 10),
 			last_page << (PAGE_SHIFT - 10));
 	}
@@ -1988,8 +1986,7 @@ static unsigned long read_swap_header(st
 		return 0;
 	swapfilepages = i_size_read(inode) >> PAGE_SHIFT;
 	if (swapfilepages && maxpages > swapfilepages) {
-		printk(KERN_WARNING
-		       "Swap area shorter than signature indicates\n");
+		pr_warn("Swap area shorter than signature indicates\n");
 		return 0;
 	}
 	if (swap_header->info.nr_badpages && S_ISREG(inode->i_mode))
@@ -2032,7 +2029,7 @@ static int setup_swap_map_and_extents(st
 		nr_good_pages = p->pages;
 	}
 	if (!nr_good_pages) {
-		printk(KERN_WARNING "Empty swap-file\n");
+		pr_warn("Empty swap-file\n");
 		return -EINVAL;
 	}
 
@@ -2186,8 +2183,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 			if (p->flags & SWP_AREA_DISCARD) {
 				int err = discard_swap(p);
 				if (unlikely(err))
-					printk(KERN_ERR
-					       "swapon: discard_swap(%p): %d\n",
+					pr_err("swapon: discard_swap(%p): %d\n",
 						p, err);
 			}
 		}
@@ -2200,7 +2196,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 		  (swap_flags & SWAP_FLAG_PRIO_MASK) >> SWAP_FLAG_PRIO_SHIFT;
 	enable_swap_info(p, prio, swap_map, frontswap_map);
 
-	printk(KERN_INFO "Adding %uk swap on %s.  "
+	pr_info("Adding %uk swap on %s.  "
 			"Priority:%d extents:%d across:%lluk %s%s%s%s%s\n",
 		p->pages<<(PAGE_SHIFT-10), name->name, p->prio,
 		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10),
@@ -2334,7 +2330,7 @@ out:
 	return err;
 
 bad_file:
-	printk(KERN_ERR "swap_dup: %s%08lx\n", Bad_file, entry.val);
+	pr_err("swap_dup: %s%08lx\n", Bad_file, entry.val);
 	goto out;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch
mm.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
memcg-trivial-cleanups.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

