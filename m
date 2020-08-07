Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 888F3C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60F952177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779923;
	bh=k67lGesIiirbz10D158O50wTsZTRranX/XJ6ZN+yVls=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=kw+tPrx9kbiCViu/PFkqjtRkmU38QdKrXLLQrOvhm1O4ATf0nejCBlWQAymISKD7A
	 Xr1XVK4iH8wZaEo7WggMi86cbtODgnGX6PNryJ69jn5MT5AeBgXpbGzSTX+mqTe3e9
	 aPas1YGAyHyp3mD5m2e999IedwgoPR0Z/92Z8IRY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgHGF6n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGF6m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:58:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28FB721744;
        Fri,  7 Aug 2020 05:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779922;
        bh=k67lGesIiirbz10D158O50wTsZTRranX/XJ6ZN+yVls=;
        h=Date:From:To:Subject:From;
        b=SLOeKJSdxz3yzxfo39K+rDNgKY/3AlcdIoUsdYLSysA75PLsgtpdJzai+LewJMWQi
         BJGw1VB+O/iBdWhqN3W3aVhYmjzCve1T5uqcLrPDDZq0CETvuNkRGopixjh4nfcWdB
         WtiK5WzB7INzS0ZmAhv2ai0VPBTW2R+cWeP7etH0=
Date:   Thu, 06 Aug 2020 22:58:41 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, grandmaster@al2klimov.de,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [folded-merged]
 mm-thp-replace-http-links-with-https-ones-fix.patch removed from -mm tree
Message-ID: <20200807055841.UZJ3tqFOH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-replace-http-links-with-https-ones-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-replace-http-links-with-https-ones-fix.patch

This patch was dropped because it was folded into mm-thp-replace-http-links-with-https-ones.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-replace-http-links-with-https-ones-fix

fix amd.com URL, per Vlastimil

Cc: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-thp-replace-http-links-with-https-ones-fix
+++ a/mm/huge_memory.c
@@ -2066,8 +2066,8 @@ static void __split_huge_pmd_locked(stru
 	 * free), userland could trigger a small page size TLB miss on the
 	 * small sized TLB while the hugepage TLB entry is still established in
 	 * the huge TLB. Some CPU doesn't like that.
-	 * See https://support.amd.com/us/Processor_TechDocs/41322.pdf, Erratum
-	 * 383 on page 93. Intel should be safe but is also warns that it's
+	 * See http://support.amd.com/TechDocs/41322_10h_Rev_Gd.pdf, Erratum
+	 * 383 on page 105. Intel should be safe but is also warns that it's
 	 * only safe if the permission and cache attributes of the two entries
 	 * loaded in the two TLB is identical (which should be the case here).
 	 * But it is generally safer to never allow small and huge TLB entries
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-thp-replace-http-links-with-https-ones.patch
mm.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-hugetlb-add-mempolicy-check-in-the-reservation-routine-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

