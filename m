Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F110DC25B06
	for <mm-commits@archiver.kernel.org>; Wed, 10 Aug 2022 23:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiHJXkq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Aug 2022 19:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbiHJXkh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2022 19:40:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35A7B8F
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 16:40:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AAD1B81D92
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 23:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED9EC433C1;
        Wed, 10 Aug 2022 23:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660174834;
        bh=pHFNFWeAzlHRyqxWatl8iWNdTvC4DWXlz+FpHmmbuKk=;
        h=Date:To:From:Subject:From;
        b=THdeIUExXe9ty959TiNpXXpYX27XMuKUAgQ+BJloZR7t4zVPWHJXKcyAfn89XnPkF
         4/tJc9sbWqO8FtIQgDWAFMBkAn2+vbPdVrMlnTmlMQItacyKPkVj6j6ok7QdNyMs8S
         RozvOSFVCd8aRbIRI/MRY1RMeFlwOf9VIS3hVgA8=
Date:   Wed, 10 Aug 2022 16:40:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, slava@dubeyko.com, keescook@chromium.org,
        ira.weiny@intel.com, bvanassche@acm.org, axboe@kernel.dk,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hfsplus-convert-kmap-to-kmap_local_page-in-bitmapc.patch added to mm-nonmm-unstable branch
Message-Id: <20220810234034.0ED9EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: convert kmap() to kmap_local_page() in bitmap.c
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hfsplus-convert-kmap-to-kmap_local_page-in-bitmapc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hfsplus-convert-kmap-to-kmap_local_page-in-bitmapc.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: hfsplus: convert kmap() to kmap_local_page() in bitmap.c
Date: Tue, 9 Aug 2022 22:31:04 +0200

kmap() is being deprecated in favor of kmap_local_page().

There are two main problems with kmap(): (1) It comes with an overhead as
mapping space is restricted and protected by a global lock for
synchronization and (2) it also requires global TLB invalidation when the
kmap's pool wraps and it might block when the mapping space is fully
utilized until a slot becomes available.

With kmap_local_page() the mappings are per thread, CPU local, can take
page faults, and can be called from any context (including interrupts). 
It is faster than kmap() in kernels with HIGHMEM enabled.  Furthermore,
the tasks can be preempted and, when they are scheduled to run again, the
kernel virtual addresses are restored and are still valid.

Since its use in bitmap.c is safe everywhere, it should be preferred.

Therefore, replace kmap() with kmap_local_page() in bitmap.c.

Tested in a QEMU/KVM x86_32 VM, 6GB RAM, booting a kernel with
HIGHMEM64GB enabled.

Link: https://lkml.kernel.org/r/20220809203105.26183-4-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/bitmap.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/fs/hfsplus/bitmap.c~hfsplus-convert-kmap-to-kmap_local_page-in-bitmapc
+++ a/fs/hfsplus/bitmap.c
@@ -39,7 +39,7 @@ int hfsplus_block_allocate(struct super_
 		start = size;
 		goto out;
 	}
-	pptr = kmap(page);
+	pptr = kmap_local_page(page);
 	curr = pptr + (offset & (PAGE_CACHE_BITS - 1)) / 32;
 	i = offset % 32;
 	offset &= ~(PAGE_CACHE_BITS - 1);
@@ -74,7 +74,7 @@ int hfsplus_block_allocate(struct super_
 			}
 			curr++;
 		}
-		kunmap(page);
+		kunmap_local(pptr);
 		offset += PAGE_CACHE_BITS;
 		if (offset >= size)
 			break;
@@ -84,7 +84,7 @@ int hfsplus_block_allocate(struct super_
 			start = size;
 			goto out;
 		}
-		curr = pptr = kmap(page);
+		curr = pptr = kmap_local_page(page);
 		if ((size ^ offset) / PAGE_CACHE_BITS)
 			end = pptr + PAGE_CACHE_BITS / 32;
 		else
@@ -127,7 +127,7 @@ found:
 			len -= 32;
 		}
 		set_page_dirty(page);
-		kunmap(page);
+		kunmap_local(pptr);
 		offset += PAGE_CACHE_BITS;
 		page = read_mapping_page(mapping, offset / PAGE_CACHE_BITS,
 					 NULL);
@@ -135,7 +135,7 @@ found:
 			start = size;
 			goto out;
 		}
-		pptr = kmap(page);
+		pptr = kmap_local_page(page);
 		curr = pptr;
 		end = pptr + PAGE_CACHE_BITS / 32;
 	}
@@ -151,7 +151,7 @@ last:
 done:
 	*curr = cpu_to_be32(n);
 	set_page_dirty(page);
-	kunmap(page);
+	kunmap_local(pptr);
 	*max = offset + (curr - pptr) * 32 + i - start;
 	sbi->free_blocks -= *max;
 	hfsplus_mark_mdb_dirty(sb);
@@ -185,7 +185,7 @@ int hfsplus_block_free(struct super_bloc
 	page = read_mapping_page(mapping, pnr, NULL);
 	if (IS_ERR(page))
 		goto kaboom;
-	pptr = kmap(page);
+	pptr = kmap_local_page(page);
 	curr = pptr + (offset & (PAGE_CACHE_BITS - 1)) / 32;
 	end = pptr + PAGE_CACHE_BITS / 32;
 	len = count;
@@ -215,11 +215,11 @@ int hfsplus_block_free(struct super_bloc
 		if (!count)
 			break;
 		set_page_dirty(page);
-		kunmap(page);
+		kunmap_local(pptr);
 		page = read_mapping_page(mapping, ++pnr, NULL);
 		if (IS_ERR(page))
 			goto kaboom;
-		pptr = kmap(page);
+		pptr = kmap_local_page(page);
 		curr = pptr;
 		end = pptr + PAGE_CACHE_BITS / 32;
 	}
@@ -231,7 +231,7 @@ done:
 	}
 out:
 	set_page_dirty(page);
-	kunmap(page);
+	kunmap_local(pptr);
 	sbi->free_blocks += len;
 	hfsplus_mark_mdb_dirty(sb);
 	mutex_unlock(&sbi->alloc_mutex);
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

hfsplus-unmap-the-page-in-the-fail_page-label.patch
hfsplus-convert-kmap-to-kmap_local_page-in-bnodec.patch
hfsplus-convert-kmap-to-kmap_local_page-in-bitmapc.patch
hfsplus-convert-kmap-to-kmap_local_page-in-btreec.patch

