From: akpm@linux-foundation.org
Subject: + fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch added to -mm tree
Date: Thu, 12 Jun 2008 19:11:20 -0700
Message-ID: <200806130211.m5D2BKhU018826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754533AbYFMCMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 22:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, kamewzawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, npiggin@suse.de, riel@redhat.com


The patch titled
     fix double unlock_page() in 2.6.26-rc5-mm3 kernel BUG at mm/filemap.c:575!
has been added to the -mm tree.  Its filename is
     fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch

