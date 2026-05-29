Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B312372B2B
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028810; cv=none; b=Mgtw9UtVDsbfN/l9P0fRcvrlRJXVrbvRlbXltdTK2ghv3oUUwrnOfK06ceuE8LEdwHxqBe4pHEq3pGvITYt8g2f9s3N62UJaeyO5k2cfpqq9GpIlgWhiDSs4OZG1DoPo5rLBAa5bXLUPh1AXvwMTTesbxk9G7B7ajgSZhKNEtr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028810; c=relaxed/simple;
	bh=2qcCawHi8brVSTZIPzvymQ9AuJgPIHjTV13e7NCbaYU=;
	h=Date:To:From:Subject:Message-Id; b=Ebswt/G1jQAclKdj6RheiCKQU70wHAEpnSce51lXa45RaCSoO1P8WERbgsYS9so9J2+LMwxA4sj9m3c3kH2SU7OnsBh/g8Zr6PNaLPCCPoaZGNI8WlmjFXfvMKXeiWMZn2dTPB5WH0q8QHOvQrNMPE40P1Z9DjMLqFxfc73tRtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qyJB0cC1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qyJB0cC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB641F00898;
	Fri, 29 May 2026 04:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028809;
	bh=G9jQK6XjegNe4I3Us0gczEvdGSRvhZA/TfXZnNgUPS4=;
	h=Date:To:From:Subject;
	b=qyJB0cC1vFY7spmqx+jb6pDCb46RTJbEa/1Kv1PR1OOedQh5WVPto+nHVQoinLqbj
	 bylgZS8taGjNxJhIDzHocYiizxT/s8/akk4sD4OyvamtayRWFRvMXVGWnFXHQZW77c
	 lGarNVQ6Ieg4ozUoZX/1UO7H/30vAcFYT1bahHCE=
Date: Thu, 28 May 2026 21:26:48 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,svens@linux.ibm.com,song@kernel.org,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maddy@linux.ibm.com,linan122@huawei.com,kernel@xen0n.name,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,dsterba@suse.com,dan.j.williams@intel.com,clm@fb.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,arnd@arndb.de,ardb@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] raid6-warn-when-using-less-than-four-devices.patch removed from -mm tree
Message-Id: <20260529042648.DEB641F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: raid6: warn when using less than four devices
has been removed from the -mm tree.  Its filename was
     raid6-warn-when-using-less-than-four-devices.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


