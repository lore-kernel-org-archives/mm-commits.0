Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904ADC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbjBCFtN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbjBCFtJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:49:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFF78AC18
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:49:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 660D861D1F
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0BFC433D2;
        Fri,  3 Feb 2023 05:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675403345;
        bh=v7+xsJu6cRlJbAmOYO/Di7wDA17D9KCqZcgZzybPxYo=;
        h=Date:To:From:Subject:From;
        b=EUL6JY/NxbFIR+OPgs6oob3c1L571NZp7FNzpvdxw4wP7NxLQ9RdxHAIeZVdnbYjL
         hJ1OY2lyBXLvPHCmEWdlyU6dSYHTpkenAJ8kalchyuSHyGZ3PrpRdLf4YLt25JpWtF
         21nqEniCkjDAfZtET5+WjrE9odgV1CrfDMVd45Z4=
Date:   Thu, 02 Feb 2023 21:49:05 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ira.weiny@intel.com, fmdefrancesco@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-memcpy_from_file_folio-fix.patch removed from -mm tree
Message-Id: <20230203054905.BF0BFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-add-memcpy_from_file_folio-fix
has been removed from the -mm tree.  Its filename was
     mm-add-memcpy_from_file_folio-fix.patch

This patch was dropped because it was folded into mm-add-memcpy_from_file_folio.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-memcpy_from_file_folio-fix
Date: Thu Jan 26 03:36:39 PM PST 2023

Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/highmem.h~mm-add-memcpy_from_file_folio-fix
+++ a/include/linux/highmem.h
@@ -432,7 +432,7 @@ static inline size_t memcpy_from_file_fo
 	char *from = kmap_local_folio(folio, offset);
 
 	if (folio_test_highmem(folio))
-		len = min(len, PAGE_SIZE - offset);
+		len = min_t(size_t, len, PAGE_SIZE - offset);
 	else
 		len = min(len, folio_size(folio) - offset);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fsdax-dax_unshare_iter-should-return-a-valid-length-fix.patch
revert-squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch
mm-add-memcpy_from_file_folio.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

