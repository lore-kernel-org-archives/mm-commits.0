From: akpm@linux-foundation.org
Subject: + v4l-fix-videobuf_cgmbuf-export.patch added to -mm tree
Date: Mon, 15 Oct 2007 15:48:08 -0700
Message-ID: <200710152248.l9FMm8jU029227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36381 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbXJOWsS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 18:48:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, mchehab@infradead.org


The patch titled
     v4l: fix videobuf_cgmbuf export
has been added to the -mm tree.  Its filename is
     v4l-fix-videobuf_cgmbuf-export.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: v4l: fix videobuf_cgmbuf export
From: Pekka Enberg <penberg@cs.helsinki.fi>

As videobuf_cgmbuf is defined only if CONFIG_VIDEO_V4L1_COMPAT is enabled,
move the EXPORT_SYMBOL_GPL declaration inside the #ifdef block.  Fixes
compilation for x86_64 defconfig.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/videobuf-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/videobuf-core.c~v4l-fix-videobuf_cgmbuf-export drivers/media/video/videobuf-core.c
--- a/drivers/media/video/videobuf-core.c~v4l-fix-videobuf_cgmbuf-export
+++ a/drivers/media/video/videobuf-core.c
@@ -971,6 +971,7 @@ int videobuf_cgmbuf(struct videobuf_queu
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(videobuf_cgmbuf);
 #endif
 
 /* --------------------------------------------------------------------- */
@@ -989,7 +990,6 @@ EXPORT_SYMBOL_GPL(videobuf_reqbufs);
 EXPORT_SYMBOL_GPL(videobuf_querybuf);
 EXPORT_SYMBOL_GPL(videobuf_qbuf);
 EXPORT_SYMBOL_GPL(videobuf_dqbuf);
-EXPORT_SYMBOL_GPL(videobuf_cgmbuf);
 EXPORT_SYMBOL_GPL(videobuf_streamon);
 EXPORT_SYMBOL_GPL(videobuf_streamoff);
 
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

v4l-fix-videobuf_cgmbuf-export.patch
tokenring-3c359c-fixed-array-index-problem.patch
git-unionfs.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
slab-allocators-fail-if-ksize-is-called-with-a-null-parameter.patch
slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way-fix.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
slab-leaks3-default-y.patch
