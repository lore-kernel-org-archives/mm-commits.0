Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0280D182C5
	for <mm-commits@vger.kernel.org>; Wed, 15 Jan 2025 01:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736903839; cv=none; b=Q6J4q7m1PGl8wsHuhwsFfNHfvCisd6tbxMXzPZ2fc/Hnt8+7Q3G65X3rE+16lJzHwel0J035ue+AsZe261uDCafo6gtTgrBzGPR8xEaxfoopDQpZx7OW6iFPkt/qrf+3gmeUfcIWKAOx1HWs4G+MgRWMKAyO0U/9jzlKT2Vti5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736903839; c=relaxed/simple;
	bh=R2HMapd6+Ka4NBaCXMA1NWuFedLtHV3f4mn/tIQ8ZKQ=;
	h=Date:To:From:Subject:Message-Id; b=iALCh4P5Lx62/HNbuCi7AwpJDeFFK8jvbvYaJbeci4teGkAiMEgd9wAkBr3Ba9gYBoPezYMDo2atykupkqXof2aZ8yM4HiWT/V36cDJ17WJlqFjBfN/4yu3qWNanB+Bxr2gZlA/+srx2VBTle37NCz+iVgbGe6fIH/jELE9/Gkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kCTE7z/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kCTE7z/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7782CC4CEE3;
	Wed, 15 Jan 2025 01:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736903838;
	bh=R2HMapd6+Ka4NBaCXMA1NWuFedLtHV3f4mn/tIQ8ZKQ=;
	h=Date:To:From:Subject:From;
	b=kCTE7z/T8ZgTLpBQuL1SHSXJWK/122hl4/P4NI4IdqWpsHlrFm3JueM33V/2erb0G
	 PM6PqJDfr5ODHdHxf6Q4DAcqJKcImdO5dxjxzx4VZIBGtGvbgZoAXua2jbuYTM+FvX
	 YOQgFMAZesayr010JMRhhxPrK5jiLrW5adhw+Xic=
Date: Tue, 14 Jan 2025 17:17:17 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,shuah@kernel.org,oliver.sang@intel.com,khandual@linux.vnet.ibm.com,dev.jain@arm.com,david@redhat.com,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-virtual_address_range-mmap-without-prot_write.patch added to mm-unstable branch
Message-Id: <20250115011718.7782CC4CEE3@smtp.kernel.org>
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
Date: Tue, 14 Jan 2025 17:06:45 +0100

Patch series "selftests/mm: virtual_address_range: Reduce memory", v4.

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

Link: https://lkml.kernel.org/r/20250114-virtual_address_range-tests-v4-0-6fd7269934a5@linutronix.de
Link: https://lkml.kernel.org/r/20250114-virtual_address_range-tests-v4-1-6fd7269934a5@linutronix.de
Fixes: 4e5ce33ceb32 ("selftests/vm: add a test for virtual address range mapping")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
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

