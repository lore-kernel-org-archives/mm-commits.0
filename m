Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6042EC4332F
	for <mm-commits@archiver.kernel.org>; Sat, 17 Dec 2022 00:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiLQAj2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 19:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLQAj0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 19:39:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010021F2E4
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 16:39:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF895B81DC6
        for <mm-commits@vger.kernel.org>; Sat, 17 Dec 2022 00:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475D9C433EF;
        Sat, 17 Dec 2022 00:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671237563;
        bh=YUirzEm36WBDzPtmRr5/qovsefLg+vIiRtsF6T7sfmw=;
        h=Date:To:From:Subject:From;
        b=VEBHkcELquCAgPw2KEiN61MjKQRliB2sUcwdcTzblWifMf7bpj7VSMizPAT6z3Q/x
         dy1dBSI1uHWSMcRODLNyeMO3q9BAGHoai4NI/wcna6ucni91N18GEXLO6bTyR18gym
         21rGizAB7Co0UhDWLEUyNn9TJ+VDary5/L4VXDgc=
Date:   Fri, 16 Dec 2022 16:39:22 -0800
To:     mm-commits@vger.kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unused-alloc_pages_bulk_list.patch added to mm-unstable branch
Message-Id: <20221217003923.475D9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unused alloc_pages_bulk_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-unused-alloc_pages_bulk_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unused-alloc_pages_bulk_list.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: remove unused alloc_pages_bulk_list()
Date: Sat, 17 Dec 2022 00:15:54 +0000

This function is not referenced anywhere else in the kernel, remove it.

Link: https://lkml.kernel.org/r/20221217001554.554913-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/include/linux/gfp.h~mm-remove-unused-alloc_pages_bulk_list
+++ a/include/linux/gfp.h
@@ -188,13 +188,6 @@ unsigned long alloc_pages_bulk_array_mem
 				unsigned long nr_pages,
 				struct page **page_array);
 
-/* Bulk allocate order-0 pages */
-static inline unsigned long
-alloc_pages_bulk_list(gfp_t gfp, unsigned long nr_pages, struct list_head *list)
-{
-	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list, NULL);
-}
-
 static inline unsigned long
 alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **page_array)
 {
_

Patches currently in -mm which might be from lstoakes@gmail.com are

selftest-vm-add-mremap-expand-merge-offset-test.patch
mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch
mm-remove-unused-alloc_pages_bulk_list.patch

