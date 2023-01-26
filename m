Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D929BC54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 23:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbjAZXm5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 18:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbjAZXmx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 18:42:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE2855298
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 15:42:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDA6FB81ED5
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 23:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFCFC433EF;
        Thu, 26 Jan 2023 23:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674776516;
        bh=0e1C0RdeCGcXX2g9qdu4nJPwUbwVIsmQTk5uVqHYmPM=;
        h=Date:To:From:Subject:From;
        b=XI8rBoCLTlOkQxijVwXV9XohhKDFifjbzVXxLNefO5JiwLdWEir6Bfgkk7/CyKvgW
         /BwrJOGXtrdItEmxIpE+hGGAsGQyrPh1rRONhANWS1XEfFMq9J4pie4KH91QZ10Y5m
         U2DAshgz0zl0LOGHnqePldQKjZt7cBa2Og24aMOc=
Date:   Thu, 26 Jan 2023 15:41:56 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ira.weiny@intel.com, fmdefrancesco@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-memcpy_from_file_folio-fix.patch added to mm-unstable branch
Message-Id: <20230126234156.8DFCFC433EF@smtp.kernel.org>
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

 include/linux/highmem.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/highmem.h~mm-add-memcpy_from_file_folio-fix
+++ a/include/linux/highmem.h
@@ -430,13 +430,14 @@ static inline size_t memcpy_from_file_fo
 {
 	size_t offset = offset_in_folio(folio, pos);
 	char *from = kmap_local_folio(folio, offset);
+	size_t remaining;
 
 	if (folio_test_highmem(folio))
-		len = min(len, PAGE_SIZE - offset);
+		remaining = PAGE_SIZE - offset;
 	else
-		len = min(len, folio_size(folio) - offset);
+		remaining = folio_size(folio) - offset;
 
-	memcpy(to, from, len);
+	memcpy(to, from, min(len, remaining));
 	kunmap_local(from);
 
 	return len;
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

