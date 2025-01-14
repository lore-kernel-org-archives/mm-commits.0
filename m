Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331C4224B1C
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 01:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736818111; cv=none; b=PeMDn4jvGYqNdWupIhDGVHymtvsxbGqJhojNbskyIYKzA70MZvsN0lMox8Gx+uJj+s5A9nYQi6EQV5ahcYbnC6emZF1gouhcGjHy8XHJaL9KOwmvJ/jGkpxDwHFBXpUNUv7W/gcc+JfH9ZcR/u/hlWocgfdxQdTCXFOsetUERyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736818111; c=relaxed/simple;
	bh=DMYSpY2PuuYHzAppJ9YC9IpdM99EWgAObmZnYlOw4hI=;
	h=Date:To:From:Subject:Message-Id; b=mPKTCOmzU7bK7BjX5ZEBjdnsyE+oHJ33Z7i87pnDEGiBe8QxE/6p270Cazxw2hsnuqKG2VoFcsoQyegBAP4bg5p+odQLCQzYbVXU/nvJ6b62UjszTACWLZ5124xAU+34Dq0/4xVxv6ZV1FeuTopa1QQfOrB10AjGCDxbvXM/cmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=chqWY+hl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="chqWY+hl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83ECAC4CED6;
	Tue, 14 Jan 2025 01:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736818110;
	bh=DMYSpY2PuuYHzAppJ9YC9IpdM99EWgAObmZnYlOw4hI=;
	h=Date:To:From:Subject:From;
	b=chqWY+hl/God26nuT1HKFyxCcOiv3th8fhr27sjThzslTuS9AslQiRfKaJBmzeFci
	 8sC28mTchF1VcJfZMIeOaR6NY7vco9sqCGWoeIoj+bDn4IRfDPcwFpHPIDYEtCfxOS
	 nm1ltW3eHDCCsdS1IMT63enn9JpLahybDR91Ij3Y=
Date: Mon, 13 Jan 2025 17:28:29 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,shuah@kernel.org,oliver.sang@intel.com,dev.jain@arm.com,david@redhat.com,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-virtual_address_range-mmap-without-prot_write.patch added to mm-unstable branch
Message-Id: <20250114012830.83ECAC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: virtual_address_range: mmap() without PROT_WRITE
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-virtual_address_range-mmap-without-prot_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-virtual_address_range-mmap-without-prot_write.patch

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
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: selftests/mm: virtual_address_range: mmap() without PROT_WRITE
Date: Mon, 13 Jan 2025 14:15:35 +0100

Patch series "selftests/mm: virtual_address_range: Reduce memory", v3.

The selftest started failing since commit e93d2521b27f ("x86/vdso: Split
virtual clock pages into dedicated mapping") was merged.  While debugging
I stumbled upon some memory usage optimizations.

With these test now runs on a VM with only 60MiB of memory.


This patch (of 4):

When mapping a larger chunk than physical memory is available with
PROT_WRITE and overcommit is disabled, the mapping will fail.  This will
prevent the test from running on systems with less then ~1GiB of memory
and triggering an inscrutinable test failure.  As the mappings are never
written to anyways, the flag can be removed.

Link: https://lkml.kernel.org/r/20250113-virtual_address_range-tests-v3-0-f4a8e6b7feed@linutronix.de
Link: https://lkml.kernel.org/r/20250113-virtual_address_range-tests-v3-1-f4a8e6b7feed@linutronix.de
Fixes: 010409649885 ("selftests/mm: confirm VA exhaustion without reliance on correctness of mmap()")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-virtual_address_range-mmap-without-prot_write
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -166,7 +166,7 @@ int main(void)
 	ksft_set_plan(1);
 
 	for (i = 0; i < NR_CHUNKS_LOW; i++) {
-		ptr[i] = mmap(NULL, MAP_CHUNK_SIZE, PROT_READ | PROT_WRITE,
+		ptr[i] = mmap(NULL, MAP_CHUNK_SIZE, PROT_READ,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
 		if (ptr[i] == MAP_FAILED) {
@@ -186,7 +186,7 @@ int main(void)
 
 	for (i = 0; i < NR_CHUNKS_HIGH; i++) {
 		hint = hint_addr();
-		hptr[i] = mmap(hint, MAP_CHUNK_SIZE, PROT_READ | PROT_WRITE,
+		hptr[i] = mmap(hint, MAP_CHUNK_SIZE, PROT_READ,
 			       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
 		if (hptr[i] == MAP_FAILED)
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are

selftests-mm-virtual_address_range-mmap-without-prot_write.patch
selftests-mm-virtual_address_range-unmap-chunks-after-validation.patch
selftests-mm-vm_util-split-up-proc-self-smaps-parsing.patch
selftests-mm-virtual_address_range-avoid-reading-from-vm_io-mappings.patch

