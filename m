From: akpm@linux-foundation.org
Subject: [patch 41/84] kexec: make a pair of map/unmap reserved pages in
 error path
Date: Mon, 23 May 2016 16:24:16 -0700
Message-ID: <57439120.SX4BznwGH8q1Rv8Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbcEWXYS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:24:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mnfhuang@gmail.com, bhe@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, xlpang@redhat.com

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
