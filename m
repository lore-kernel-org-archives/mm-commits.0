Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905FF396591
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779138827; cv=none; b=hqze/2/sJeNCEs6tKV8sE/+f5lqVWOONuNG6tOmDvQtGLkEPVUwtnjCpACQXuDvK3RJTYgs4uSunT++lW7zl8e9io8VsgGrMDczWjoVPc+TwWtU3JMX+rGKCOqGlAqS4NLxHl9DKeeMa8Mi8tYtS4N0Bm5lKiN3baT2MUR+efrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779138827; c=relaxed/simple;
	bh=FKlDMuzz3XLPhhojKbbXSpP1pjRKMldMqm8UMpTDA+Y=;
	h=Date:To:From:Subject:Message-Id; b=KlQH5L9MeAIOgLVBus/gmubvboNo9IDQDt8mGKmtGxM8xMB2aLNvftNBSOqik1Tl+01AQQVTK5GUhvw4V6pGHodj56LdFRV6zWdOZicYtOai2q9vOzZURG2qVMuGjaeZDzN+1HQVyBwlLDsfL1wZ9/GHl1GjKz5NMDz2QXnYJtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bClOjqrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bClOjqrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03051C2BCB7;
	Mon, 18 May 2026 21:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779138827;
	bh=FKlDMuzz3XLPhhojKbbXSpP1pjRKMldMqm8UMpTDA+Y=;
	h=Date:To:From:Subject:From;
	b=bClOjqrAhYm4koZ09oMVrQDY5fSRTy13dr/hNNxlCuy/EMDUxNv1fV8RMzaYrzxan
	 UBzhYMuV8ikxWk9A8nA2Jbqy7jeKPTpa9SVKS0S/b9kaA9GcaxxMyf7NL7A06oODmo
	 /Jd7jGCRicYHX0i4KwZBdrjbEB39RTaMktPB14OE=
Date: Mon, 18 May 2026 14:13:46 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6-warn-when-using-less-than-four-devices.patch added to mm-nonmm-unstable branch
Message-Id: <20260518211347.03051C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid6: warn when using less than four devices
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-warn-when-using-less-than-four-devices.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-warn-when-using-less-than-four-devices.patch

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
Subject: raid6: warn when using less than four devices
Date: Mon, 18 May 2026 07:17:51 +0200

Quoting H.  Peter Anvin who came up with the RAID6 P/Q algorithm, and who
wrote the initial implementation, then still part of the md driver:

  The RAID-6 code has *never* supported only 3 units, and if it ever
  worked for *any* of the implementations it was purely by accident.
  Speaking as the original author I should know; this was deliberate as
  in some cases the degenerate case (3) would have required extra trays
  in the code to no user benefit.

While md never allowed less than 4 devices, btrfs does.  This new warning
will trigger for such file systems, but given how it already causes havoc
that is a good thing.  If btrfs wants to fix third, it should switch to
transparently use three-way mirroring underneath, which will work as P and
Q are copies of the single data device by the definition of the Linux RAID
6 P/Q algorithm.

Link: https://lore.kernel.org/20260518051804.462141-9-hch@lst.de
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

 include/linux/raid/pq.h |    2 ++
 lib/raid/raid6/algos.c  |    2 ++
 2 files changed, 4 insertions(+)

--- a/include/linux/raid/pq.h~raid6-warn-when-using-less-than-four-devices
+++ a/include/linux/raid/pq.h
@@ -11,6 +11,8 @@
 #include <linux/blkdev.h>
 #include <linux/mm.h>
 
+#define RAID6_MIN_DISKS		4
+
 void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
 void raid6_xor_syndrome(int disks, int start, int stop, size_t bytes,
 		void **ptrs);
--- a/lib/raid/raid6/algos.c~raid6-warn-when-using-less-than-four-devices
+++ a/lib/raid/raid6/algos.c
@@ -42,6 +42,7 @@ void raid6_gen_syndrome(int disks, size_
 {
 	WARN_ON_ONCE(!in_task() || irqs_disabled() || softirq_count());
 	WARN_ON_ONCE(bytes & 511);
+	WARN_ON_ONCE(disks < RAID6_MIN_DISKS);
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
 }
@@ -77,6 +78,7 @@ void raid6_xor_syndrome(int disks, int s
 {
 	WARN_ON_ONCE(!in_task() || irqs_disabled() || softirq_count());
 	WARN_ON_ONCE(bytes & 511);
+	WARN_ON_ONCE(disks < RAID6_MIN_DISKS);
 	WARN_ON_ONCE(stop < start);
 
 	raid6_call.xor_syndrome(disks, start, stop, bytes, ptrs);
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

