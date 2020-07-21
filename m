Return-Path: <SRS0=3Kjr=BA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70797C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 20:57:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F62420729
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 20:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595365042;
	bh=PLyRkYp7f7PKtu9dQ3Cgyt4ctdmAWy9BRab2D5mBx+Q=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=BNtiWUIjksUxwCvFJvCsdJPly3lFzz6meFCDuT/hbto528+6dc1kJCT0z6q6I/+ln
	 tYnPOg5GFjLQU6oE4LaMUidVorEOeW8h5jQ0Ys9tA/ChNKzvW3xH1jg+1DdbF+qXIk
	 utyN++lhJ9ab69OP2HsHqY1NXztGmM0y+1BZMW9k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbgGUU5W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jul 2020 16:57:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbgGUU5V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Jul 2020 16:57:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2EDD2072E;
        Tue, 21 Jul 2020 20:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595365041;
        bh=PLyRkYp7f7PKtu9dQ3Cgyt4ctdmAWy9BRab2D5mBx+Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=g1YjUjoF/h81UgOiMJ0rstkEXG0JTzJQGPGzQjfrm8g9U399D0CYg/YYwcltAyZA5
         jEjY03jb9okl2eh5/leD8ddLni2DfUlwGxEtKggAgDxIN25Swt/wzpGV/cc/fZvoMB
         nVoDue0PpVXMo1osRBRiThHZ9TzblUMyeRVu48P4=
Date:   Tue, 21 Jul 2020 13:57:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        chris@chris-wilson.co.uk, michael.j.ruhl@intel.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  + io-mapping-indicate-mapping-failure-fix.patch added to
 -mm tree
Message-ID: <20200721205720.kZL87fwFf%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: io-mapping-indicate-mapping-failure-fix
has been added to the -mm tree.  Its filename is
     io-mapping-indicate-mapping-failure-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/io-mapping-indicate-mapping-failure-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/io-mapping-indicate-mapping-failure-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix.patch
io-mapping-indicate-mapping-failure-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

