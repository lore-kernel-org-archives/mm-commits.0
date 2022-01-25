Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A041CC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 01:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S3411707AbiAYAec (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 19:34:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47292 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2371817AbiAYAJz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 19:09:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E626261496
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 00:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CCFC340F7;
        Tue, 25 Jan 2022 00:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643069388;
        bh=KQ+4NexEHs7I3A3HHphuXd/uQw66dQcRxyUvOf7BA3s=;
        h=Date:From:To:Subject:From;
        b=NFOvj3q+pm0VG3wj/B80F8c+OZbp5Sg2+e4XPC4bEXkrnxuBCAUkvXDnf1n17/k8I
         Ytfehtnw7PCDT3+/rqGOtnA9Gu5K0Xz0Kp8nkO0ivrWF00rN+XYRTXeKMmm6v8qBAN
         RVSmX6v7vV2IoGfFXV3czbhsSbEJragx1D4HbAfA=
Date:   Mon, 24 Jan 2022 16:09:47 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, hbathini@linux.ibm.com, mahesh@linux.ibm.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, osalvador@suse.de, sourabhjain@linux.ibm.com
Subject:  +
 powerpc-fadump-opt-out-from-freeing-pages-on-cma-activation-failure.patch
 added to -mm tree
Message-ID: <20220125000947.aFI4Aw_oK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/fadump: opt out from freeing pages on cma activation failure
has been added to the -mm tree.  Its filename is
     powerpc-fadump-opt-out-from-freeing-pages-on-cma-activation-failure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/powerpc-fadump-opt-out-from-freeing-pages-on-cma-activation-failure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/powerpc-fadump-opt-out-from-freeing-pages-on-cma-activation-failure.patch

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
Subject: powerpc/fadump: opt out from freeing pages on cma activation failure

With commit a4e92ce8e4c8 ("powerpc/fadump: Reservationless firmware
assisted dump"), Linux kernel's Contiguous Memory Allocator (CMA) based
reservation was introduced in fadump.  That change was aimed at using CMA
to let applications utilize the memory reserved for fadump while blocking
it from being used for kernel pages.  The assumption was, even if CMA
activation fails for whatever reason, the memory still remains reserved to
avoid it from being used for kernel pages.  But commit 072355c1cf2d
("mm/cma: expose all pages to the buddy if activation of an area fails")
breaks this assumption as it started exposing all pages to buddy allocator
on CMA activation failure.  It led to warning messages like below while
running crash-utility on vmcore of a kernel having above two commits:

  crash: seek error: kernel virtual address: <from reserved region>

To fix this problem, opt out from exposing pages to buddy allocator on CMA
activation failure for fadump reserved memory.

Link: https://lkml.kernel.org/r/20220117075246.36072-3-hbathini@linux.ibm.com
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/fadump.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/powerpc/kernel/fadump.c~powerpc-fadump-opt-out-from-freeing-pages-on-cma-activation-failure
+++ a/arch/powerpc/kernel/fadump.c
@@ -113,6 +113,12 @@ static int __init fadump_cma_init(void)
 	}
 
 	/*
+	 *  If CMA activation fails, keep the pages reserved, instead of
+	 *  exposing them to buddy allocator. Same as 'fadump=nocma' case.
+	 */
+	cma_reserve_pages_on_error(fadump_cma);
+
+	/*
 	 * So we now have successfully initialized cma area for fadump.
 	 */
 	pr_info("Initialized 0x%lx bytes cma area at %ldMB from 0x%lx "
_

Patches currently in -mm which might be from hbathini@linux.ibm.com are

mm-cma-provide-option-to-opt-out-from-exposing-pages-on-activation-failure.patch
powerpc-fadump-opt-out-from-freeing-pages-on-cma-activation-failure.patch

