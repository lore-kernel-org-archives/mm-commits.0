Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FF1C54EAA
	for <mm-commits@archiver.kernel.org>; Fri, 27 Jan 2023 03:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbjA0DVR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 22:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjA0DVQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 22:21:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEAD6225F
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 19:21:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16866B81F7D
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2023 03:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19A4C4339B;
        Fri, 27 Jan 2023 03:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674789672;
        bh=3OLKLZkKHQvslF2YGFkKEpj7CNa4+Q6svoHt5qumBFk=;
        h=Date:To:From:Subject:From;
        b=YvJs+uf87mbg+F5Vf4OFoEAt+Imdlh+rNYyVT2tBSnUQRZJ6D5J7h+HR70NzGPx6o
         6HZVPrmOFIASNGFZ2IDRgpbvBh2z4Lq+TXDgh+inoms8DnTKAqFrGyb5sYwq9BWzWa
         1yy1f9zkqcibF7WEL2/q/e07+RAYlZPx8uJAS5kw=
Date:   Thu, 26 Jan 2023 19:21:11 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ira.weiny@intel.com, fmdefrancesco@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-memcpy_from_file_folio-fix.patch added to mm-unstable branch
Message-Id: <20230127032112.B19A4C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-memcpy_from_file_folio-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-memcpy_from_file_folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-memcpy_from_file_folio-fix.patch

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

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
mm-remove-the-swap_readpage-return-value-fix.patch
block-remove-rw_page-fix.patch
mm-add-memcpy_from_file_folio-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch

