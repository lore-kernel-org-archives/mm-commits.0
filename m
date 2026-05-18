Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC164A3E
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779138863; cv=none; b=VQiBr/9dEFgrp2AKVJAB/UfDv5Syq2ifxXG+sDabK/VuEem+l5bt1JBMjWfs91Lb6XXz6g0xFdD4ir8BxbLZZA2RLvW/eWCfZ7u4pn9QDXciypYjGHdIjQCck0v6S8FHHQiPIuOuGKWLj99ogaRA25vrFI5fBUmiXMScK6ohHys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779138863; c=relaxed/simple;
	bh=jIYdVcSXpkX/OspRX4C6RLDrhi73PN7ziJ9dLU11Ylk=;
	h=Date:To:From:Subject:Message-Id; b=OudGq80O60BHvJpRHfV1y/21Jw1O0xoh9TL3ngmpM7mU4bZ/6VlaKO3yrBUA+ZMg6JZhXhmU8INtaq76HpfrTCOVv0SSXuVUMRR1OkKGIMmWyW+8jVszWEySyiJ9yrPXigddUCgBmoE8oK96E/PfBPMkVfrz4hzLcHKwuH+tgcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oyy+RGaa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oyy+RGaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F42C2BCB7;
	Mon, 18 May 2026 21:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779138863;
	bh=jIYdVcSXpkX/OspRX4C6RLDrhi73PN7ziJ9dLU11Ylk=;
	h=Date:To:From:Subject:From;
	b=Oyy+RGaaHiWQaagbzAeUi8ZwduCfZkR2GIszHt+/orKpr+c5Crs9segodu0W0s+F/
	 qOIz1cHnq/1V9lMhex71OZ/b+E1dTAtSoPu7gi1amV55R9BjERWs0dro2AUhswNqOh
	 68DArkRv5zQcjf/wPQS8829CSUUcjugMBF/Me/zc=
Date: Mon, 18 May 2026 14:14:22 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6-use-static_call-for-gen_syndrom-and-xor_syndrom.patch added to mm-nonmm-unstable branch
Message-Id: <20260518211422.E4F42C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid6: use static_call for gen_syndrom and xor_syndrom
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-use-static_call-for-gen_syndrom-and-xor_syndrom.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-use-static_call-for-gen_syndrom-and-xor_syndrom.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: raid6: use static_call for gen_syndrom and xor_syndrom
Date: Mon, 18 May 2026 07:17:54 +0200

Avoid indirect calls for P/Q parity generation.

Link: https://lore.kernel.org/20260518051804.462141-12-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Ard Biesheuvel <ardb@kernel.org> # kunit only on arm64
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Li Nan <linan122@huawei.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Song Liu <song@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/raid6/algos.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/lib/raid/raid6/algos.c~raid6-use-static_call-for-gen_syndrom-and-xor_syndrom
+++ a/lib/raid/raid6/algos.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/gfp.h>
 #include <linux/raid/pq.h>
+#include <linux/static_call.h>
 #include <kunit/visibility.h>
 #include "algos.h"
 
@@ -23,7 +24,8 @@ static unsigned int raid6_nr_algos;
 static const struct raid6_recov_calls *raid6_recov_algo;
 
 /* Selected algorithm */
-static struct raid6_calls raid6_call;
+DEFINE_STATIC_CALL_NULL(raid6_gen_syndrome_impl, *raid6_intx1.gen_syndrome);
+DEFINE_STATIC_CALL_NULL(raid6_xor_syndrome_impl, *raid6_intx1.xor_syndrome);
 
 /**
  * raid6_gen_syndrome - generate RAID6 P/Q parity
@@ -48,7 +50,7 @@ void raid6_gen_syndrome(int disks, size_
 	WARN_ON_ONCE(bytes & 511);
 	WARN_ON_ONCE(disks < RAID6_MIN_DISKS);
 
-	raid6_call.gen_syndrome(disks, bytes, ptrs);
+	static_call(raid6_gen_syndrome_impl)(disks, bytes, ptrs);
 }
 EXPORT_SYMBOL_GPL(raid6_gen_syndrome);
 
@@ -85,7 +87,7 @@ void raid6_xor_syndrome(int disks, int s
 	WARN_ON_ONCE(disks < RAID6_MIN_DISKS);
 	WARN_ON_ONCE(stop < start);
 
-	raid6_call.xor_syndrome(disks, start, stop, bytes, ptrs);
+	static_call(raid6_xor_syndrome_impl)(disks, start, stop, bytes, ptrs);
 }
 EXPORT_SYMBOL_GPL(raid6_xor_syndrome);
 
@@ -96,7 +98,7 @@ EXPORT_SYMBOL_GPL(raid6_xor_syndrome);
  */
 bool raid6_can_xor_syndrome(void)
 {
-	return !!raid6_call.xor_syndrome;
+	return !!static_call_query(raid6_xor_syndrome_impl);
 }
 EXPORT_SYMBOL_GPL(raid6_can_xor_syndrome);
 
@@ -195,7 +197,8 @@ static int raid6_choose_gen(void *(*cons
 		return -EINVAL;
 	}
 
-	raid6_call = *best;
+	static_call_update(raid6_gen_syndrome_impl, best->gen_syndrome);
+	static_call_update(raid6_xor_syndrome_impl, best->xor_syndrome);
 
 	pr_info("raid6: using algorithm %s gen() %ld MB/s\n",
 		best->name,
@@ -240,7 +243,10 @@ static int __init raid6_select_algo(void
 	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK) || raid6_nr_algos == 1) {
 		pr_info("raid6: skipped pq benchmark and selected %s\n",
 			raid6_algos[raid6_nr_algos - 1]->name);
-		raid6_call = *raid6_algos[raid6_nr_algos - 1];
+		static_call_update(raid6_gen_syndrome_impl,
+				raid6_algos[raid6_nr_algos - 1]->gen_syndrome);
+		static_call_update(raid6_xor_syndrome_impl,
+				raid6_algos[raid6_nr_algos - 1]->xor_syndrome);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from hch@lst.de are

raid6-turn-the-userspace-test-harness-into-a-kunit-test.patch
raid6-remove-__kernel__-ifdefs.patch
raid6-move-to-lib-raid.patch
raid6-remove-unused-defines-in-pqh.patch
raid6-remove-raid6_get_zero_page.patch
raid6-use-named-initializers-for-struct-raid6_calls.patch
raid6-improve-the-public-interface.patch
raid6-warn-when-using-less-than-four-devices.patch
raid6-hide-internals.patch
raid6-rework-registration-of-optimized-algorithms.patch
raid6-use-static_call-for-gen_syndrom-and-xor_syndrom.patch
raid6-use-static_call-for-raid6_recov_2data-and-raid6_recov_datap.patch
raid6-update-top-of-file-comments.patch
raid6_kunit-use-kunit_case_param.patch
raid6_kunit-dynamically-allocate-data-buffers-using-vmalloc.patch
raid6_kunit-cleanup-dataptr-handling.patch
raid6_kunit-randomize-parameters-and-increase-limits.patch
raid6_kunit-randomize-buffer-alignment.patch

