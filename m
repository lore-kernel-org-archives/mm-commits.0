Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC8DC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbjDFCtH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234973AbjDFCsP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:48:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7F1A5C1
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CB556422C
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B121C433EF;
        Thu,  6 Apr 2023 02:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749144;
        bh=oHDDAwjxGOlKA6iRAFIPf+IYjCin1xMkCCtsYqHUBDA=;
        h=Date:To:From:Subject:From;
        b=kp3UpMeL2toz1JsF0Gder/HMFm2FZKdKQgWiGxTH7gvZElIB1zdu8XXCfWK2zfm5z
         lMbqrxVw1Ipx4xwX6YSx2LEnDPmoFXVvO+B0i4xFw8Rt14TZQcwvPZzxGaQAqsuFGy
         Uzrg2x4tOhYi1seTVB3cPxxAcEZi1gOQHn8LHDmk=
Date:   Wed, 05 Apr 2023 19:45:43 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, david@redhat.com,
        chaitanyas.prakash@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-change-map_chunk_size.patch removed from -mm tree
Message-Id: <20230406024544.6B121C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: change MAP_CHUNK_SIZE
has been removed from the -mm tree.  Its filename was
     selftests-mm-change-map_chunk_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Subject: selftests/mm: change MAP_CHUNK_SIZE
Date: Thu, 23 Mar 2023 11:31:19 +0530

Patch series "selftests: Fix virtual address range for arm64", v2.

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

Link: https://lkml.kernel.org/r/20230323060121.1175830-1-chaitanyas.prakash@arm.com
Link: https://lkml.kernel.org/r/20230323060121.1175830-2-chaitanyas.prakash@arm.com
Signed-off-by: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-change-map_chunk_size
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


