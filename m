Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B9D17F385;
	Wed, 17 Jul 2024 19:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721245741; cv=none; b=BaSRmD43EiaVmTD3hWPqZ3yWrGAHIC5fbX/2C+JzIIXX0JK5l/ma3b0bvfWFxFosYzBYuDERr3BhhF4SyX8QPN/nccC1XOOXDqToRpn9XQkHBVwxW020Bf7TlWWgT6spS1jK/4vfTC4vxMGqlPch+lmrjC2uV3l2wRbH4Vkln/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721245741; c=relaxed/simple;
	bh=ztfVopKRce9PjULPAeFojdN1XcUZFJMBcx7jSdMOvy0=;
	h=Date:To:From:Subject:Message-Id; b=RgUgoe0p/7ZLSbhNQlF0zgUw1nqUcG5WPKgs8XqYjsXKaIJiQhaAarevorpY1CFz7ydXtNXKCAcz24W+jroKWEGM7D0ftMkAqruCGpuN3JoWh7tawHVoP2H9aEILsEM5NTMmmC+fi9QfYZZtl6xV+rIEpLGxjcSwZmQwoTliEoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YEjgsDmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YEjgsDmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB4BC2BD10;
	Wed, 17 Jul 2024 19:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721245740;
	bh=ztfVopKRce9PjULPAeFojdN1XcUZFJMBcx7jSdMOvy0=;
	h=Date:To:From:Subject:From;
	b=YEjgsDmZMZGvAi8ToB0nCMUUGOdHSiRLPJnz05tUdUpS7JLwIkghgMX5ISsl98elM
	 cNdL2ks3pwjgYTHOuFTmeR2Z6bryxVQUyrryWtB2LkBlCgPfbXR8XYKfpQiUN2fpV7
	 +7choyk4BJZuaAN1W+pqyQOvIk8J/TOarHROqTe0=
Date: Wed, 17 Jul 2024 12:49:00 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,stable@vger.kernel.org,dyoung@redhat.com,bhe@redhat.com,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] crash-fix-x86_32-memory-reserve-dead-loop-retry-bug.patch removed from -mm tree
Message-Id: <20240717194900.BAB4BC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: fix x86_32 memory reserve dead loop retry bug
has been removed from the -mm tree.  Its filename was
     crash-fix-x86_32-memory-reserve-dead-loop-retry-bug.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jinjie Ruan <ruanjinjie@huawei.com>
Subject: crash: fix x86_32 memory reserve dead loop retry bug
Date: Thu, 11 Jul 2024 15:31:18 +0800

On x86_32 Qemu machine with 1GB memory, the cmdline "crashkernel=1G,high"
will cause system stall as below:

	ACPI: Reserving FACP table memory at [mem 0x3ffe18b8-0x3ffe192b]
	ACPI: Reserving DSDT table memory at [mem 0x3ffe0040-0x3ffe18b7]
	ACPI: Reserving FACS table memory at [mem 0x3ffe0000-0x3ffe003f]
	ACPI: Reserving APIC table memory at [mem 0x3ffe192c-0x3ffe19bb]
	ACPI: Reserving HPET table memory at [mem 0x3ffe19bc-0x3ffe19f3]
	ACPI: Reserving WAET table memory at [mem 0x3ffe19f4-0x3ffe1a1b]
	143MB HIGHMEM available.
	879MB LOWMEM available.
	  mapped low ram: 0 - 36ffe000
	  low ram: 0 - 36ffe000
	 (stall here)

The reason is that the CRASH_ADDR_LOW_MAX is equal to CRASH_ADDR_HIGH_MAX
on x86_32, the first high crash kernel memory reservation will fail, then
go into the "retry" loop and never came out as below.

-> reserve_crashkernel_generic() and high is true
 -> alloc at [CRASH_ADDR_LOW_MAX, CRASH_ADDR_HIGH_MAX] fail
    -> alloc at [0, CRASH_ADDR_LOW_MAX] fail and repeatedly
       (because CRASH_ADDR_LOW_MAX = CRASH_ADDR_HIGH_MAX).

Fix it by changing the out check condition.

After this patch, it prints:
	cannot allocate crashkernel (size:0x40000000)

Link: https://lkml.kernel.org/r/20240711073118.1289866-1-ruanjinjie@huawei.com
Fixes: 9c08a2a139fe ("x86: kdump: use generic interface to simplify crashkernel reservation code")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_reserve.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/crash_reserve.c~crash-fix-x86_32-memory-reserve-dead-loop-retry-bug
+++ a/kernel/crash_reserve.c
@@ -420,7 +420,7 @@ retry:
 		 * For crashkernel=size[KMG],high, if the first attempt was
 		 * for high memory, fall back to low memory.
 		 */
-		if (high && search_end == CRASH_ADDR_HIGH_MAX) {
+		if (high && search_base == CRASH_ADDR_LOW_MAX) {
 			search_end = CRASH_ADDR_LOW_MAX;
 			search_base = 0;
 			goto retry;
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are


