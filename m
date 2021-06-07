Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB5EC47095
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 22:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC78B61246
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 22:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhFGWij (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 18:38:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230306AbhFGWij (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 18:38:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CBD561090;
        Mon,  7 Jun 2021 22:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623105397;
        bh=AyNOCh6pINNjNU5xcnvPzEjcWUej3V91JCMuA2xvSb0=;
        h=Date:From:To:Subject:From;
        b=h9/8Z7p8h12uAfx68j3k7/TnRs2VYWvdKTXk8fu9VqQcHzYEA55nZA+tjZWR3cpp9
         2ndagdujfpLnGu54JnaJRz9+vj4tEEIlRqjoO4z5V5s4ZGBwMsSjpeWAp2o6K4GpAQ
         DdK0dixP/sG1wLVDuZWqKIC3WcvJKVqUaD4DKfS8=
Date:   Mon, 07 Jun 2021 15:36:37 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        joel@joelfernandes.org, kaleshsingh@google.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject:  [to-be-updated]
 selftest-mremap_test-avoid-crash-with-static-build.patch removed from -mm
 tree
Message-ID: <20210607223637.vmypldEAx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/mremap_test: avoid crash with static build
has been removed from the -mm tree.  Its filename was
     selftest-mremap_test-avoid-crash-with-static-build.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: selftest/mremap_test: avoid crash with static build

With a large mmap map size, we can overlap with the text area and using
MAP_FIXED results in unmapping that area.  Switch to MAP_FIXED_NOREPLACE
and handle the EEXIST error.

Link: https://lkml.kernel.org/r/20210422054323.150993-3-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Kalesh Singh <kaleshsingh@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mremap_test.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/mremap_test.c~selftest-mremap_test-avoid-crash-with-static-build
+++ a/tools/testing/selftests/vm/mremap_test.c
@@ -75,9 +75,10 @@ static void *get_source_mapping(struct c
 retry:
 	addr += c.src_alignment;
 	src_addr = mmap((void *) addr, c.region_size, PROT_READ | PROT_WRITE,
-			MAP_FIXED | MAP_ANONYMOUS | MAP_SHARED, -1, 0);
+			MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
+			-1, 0);
 	if (src_addr == MAP_FAILED) {
-		if (errno == EPERM)
+		if (errno == EPERM || errno == EEXIST)
 			goto retry;
 		goto error;
 	}
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch
mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries-fix.patch
powerpc-mm-book3s64-fix-possible-build-error.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush.patch
mm-mremap-move-tlb-flush-outside-page-table-lock.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-mm-enable-move-pmd-pud.patch

