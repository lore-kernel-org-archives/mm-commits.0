Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE751C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiJCVR0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiJCVPZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:15:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7AC32A84
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:10:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69C1DB815F8
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BE1C433D7;
        Mon,  3 Oct 2022 21:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831398;
        bh=EsHjsuOpQh9HsUTVbQpLS55pNaobfxmY1OjtD0JR2t4=;
        h=Date:To:From:Subject:From;
        b=GcNS6HFriL2GLA5Kl510LC/0ZnB5blmLhf05/NbztvlLaO5GkkwcCDjqdSCyIKWpi
         hbKTEcUEdaI/Jig6/8b0DYZH/BPY5TpYrLgoXF+FEyHLJwawR0U2Mwr795SvmxFLRq
         rkmP8CY8HV6eudXaRfJEhjAPKMMiFrYyCoUWf2pU=
Date:   Mon, 03 Oct 2022 14:09:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, hughd@google.com, david@redhat.com,
        ckennelly@google.com, axelrasmussen@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-retry-on-eagain-for-madv_collapse-selftest.patch removed from -mm tree
Message-Id: <20221003210958.07BE1C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: retry on EAGAIN for MADV_COLLAPSE selftest
has been removed from the -mm tree.  Its filename was
     selftests-vm-retry-on-eagain-for-madv_collapse-selftest.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: selftests/vm: retry on EAGAIN for MADV_COLLAPSE selftest
Date: Thu, 22 Sep 2022 11:46:51 -0700

MADV_COLLAPSE is a best-effort request that will set errno to an
actionable value if the request cannot be performed.

For example, if pages are not found on the LRU, or if they are currently
locked by something else, MADV_COLLAPSE will fail and set errno to EAGAIN
to inform callers that they may try again.

Since the khugepaged selftest is the first public use of MADV_COLLAPSE,
set a best practice of checking errno and retrying on EAGAIN.

Link: https://lkml.kernel.org/r/20220922184651.1016461-2-zokeefe@google.com
Fixes: 9330694de59f ("selftests/vm: add MADV_COLLAPSE collapse context to selftests")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/khugepaged.c |   23 +++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/khugepaged.c~selftests-vm-retry-on-eagain-for-madv_collapse-selftest
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -1,4 +1,5 @@
 #define _GNU_SOURCE
+#include <errno.h>
 #include <fcntl.h>
 #include <limits.h>
 #include <signal.h>
@@ -478,6 +479,26 @@ static void fill_memory(int *p, unsigned
 }
 
 /*
+ * MADV_COLLAPSE is a best-effort request and may fail if an internal
+ * resource is temporarily unavailable, in which case it will set errno to
+ * EAGAIN.  In such a case, immediately reattempt the operation one more
+ * time.
+ */
+static int madvise_collapse_retry(void *p, unsigned long size)
+{
+	bool retry = true;
+	int ret;
+
+retry:
+	ret = madvise(p, size, MADV_COLLAPSE);
+	if (ret && errno == EAGAIN && retry) {
+		retry = false;
+		goto retry;
+	}
+	return ret;
+}
+
+/*
  * Returns pmd-mapped hugepage in VMA marked VM_HUGEPAGE, filled with
  * validate_memory()'able contents.
  */
@@ -531,7 +552,7 @@ static void madvise_collapse(const char
 
 	/* Clear VM_NOHUGEPAGE */
 	madvise(p, nr_hpages * hpage_pmd_size, MADV_HUGEPAGE);
-	ret = madvise(p, nr_hpages * hpage_pmd_size, MADV_COLLAPSE);
+	ret = madvise_collapse_retry(p, nr_hpages * hpage_pmd_size);
 	if (((bool)ret) == expect)
 		fail("Fail: Bad return value");
 	else if (check_huge(p, nr_hpages) != expect)
_

Patches currently in -mm which might be from zokeefe@google.com are


