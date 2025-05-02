Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9062A33993
	for <mm-commits@vger.kernel.org>; Fri,  2 May 2025 00:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746146630; cv=none; b=SEtfJJOlB5HHhtpM3XHo9Vf4kZryV28H+/mhNd7EDlDrJSAV03jLYYDEq8X7KmHJmicgxXmJWmx7ZmNENWEVGzAcWckPjki4LSC9lhjEDV40etzgSkTv06W5PBRYHPwZWt5vMqyW0oEYb3fN9XsvHwO6q4y1RTUpBNXNtMes68I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746146630; c=relaxed/simple;
	bh=YR0ni2egxOnjHOEVLfsR1Lxritq6uQE/VNmDkn9X6CU=;
	h=Date:To:From:Subject:Message-Id; b=O4ukMcGo5rMHIrATi+jcO8yUIMuxpQo0qcsMSP/PxPncMGQIigY4UIL6AG9uPbbnSu36dCPWb9a54kvbeWlcmNEHk0XCa4rVOcm1KLZEjFlgSE95slx4Ql7Ll56PIu1MREYtSRpDMhwy4iW8f5uBFQ7GELwGstDMoNSZHwPNnyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eqgc30jm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eqgc30jm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F11C4CEE3;
	Fri,  2 May 2025 00:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746146630;
	bh=YR0ni2egxOnjHOEVLfsR1Lxritq6uQE/VNmDkn9X6CU=;
	h=Date:To:From:Subject:From;
	b=eqgc30jmXV59/vDBsqp5XRIfan0WMvjqIgYFdtyx92Jv1mTaxVJfuW3jOT7BrhgdX
	 1w7iwMedCQXqy8ax1znrBKCP2K9ERh/iNfTUT5gL+PDH+s7j9FZfuK51bZJQQ0o4y+
	 tQ4zFDLcy8nImVCHKMdpVu/FE4Ra67hzQCvDMicQ=
Date: Thu, 01 May 2025 17:43:49 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,changyuanl@google.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-boot-make-sure-kaslr-does-not-step-over-kho-preserved-memory.patch added to mm-unstable branch
Message-Id: <20250502004350.00F11C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/boot: make sure KASLR does not step over KHO preserved memory
has been added to the -mm mm-unstable branch.  Its filename is
     x86-boot-make-sure-kaslr-does-not-step-over-kho-preserved-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-boot-make-sure-kaslr-does-not-step-over-kho-preserved-memory.patch

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
Subject: x86/boot: make sure KASLR does not step over KHO preserved memory
Date: Thu, 1 May 2025 15:54:21 -0700

KHO uses "scratch regions" to bootstrap a kexec'ed kernel.  These regions
are guaranteed to not have any memory that KHO would preserve.

Teach KASLR in decompression code to only consider these scratch regions
when KHO is enabled to make sure preserved memory won't get overwritten.

Link: https://lkml.kernel.org/r/20250501225425.635167-15-changyuanl@google.com
Signed-off-by: Alexander Graf <graf@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Co-developed-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/compressed/kaslr.c |   52 ++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

--- a/arch/x86/boot/compressed/kaslr.c~x86-boot-make-sure-kaslr-does-not-step-over-kho-preserved-memory
+++ a/arch/x86/boot/compressed/kaslr.c
@@ -760,6 +760,55 @@ static void process_e820_entries(unsigne
 	}
 }
 
+/*
+ * If KHO is active, only process its scratch areas to ensure we are not
+ * stepping onto preserved memory.
+ */
+#ifdef CONFIG_KEXEC_HANDOVER
+static bool process_kho_entries(unsigned long minimum, unsigned long image_size)
+{
+	struct kho_scratch *kho_scratch;
+	struct setup_data *ptr;
+	int i, nr_areas = 0;
+
+	ptr = (struct setup_data *)boot_params_ptr->hdr.setup_data;
+	while (ptr) {
+		if (ptr->type == SETUP_KEXEC_KHO) {
+			struct kho_data *kho = (struct kho_data *)ptr->data;
+
+			kho_scratch = (void *)kho->scratch_addr;
+			nr_areas = kho->scratch_size / sizeof(*kho_scratch);
+
+			break;
+		}
+
+		ptr = (struct setup_data *)ptr->next;
+	}
+
+	if (!nr_areas)
+		return false;
+
+	for (i = 0; i < nr_areas; i++) {
+		struct kho_scratch *area = &kho_scratch[i];
+		struct mem_vector region = {
+			.start = area->addr,
+			.size = area->size,
+		};
+
+		if (process_mem_region(&region, minimum, image_size))
+			break;
+	}
+
+	return true;
+}
+#else
+static inline bool process_kho_entries(unsigned long minimum,
+				       unsigned long image_size)
+{
+	return false;
+}
+#endif
+
 static unsigned long find_random_phys_addr(unsigned long minimum,
 					   unsigned long image_size)
 {
@@ -775,7 +824,8 @@ static unsigned long find_random_phys_ad
 		return 0;
 	}
 
-	if (!process_efi_entries(minimum, image_size))
+	if (!process_kho_entries(minimum, image_size) &&
+	    !process_efi_entries(minimum, image_size))
 		process_e820_entries(minimum, image_size);
 
 	phys_addr = slots_fetch_random();
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

