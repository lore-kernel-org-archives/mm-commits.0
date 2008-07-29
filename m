From: akpm@linux-foundation.org
Subject: - fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch removed from -mm tree
Date: Mon, 28 Jul 2008 17:03:34 -0700
Message-ID: <200807290003.m6T03ZHc003108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752413AbYG2AEl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 20:04:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, kamewzawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, npiggin@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix double unlock_page() in 2.6.26-rc5-mm3 kernel BUG at mm/filemap.c:575!
has been removed from the -mm tree.  Its filename was
     fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch

This patch was dropped because it was folded into mmap-handle-mlocked-pages-during-map-remap-unmap.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix double unlock_page() in 2.6.26-rc5-mm3 kernel BUG at mm/filemap.c:575!
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This is reproducer of panic. "quick fix" is attached.
But I think putback_lru_page() should be re-designed.

==
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <errno.h>

int main(int argc, char *argv[])
{
        int fd;
        char *filename = argv[1];
        char buffer[4096];
        char *addr;
        int len;

        fd = open(filename, O_CREAT | O_EXCL | O_RDWR, S_IRWXU);

        if (fd < 0) {
                perror("open");
                exit(1);
        }
        len = write(fd, buffer, sizeof(buffer));

        if (len < 0) {
                perror("write");
                exit(1);
        }

        addr = mmap(NULL, 4096, PROT_WRITE, MAP_SHARED|MAP_LOCKED, fd, 0);
        if (addr == MAP_FAILED) {
                perror("mmap");
                exit(1);
        }
        munmap(addr, 4096);
        close(fd);

        unlink(filename);
}
==
you'll see panic.

Fix is here
==

quick fix for double unlock_page();

Signed-off-by: KAMEZAWA Hiroyuki <kamewzawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/truncate.c~fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575 mm/truncate.c
--- a/mm/truncate.c~fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575
+++ a/mm/truncate.c
@@ -104,8 +104,8 @@ truncate_complete_page(struct address_sp
 
 	cancel_dirty_page(page, PAGE_CACHE_SIZE);
 
-	remove_from_page_cache(page);
 	clear_page_mlock(page);
+	remove_from_page_cache(page);
 	ClearPageUptodate(page);
 	ClearPageMappedToDisk(page);
 	page_cache_release(page);	/* pagecache ref */
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroup-fix-possible-memory-leak.patch
cgroup-remove-duplicate-code-in-allocate_cg_link.patch
cgroup-uninline-cgroup_has_css_refs.patch
memcg-remove-redundant-check-in-move_task.patch
cpuset-a-bit-cleanup-for-scan_for_empty_cpusets.patch
cpuset-speed-up-sched-domain-partition.patch
cpuset-fix-wrong-calculation-of-relax-domain-level.patch
cpuset-clean-up-cpuset-hierarchy-traversal-code.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

