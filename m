Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02583C2BB3F
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbjKTSwh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjKTSwd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:52:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D7AC8
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 10:52:29 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757C8C433C7;
        Mon, 20 Nov 2023 18:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700506349;
        bh=f+uxb75ailY2DwQDLmPNkyrlvgBH2ikTfQW1gt4P2Zg=;
        h=Date:To:From:Subject:From;
        b=HSJvqVvbIwT3BnUrhxKQueQz0W4RuKvgX69Eyk5Qz/HF3ewXnFK/fDNl1ue5xpM4y
         Kzo/2L0bFzMA5Hm1/J413GE3IauKnawKft+pGtVoB02X5REx/flq8pAXHCgsKl+JgD
         0WjtQ+0U0aU3n0BKmqQXUHMndDhq3J8SgapHNmMQ=
Date:   Mon, 20 Nov 2023 10:52:29 -0800
To:     mm-commits@vger.kernel.org, ira.weiny@intel.com,
        fabio.maria.de.francesco@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-use-kmap_local_page-in-__wp_page_copy_user.patch added to mm-unstable branch
Message-Id: <20231120185229.757C8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory: use kmap_local_page() in __wp_page_copy_user()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-use-kmap_local_page-in-__wp_page_copy_user.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-use-kmap_local_page-in-__wp_page_copy_user.patch

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
Subject: mm/memory: use kmap_local_page() in __wp_page_copy_user()
Date: Mon, 20 Nov 2023 15:24:05 +0100

kmap_atomic() has been deprecated in favor of kmap_local_{folio,page}.

Therefore, replace kmap_atomic() with kmap_local_page in
__wp_page_copy_user().

kmap_atomic() disables preemption in !PREEMPT_RT kernels and
unconditionally disables also page-faults.  My limited knowledge of the
implementation of __wp_page_copy_user() makes me think that the latter
side effect is still needed here, but kmap_local_page() is implemented not
to disable page-faults.

So, in addition to the conversion to local mapping, add explicit
pagefault_disable() / pagefault_enable() between mapping and un-mapping.

Link: https://lkml.kernel.org/r/20231120142418.6977-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-memory-use-kmap_local_page-in-__wp_page_copy_user
+++ a/mm/memory.c
@@ -2841,7 +2841,8 @@ static inline int __wp_page_copy_user(st
 	 * just copying from the original user address. If that
 	 * fails, we just zero-fill it. Live with it.
 	 */
-	kaddr = kmap_atomic(dst);
+	kaddr = kmap_local_page(dst);
+	pagefault_disable();
 	uaddr = (void __user *)(addr & PAGE_MASK);
 
 	/*
@@ -2909,7 +2910,8 @@ warn:
 pte_unlock:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-	kunmap_atomic(kaddr);
+	pagefault_enable();
+	kunmap_local(kaddr);
 	flush_dcache_page(dst);
 
 	return ret;
_

Patches currently in -mm which might be from fabio.maria.de.francesco@linux.intel.com are

mm-memory-use-kmap_local_page-in-__wp_page_copy_user.patch
mm-mempool-replace-kmap_atomic-with-kmap_local_page.patch
mm-page_poison-replace-kmap_atomic-with-kmap_local_page.patch

