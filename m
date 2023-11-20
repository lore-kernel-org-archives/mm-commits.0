Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41293C197A0
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjKTSwa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjKTSwa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:52:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899FACB
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 10:52:26 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276C0C433C7;
        Mon, 20 Nov 2023 18:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700506346;
        bh=ap2hv6w87svdpY8rlWBwxuq7cSfVs/2ovhFtEItyA1Q=;
        h=Date:To:From:Subject:From;
        b=K8TpLS+dXi9MIvpR4/QybBfJm3rKGztt9kyq/kAH+N8iotjJOQUR9OZPWhJjUgMqF
         fxo6Tceptvaj8LRqdn+U77G6n/F6bNbCAi70jcthQ45+by+0GF1ftrgX4S1Di3bycy
         kKbsJGpi3QUGRY4T+4uuxZI0ZIltdClVjFdg1Nho=
Date:   Mon, 20 Nov 2023 10:52:25 -0800
To:     mm-commits@vger.kernel.org, ira.weiny@intel.com,
        fabio.maria.de.francesco@linux.intel.com,
        fabio.maria.de.francesco@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-util-use-kmap_local_page-in-memcmp_pages.patch added to mm-unstable branch
Message-Id: <20231120185226.276C0C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/util: use kmap_local_page() in memcmp_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-util-use-kmap_local_page-in-memcmp_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-util-use-kmap_local_page-in-memcmp_pages.patch

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
From: Fabio De Francesco <fabio.maria.de.francesco@intel.com>
Subject: mm/util: use kmap_local_page() in memcmp_pages()
Date: Mon, 20 Nov 2023 15:15:27 +0100

kmap_atomic() has been deprecated in favor of kmap_local_page().

Therefore, replace kmap_atomic() with kmap_local_page() in memcmp_pages().

kmap_atomic() is implemented like a kmap_local_page() which also disables
page-faults and preemption (the latter only in !PREEMPT_RT kernels).  The
kernel virtual addresses returned by these two API are only valid in the
context of the callers (i.e., they cannot be handed to other threads).

With kmap_local_page() the mappings are per thread and CPU local like in
kmap_atomic(); however, they can handle page-faults and can be called from
any context (including interrupts).  The tasks that call kmap_local_page()
can be preempted and, when they are scheduled to run again, the kernel
virtual addresses are restored and are still valid.

In memcmp_pages(), the block of code between the mapping and un-mapping
does not depend on the above-mentioned side effects of kmap_aatomic(), so
that mere replacements of the old API with the new one is all that is
required (i.e., there is no need to explicitly call pagefault_disable()
and/or preempt_disable()).

Link: https://lkml.kernel.org/r/20231120141554.6612-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/util.c~mm-util-use-kmap_local_page-in-memcmp_pages
+++ a/mm/util.c
@@ -1047,11 +1047,11 @@ int __weak memcmp_pages(struct page *pag
 	char *addr1, *addr2;
 	int ret;
 
-	addr1 = kmap_atomic(page1);
-	addr2 = kmap_atomic(page2);
+	addr1 = kmap_local_page(page1);
+	addr2 = kmap_local_page(page2);
 	ret = memcmp(addr1, addr2, PAGE_SIZE);
-	kunmap_atomic(addr2);
-	kunmap_atomic(addr1);
+	kunmap_local(addr2);
+	kunmap_local(addr1);
 	return ret;
 }
 
_

Patches currently in -mm which might be from fabio.maria.de.francesco@intel.com are

mm-util-use-kmap_local_page-in-memcmp_pages.patch
mm-ksm-use-kmap_local_page-in-calc_checksum.patch

