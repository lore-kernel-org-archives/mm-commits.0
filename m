From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 22 Jun 2011 11:34:30 -0700
Message-ID: <201106221834.p5MIYH0N018812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756602Ab1FVSeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Jun 2011 14:34:18 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p5MIYHqb009077
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2011 11:34:17 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/pnfs.c |   33 ---------------------------------
 1 file changed, 33 deletions(-)

diff -puN fs/nfs/pnfs.c~linux-next-git-rejects fs/nfs/pnfs.c
--- a/fs/nfs/pnfs.c~linux-next-git-rejects
+++ a/fs/nfs/pnfs.c
@@ -1079,38 +1079,6 @@ pnfs_generic_pg_init_read(struct nfs_pag
 }
 EXPORT_SYMBOL_GPL(pnfs_generic_pg_init_read);
 
-<<<<<<< HEAD
-	if (pgio->pg_lseg == NULL) {
-		if (pgio->pg_count != prev->wb_bytes)
-			return true;
-		/* This is first coelesce call for a series of nfs_pages */
-		pgio->pg_lseg = pnfs_update_layout(pgio->pg_inode,
-						   prev->wb_context,
-						   req_offset(prev),
-						   pgio->pg_count,
-						   access_type,
-						   gfp_flags);
-		if (pgio->pg_lseg == NULL)
-			return true;
-	}
-
-	/*
-	 * Test if a nfs_page is fully contained in the pnfs_layout_range.
-	 * Note that this test makes several assumptions:
-	 * - that the previous nfs_page in the struct nfs_pageio_descriptor
-	 *   is known to lie within the range.
-	 *   - that the nfs_page being tested is known to be contiguous with the
-	 *   previous nfs_page.
-	 *   - Layout ranges are page aligned, so we only have to test the
-	 *   start offset of the request.
-	 *
-	 * Please also note that 'end_offset' is actually the offset of the
-	 * first byte that lies outside the pnfs_layout_range. FIXME?
-	 *
-	 */
-	return req_offset(req) < end_offset(pgio->pg_lseg->pls_range.offset,
-					 pgio->pg_lseg->pls_range.length);
-=======
 void
 pnfs_generic_pg_init_write(struct nfs_pageio_descriptor *pgio, struct nfs_page *req)
 {
@@ -1150,7 +1118,6 @@ pnfs_pageio_init_write(struct nfs_pageio
 		return false;
 	nfs_pageio_init(pgio, inode, ld->pg_write_ops, server->wsize, ioflags);
 	return true;
->>>>>>> FETCH_HEAD
 }
 
 bool
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-gma500-psb_intel_displayc-fix-build.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

