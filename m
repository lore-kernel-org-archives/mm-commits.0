Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 782F4C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EDE060FE3
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhGFTPf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231773AbhGFTPf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CD1360FEE;
        Tue,  6 Jul 2021 19:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598776;
        bh=UM/m/Q/cTkuJbXdpV8K0uxUM1I9+yNImmYSm49Y7wO0=;
        h=Date:From:To:Subject:From;
        b=XJRBpKawk7KarhsdY11tdCoo7D/KJtLvZGSx9hjlaKM5GRaAMkUdqgmEPrGqtnBPF
         XqAwwtdK7piqsmWwMisa0Np6VgdyM+u6t0GessECwVF/P4R4p8iyaAyaJj/A5MTysE
         XUAcAtyMSmLuVBOkYuwvI0BuILYsBuQsLS6BDBNE=
Date:   Tue, 06 Jul 2021 12:12:56 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-ksm-use-vma_lookup-in-find_mergeable_vma.patch removed from -mm tree
Message-ID: <20210706191256.hv_gGpGG2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: use vma_lookup() in find_mergeable_vma()
has been removed from the -mm tree.  Its filename was
     mm-ksm-use-vma_lookup-in-find_mergeable_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/ksm: use vma_lookup() in find_mergeable_vma()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-19-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/ksm.c~mm-ksm-use-vma_lookup-in-find_mergeable_vma
+++ a/mm/ksm.c
@@ -521,10 +521,8 @@ static struct vm_area_struct *find_merge
 	struct vm_area_struct *vma;
 	if (ksm_test_exit(mm))
 		return NULL;
-	vma = find_vma(mm, addr);
-	if (!vma || vma->vm_start > addr)
-		return NULL;
-	if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
+	vma = vma_lookup(mm, addr);
+	if (!vma || !(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 		return NULL;
 	return vma;
 }
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


