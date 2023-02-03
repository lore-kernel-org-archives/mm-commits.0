Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE10C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjBCGor (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbjBCGnV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:43:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4230D91181
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0CB361D99
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3246FC4339C;
        Fri,  3 Feb 2023 06:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406330;
        bh=zsstVWSOM+bDqSYzeal3U2wFX3KuXfaSidUgFoZ7Te8=;
        h=Date:To:From:Subject:From;
        b=uM2uhr3j/+7rVMGD4sib7E4ap3skbggcwvUQ8jM4gc4ugOiVxvLG6MdsQ1EzEo2N7
         eEidCCe/O3xXuTbCCFnxtLvitJVuw0RuvT4P6eTgFnZA20DBKLksQEUBobHILRK6J/
         Oi/BX5AP7wf2Fv6Y9SJwBLcYTaz/bcAIAET7/K5A=
Date:   Thu, 02 Feb 2023 22:38:49 -0800
To:     mm-commits@vger.kernel.org, ira.weiny@intel.com,
        fmdefrancesco@gmail.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-memcpy_from_file_folio.patch removed from -mm tree
Message-Id: <20230203063850.3246FC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add memcpy_from_file_folio()
has been removed from the -mm tree.  Its filename was
     mm-add-memcpy_from_file_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add memcpy_from_file_folio()
Date: Thu, 26 Jan 2023 20:15:52 +0000

This is the equivalent of memcpy_from_page().  It differs in that it takes
the position in a file instead of offset in a folio, it accepts the total
number of bytes to be copied (instead of the number of bytes to be copied
from this folio) and it returns how many bytes were copied from the folio,
rather than making the caller calculate that and then checking if the
caller got it right.

[akpm@linux-foundation.org: fix typo in comment]
Link: https://lkml.kernel.org/r/20230126201552.1681588-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/highmem.h~mm-add-memcpy_from_file_folio
+++ a/include/linux/highmem.h
@@ -414,6 +414,35 @@ static inline void memzero_page(struct p
 }
 
 /**
+ * memcpy_from_file_folio - Copy some bytes from a file folio.
+ * @to: The destination buffer.
+ * @folio: The folio to copy from.
+ * @pos: The position in the file.
+ * @len: The maximum number of bytes to copy.
+ *
+ * Copy up to @len bytes from this folio.  This may be limited by PAGE_SIZE
+ * if the folio comes from HIGHMEM, and by the size of the folio.
+ *
+ * Return: The number of bytes copied from the folio.
+ */
+static inline size_t memcpy_from_file_folio(char *to, struct folio *folio,
+		loff_t pos, size_t len)
+{
+	size_t offset = offset_in_folio(folio, pos);
+	char *from = kmap_local_folio(folio, offset);
+
+	if (folio_test_highmem(folio))
+		len = min_t(size_t, len, PAGE_SIZE - offset);
+	else
+		len = min(len, folio_size(folio) - offset);
+
+	memcpy(to, from, len);
+	kunmap_local(from);
+
+	return len;
+}
+
+/**
  * folio_zero_segments() - Zero two byte ranges in a folio.
  * @folio: The folio to write to.
  * @start1: The first byte to zero.
--- a/include/linux/page-flags.h~mm-add-memcpy_from_file_folio
+++ a/include/linux/page-flags.h
@@ -531,6 +531,7 @@ PAGEFLAG(Readahead, readahead, PF_NO_COM
  * available at this point.
  */
 #define PageHighMem(__p) is_highmem_idx(page_zonenum(__p))
+#define folio_test_highmem(__f)	is_highmem_idx(folio_zonenum(__f))
 #else
 PAGEFLAG_FALSE(HighMem, highmem)
 #endif
_

Patches currently in -mm which might be from willy@infradead.org are


