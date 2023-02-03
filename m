Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C6AC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjBCFhz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjBCFhy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:37:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD7646142
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:37:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5743BB828B2
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EF8C4339B;
        Fri,  3 Feb 2023 05:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675402671;
        bh=lychMQp8LLXLiau5D9U/4sjAQ64ZhSCXplMofxh3p7I=;
        h=Date:To:From:Subject:From;
        b=sIcp5RHYUVB09nGthsDZ810zJcxgkC/htZiiX3q5Ns7j2dDtpbfPndY+F5dhHAkIF
         O0pGTssEGFVS94A6CiDqim73Vxz4TY3Kt9uNpgHrFsdDrj9KdI7wvBmqPFMiWGe7pv
         1qbUtUE0MS46UfX6d+m3MLTV2+razI1TYHc9svQ8=
Date:   Thu, 02 Feb 2023 21:37:50 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-folio_add_new_anon_rmap-fix.patch removed from -mm tree
Message-Id: <20230203053751.04EF8C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-add-folio_add_new_anon_rmap-fix
has been removed from the -mm tree.  Its filename was
     mm-add-folio_add_new_anon_rmap-fix.patch

This patch was dropped because it was folded into mm-add-folio_add_new_anon_rmap.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-folio_add_new_anon_rmap-fix
Date: Wed Jan 11 02:11:45 PM PST 2023

Fix NOMMU build.  page_add_new_anon_rmap() requires CONFIG_MMU.

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/folio-compat.c~mm-add-folio_add_new_anon_rmap-fix
+++ a/mm/folio-compat.c
@@ -124,6 +124,7 @@ void putback_lru_page(struct page *page)
 	folio_putback_lru(page_folio(page));
 }
 
+#ifdef CONFIG_MMU
 void page_add_new_anon_rmap(struct page *page, struct vm_area_struct *vma,
 		unsigned long address)
 {
@@ -131,3 +132,4 @@ void page_add_new_anon_rmap(struct page
 
 	return folio_add_new_anon_rmap((struct folio *)page, vma, address);
 }
+#endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fsdax-dax_unshare_iter-should-return-a-valid-length-fix.patch
revert-squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch
mm-add-folio_add_new_anon_rmap.patch
mm-remove-page_evictable-fix.patch
mm-remove-the-swap_readpage-return-value-fix.patch
block-remove-rw_page-fix.patch
mm-add-memcpy_from_file_folio-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

