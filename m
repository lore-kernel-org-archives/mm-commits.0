Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD98372EC0
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028821; cv=none; b=SJMvng45PJNmcp32/c3ZppzGbybGy7tObSlQ7P52WPh5Ll3QlyJhVATULa37ifdcZN4jk4RwsiBM7SpXkPNQ+knh+sqIr8qRrMh5eJrjmcp3IoHHkQvfD9ejEdc8/GomhOTD4C3ru9zEldH81YBC3mORtxuqpb4CKR0YiTTBQxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028821; c=relaxed/simple;
	bh=JK42X6F39lzgYGP4Gx4B+UqUsUdwmqRhELbbZngTSxM=;
	h=Date:To:From:Subject:Message-Id; b=DadrnmBQPRvbTpxibM/Kwzbdk9B1vpXa0sL0n6raaVJcTtedJ8TKnQ4EQSrFHeWFnGxtKIzMANZ4aJQmO/5tKPEOcBaNR19kxTqTHhTJhwclN0Qv2Bw7K37gBM+j9aPLcEiyTmL9/2jBIkX3VJ7Ig2fF82HxpA+mJ9yRwY/uru4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o1myD2/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o1myD2/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718FE1F00898;
	Fri, 29 May 2026 04:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028819;
	bh=qdM/+SRG1Yw9P0Io4Nor8hWnv58oFRmGEVBV2WAa6Ig=;
	h=Date:To:From:Subject;
	b=o1myD2/eJAwzS+YITmpW8aTziN+JGVlH5IXDkWIsNTB1BvSZwf0zSipUguDsActrQ
	 mR04VO++VAoAoY0NFuueSUqw3MxGm2fRaofHANGJpQLEGyxzhRHg7trkrjW+qXZlO4
	 0jYpXN0DigamRTtbFJBT/IRBGJR1nzhygUI62M44=
Date: Thu, 28 May 2026 21:26:59 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,svens@linux.ibm.com,song@kernel.org,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maddy@linux.ibm.com,linan122@huawei.com,kernel@xen0n.name,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,dsterba@suse.com,dan.j.williams@intel.com,clm@fb.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,arnd@arndb.de,ardb@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] raid6-use-static_call-for-gen_syndrom-and-xor_syndrom.patch removed from -mm tree
Message-Id: <20260529042659.718FE1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: raid6: use static_call for gen_syndrom and xor_syndrom
has been removed from the -mm tree.  Its filename was
     raid6-use-static_call-for-gen_syndrom-and-xor_syndrom.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


