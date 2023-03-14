Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDD2C6FD1F
	for <mm-commits@archiver.kernel.org>; Tue, 14 Mar 2023 21:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjCNVp2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Mar 2023 17:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCNVp1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2023 17:45:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF753D902
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 14:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A79E4619EB
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 21:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF89C433EF;
        Tue, 14 Mar 2023 21:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678830325;
        bh=mEQmQvYH/Nc46yAhvPOMwwR3mFkAAjlTPLYALXQHsbA=;
        h=Date:To:From:Subject:From;
        b=WrfH+T1qTnCF6lZkq+SyqDc5tg2PrizGGX5oQ4hPaUm/3lkimJpNtNkVvvbPx7vNv
         wi4Ij6nWJgYrQlJgwnYPFRT1NGM2isBIYSGo6UdnxKsA5UFKbUSiMIvt670wdQizMQ
         8FadfovyBvoJRfnRehhmXsjGtHCJKa7DdNOcXC54=
Date:   Tue, 14 Mar 2023 14:45:24 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        khandual@linux.vnet.ibm.com, chaitanyas.prakash@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-change-map_chunk_size.patch added to mm-unstable branch
Message-Id: <20230314214524.EDF89C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: change MAP_CHUNK_SIZE
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-change-map_chunk_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-change-map_chunk_size.patch

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
From: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Subject: selftests: change MAP_CHUNK_SIZE
Date: Tue, 14 Mar 2023 09:53:49 +0530

Patch series "selftests: Fix virtual address range for arm64".

When the virtual address range selftest is run on arm64 and x86 platforms,
it is observed that both the low and high VA range iterations are skipped
when the MAP_CHUNK_SIZE is set to 16GB.  The MAP_CHUNK_SIZE is changed to
1GB to resolve this issue, following which support for arm64 platform is
added by changing the NR_CHUNKS_HIGH for aarch64 to accommodate up to 4PB
of virtual address space allocation requests.  Dynamic memory allocation
of array holding addresses is introduced to prevent overflow of the stack.
Finally, the overcommit_policy is set as OVERCOMMIT_ALWAYS to prevent the
kernel from denying a memory allocation request based on a platform's
physical memory availability.


This patch (of 3):

mmap() fails to allocate 16GB virtual space chunk, skipping both low and
high VA range iterations.  Hence, reduce MAP_CHUNK_SIZE to 1GB and update
relevant macros as required.

Link: https://lkml.kernel.org/r/20230314042351.13134-1-chaitanyas.prakash@arm.com
Link: https://lkml.kernel.org/r/20230314042351.13134-2-chaitanyas.prakash@arm.com
Signed-off-by: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-change-map_chunk_size
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -15,11 +15,15 @@
 
 /*
  * Maximum address range mapped with a single mmap()
- * call is little bit more than 16GB. Hence 16GB is
+ * call is little bit more than 1GB. Hence 1GB is
  * chosen as the single chunk size for address space
  * mapping.
  */
-#define MAP_CHUNK_SIZE   17179869184UL /* 16GB */
+
+#define SZ_1GB	(1024 * 1024 * 1024UL)
+#define SZ_1TB	(1024 * 1024 * 1024 * 1024UL)
+
+#define MAP_CHUNK_SIZE	SZ_1GB
 
 /*
  * Address space till 128TB is mapped without any hint
@@ -36,7 +40,7 @@
  * are supported so far.
  */
 
-#define NR_CHUNKS_128TB   8192UL /* Number of 16GB chunks for 128TB */
+#define NR_CHUNKS_128TB   ((128 * SZ_1TB) / MAP_CHUNK_SIZE) /* Number of chunks for 128TB */
 #define NR_CHUNKS_256TB   (NR_CHUNKS_128TB * 2UL)
 #define NR_CHUNKS_384TB   (NR_CHUNKS_128TB * 3UL)
 
_

Patches currently in -mm which might be from chaitanyas.prakash@arm.com are

selftests-change-map_chunk_size.patch
selftests-change-nr_chunks_high-for-aarch64.patch
selftests-set-overcommit_policy-as-overcommit_always.patch

