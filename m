Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B81C64ED6
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjBMX4E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjBMXzh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D305A18B06
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76D22611B2
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EECC433D2;
        Mon, 13 Feb 2023 23:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332534;
        bh=rt+S5aFZUbXj1s2z+snJmC1f77M3omy+dEpxfUjJbsg=;
        h=Date:To:From:Subject:From;
        b=DKoSiFFeZD9YUH3008rrlK7QvH+5TDS8OhzNvon6sCVpVqzu+3L0F8PC/QBgY7wyC
         HM350qFzDJzy4z3D2+syxBL/69WlqLITotv0WflKCjw0lWhQkS+Urv3D2r1xRUG0PI
         4H7Aa/TqFNs3uEXH5rM520C+ktUJvzlvkmW/XoOc=
Date:   Mon, 13 Feb 2023 15:55:34 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio_get_nontail_page.patch removed from -mm tree
Message-Id: <20230213235534.D1EECC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add folio_get_nontail_page()
has been removed from the -mm tree.  Its filename was
     mm-add-folio_get_nontail_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm: add folio_get_nontail_page()
Date: Mon, 30 Jan 2023 13:43:49 -0800

Patch series "Convert a couple migrate functions to use folios", v2.

This patchset introduces folio_movable_ops() and converts 3 functions in
mm/migrate.c to use folios.  It also introduces folio_get_nontail_page()
for folio conversions which may want to distinguish between head and tail
pages.


This patch (of 4):

folio_get_nontail_page() returns the folio associated with a head page. 
This is necessary for folio conversions where the behavior of that
function differs between head pages and tail pages.

Link: https://lkml.kernel.org/r/20230130214352.40538-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20230130214352.40538-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-add-folio_get_nontail_page
+++ a/include/linux/mm.h
@@ -892,6 +892,13 @@ static inline bool get_page_unless_zero(
 	return page_ref_add_unless(page, 1, 0);
 }
 
+static inline struct folio *folio_get_nontail_page(struct page *page)
+{
+	if (unlikely(!get_page_unless_zero(page)))
+		return NULL;
+	return (struct folio *)page;
+}
+
 extern int page_is_ram(unsigned long pfn);
 
 enum {
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


