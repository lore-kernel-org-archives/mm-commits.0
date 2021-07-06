Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726C6C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E0F960FEE
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhGFTPd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231784AbhGFTPd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C52A60C3D;
        Tue,  6 Jul 2021 19:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598774;
        bh=SJH9rnLjFBn/R/DVbviHAo5JYObp6fBIyc336nBsCt8=;
        h=Date:From:To:Subject:From;
        b=SxvmZrbI3FJ2SrFLYfH4x8Z2KYND5BhMzInfeYmNZVn0P1fIF7VxmQiklwAdPvE52
         kU2omTV+OwuDP+jQ6+EuS96ghqyNNSouMWpMBzo+Nze1UFmObEW0vtMrS+QLCpWmg9
         cUahJlwhlcyLab9xbngj1gGo+l7fChYGxdKgqmQ8=
Date:   Tue, 06 Jul 2021 12:12:54 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 lib-test_hmm-use-vma_lookup-in-dmirror_migrate.patch removed from -mm tree
Message-ID: <20210706191254.a6pHonjgB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_hmm: use vma_lookup() in dmirror_migrate()
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-use-vma_lookup-in-dmirror_migrate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: lib/test_hmm: use vma_lookup() in dmirror_migrate()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-18-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-use-vma_lookup-in-dmirror_migrate
+++ a/lib/test_hmm.c
@@ -686,9 +686,8 @@ static int dmirror_migrate(struct dmirro
 
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
-		vma = find_vma(mm, addr);
-		if (!vma || addr < vma->vm_start ||
-		    !(vma->vm_flags & VM_READ)) {
+		vma = vma_lookup(mm, addr);
+		if (!vma || !(vma->vm_flags & VM_READ)) {
 			ret = -EINVAL;
 			goto out;
 		}
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


