From: akpm@linux-foundation.org
Subject: +
 kexec-make-a-pair-of-map-unmap-reserved-pages-in-error-path.patch added to
 -mm tree
Date: Tue, 01 Mar 2016 14:06:32 -0800
Message-ID: <56d61268.RYjxkMwZRCuExA+6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbcCAWGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 17:06:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mnfhuang@gmail.com, ebiederm@xmission.com, vgoyal@redhat.com, xlpang@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: make a pair of map/unmap reserved pages in error path
has been added to the -mm tree.  Its filename is
     kexec-make-a-pair-of-map-unmap-reserved-pages-in-error-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-make-a-pair-of-map-unmap-reserved-pages-in-error-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-make-a-pair-of-map-unmap-reserved-pages-in-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minfei Huang <mnfhuang@gmail.com>
Subject: kexec: make a pair of map/unmap reserved pages in error path

For some arch, kexec shall map the reserved pages, then use them, when we
try to start the kdump service.

kexec may return directly, without unmaping the reserved pages, if it
fails during starting service.  To fix it, we make a pair of map/unmap
reserved pages both in generic path and error path.

Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Xunlei Pang <xlpang@redhat.com>
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

proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan.patch
kexec-make-a-pair-of-map-unmap-reserved-pages-in-error-path.patch
kexec-do-a-cleanup-for-function-kexec_load.patch

