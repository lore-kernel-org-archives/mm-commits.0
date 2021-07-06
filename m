Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A07AC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78B2860FEE
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhGFTPR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231803AbhGFTPR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E7E660FE3;
        Tue,  6 Jul 2021 19:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598758;
        bh=xP8Xj1oKci7nOpXXjZZCivd6eVDGsCPllqD91n5nrNI=;
        h=Date:From:To:Subject:From;
        b=o1l8oSYwS84j+AFL91ruZeyBvJnjAVPgUKwbe91fnC9Tn+w33+2xL7VGq6K6F9EFs
         HPraI+OoBP/wf4cJiQCkzMhNDF33jqo+9IKZo1FqL3l3XdEonw9SZlfxvGq7gRE/2u
         yeqcPQGnlLOxK/F9a+82KScUxYG9bvKoGLU4LlyQ=
Date:   Tue, 06 Jul 2021 12:12:38 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged] x86-sgx-use-vma_lookup-in-sgx_encl_find.patch
 removed from -mm tree
Message-ID: <20210706191238.cds_4nwri%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/sgx: use vma_lookup() in sgx_encl_find()
has been removed from the -mm tree.  Its filename was
     x86-sgx-use-vma_lookup-in-sgx_encl_find.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: x86/sgx: use vma_lookup() in sgx_encl_find()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-10-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/sgx/encl.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/sgx/encl.h~x86-sgx-use-vma_lookup-in-sgx_encl_find
+++ a/arch/x86/kernel/cpu/sgx/encl.h
@@ -91,8 +91,8 @@ static inline int sgx_encl_find(struct m
 {
 	struct vm_area_struct *result;
 
-	result = find_vma(mm, addr);
-	if (!result || result->vm_ops != &sgx_vm_ops || addr < result->vm_start)
+	result = vma_lookup(mm, addr);
+	if (!result || result->vm_ops != &sgx_vm_ops)
 		return -EINVAL;
 
 	*vma = result;
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


