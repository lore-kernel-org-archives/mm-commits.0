Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 683EBC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbjDFCtN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235090AbjDFCsP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:48:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEDC7EEA
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4647C6417C
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAA8C433EF;
        Thu,  6 Apr 2023 02:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749145;
        bh=pMYL6kNPne7TVPx5W8oXMzTlbSXpdcQlM7KVMynMi9s=;
        h=Date:To:From:Subject:From;
        b=zbSJFWMMbFWy4f7rOej1w8y8MgjEBUZ5NA3Yye5gYVXIej/dvvr2lwM0x03+/AgpU
         JVg6YO16FFbhMuPgtZrt/YGSACiznlhkOJPX36pWOaRPtg5nGghgrnLywLCENNLWpe
         CrZm6+25zGUjxFxIHHg/SXgkribQf94h1v8wgSQc=
Date:   Wed, 05 Apr 2023 19:45:44 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, david@redhat.com,
        chaitanyas.prakash@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-change-nr_chunks_high-for-aarch64.patch removed from -mm tree
Message-Id: <20230406024545.9BAA8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: change NR_CHUNKS_HIGH for aarch64
has been removed from the -mm tree.  Its filename was
     selftests-mm-change-nr_chunks_high-for-aarch64.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


