Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F59C2BB3F
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjKTSwc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjKTSwb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:52:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D502C9
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 10:52:28 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA727C433C8;
        Mon, 20 Nov 2023 18:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700506347;
        bh=LNfmugjSgLN2q/2FgjNbRGAqqlvCoyOJMhfNEfFX5fE=;
        h=Date:To:From:Subject:From;
        b=Ere6hIt2ip7kH7JGl+UCblcjA5sWuYX7vq7ovYgOwK+gZTyVS6xvFFeeoz+qo7Iuc
         OhDqzdXOvrzaecHuBearAsaSl55fXZTjr1Bf5OHeLHCO1FxOlpyHQrAcEgdwbjIhDs
         LevOTtesixSKhX5ieFLl4PI3hE8KaHYKWOMcXA1o=
Date:   Mon, 20 Nov 2023 10:52:27 -0800
To:     mm-commits@vger.kernel.org, ira.weiny@intel.com,
        fabio.maria.de.francesco@linux.intel.com,
        fabio.maria.de.francesco@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-use-kmap_local_page-in-calc_checksum.patch added to mm-unstable branch
Message-Id: <20231120185227.DA727C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: use kmap_local_page() in calc_checksum()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-use-kmap_local_page-in-calc_checksum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-use-kmap_local_page-in-calc_checksum.patch

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
From: "Fabio M. De Francesco" <fabio.maria.de.francesco@intel.com>
Subject: mm/ksm: use kmap_local_page() in calc_checksum()
Date: Mon, 20 Nov 2023 15:18:44 +0100

kmap_atomic() has been deprecated in favor of kmap_local_page().

Therefore, replace kmap_atomic() with kmap_local_page() in
calc_checksum().

kmap_atomic() is implemented like a kmap_local_page() which also disables
page-faults and preemption (the latter only in !PREEMPT_RT kernels).  The
kernel virtual addresses returned by these two API are only valid in the
context of the callers (i.e., they cannot be handed to other threads).

With kmap_local_page() the mappings are per thread and CPU local like in
kmap_atomic(); however, they can handle page-faults and can be called from
any context (including interrupts).  The tasks that call kmap_local_page()
can be preempted and, when they are scheduled to run again, the kernel
virtual addresses are restored and are still valid.

In calc_checksum(), the block of code between the mapping and un-mapping
does not depend on the above-mentioned side effects of kmap_aatomic(), so
that a mere replacements of the old API with the new one is all that is
required (i.e., there is no need to explicitly call pagefault_disable()
and/or preempt_disable()).

Link: https://lkml.kernel.org/r/20231120141855.6761-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/ksm.c~mm-ksm-use-kmap_local_page-in-calc_checksum
+++ a/mm/ksm.c
@@ -1099,9 +1099,9 @@ error:
 static u32 calc_checksum(struct page *page)
 {
 	u32 checksum;
-	void *addr = kmap_atomic(page);
+	void *addr = kmap_local_page(page);
 	checksum = xxhash(addr, PAGE_SIZE, 0);
-	kunmap_atomic(addr);
+	kunmap_local(addr);
 	return checksum;
 }
 
_

Patches currently in -mm which might be from fabio.maria.de.francesco@intel.com are

mm-util-use-kmap_local_page-in-memcmp_pages.patch
mm-ksm-use-kmap_local_page-in-calc_checksum.patch

