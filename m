From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 13 Feb 2013 12:28:27 -0800
Message-ID: <20130213202828.DA98231C211@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:58456 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3BMU2c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Feb 2013 15:28:32 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so886651ghb.2
        for <mm-commits@vger.kernel.org>; Wed, 13 Feb 2013 12:28:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/evergreen_cs.c |  345 ------------------------
 1 file changed, 345 deletions(-)

diff -puN drivers/gpu/drm/radeon/evergreen_cs.c~linux-next-git-rejects drivers/gpu/drm/radeon/evergreen_cs.c
--- a/drivers/gpu/drm/radeon/evergreen_cs.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -2708,30 +2708,19 @@ int evergreen_dma_cs_parse(struct radeon
 				DRM_ERROR("bad DMA_PACKET_WRITE\n");
 				return -EINVAL;
 			}
-<<<<<<< HEAD
-			if (tiled) {
-				dst_offset = radeon_get_ib_value(p, idx+1);
-=======
 			switch (sub_cmd) {
 			/* tiled */
 			case 8:
 				dst_offset = ib[idx+1];
->>>>>>> linux-next/akpm-base
 				dst_offset <<= 8;
 
 				ib[idx+1] += (u32)(dst_reloc->lobj.gpu_offset >> 8);
 				p->idx += count + 7;
-<<<<<<< HEAD
-			} else {
-				dst_offset = radeon_get_ib_value(p, idx+1);
-				dst_offset |= ((u64)(radeon_get_ib_value(p, idx+2) & 0xff)) << 32;
-=======
 				break;
 			/* linear */
 			case 0:
 				dst_offset = ib[idx+1];
 				dst_offset |= ((u64)(ib[idx+2] & 0xff)) << 32;
->>>>>>> linux-next/akpm-base
 
 				ib[idx+1] += (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
 				ib[idx+2] += upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
@@ -2758,339 +2747,6 @@ int evergreen_dma_cs_parse(struct radeon
 				DRM_ERROR("bad DMA_PACKET_COPY\n");
 				return -EINVAL;
 			}
-<<<<<<< HEAD
-			if (tiled) {
-				idx_value = radeon_get_ib_value(p, idx + 2);
-				if (new_cmd) {
-					switch (misc) {
-					case 0:
-						/* L2T, frame to fields */
-						if (idx_value & (1 << 31)) {
-							DRM_ERROR("bad L2T, frame to fields DMA_PACKET_COPY\n");
-							return -EINVAL;
-						}
-						r = r600_dma_cs_next_reloc(p, &dst2_reloc);
-						if (r) {
-							DRM_ERROR("bad L2T, frame to fields DMA_PACKET_COPY\n");
-							return -EINVAL;
-						}
-						dst_offset = radeon_get_ib_value(p, idx+1);
-						dst_offset <<= 8;
-						dst2_offset = radeon_get_ib_value(p, idx+2);
-						dst2_offset <<= 8;
-						src_offset = radeon_get_ib_value(p, idx+8);
-						src_offset |= ((u64)(radeon_get_ib_value(p, idx+9) & 0xff)) << 32;
-						if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2T, frame to fields src buffer too small (%llu %lu)\n",
-								 src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
-							return -EINVAL;
-						}
-						if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2T, frame to fields buffer too small (%llu %lu)\n",
-								 dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
-							return -EINVAL;
-						}
-						if ((dst2_offset + (count * 4)) > radeon_bo_size(dst2_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2T, frame to fields buffer too small (%llu %lu)\n",
-								 dst2_offset + (count * 4), radeon_bo_size(dst2_reloc->robj));
-							return -EINVAL;
-						}
-						ib[idx+1] += (u32)(dst_reloc->lobj.gpu_offset >> 8);
-						ib[idx+2] += (u32)(dst2_reloc->lobj.gpu_offset >> 8);
-						ib[idx+8] += (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
-						ib[idx+9] += upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
-						p->idx += 10;
-						break;
-					case 1:
-						/* L2T, T2L partial */
-						if (p->family < CHIP_CAYMAN) {
-							DRM_ERROR("L2T, T2L Partial is cayman only !\n");
-							return -EINVAL;
-						}
-						/* detile bit */
-						if (idx_value & (1 << 31)) {
-							/* tiled src, linear dst */
-							ib[idx+1] += (u32)(src_reloc->lobj.gpu_offset >> 8);
-
-							ib[idx+7] += (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
-							ib[idx+8] += upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
-						} else {
-							/* linear src, tiled dst */
-							ib[idx+7] += (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
-							ib[idx+8] += upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
-
-							ib[idx+1] += (u32)(dst_reloc->lobj.gpu_offset >> 8);
-						}
-						p->idx += 12;
-						break;
-					case 3:
-						/* L2T, broadcast */
-						if (idx_value & (1 << 31)) {
-							DRM_ERROR("bad L2T, broadcast DMA_PACKET_COPY\n");
-							return -EINVAL;
-						}
-						r = r600_dma_cs_next_reloc(p, &dst2_reloc);
-						if (r) {
-							DRM_ERROR("bad L2T, broadcast DMA_PACKET_COPY\n");
-							return -EINVAL;
-						}
-						dst_offset = radeon_get_ib_value(p, idx+1);
-						dst_offset <<= 8;
-						dst2_offset = radeon_get_ib_value(p, idx+2);
-						dst2_offset <<= 8;
-						src_offset = radeon_get_ib_value(p, idx+8);
-						src_offset |= ((u64)(radeon_get_ib_value(p, idx+9) & 0xff)) << 32;
-						if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2T, broadcast src buffer too small (%llu %lu)\n",
-								 src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
-							return -EINVAL;
-						}
-						if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2T, broadcast dst buffer too small (%llu %lu)\n",
-								 dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
-							return -EINVAL;
-						}
-						if ((dst2_offset + (count * 4)) > radeon_bo_size(dst2_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2T, broadcast dst2 buffer too small (%llu %lu)\n",
-								 dst2_offset + (count * 4), radeon_bo_size(dst2_reloc->robj));
-							return -EINVAL;
-						}
-						ib[idx+1] += (u32)(dst_reloc->lobj.gpu_offset >> 8);
-						ib[idx+2] += (u32)(dst2_reloc->lobj.gpu_offset >> 8);
-						ib[idx+8] += (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
-						ib[idx+9] += upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
-						p->idx += 10;
-						break;
-					case 4:
-						/* L2T, T2L */
-						/* detile bit */
-						if (idx_value & (1 << 31)) {
-							/* tiled src, linear dst */
-							src_offset = radeon_get_ib_value(p, idx+1);
-							src_offset <<= 8;
-							ib[idx+1] += (u32)(src_reloc->lobj.gpu_offset >> 8);
-
-							dst_offset = radeon_get_ib_value(p, idx+7);
-							dst_offset |= ((u64)(radeon_get_ib_value(p, idx+8) & 0xff)) << 32;
-							ib[idx+7] += (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
-							ib[idx+8] += upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
-						} else {
-							/* linear src, tiled dst */
-							src_offset = radeon_get_ib_value(p, idx+7);
-							src_offset |= ((u64)(radeon_get_ib_value(p, idx+8) & 0xff)) << 32;
-							ib[idx+7] += (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
-							ib[idx+8] += upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
-
-							dst_offset = radeon_get_ib_value(p, idx+1);
-							dst_offset <<= 8;
-							ib[idx+1] += (u32)(dst_reloc->lobj.gpu_offset >> 8);
-						}
-						if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2T, T2L src buffer too small (%llu %lu)\n",
-								 src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
-							return -EINVAL;
-						}
-						if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2T, T2L dst buffer too small (%llu %lu)\n",
-								 dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
-							return -EINVAL;
-						}
-						p->idx += 9;
-						break;
-					case 5:
-						/* T2T partial */
-						if (p->family < CHIP_CAYMAN) {
-							DRM_ERROR("L2T, T2L Partial is cayman only !\n");
-							return -EINVAL;
-						}
-						ib[idx+1] += (u32)(src_reloc->lobj.gpu_offset >> 8);
-						ib[idx+4] += (u32)(dst_reloc->lobj.gpu_offset >> 8);
-						p->idx += 13;
-						break;
-					case 7:
-						/* L2T, broadcast */
-						if (idx_value & (1 << 31)) {
-							DRM_ERROR("bad L2T, broadcast DMA_PACKET_COPY\n");
-							return -EINVAL;
-						}
-						r = r600_dma_cs_next_reloc(p, &dst2_reloc);
-						if (r) {
-							DRM_ERROR("bad L2T, broadcast DMA_PACKET_COPY\n");
-							return -EINVAL;
-						}
-						dst_offset = radeon_get_ib_value(p, idx+1);
-						dst_offset <<= 8;
-						dst2_offset = radeon_get_ib_value(p, idx+2);
-						dst2_offset <<= 8;
-						src_offset = radeon_get_ib_value(p, idx+8);
-						src_offset |= ((u64)(radeon_get_ib_value(p, idx+9) & 0xff)) << 32;
-						if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2T, broadcast src buffer too small (%llu %lu)\n",
-								 src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
-							return -EINVAL;
-						}
-						if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2T, broadcast dst buffer too small (%llu %lu)\n",
-								 dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
-							return -EINVAL;
-						}
-						if ((dst2_offset + (count * 4)) > radeon_bo_size(dst2_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2T, broadcast dst2 buffer too small (%llu %lu)\n",
-								 dst2_offset + (count * 4), radeon_bo_size(dst2_reloc->robj));
-							return -EINVAL;
-						}
-						ib[idx+1] += (u32)(dst_reloc->lobj.gpu_offset >> 8);
-						ib[idx+2] += (u32)(dst2_reloc->lobj.gpu_offset >> 8);
-						ib[idx+8] += (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
-						ib[idx+9] += upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
-						p->idx += 10;
-						break;
-					default:
-						DRM_ERROR("bad DMA_PACKET_COPY misc %u\n", misc);
-						return -EINVAL;
-					}
-				} else {
-					switch (misc) {
-					case 0:
-						/* detile bit */
-						if (idx_value & (1 << 31)) {
-							/* tiled src, linear dst */
-							src_offset = radeon_get_ib_value(p, idx+1);
-							src_offset <<= 8;
-							ib[idx+1] += (u32)(src_reloc->lobj.gpu_offset >> 8);
-
-							dst_offset = radeon_get_ib_value(p, idx+7);
-							dst_offset |= ((u64)(radeon_get_ib_value(p, idx+8) & 0xff)) << 32;
-							ib[idx+7] += (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
-							ib[idx+8] += upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
-						} else {
-							/* linear src, tiled dst */
-							src_offset = radeon_get_ib_value(p, idx+7);
-							src_offset |= ((u64)(radeon_get_ib_value(p, idx+8) & 0xff)) << 32;
-							ib[idx+7] += (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
-							ib[idx+8] += upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
-
-							dst_offset = radeon_get_ib_value(p, idx+1);
-							dst_offset <<= 8;
-							ib[idx+1] += (u32)(dst_reloc->lobj.gpu_offset >> 8);
-						}
-						if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2T, broadcast src buffer too small (%llu %lu)\n",
-								 src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
-							return -EINVAL;
-						}
-						if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2T, broadcast dst buffer too small (%llu %lu)\n",
-								 dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
-							return -EINVAL;
-						}
-						p->idx += 9;
-						break;
-					default:
-						DRM_ERROR("bad DMA_PACKET_COPY misc %u\n", misc);
-						return -EINVAL;
-					}
-				}
-			} else {
-				if (new_cmd) {
-					switch (misc) {
-					case 0:
-						/* L2L, byte */
-						src_offset = radeon_get_ib_value(p, idx+2);
-						src_offset |= ((u64)(radeon_get_ib_value(p, idx+4) & 0xff)) << 32;
-						dst_offset = radeon_get_ib_value(p, idx+1);
-						dst_offset |= ((u64)(radeon_get_ib_value(p, idx+3) & 0xff)) << 32;
-						if ((src_offset + count) > radeon_bo_size(src_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2L, byte src buffer too small (%llu %lu)\n",
-								 src_offset + count, radeon_bo_size(src_reloc->robj));
-							return -EINVAL;
-						}
-						if ((dst_offset + count) > radeon_bo_size(dst_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2L, byte dst buffer too small (%llu %lu)\n",
-								 dst_offset + count, radeon_bo_size(dst_reloc->robj));
-							return -EINVAL;
-						}
-						ib[idx+1] += (u32)(dst_reloc->lobj.gpu_offset & 0xffffffff);
-						ib[idx+2] += (u32)(src_reloc->lobj.gpu_offset & 0xffffffff);
-						ib[idx+3] += upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
-						ib[idx+4] += upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
-						p->idx += 5;
-						break;
-					case 1:
-						/* L2L, partial */
-						if (p->family < CHIP_CAYMAN) {
-							DRM_ERROR("L2L Partial is cayman only !\n");
-							return -EINVAL;
-						}
-						ib[idx+1] += (u32)(src_reloc->lobj.gpu_offset & 0xffffffff);
-						ib[idx+2] += upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
-						ib[idx+4] += (u32)(dst_reloc->lobj.gpu_offset & 0xffffffff);
-						ib[idx+5] += upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
-
-						p->idx += 9;
-						break;
-					case 4:
-						/* L2L, dw, broadcast */
-						r = r600_dma_cs_next_reloc(p, &dst2_reloc);
-						if (r) {
-							DRM_ERROR("bad L2L, dw, broadcast DMA_PACKET_COPY\n");
-							return -EINVAL;
-						}
-						dst_offset = radeon_get_ib_value(p, idx+1);
-						dst_offset |= ((u64)(radeon_get_ib_value(p, idx+4) & 0xff)) << 32;
-						dst2_offset = radeon_get_ib_value(p, idx+2);
-						dst2_offset |= ((u64)(radeon_get_ib_value(p, idx+5) & 0xff)) << 32;
-						src_offset = radeon_get_ib_value(p, idx+3);
-						src_offset |= ((u64)(radeon_get_ib_value(p, idx+6) & 0xff)) << 32;
-						if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2L, dw, broadcast src buffer too small (%llu %lu)\n",
-								 src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
-							return -EINVAL;
-						}
-						if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2L, dw, broadcast dst buffer too small (%llu %lu)\n",
-								 dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
-							return -EINVAL;
-						}
-						if ((dst2_offset + (count * 4)) > radeon_bo_size(dst2_reloc->robj)) {
-							dev_warn(p->dev, "DMA L2L, dw, broadcast dst2 buffer too small (%llu %lu)\n",
-								 dst2_offset + (count * 4), radeon_bo_size(dst2_reloc->robj));
-							return -EINVAL;
-						}
-						ib[idx+1] += (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
-						ib[idx+2] += (u32)(dst2_reloc->lobj.gpu_offset & 0xfffffffc);
-						ib[idx+3] += (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
-						ib[idx+4] += upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
-						ib[idx+5] += upper_32_bits(dst2_reloc->lobj.gpu_offset) & 0xff;
-						ib[idx+6] += upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
-						p->idx += 7;
-						break;
-					default:
-						DRM_ERROR("bad DMA_PACKET_COPY misc %u\n", misc);
-						return -EINVAL;
-					}
-				} else {
-					/* L2L, dw */
-					src_offset = radeon_get_ib_value(p, idx+2);
-					src_offset |= ((u64)(radeon_get_ib_value(p, idx+4) & 0xff)) << 32;
-					dst_offset = radeon_get_ib_value(p, idx+1);
-					dst_offset |= ((u64)(radeon_get_ib_value(p, idx+3) & 0xff)) << 32;
-					if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
-						dev_warn(p->dev, "DMA L2L, dw src buffer too small (%llu %lu)\n",
-							 src_offset + (count * 4), radeon_bo_size(src_reloc->robj));
-						return -EINVAL;
-					}
-					if ((dst_offset + (count * 4)) > radeon_bo_size(dst_reloc->robj)) {
-						dev_warn(p->dev, "DMA L2L, dw dst buffer too small (%llu %lu)\n",
-							 dst_offset + (count * 4), radeon_bo_size(dst_reloc->robj));
-						return -EINVAL;
-					}
-					ib[idx+1] += (u32)(dst_reloc->lobj.gpu_offset & 0xfffffffc);
-					ib[idx+2] += (u32)(src_reloc->lobj.gpu_offset & 0xfffffffc);
-					ib[idx+3] += upper_32_bits(dst_reloc->lobj.gpu_offset) & 0xff;
-					ib[idx+4] += upper_32_bits(src_reloc->lobj.gpu_offset) & 0xff;
-					p->idx += 5;
-=======
 			switch (sub_cmd) {
 			/* Copy L2L, DW aligned */
 			case 0x00:
@@ -3349,7 +3005,6 @@ int evergreen_dma_cs_parse(struct radeon
 					dst_offset = ib[idx+1];
 					dst_offset <<= 8;
 					ib[idx+1] += (u32)(dst_reloc->lobj.gpu_offset >> 8);
->>>>>>> linux-next/akpm-base
 				}
 				if ((src_offset + (count * 4)) > radeon_bo_size(src_reloc->robj)) {
 					dev_warn(p->dev, "DMA L2T, T2L src buffer too small (%llu %lu)\n",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.patch
goldfish-framebuffer-driver-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix-fix.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix-fix.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
mm-rename-page-struct-field-helpers.patch
mm-rename-page-struct-field-helpers-fix.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kernel-smpc-cleanups.patch
maintainers-remove-mark-m-hoffman-fix.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
drivers-video-backlight-makefile-cleanup.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

