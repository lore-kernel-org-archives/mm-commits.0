From: akpm@linux-foundation.org
Subject: [alternative-merged] fs-ocfs2-dlm-dlmdomainc-avoid-a-gfp_atomic-allocation.patch removed from -mm tree
Date: Thu, 24 Feb 2011 12:52:00 -0800
Message-ID: <201102242052.p1OKq0NJ025682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825Ab1BXUwK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 15:52:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Joel.Becker@oracle.com, dsterba@suse.cz, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     fs/ocfs2/dlm/dlmdomain.c: avoid a GFP_ATOMIC allocation
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-dlm-dlmdomainc-avoid-a-gfp_atomic-allocation.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ocfs2/dlm/dlmdomain.c: avoid a GFP_ATOMIC allocation
From: Andrew Morton <akpm@linux-foundation.org>

GFP_ATOMIC is unreliable.  Use a statically-allocated buffer protceted by
the global lock.

Cc: David Sterba <dsterba@suse.cz>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <Joel.Becker@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~fs-ocfs2-dlm-dlmdomainc-avoid-a-gfp_atomic-allocation fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~fs-ocfs2-dlm-dlmdomainc-avoid-a-gfp_atomic-allocation
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -926,9 +926,9 @@ static int dlm_assert_joined_handler(str
 }
 
 static int dlm_match_regions(struct dlm_ctxt *dlm,
-			     struct dlm_query_region *qr)
+			     struct dlm_query_region *qr, u8 *local)
 {
-	char *local = NULL, *remote = qr->qr_regions;
+	char *remote = qr->qr_regions;
 	char *l, *r;
 	int localnr, i, j, foundit;
 	int status = 0;
@@ -957,12 +957,6 @@ static int dlm_match_regions(struct dlm_
 		r += O2HB_MAX_REGION_NAME_LEN;
 	}
 
-	local = kmalloc(sizeof(qr->qr_regions), GFP_ATOMIC);
-	if (!local) {
-		status = -ENOMEM;
-		goto bail;
-	}
-
 	localnr = o2hb_get_all_regions(local, O2NM_MAX_REGIONS);
 
 	/* compare local regions with remote */
@@ -1012,8 +1006,6 @@ static int dlm_match_regions(struct dlm_
 	}
 
 bail:
-	kfree(local);
-
 	return status;
 }
 
@@ -1077,6 +1069,7 @@ static int dlm_query_region_handler(stru
 	struct dlm_ctxt *dlm = NULL;
 	int status = 0;
 	int locked = 0;
+	static u8 local[sizeof(qr->qr_regions)]; /* locked by dlm_domain_lock */
 
 	qr = (struct dlm_query_region *) msg->buf;
 
@@ -1112,7 +1105,7 @@ static int dlm_query_region_handler(stru
 		goto bail;
 	}
 
-	status = dlm_match_regions(dlm, qr);
+	status = dlm_match_regions(dlm, qr, local);
 
 bail:
 	if (locked)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-fix.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

