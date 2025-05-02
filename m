Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CAB286A1
	for <mm-commits@vger.kernel.org>; Fri,  2 May 2025 00:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746146627; cv=none; b=kuhpTewSYMGucq+6PkOUnMWgSnC8L4EwobQm9GhG2kkSfLuIiWQWt5L+EreoeWadsoclzJt0aU8GBNGuc+1rB2Q5/ZL7PX+tLTV8kocrc8mEtpkUGbHbTiZ/h0P9UpKJuBtnY5tW02WlQNQUiRmE8GpkLojUHnInrLm2/+Nn35M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746146627; c=relaxed/simple;
	bh=WYFE4L3yycrYv1J+5xqIQjzcQOWHUBTjIqwjONyEi6E=;
	h=Date:To:From:Subject:Message-Id; b=JD+SIklM18eUoWTkZpz8d71j1Reelsw/PEOCAABB8YOZXLSSspGEM3hjduULvcEGeTX7hGOTCh5vEF6etrba0wpgix0fgU9aeY4175fcg/q93m9utINTFkqYk2yerhrvEuhIHMzgV/FK486/481kQlqHmTpeO9XazoVFYohg26o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IWqcm66C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IWqcm66C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C046C4CEE3;
	Fri,  2 May 2025 00:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746146627;
	bh=WYFE4L3yycrYv1J+5xqIQjzcQOWHUBTjIqwjONyEi6E=;
	h=Date:To:From:Subject:From;
	b=IWqcm66CuLlkpsy3m6UZNR6I1pTgujg1/lAa4bNeDmSIPzwBkHl10rBDMlMWltKcU
	 ntixrJuYPb39+CgxkPNgQW2LLH12nADRtIG+WqGJDUCWideHUkxTiOOdDwUMRcULDq
	 ytMY+1Ay9CI4cEXj3bJuhb6n/GliXq6KyIFv+vt4=
Date: Thu, 01 May 2025 17:43:47 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,changyuanl@google.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-e820-temporarily-enable-kho-scratch-for-memory-below-1m.patch added to mm-unstable branch
Message-Id: <20250502004347.9C046C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/e820: temporarily enable KHO scratch for memory below 1M
has been added to the -mm mm-unstable branch.  Its filename is
     x86-e820-temporarily-enable-kho-scratch-for-memory-below-1m.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-e820-temporarily-enable-kho-scratch-for-memory-below-1m.patch

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
From: Alexander Graf <graf@amazon.com>
Subject: x86/e820: temporarily enable KHO scratch for memory below 1M
Date: Thu, 1 May 2025 15:54:20 -0700

KHO kernels are special and use only scratch memory for memblock
allocations, but memory below 1M is ignored by kernel after early boot and
cannot be naturally marked as scratch.

To allow allocation of the real-mode trampoline and a few (if any) other
very early allocations from below 1M forcibly mark the memory below 1M as
scratch.

After real mode trampoline is allocated, clear that scratch marking.

Link: https://lkml.kernel.org/r/20250501225425.635167-14-changyuanl@google.com
Signed-off-by: Alexander Graf <graf@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Co-developed-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/e820.c   |   18 ++++++++++++++++++
 arch/x86/realmode/init.c |    2 ++
 2 files changed, 20 insertions(+)

--- a/arch/x86/kernel/e820.c~x86-e820-temporarily-enable-kho-scratch-for-memory-below-1m
+++ a/arch/x86/kernel/e820.c
@@ -1273,6 +1273,24 @@ void __init e820__memblock_setup(void)
 	memblock_set_current_limit(ISA_END_ADDRESS);
 
 	/*
+	 * At this point memblock is only allowed to allocate from memory
+	 * below 1M (aka ISA_END_ADDRESS) up until direct map is completely set
+	 * up in init_mem_mapping().
+	 *
+	 * KHO kernels are special and use only scratch memory for memblock
+	 * allocations, but memory below 1M is ignored by kernel after early
+	 * boot and cannot be naturally marked as scratch.
+	 *
+	 * To allow allocation of the real-mode trampoline and a few (if any)
+	 * other very early allocations from below 1M forcibly mark the memory
+	 * below 1M as scratch.
+	 *
+	 * After real mode trampoline is allocated, we clear that scratch
+	 * marking.
+	 */
+	memblock_mark_kho_scratch(0, SZ_1M);
+
+	/*
 	 * The bootstrap memblock region count maximum is 128 entries
 	 * (INIT_MEMBLOCK_REGIONS), but EFI might pass us more E820 entries
 	 * than that - so allow memblock resizing.
--- a/arch/x86/realmode/init.c~x86-e820-temporarily-enable-kho-scratch-for-memory-below-1m
+++ a/arch/x86/realmode/init.c
@@ -65,6 +65,8 @@ void __init reserve_real_mode(void)
 	 * setup_arch().
 	 */
 	memblock_reserve(0, SZ_1M);
+
+	memblock_clear_kho_scratch(0, SZ_1M);
 }
 
 static void __init sme_sev_setup_real_mode(struct trampoline_header *th)
_

Patches currently in -mm which might be from graf@amazon.com are

memblock-add-support-for-scratch-memory.patch
kexec-add-kexec-handover-kho-generation-helpers.patch
kexec-add-kho-parsing-support.patch
kexec-add-kho-support-to-kexec-file-loads.patch
kexec-add-config-option-for-kho.patch
arm64-add-kho-support.patch
x86-kexec-add-support-for-passing-kexec-handover-kho-data.patch
x86-e820-temporarily-enable-kho-scratch-for-memory-below-1m.patch
x86-boot-make-sure-kaslr-does-not-step-over-kho-preserved-memory.patch
x86-kconfig-enable-kexec-handover-for-64-bits.patch
memblock-add-kho-support-for-reserve_mem.patch
documentation-add-documentation-for-kho.patch

