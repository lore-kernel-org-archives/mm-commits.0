Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BAAC6FD1F
	for <mm-commits@archiver.kernel.org>; Tue, 14 Mar 2023 21:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjCNVpf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Mar 2023 17:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCNVpa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2023 17:45:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9323E60F
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 14:45:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23CBCB81BA8
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 21:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB016C433EF;
        Tue, 14 Mar 2023 21:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678830326;
        bh=GtR2KaDEc3q9EZnxOf4XAXGERS3drFvmd+Fsqb4IpBk=;
        h=Date:To:From:Subject:From;
        b=a2Y74pk58YfYSuBJkOus4S5i8C3Y8cJi7KrbUfhgexT98WfMw0ulC8TyR5A1yexRJ
         jY7uAywzTjsS47dKamxGbimhEms2OOnaZiEMUisWcvGbuSNRMFuFai4IQAwd5EtyRS
         XGG2NFAFiRxiRumYm+TE6U3UWkM0vKZ5n1TWI9X4=
Date:   Tue, 14 Mar 2023 14:45:26 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        khandual@linux.vnet.ibm.com, chaitanyas.prakash@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-change-nr_chunks_high-for-aarch64.patch added to mm-unstable branch
Message-Id: <20230314214526.AB016C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: change NR_CHUNKS_HIGH for aarch64
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-change-nr_chunks_high-for-aarch64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-change-nr_chunks_high-for-aarch64.patch

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
Subject: selftests: change NR_CHUNKS_HIGH for aarch64
Date: Tue, 14 Mar 2023 09:53:50 +0530

Although there is a provision for 52 bit VA on arm64 platform, it remains
unutilised and higher addresses are not allocated.  In order to
accommodate 4PB [2^52] virtual address space where supported,
NR_CHUNKS_HIGH is changed accordingly.

Array holding addresses is changed from static allocation to dynamic
allocation to accommodate its voluminous nature which otherwise might
overflow the stack.

Link: https://lkml.kernel.org/r/20230314042351.13134-3-chaitanyas.prakash@arm.com
Signed-off-by: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-change-nr_chunks_high-for-aarch64
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

selftests-change-map_chunk_size.patch
selftests-change-nr_chunks_high-for-aarch64.patch
selftests-set-overcommit_policy-as-overcommit_always.patch

