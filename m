Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC06C74A5B
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 22:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjCWWRk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Mar 2023 18:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjCWWRe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Mar 2023 18:17:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027C41E1DA
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 15:17:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C766628E4
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 22:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59EEC433EF;
        Thu, 23 Mar 2023 22:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679609853;
        bh=U5nThfnfSpJkhwj8JU4dBUuj+TfiYpViwDBtiwkyCQg=;
        h=Date:To:From:Subject:From;
        b=wrM86IQhvnXxDvwQEjN0MdZXYbQevqaglBDqH9jl8uS0I39bPZ1vE92bRQu+/tbiM
         fDa+fZH/aofvHVNKflcNRLxdarGSRWtDMzxwl7NkR9zn4NmaZOaku2lVLac57jdNS0
         Vnxx0Ul8MfnIEaOv8NZjUfxllZNLS1h2zEYLnksA=
Date:   Thu, 23 Mar 2023 15:17:32 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, david@redhat.com,
        chaitanyas.prakash@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-change-nr_chunks_high-for-aarch64.patch added to mm-unstable branch
Message-Id: <20230323221732.E59EEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: change NR_CHUNKS_HIGH for aarch64
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-change-nr_chunks_high-for-aarch64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-change-nr_chunks_high-for-aarch64.patch

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
Subject: selftests/mm: change NR_CHUNKS_HIGH for aarch64
Date: Thu, 23 Mar 2023 11:31:20 +0530

Although there is a provision for 52 bit VA on arm64 platform, it remains
unutilised and higher addresses are not allocated.  In order to
accommodate 4PB [2^52] virtual address space where supported,
NR_CHUNKS_HIGH is changed accordingly.

Array holding addresses is changed from static allocation to dynamic
allocation to accommodate its voluminous nature which otherwise might
overflow the stack.

Link: https://lkml.kernel.org/r/20230323060121.1175830-3-chaitanyas.prakash@arm.com
Signed-off-by: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |   14 +++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-change-nr_chunks_high-for-aarch64
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -36,13 +36,15 @@
  * till it reaches 512TB. One with size 128TB and the
  * other being 384TB.
  *
- * On Arm64 the address space is 256TB and no high mappings
- * are supported so far.
+ * On Arm64 the address space is 256TB and support for
+ * high mappings up to 4PB virtual address space has
+ * been added.
  */
 
 #define NR_CHUNKS_128TB   ((128 * SZ_1TB) / MAP_CHUNK_SIZE) /* Number of chunks for 128TB */
 #define NR_CHUNKS_256TB   (NR_CHUNKS_128TB * 2UL)
 #define NR_CHUNKS_384TB   (NR_CHUNKS_128TB * 3UL)
+#define NR_CHUNKS_3840TB  (NR_CHUNKS_128TB * 30UL)
 
 #define ADDR_MARK_128TB  (1UL << 47) /* First address beyond 128TB */
 #define ADDR_MARK_256TB  (1UL << 48) /* First address beyond 256TB */
@@ -51,7 +53,7 @@
 #define HIGH_ADDR_MARK  ADDR_MARK_256TB
 #define HIGH_ADDR_SHIFT 49
 #define NR_CHUNKS_LOW   NR_CHUNKS_256TB
-#define NR_CHUNKS_HIGH  0
+#define NR_CHUNKS_HIGH  NR_CHUNKS_3840TB
 #else
 #define HIGH_ADDR_MARK  ADDR_MARK_128TB
 #define HIGH_ADDR_SHIFT 48
@@ -101,7 +103,7 @@ static int validate_lower_address_hint(v
 int main(int argc, char *argv[])
 {
 	char *ptr[NR_CHUNKS_LOW];
-	char *hptr[NR_CHUNKS_HIGH];
+	char **hptr;
 	char *hint;
 	unsigned long i, lchunks, hchunks;
 
@@ -119,6 +121,9 @@ int main(int argc, char *argv[])
 			return 1;
 	}
 	lchunks = i;
+	hptr = (char **) calloc(NR_CHUNKS_HIGH, sizeof(char *));
+	if (hptr == NULL)
+		return 1;
 
 	for (i = 0; i < NR_CHUNKS_HIGH; i++) {
 		hint = hind_addr();
@@ -139,5 +144,6 @@ int main(int argc, char *argv[])
 	for (i = 0; i < hchunks; i++)
 		munmap(hptr[i], MAP_CHUNK_SIZE);
 
+	free(hptr);
 	return 0;
 }
_

Patches currently in -mm which might be from chaitanyas.prakash@arm.com are

selftests-mm-change-map_chunk_size.patch
selftests-mm-change-nr_chunks_high-for-aarch64.patch
selftests-mm-set-overcommit_policy-as-overcommit_always.patch

