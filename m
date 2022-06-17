Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBBF6CCA47E
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379805AbiFQCtm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379793AbiFQCt3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179CE6540E
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A425261D1F
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09118C34114;
        Fri, 17 Jun 2022 02:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434163;
        bh=uL6tpJia3r9qLT1JnVyYVIeFouPYqrcR7Yo60Td1UvA=;
        h=Date:To:From:Subject:From;
        b=ni4YYnAm1Al4URT7HAolQAs9O1K2eP14f3PKN+9UYokAxF0o+OpfoY80igPXzu73p
         kJoxjH2AmFgP8prjYpg8DxS8P1vmObJLFY7hR839lzqe7WltOCZZkXsXatcMM0f0hl
         miaRRSxiEPduioPwgKW++dAhCe00+1Ev57J8celg=
Date:   Thu, 16 Jun 2022 19:49:22 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, hch@infradead.org,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-remove-the-redundant-boundary-check.patch removed from -mm tree
Message-Id: <20220617024923.09118C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: remove the redundant boundary check
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-the-redundant-boundary-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc: remove the redundant boundary check
Date: Tue, 7 Jun 2022 18:59:56 +0800

In find_va_links(), when traversing the vmap_area tree, the comparing to
check if the passed in 'va' is above or below 'tmp_va' is redundant,
assuming both 'va' and 'tmp_va' has ->va_start <= ->va_end.

Here, to simplify the checking as code change.

Link: https://lkml.kernel.org/r/20220607105958.382076-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-the-redundant-boundary-check
+++ a/mm/vmalloc.c
@@ -874,11 +874,9 @@ find_va_links(struct vmap_area *va,
 		 * Trigger the BUG() if there are sides(left/right)
 		 * or full overlaps.
 		 */
-		if (va->va_start < tmp_va->va_end &&
-				va->va_end <= tmp_va->va_start)
+		if (va->va_end <= tmp_va->va_start)
 			link = &(*link)->rb_left;
-		else if (va->va_end > tmp_va->va_start &&
-				va->va_start >= tmp_va->va_end)
+		else if (va->va_start >= tmp_va->va_end)
 			link = &(*link)->rb_right;
 		else {
 			WARN(1, "vmalloc bug: 0x%lx-0x%lx overlaps with 0x%lx-0x%lx\n",
_

Patches currently in -mm which might be from bhe@redhat.com are


