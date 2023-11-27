Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25544C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 17:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjK0RWk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 12:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343545AbjK0RFw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 12:05:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D980C327B
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 09:00:51 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF7FC433C7;
        Mon, 27 Nov 2023 17:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701104451;
        bh=Whft52qpN+Yr+ZAOtkw2jaYPkVuPnxO4xB1eDJAkmRc=;
        h=Date:To:From:Subject:From;
        b=1xBCJpiYqWhAF0gHkdTgpYRnQBGJa/VWcYAQ4cx1DwvePHXaTL4uVCgph3Bv/+HdF
         XUXBVIuRyzd8iPvd2CmRK52HqINc3kIk5dcOPh/fROaxTptm7dTkh75AKXP8YXUvrL
         /ytzpZRkKn/GKNCIVB6X7iNmzS3z2SNgTp6ssBGs=
Date:   Mon, 27 Nov 2023 09:00:50 -0800
To:     mm-commits@vger.kernel.org, sjenning@redhat.com,
        ira.weiny@intel.com, ddstreet@ieee.org,
        fabio.maria.de.francesco@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-replace-kmap_atomic-with-kmap_local_page.patch added to mm-unstable branch
Message-Id: <20231127170051.4AF7FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: replace kmap_atomic() with kmap_local_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-replace-kmap_atomic-with-kmap_local_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-replace-kmap_atomic-with-kmap_local_page.patch

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
From: "Fabio M. De Francesco" <fabio.maria.de.francesco@linux.intel.com>
Subject: mm/zswap: replace kmap_atomic() with kmap_local_page()
Date: Mon, 27 Nov 2023 16:55:21 +0100

kmap_atomic() has been deprecated in favor of kmap_local_page().

Therefore, replace kmap_atomic() with kmap_local_page() in
zswap.c.

kmap_atomic() is implemented like a kmap_local_page() which also disables
page-faults and preemption (the latter only in !PREEMPT_RT kernels).  The
kernel virtual addresses returned by these two API are only valid in the
context of the callers (i.e., they cannot be handed to other threads).

With kmap_local_page() the mappings are per thread and CPU local like in
kmap_atomic(); however, they can handle page-faults and can be called from
any context (including interrupts).  The tasks that call kmap_local_page()
can be preempted and, when they are scheduled to run again, the kernel
virtual addresses are restored and are still valid.

In mm/zswap.c, the blocks of code between the mappings and un-mappings do
not depend on the above-mentioned side effects of kmap_atomic(), so that
the mere replacements of the old API with the new one is all that is
required (i.e., there is no need to explicitly call pagefault_disable()
and/or preempt_disable()).

Link: https://lkml.kernel.org/r/20231127160058.586446-1-fabio.maria.de.francesco@linux.intel.com
Signed-off-by: Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/zswap.c~mm-zswap-replace-kmap_atomic-with-kmap_local_page
+++ a/mm/zswap.c
@@ -1267,16 +1267,16 @@ bool zswap_store(struct folio *folio)
 	}
 
 	if (zswap_same_filled_pages_enabled) {
-		src = kmap_atomic(page);
+		src = kmap_local_page(page);
 		if (zswap_is_page_same_filled(src, &value)) {
-			kunmap_atomic(src);
+			kunmap_local(src);
 			entry->swpentry = swp_entry(type, offset);
 			entry->length = 0;
 			entry->value = value;
 			atomic_inc(&zswap_same_filled_pages);
 			goto insert_entry;
 		}
-		kunmap_atomic(src);
+		kunmap_local(src);
 	}
 
 	if (!zswap_non_same_filled_pages_enabled)
@@ -1422,9 +1422,9 @@ bool zswap_load(struct folio *folio)
 	spin_unlock(&tree->lock);
 
 	if (!entry->length) {
-		dst = kmap_atomic(page);
+		dst = kmap_local_page(page);
 		zswap_fill_page(dst, entry->value);
-		kunmap_atomic(dst);
+		kunmap_local(dst);
 		ret = true;
 		goto stats;
 	}
_

Patches currently in -mm which might be from fabio.maria.de.francesco@linux.intel.com are

mm-util-use-kmap_local_page-in-memcmp_pages.patch
mm-memory-use-kmap_local_page-in-__wp_page_copy_user.patch
mm-mempool-replace-kmap_atomic-with-kmap_local_page.patch
mm-page_poison-replace-kmap_atomic-with-kmap_local_page.patch
mm-zswap-replace-kmap_atomic-with-kmap_local_page.patch
mm-swapfile-replace-kmap_atomic-with-kmap_local_page.patch

