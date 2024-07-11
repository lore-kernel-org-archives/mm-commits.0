Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CA81EA85;
	Thu, 11 Jul 2024 19:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720725446; cv=none; b=Qv48x2iy6yg8Z8sMABAbDIz/kVSu9v5vOLKuYLgRzboId8265mRLAP71kVr21D6d1e6o5VFm1lAY96V3rehWDcmMhBIbbGtwyGqT/2HcRBp5/9pRcmxhGpUN+yMO02phqcOaQtZUHVID6pepAznnaeosuRYge8RtV3+fmE3FTfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720725446; c=relaxed/simple;
	bh=JEDlTA/gWwVLu+myms/njMtNeizH7dAGGVfr85H4qME=;
	h=Date:To:From:Subject:Message-Id; b=DXBSU5TAVjeYMzDei0zbrPYsjcP0hgMEZ4FdJ381XdCtCAi+hMFQ3k70XODdLT5fHDkZGaKUxj9eXboNjLPIolw2YSQ7TMnHlGN03qO2IvCNmvR0qoFiU637UzW5dk9xmHUpc0xx3KeNZIhc8Sk+HnWiCDd/QIJrGtHxqXbxdl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VmldE/74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VmldE/74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40B3C116B1;
	Thu, 11 Jul 2024 19:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720725445;
	bh=JEDlTA/gWwVLu+myms/njMtNeizH7dAGGVfr85H4qME=;
	h=Date:To:From:Subject:From;
	b=VmldE/74mScEygyfFv30LdCsmd5KXD58Shgg7B7eZTGmNyGk0peoRDQRJ0yoi9FVu
	 7WFj/FiSOFH2TPAPeJn+vNfqCsj1fDtkq3CvnyNU+HutRWj/j2zOdGD1FjYztZWzCX
	 /E4wp7yyD5l6pDVIUSvDD7TtFH2qLko+cmc9ZERA=
Date: Thu, 11 Jul 2024 12:17:25 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,stable@vger.kernel.org,dyoung@redhat.com,bhe@redhat.com,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-fix-x86_32-memory-reserve-dead-loop-retry-bug.patch added to mm-hotfixes-unstable branch
Message-Id: <20240711191725.A40B3C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: fix x86_32 memory reserve dead loop retry bug
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     crash-fix-x86_32-memory-reserve-dead-loop-retry-bug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-fix-x86_32-memory-reserve-dead-loop-retry-bug.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
@@ -421,7 +421,7 @@ retry:
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

crash-fix-x86_32-memory-reserve-dead-loop-retry-bug.patch

