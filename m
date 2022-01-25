Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345DFC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 03:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S246353AbiAYDqs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 22:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1311730AbiAYClN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 21:41:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F233BC0AD1A7
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 16:09:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF846B81600
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 00:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A86C340E4;
        Tue, 25 Jan 2022 00:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643069385;
        bh=CM8KbDYGNZditYccJyGI92Fi7othHo5T96AFOBr4MRs=;
        h=Date:From:To:Subject:From;
        b=m9kqz4U2H8a2asX7+uUAWNRAxv2vEj1sUzBDghVtCfa9sMfkwHHpWug6SXEZdpTwp
         QW8SwcXt+jgXXkql9HsepbPgszhkLbfedUD1Ji3Jv4da0usbKsJf4ZkiBqyLFbytjd
         5MFm4kXL1RUpPXwsjieTtSEGE1m9oDN3wDTEp5N8=
Date:   Mon, 24 Jan 2022 16:09:44 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, hbathini@linux.ibm.com, mahesh@linux.ibm.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, osalvador@suse.de, sourabhjain@linux.ibm.com
Subject:  +
 =?US-ASCII?Q?mm-cma-provide-option-to-opt-out-from-exposing-pages-on-acti?=
 =?US-ASCII?Q?vation-failure.patch?= added to -mm tree
Message-ID: <20220125000944.sj48Pegoj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: provide option to opt out from exposing pages on activation failure
has been added to the -mm tree.  Its filename is
     mm-cma-provide-option-to-opt-out-from-exposing-pages-on-activation-failure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-provide-option-to-opt-out-from-exposing-pages-on-activation-failure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-provide-option-to-opt-out-from-exposing-pages-on-activation-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hari Bathini <hbathini@linux.ibm.com>
Subject: mm/cma: provide option to opt out from exposing pages on activation failure

Patch series "powerpc/fadump: handle CMA activation failure appropriately", v3.

Commit 072355c1cf2d ("mm/cma: expose all pages to the buddy if activation
of an area fails") started exposing all pages to buddy allocator on CMA
activation failure.  But there can be CMA users that want to handle the
reserved memory differently on CMA allocation failure.  Provide an option
to opt out from exposing pages to buddy for such cases.

Link: https://lkml.kernel.org/r/20220117075246.36072-1-hbathini@linux.ibm.com
Link: https://lkml.kernel.org/r/20220117075246.36072-2-hbathini@linux.ibm.com
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    2 ++
 mm/cma.c            |   11 +++++++++--
 mm/cma.h            |    1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/include/linux/cma.h~mm-cma-provide-option-to-opt-out-from-exposing-pages-on-activation-failure
+++ a/include/linux/cma.h
@@ -50,4 +50,6 @@ extern bool cma_pages_valid(struct cma *
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
 
 extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
+
+extern void cma_reserve_pages_on_error(struct cma *cma);
 #endif
--- a/mm/cma.c~mm-cma-provide-option-to-opt-out-from-exposing-pages-on-activation-failure
+++ a/mm/cma.c
@@ -131,8 +131,10 @@ not_in_zone:
 	bitmap_free(cma->bitmap);
 out_error:
 	/* Expose all pages to the buddy, they are useless for CMA. */
-	for (pfn = base_pfn; pfn < base_pfn + cma->count; pfn++)
-		free_reserved_page(pfn_to_page(pfn));
+	if (!cma->reserve_pages_on_error) {
+		for (pfn = base_pfn; pfn < base_pfn + cma->count; pfn++)
+			free_reserved_page(pfn_to_page(pfn));
+	}
 	totalcma_pages -= cma->count;
 	cma->count = 0;
 	pr_err("CMA area %s could not be activated\n", cma->name);
@@ -150,6 +152,11 @@ static int __init cma_init_reserved_area
 }
 core_initcall(cma_init_reserved_areas);
 
+void __init cma_reserve_pages_on_error(struct cma *cma)
+{
+	cma->reserve_pages_on_error = true;
+}
+
 /**
  * cma_init_reserved_mem() - create custom contiguous area from reserved memory
  * @base: Base address of the reserved area
--- a/mm/cma.h~mm-cma-provide-option-to-opt-out-from-exposing-pages-on-activation-failure
+++ a/mm/cma.h
@@ -30,6 +30,7 @@ struct cma {
 	/* kobject requires dynamic object */
 	struct cma_kobject *cma_kobj;
 #endif
+	bool reserve_pages_on_error;
 };
 
 extern struct cma cma_areas[MAX_CMA_AREAS];
_

Patches currently in -mm which might be from hbathini@linux.ibm.com are

mm-cma-provide-option-to-opt-out-from-exposing-pages-on-activation-failure.patch
powerpc-fadump-opt-out-from-freeing-pages-on-cma-activation-failure.patch

