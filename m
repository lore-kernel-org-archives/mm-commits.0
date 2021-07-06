Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12F6C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAA8661057
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhGFTPo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231701AbhGFTPo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68E0960FEE;
        Tue,  6 Jul 2021 19:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598784;
        bh=0xzs7sZ2sCKboBGpLmij4VaH4VY1vq29nNIRwcjd1TA=;
        h=Date:From:To:Subject:From;
        b=qoCDQnWn60J5w+TEi8aDpQIoJQOwpigDmSynCCVi0ovXS6Y1y8gv15GrDnRbHEgur
         pg+xQnAMqHaw4VDaf7NX/qZ0ILmnpafMz+5zaQEzNtSRpMxpeZQeeRTWKMNkY1S4jQ
         m+lI2tQzFBphYHyMAi4b0JQE6E2Y+82pgJ+rTgnY=
Date:   Tue, 06 Jul 2021 12:13:04 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-mempolicy-use-vma_lookup-in-__access_remote_vm.patch removed from -mm
 tree
Message-ID: <20210706191304.cGGidiLe9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: use vma_lookup() in __access_remote_vm()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-use-vma_lookup-in-__access_remote_vm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mempolicy: use vma_lookup() in __access_remote_vm()

vma_lookup() finds the vma of a specific address with a cleaner interface
and is more readable.

Link: https://lkml.kernel.org/r/20210521174745.2219620-23-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-vma_lookup-in-__access_remote_vm
+++ a/mm/mempolicy.c
@@ -975,7 +975,7 @@ static long do_get_mempolicy(int *policy
 		 * want to return MPOL_DEFAULT in this case.
 		 */
 		mmap_read_lock(mm);
-		vma = find_vma_intersection(mm, addr, addr+1);
+		vma = vma_lookup(mm, addr);
 		if (!vma) {
 			mmap_read_unlock(mm);
 			return -EFAULT;
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


