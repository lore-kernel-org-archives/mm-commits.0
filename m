From: akpm@linux-foundation.org
Subject: [merged] mm-nommu-fix-a-potential-memory-leak-in-do_mmap_private.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:28 -0700
Message-ID: <201105252025.p4PKPpqT014433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932417Ab1EYUtS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     mm: nommu: fix a potential memory leak in do_mmap_private()
has been removed from the -mm tree.  Its filename was
     mm-nommu-fix-a-potential-memory-leak-in-do_mmap_private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: nommu: fix a potential memory leak in do_mmap_private()
From: Namhyung Kim <namhyung@gmail.com>

If f_op->read() fails and sysctl_nr_trim_pages > 1, there could be a
memory leak between @region->vm_end and @region->vm_top.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/nommu.c~mm-nommu-fix-a-potential-memory-leak-in-do_mmap_private mm/nommu.c
--- a/mm/nommu.c~mm-nommu-fix-a-potential-memory-leak-in-do_mmap_private
+++ a/mm/nommu.c
@@ -1217,7 +1217,7 @@ static int do_mmap_private(struct vm_are
 	return 0;
 
 error_free:
-	free_page_series(region->vm_start, region->vm_end);
+	free_page_series(region->vm_start, region->vm_top);
 	region->vm_start = vma->vm_start = 0;
 	region->vm_end   = vma->vm_end = 0;
 	region->vm_top   = 0;
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
memcg-mark-init_section_page_cgroup-properly.patch
memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch
memcg-move-page-freeing-code-out-of-lock.patch
maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch

