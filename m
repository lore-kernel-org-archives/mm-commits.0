From: akpm@linux-foundation.org
Subject: + initramfs-support-initramfs-that-is-more-than-2g-fix.patch
 added to -mm tree
Date: Fri, 20 Jun 2014 12:20:54 -0700
Message-ID: <53a48996.u1QT10GIGdsG+QxB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877AbaFTTUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 15:20:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, akpm@linux-foundation.org


The patch titled
     Subject: initramfs-support-initramfs-that-is-more-than-2g-fix
has been added to the -mm tree.  Its filename is
     initramfs-support-initramfs-that-is-more-than-2g-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initramfs-support-initramfs-that-is-more-than-2g-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initramfs-support-initramfs-that-is-more-than-2g-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: initramfs-support-initramfs-that-is-more-than-2g-fix

crypto/zlib.c: In function 'zlib_compress_update':
crypto/zlib.c:171:2: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'uLong' [-Wformat]
crypto/zlib.c:171:2: warning: format '%u' expects argument of type 'unsigned int', but argument 5 has type 'uLong' [-Wformat]
crypto/zlib.c:171:2: warning: format '%u' expects argument of type 'unsigned int', but argument 6 has type 'long unsigned int' [-Wformat]
crypto/zlib.c: In function 'zlib_compress_final':
crypto/zlib.c:201:2: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'uLong' [-Wformat]
crypto/zlib.c:201:2: warning: format '%u' expects argument of type 'unsigned int', but argument 5 has type 'uLong' [-Wformat]
crypto/zlib.c:201:2: warning: format '%u' expects argument of type 'unsigned int', but argument 6 has type 'long unsigned int' [-Wformat]
crypto/zlib.c: In function 'zlib_decompress_update':
crypto/zlib.c:286:2: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'uLong' [-Wformat]
crypto/zlib.c:286:2: warning: format '%u' expects argument of type 'unsigned int', but argument 5 has type 'uLong' [-Wformat]
crypto/zlib.c:286:2: warning: format '%u' expects argument of type 'unsigned int', but argument 6 has type 'long unsigned int' [-Wformat]
crypto/zlib.c: In function 'zlib_decompress_final':
crypto/zlib.c:334:2: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'uLong' [-Wformat]
crypto/zlib.c:334:2: warning: format '%u' expects argument of type 'unsigned int', but argument 5 has type 'uLong' [-Wformat]
crypto/zlib.c:334:2: warning: format '%u' expects argument of type 'unsigned int', but argument 6 has type 'long unsigned int' [-Wformat]

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/zlib.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN crypto/zlib.c~initramfs-support-initramfs-that-is-more-than-2g-fix crypto/zlib.c
--- a/crypto/zlib.c~initramfs-support-initramfs-that-is-more-than-2g-fix
+++ a/crypto/zlib.c
@@ -168,7 +168,7 @@ static int zlib_compress_update(struct c
 	}
 
 	ret = req->avail_out - stream->avail_out;
-	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
+	pr_debug("avail_in %lu, avail_out %lu (consumed %lu, produced %u)\n",
 		 stream->avail_in, stream->avail_out,
 		 req->avail_in - stream->avail_in, ret);
 	req->next_in = stream->next_in;
@@ -198,7 +198,7 @@ static int zlib_compress_final(struct cr
 	}
 
 	ret = req->avail_out - stream->avail_out;
-	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
+	pr_debug("avail_in %lu, avail_out %lu (consumed %lu, produced %u)\n",
 		 stream->avail_in, stream->avail_out,
 		 req->avail_in - stream->avail_in, ret);
 	req->next_in = stream->next_in;
@@ -283,7 +283,7 @@ static int zlib_decompress_update(struct
 	}
 
 	ret = req->avail_out - stream->avail_out;
-	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
+	pr_debug("avail_in %lu, avail_out %lu (consumed %lu, produced %u)\n",
 		 stream->avail_in, stream->avail_out,
 		 req->avail_in - stream->avail_in, ret);
 	req->next_in = stream->next_in;
@@ -331,7 +331,7 @@ static int zlib_decompress_final(struct
 	}
 
 	ret = req->avail_out - stream->avail_out;
-	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
+	pr_debug("avail_in %lu, avail_out %lu (consumed %lu, produced %u)\n",
 		 stream->avail_in, stream->avail_out,
 		 req->avail_in - stream->avail_in, ret);
 	req->next_in = stream->next_in;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry-checkpatch-fixes.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep-checkpatch-fixes.patch
shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-memcontrol-rewrite-charge-api-fix.patch
mm-memcontrol-rewrite-uncharge-api-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
fs-isofs-logging-clean-up-fix.patch
initramfs-support-initramfs-that-is-more-than-2g-fix.patch
initramfs-support-initramfs-that-is-more-than-2g-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

