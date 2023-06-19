Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 503ECEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjFSXUs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjFSXUi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FB4E60
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6210B60F3A
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99CAC433C8;
        Mon, 19 Jun 2023 23:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216831;
        bh=LMzrVv2zWaJfRdDjCOLi4aChifgDaAVsxSOtU078Eg4=;
        h=Date:To:From:Subject:From;
        b=EeJ+pcFuS08VUnweYbRT1Ecd+06dyahwI8Btaf0195BRGI3cjSztgRRG5ILz3IyUR
         RNBGpb+pIUhBk+wUKsNDxiFlBy6LXwkJ66VgpgUQHe+X9Ey65zOJ6NqzTBDNjP5NnB
         99tv3zWRBYWtTCTlcB2DnIqucqsJGpaoEyBpdMEY=
Date:   Mon, 19 Jun 2023 16:20:31 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-build-failures-due-to-missing-madv_collapse.patch removed from -mm tree
Message-Id: <20230619232031.B99CAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: fix build failures due to missing MADV_COLLAPSE
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-build-failures-due-to-missing-madv_collapse.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: fix build failures due to missing MADV_COLLAPSE
Date: Tue, 6 Jun 2023 00:16:34 -0700

MADV_PAGEOUT, MADV_POPULATE_READ, MADV_COLLAPSE are conditionally
defined as necessary. However, that was being done in .c files, and a
new build failure came up that would have been automatically avoided had
these been in a common header file.

So consolidate and move them all to vm_util.h, which fixes the build
failure.

An alternative approach from Muhammad Usama Anjum was: rely on "make
headers" being required, and include asm-generic/mman-common.h. This
works in the sense that it builds, but it still generates warnings about
duplicate MADV_* symbols, and the goal here is to get a fully clean (no
warnings) build here.

Link: https://lkml.kernel.org/r/20230606071637.267103-9-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c        |    7 -------
 tools/testing/selftests/mm/khugepaged.c |   10 ----------
 tools/testing/selftests/mm/vm_util.h    |   10 ++++++++++
 3 files changed, 10 insertions(+), 17 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-fix-build-failures-due-to-missing-madv_collapse
+++ a/tools/testing/selftests/mm/cow.c
@@ -29,13 +29,6 @@
 #include "../kselftest.h"
 #include "vm_util.h"
 
-#ifndef MADV_PAGEOUT
-#define MADV_PAGEOUT 21
-#endif
-#ifndef MADV_COLLAPSE
-#define MADV_COLLAPSE 25
-#endif
-
 static size_t pagesize;
 static int pagemap_fd;
 static size_t thpsize;
--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-fix-build-failures-due-to-missing-madv_collapse
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -22,16 +22,6 @@
 
 #include "vm_util.h"
 
-#ifndef MADV_PAGEOUT
-#define MADV_PAGEOUT 21
-#endif
-#ifndef MADV_POPULATE_READ
-#define MADV_POPULATE_READ 22
-#endif
-#ifndef MADV_COLLAPSE
-#define MADV_COLLAPSE 25
-#endif
-
 #define BASE_ADDR ((void *)(1UL << 30))
 static unsigned long hpage_pmd_size;
 static unsigned long page_size;
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-fix-build-failures-due-to-missing-madv_collapse
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -64,3 +64,13 @@ int uffd_register_with_ioctls(int uffd,
 
 #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
 #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
+
+#ifndef MADV_PAGEOUT
+#define MADV_PAGEOUT 21
+#endif
+#ifndef MADV_POPULATE_READ
+#define MADV_POPULATE_READ 22
+#endif
+#ifndef MADV_COLLAPSE
+#define MADV_COLLAPSE 25
+#endif
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


