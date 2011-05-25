From: akpm@linux-foundation.org
Subject: [merged] mm-nommu-fix-a-compile-warning-in-do_mmap_pgoff.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:30 -0700
Message-ID: <201105252025.p4PKPr2N014436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755638Ab1EYU0d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:26:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     mm: nommu: fix a compile warning in do_mmap_pgoff()
has been removed from the -mm tree.  Its filename was
     mm-nommu-fix-a-compile-warning-in-do_mmap_pgoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: nommu: fix a compile warning in do_mmap_pgoff()
From: Namhyung Kim <namhyung@gmail.com>

Because 'ret' is declared as int, not unsigned long, no need to cast the
error contants into unsigned long.  If you compile this code on a 64-bit
machine somehow, you'll see following warning:

  CC      mm/nommu.o
mm/nommu.c: In function `do_mmap_pgoff':
mm/nommu.c:1411: warning: overflow in implicit constant conversion

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/nommu.c~mm-nommu-fix-a-compile-warning-in-do_mmap_pgoff mm/nommu.c
--- a/mm/nommu.c~mm-nommu-fix-a-compile-warning-in-do_mmap_pgoff
+++ a/mm/nommu.c
@@ -1376,15 +1376,15 @@ unsigned long do_mmap_pgoff(struct file 
 		if (capabilities & BDI_CAP_MAP_DIRECT) {
 			addr = file->f_op->get_unmapped_area(file, addr, len,
 							     pgoff, flags);
-			if (IS_ERR((void *) addr)) {
+			if (IS_ERR_VALUE(addr)) {
 				ret = addr;
-				if (ret != (unsigned long) -ENOSYS)
+				if (ret != -ENOSYS)
 					goto error_just_free;
 
 				/* the driver refused to tell us where to site
 				 * the mapping so we'll have to attempt to copy
 				 * it */
-				ret = (unsigned long) -ENODEV;
+				ret = -ENODEV;
 				if (!(capabilities & BDI_CAP_MAP_COPY))
 					goto error_just_free;
 
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
memcg-mark-init_section_page_cgroup-properly.patch
memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch
memcg-move-page-freeing-code-out-of-lock.patch
maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch

