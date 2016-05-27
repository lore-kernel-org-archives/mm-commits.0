From: akpm@linux-foundation.org
Subject: [merged]
 kexec-make-a-pair-of-map-unmap-reserved-pages-in-error-path.patch removed
 from -mm tree
Date: Fri, 27 May 2016 11:43:39 -0700
Message-ID: <5748955b.LRuCd+4zdocFWL63%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbcE0Snk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mnfhuang@gmail.com, bhe@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, xlpang@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: make a pair of map/unmap reserved pages in error path
has been removed from the -mm tree.  Its filename was
     kexec-make-a-pair-of-map-unmap-reserved-pages-in-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minfei Huang <mnfhuang@gmail.com>
Subject: kexec: make a pair of map/unmap reserved pages in error path

For some arch, kexec shall map the reserved pages, then use them, when we
try to start the kdump service.

kexec may return directly, without unmaping the reserved pages, if it
fails during starting service.  To fix it, we make a pair of map/unmap
reserved pages both in generic path and error path.

This patch only affects s390.  Other architecturess don't implement the
interface of crash_unmap_reserved_pages and crash_map_reserved_pages.

It isn't a urgent patch.  Kernel can work well without any risk, although
the reserved pages are not unmapped before returning in error path.

Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Xunlei Pang <xlpang@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/kexec.c~kexec-make-a-pair-of-map-unmap-reserved-pages-in-error-path kernel/kexec.c
--- a/kernel/kexec.c~kexec-make-a-pair-of-map-unmap-reserved-pages-in-error-path
+++ a/kernel/kexec.c
@@ -194,22 +194,25 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
 						   segments, flags);
 		}
 		if (result)
-			goto out;
+			goto unmap_page;
 
 		if (flags & KEXEC_PRESERVE_CONTEXT)
 			image->preserve_context = 1;
 		result = machine_kexec_prepare(image);
 		if (result)
-			goto out;
+			goto unmap_page;
 
 		for (i = 0; i < nr_segments; i++) {
 			result = kimage_load_segment(image, &image->segment[i]);
 			if (result)
-				goto out;
+				goto unmap_page;
 		}
 		kimage_terminate(image);
+unmap_page:
 		if (flags & KEXEC_ON_CRASH)
 			crash_unmap_reserved_pages();
+		if (result)
+			goto out;
 	}
 	/* Install the new kernel, and  Uninstall the old */
 	image = xchg(dest_image, image);
_

Patches currently in -mm which might be from mnfhuang@gmail.com are


