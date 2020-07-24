Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EA0C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E47BE20792
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595563717;
	bh=sUAoIBKKCWgj3Gv+Y9tBEQj+gyKK8qy8MGbkrKF7YU4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wTnnrTEt0YdggWQkwwEBv9vboiDfwBhBQjXHOnjDpSMjADkF1uhXILnfBOuQQcYuB
	 clerZxKUTg0xe9J7oc0OfxALdo1E4MOMUfDcNzncimq6SYO07ryvPtOHJY5tvEwgn6
	 ZNHcT4+uCGO5XqNORGasVYnOkeQ5NdNuMlLUZljE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725898AbgGXEIh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 00:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgGXEIh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 00:08:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D86620709;
        Fri, 24 Jul 2020 04:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595563717;
        bh=sUAoIBKKCWgj3Gv+Y9tBEQj+gyKK8qy8MGbkrKF7YU4=;
        h=Date:From:To:Subject:From;
        b=yoCKA9G18DBWRMhRw8y01JTSJ5D7CtmgpHB8A2DdSqfikyf4qU1G9oihsf9cxRQgH
         uoG1tLodD+xJajKxdp8re82zM4liLVJCLMX6wI+llV5lFIu+LvaXwGgeJGeIRZ1xzw
         p1C/Bf4emSwSXdXJF+/vKR5TChoiUsUgtC1wsev8=
Date:   Thu, 23 Jul 2020 21:08:36 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        chris@chris-wilson.co.uk, michael.j.ruhl@intel.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  [folded-merged]
 io-mapping-indicate-mapping-failure-fix.patch removed from -mm tree
Message-ID: <20200724040836.EjQBLzsih%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: io-mapping-indicate-mapping-failure-fix
has been removed from the -mm tree.  Its filename was
     io-mapping-indicate-mapping-failure-fix.patch

This patch was dropped because it was folded into io-mapping-indicate-mapping-failure.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: io-mapping-indicate-mapping-failure-fix

detact ioremap_wc() errors earlier

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: "Michael J. Ruhl" <michael.j.ruhl@intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io-mapping.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/include/linux/io-mapping.h~io-mapping-indicate-mapping-failure-fix
+++ a/include/linux/io-mapping.h
@@ -107,9 +107,12 @@ io_mapping_init_wc(struct io_mapping *io
 		   resource_size_t base,
 		   unsigned long size)
 {
+	iomap->iomem = ioremap_wc(base, size);
+	if (!iomap->iomem)
+		return NULL;
+
 	iomap->base = base;
 	iomap->size = size;
-	iomap->iomem = ioremap_wc(base, size);
 #if defined(pgprot_noncached_wc) /* archs can't agree on a name ... */
 	iomap->prot = pgprot_noncached_wc(PAGE_KERNEL);
 #elif defined(pgprot_writecombine)
@@ -118,7 +121,7 @@ io_mapping_init_wc(struct io_mapping *io
 	iomap->prot = pgprot_noncached(PAGE_KERNEL);
 #endif
 
-	return iomap->iomem ? iomap : NULL;
+	return iomap;
 }
 
 static inline void
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
io-mapping-indicate-mapping-failure.patch
mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
revert-revert-mm-vmalloc-modify-struct-vmap_area-to-reduce-its-size.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

