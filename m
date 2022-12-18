Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 869F9C4332F
	for <mm-commits@archiver.kernel.org>; Sun, 18 Dec 2022 00:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiLRAQN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Dec 2022 19:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiLRAQL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 17 Dec 2022 19:16:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B4626C5
        for <mm-commits@vger.kernel.org>; Sat, 17 Dec 2022 16:16:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4812060C50
        for <mm-commits@vger.kernel.org>; Sun, 18 Dec 2022 00:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AF0C433F0;
        Sun, 18 Dec 2022 00:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671322568;
        bh=AkmMinGJ7xaUTpv2OqaatDnvN+SLUTFxrV52xzQQqWk=;
        h=Date:To:From:Subject:From;
        b=vnVdYbTE9vBVnzTgzaSehYXXzAihU290X6fggsrUzph0XJCqchHsbWBkv7SHl7s7V
         D+V+Dax8otAi8oAISQP2TYxVxrXF1k0DvAcBJ8OL5xIAG9zVaRaE7qxgnGkzGVufay
         YmHr+6A0hUyGlvmVmEKIfLtkW/4f0pYsw0flC1T0=
Date:   Sat, 17 Dec 2022 16:16:07 -0800
To:     mm-commits@vger.kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-remove-unused-alloc_pages_bulk_list.patch removed from -mm tree
Message-Id: <20221218001608.95AF0C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove unused alloc_pages_bulk_list()
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-alloc_pages_bulk_list.patch

This patch was dropped because it is obsolete

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

