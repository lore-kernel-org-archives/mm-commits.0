From: akpm@linux-foundation.org
Subject: [patch 075/111] kexec: return error number directly
Date: Tue, 02 Aug 2016 14:05:45 -0700
Message-ID: <57a10b29.+rElRgG5NDorlSsy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbcHBVRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mnghuan@gmail.com, ats-kumagai@wm.jp.nec.com, bhe@redhat.com, bp@suse.de, dyoung@redhat.com, vgoyal@redhat.com, xlpang@redhat.com

From: Minfei Huang <mnghuan@gmail.com>
Subject: kexec: return error number directly

This is a cleanup patch to make kexec more clear to return error number
directly.  The variable result is useless, because there is no other
function's return value assignes to it.  So remove it.

Link: http://lkml.kernel.org/r/1464179273-57668-1-git-send-email-mnghuan@gmail.com
Signed-off-by: Minfei Huang <mnghuan@gmail.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Xunlei Pang <xlpang@redhat.com>
Cc: Atsushi Kumagai <ats-kumagai@wm.jp.nec.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN kernel/kexec_core.c~kexec-return-error-number-directly kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-return-error-number-directly
+++ a/kernel/kexec_core.c
@@ -147,7 +147,7 @@ static struct page *kimage_alloc_page(st
 
 int sanity_check_segment_list(struct kimage *image)
 {
-	int result, i;
+	int i;
 	unsigned long nr_segments = image->nr_segments;
 
 	/*
@@ -163,16 +163,15 @@ int sanity_check_segment_list(struct kim
 	 * simply because addresses are changed to page size
 	 * granularity.
 	 */
-	result = -EADDRNOTAVAIL;
 	for (i = 0; i < nr_segments; i++) {
 		unsigned long mstart, mend;
 
 		mstart = image->segment[i].mem;
 		mend   = mstart + image->segment[i].memsz;
 		if ((mstart & ~PAGE_MASK) || (mend & ~PAGE_MASK))
-			return result;
+			return -EADDRNOTAVAIL;
 		if (mend >= KEXEC_DESTINATION_MEMORY_LIMIT)
-			return result;
+			return -EADDRNOTAVAIL;
 	}
 
 	/* Verify our destination addresses do not overlap.
@@ -180,7 +179,6 @@ int sanity_check_segment_list(struct kim
 	 * through very weird things can happen with no
 	 * easy explanation as one segment stops on another.
 	 */
-	result = -EINVAL;
 	for (i = 0; i < nr_segments; i++) {
 		unsigned long mstart, mend;
 		unsigned long j;
@@ -194,7 +192,7 @@ int sanity_check_segment_list(struct kim
 			pend   = pstart + image->segment[j].memsz;
 			/* Do the segments overlap ? */
 			if ((mend > pstart) && (mstart < pend))
-				return result;
+				return -EINVAL;
 		}
 	}
 
@@ -203,10 +201,9 @@ int sanity_check_segment_list(struct kim
 	 * and it is easier to check up front than to be surprised
 	 * later on.
 	 */
-	result = -EINVAL;
 	for (i = 0; i < nr_segments; i++) {
 		if (image->segment[i].bufsz > image->segment[i].memsz)
-			return result;
+			return -EINVAL;
 	}
 
 	/*
@@ -220,7 +217,6 @@ int sanity_check_segment_list(struct kim
 	 */
 
 	if (image->type == KEXEC_TYPE_CRASH) {
-		result = -EADDRNOTAVAIL;
 		for (i = 0; i < nr_segments; i++) {
 			unsigned long mstart, mend;
 
@@ -229,7 +225,7 @@ int sanity_check_segment_list(struct kim
 			/* Ensure we are within the crash kernel limits */
 			if ((mstart < crashk_res.start) ||
 			    (mend > crashk_res.end))
-				return result;
+				return -EADDRNOTAVAIL;
 		}
 	}
 
_
