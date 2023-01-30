Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2549C54EAA
	for <mm-commits@archiver.kernel.org>; Mon, 30 Jan 2023 23:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjA3XFn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Jan 2023 18:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjA3XFZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2023 18:05:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D966424106
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 15:04:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EE47612FC
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 23:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9ADC433D2;
        Mon, 30 Jan 2023 23:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675119841;
        bh=CtavB5BK7HWeS60oMkpbeuX8OeJ1eyhNdORhrhX9jCY=;
        h=Date:To:From:Subject:From;
        b=IYLwHwrAsD5Q3fyJGvvfklJnUuHwc3CGZg4+ZDjcinV16b3N9fCWqBwdqXxPEnvM4
         /klvoJ3OSPI1+5o6VZ7kDPgDCd1SE5sMnibZFj9DOBT8EnUCYGl9badi0plGn1jlbd
         VUbsGPAWE3jMTHSjJfyoOfaTHEP+F4XprKoIZejY=
Date:   Mon, 30 Jan 2023 15:04:00 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        pasha.tatashin@soleen.com, naoya.horiguchi@nec.com,
        mhocko@suse.com, Liam.Howlett@Oracle.com, jhubbard@nvidia.com,
        hughd@google.com, glider@google.com, david@redhat.com,
        alex.sierra@amd.com, alexander.h.duyck@linux.intel.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-extend-max-struct-page-size-for-kmsan.patch added to mm-hotfixes-unstable branch
Message-Id: <20230130230401.BC9ADC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: extend max struct page size for kmsan
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-extend-max-struct-page-size-for-kmsan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-extend-max-struct-page-size-for-kmsan.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: extend max struct page size for kmsan
Date: Mon, 30 Jan 2023 14:07:26 +0100

After x86 enabled support for KMSAN, it has become possible to have larger
'struct page' than was expected when commit 5470dea49f53 ("mm: use
mm_zero_struct_page from SPARC on all 64b architectures") was merged:

include/linux/mm.h:156:10: warning: no case matching constant switch condition '96'
        switch (sizeof(struct page)) {

Extend the maximum accordingly.

Link: https://lkml.kernel.org/r/20230130130739.563628-1-arnd@kernel.org
Fixes: 5470dea49f53 ("mm: use mm_zero_struct_page from SPARC on all 64b architectures")
Fixes: 4ca8cc8d1bbe ("x86: kmsan: enable KMSAN builds for x86")
Fixes: f80be4571b19 ("kmsan: add KMSAN runtime core")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-extend-max-struct-page-size-for-kmsan
+++ a/include/linux/mm.h
@@ -137,7 +137,7 @@ extern int mmap_rnd_compat_bits __read_m
  * define their own version of this macro in <asm/pgtable.h>
  */
 #if BITS_PER_LONG == 64
-/* This function must be updated when the size of struct page grows above 80
+/* This function must be updated when the size of struct page grows above 96
  * or reduces below 56. The idea that compiler optimizes out switch()
  * statement, and only leaves move/store instructions. Also the compiler can
  * combine write statements if they are both assignments and can be reordered,
@@ -148,12 +148,18 @@ static inline void __mm_zero_struct_page
 {
 	unsigned long *_pp = (void *)page;
 
-	 /* Check that struct page is either 56, 64, 72, or 80 bytes */
+	 /* Check that struct page is either 56, 64, 72, 80, 88 or 96 bytes */
 	BUILD_BUG_ON(sizeof(struct page) & 7);
 	BUILD_BUG_ON(sizeof(struct page) < 56);
-	BUILD_BUG_ON(sizeof(struct page) > 80);
+	BUILD_BUG_ON(sizeof(struct page) > 96);
 
 	switch (sizeof(struct page)) {
+	case 96:
+		_pp[11] = 0;
+		fallthrough;
+	case 88:
+		_pp[10] = 0;
+		fallthrough;
 	case 80:
 		_pp[9] = 0;
 		fallthrough;
_

Patches currently in -mm which might be from arnd@arndb.de are

zsmalloc-fix-a-race-with-deferred_handles-storing-fix.patch
mm-extend-max-struct-page-size-for-kmsan.patch
mm-hugetlb-convert-get_hwpoison_huge_page-to-folios-fix.patch

