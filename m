From: akpm@linux-foundation.org
Subject: [merged] mbind-fix-leak-of-never-putback-pages.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:50:39 -0700
Message-ID: <200910302050.n9UKodu1011059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757520AbZJ3Uve (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:51:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mbind(): fix leak of never putback pages
has been removed from the -mm tree.  Its filename was
     mbind-fix-leak-of-never-putback-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mbind(): fix leak of never putback pages
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

If mbind() receives an invalid address, do_mbind leaks a page.  The
following test program detects this leak.

This patch fixes it.

migrate_efault.c
=======================================
 #include <numaif.h>
 #include <numa.h>
 #include <sys/mman.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <stdlib.h>
 #include <string.h>

static unsigned long pagesize;

static void* make_hole_mapping(void)
{

	void* addr;

	addr = mmap(NULL, pagesize*3, PROT_READ|PROT_WRITE,
		    MAP_ANON|MAP_PRIVATE, 0, 0);
	if (addr == MAP_FAILED)
		return NULL;

	/* make page populate */
	memset(addr, 0, pagesize*3);

	/* make memory hole */
	munmap(addr+pagesize, pagesize);

	return addr;
}

int main(int argc, char** argv)
{
	void* addr;
	int ch;
	int node;
	struct bitmask *nmask = numa_allocate_nodemask();
	int err;
	int node_set = 0;

	while ((ch = getopt(argc, argv, "n:")) != -1){
		switch (ch){
		case 'n':
			node = strtol(optarg, NULL, 0);
			numa_bitmask_setbit(nmask, node);
			node_set = 1;
			break;
		default:
			;
		}
	}
	argc -= optind;
	argv += optind;

	if (!node_set)
		numa_bitmask_setbit(nmask, 0);

	pagesize = getpagesize();

	addr = make_hole_mapping();

	err = mbind(addr, pagesize*3, MPOL_BIND, nmask->maskp, nmask->size, MPOL_MF_MOVE_ALL);
	if (err)
		perror("mbind ");

	return 0;
}
=======================================

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/mempolicy.c~mbind-fix-leak-of-never-putback-pages mm/mempolicy.c
--- a/mm/mempolicy.c~mbind-fix-leak-of-never-putback-pages
+++ a/mm/mempolicy.c
@@ -1058,7 +1058,8 @@ static long do_mbind(unsigned long start
 
 		if (!err && nr_failed && (flags & MPOL_MF_STRICT))
 			err = -EIO;
-	}
+	} else
+		putback_lru_pages(&pagelist);
 
 	up_write(&mm->mmap_sem);
 	mpol_put(new);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
page-allocator-always-wake-kswapd-when-restarting-an-allocation-attempt-after-direct-reclaim-failed.patch
page-allocator-do-not-allow-interrupts-to-use-alloc_harder.patch
linux-next.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

