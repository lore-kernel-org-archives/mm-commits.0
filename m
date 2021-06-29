Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 506BDC11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A22661D0E
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhF2Cl0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231682AbhF2ClY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:41:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1B9561D08;
        Tue, 29 Jun 2021 02:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934337;
        bh=XYxKEv75dOATf3c+E+UmLWopid90eLhROO8f/EVOQDw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0cOV1H8VaBM3nTZTCtUvfMaEB23QcDtnGW86jLV60cUUsIm+8GcaSqBK/8g4UZpmn
         HgHM/mMRiJw2z8DFywNsaaSZtDexUJpsbWbL621wWdA460aKfjSDTK75EdIFEAo/Pi
         ZL13XfzW0FNgZsVBKYoaangv/OzUavyi0mXYKttA=
Date:   Mon, 28 Jun 2021 19:38:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 107/192] arch/arc/kernel/troubleshoot: use
 vma_lookup() instead of find_vma()
Message-ID: <20210629023856.1G3b63JAG%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: arch/arc/kernel/troubleshoot: use vma_lookup() instead of find_vma()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-4-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/troubleshoot.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arc/kernel/troubleshoot.c~arch-arc-kernel-troubleshoot-use-vma_lookup-instead-of-find_vma
+++ a/arch/arc/kernel/troubleshoot.c
@@ -83,12 +83,12 @@ static void show_faulting_vma(unsigned l
 	 * non-inclusive vma
 	 */
 	mmap_read_lock(active_mm);
-	vma = find_vma(active_mm, address);
+	vma = vma_lookup(active_mm, address);
 
-	/* check against the find_vma( ) behaviour which returns the next VMA
-	 * if the container VMA is not found
+	/* Lookup the vma at the address and report if the container VMA is not
+	 * found
 	 */
-	if (vma && (vma->vm_start <= address)) {
+	if (vma) {
 		char buf[ARC_PATH_MAX];
 		char *nm = "?";
 
_
