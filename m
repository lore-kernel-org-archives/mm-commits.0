Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD76A3D3B8
	for <mm-commits@vger.kernel.org>; Wed, 15 Jan 2025 01:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736903845; cv=none; b=PhvxBzngDeeRH1SwCE7OF8ReLysszOv/oYRfGcD3d17h5Sr8di0w8EWM+IH0ulrE97giAufAuF0B7Q8Lfl68M+BHxOmnPa0nVqchZGwVQZM+HWQWzGo2zDzjuhr/jxJF78MY5uruQxeT/ScPTn72OECrjJuGqxk1enhTKWV6T0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736903845; c=relaxed/simple;
	bh=X6D0xW7nnvi0Nxe6h/uigi+YzkVxnfdugjuO6nq5XFM=;
	h=Date:To:From:Subject:Message-Id; b=iFZQgPB/1ovRSUDajNpmBP5CVBv2cgwNvUvB/8meS4QNbfTrq5uUK71lKBr4k2cERv2C/uvp1FB0w9JzoYTinSSL5wFKr0R3b6PtFwUkEB/4UQ5altqtgjpYliMCIYUDO8/eXBG37ebusE7tsFXWKGXpkeZmsyk9C/E7jZ83BXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uhJjqBeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uhJjqBeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC88C4CEE4;
	Wed, 15 Jan 2025 01:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736903845;
	bh=X6D0xW7nnvi0Nxe6h/uigi+YzkVxnfdugjuO6nq5XFM=;
	h=Date:To:From:Subject:From;
	b=uhJjqBeM46a1+uiwDNPTRIGM/NUrVczEnNMeDdVcN49GV31a6UB8wcdihrII3M7i/
	 e2AoqFGHBs5IOzShi/aMvf/olHWBXRqWQ5V6UYXTEQrZLCAOOJSmstSqzZhxxM/sN3
	 L9sBhmYBt/d3CCM3sb9UozWQN/kKUyD5MD8ZU/NM=
Date: Tue, 14 Jan 2025 17:17:24 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,shuah@kernel.org,oliver.sang@intel.com,khandual@linux.vnet.ibm.com,dev.jain@arm.com,david@redhat.com,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-virtual_address_range-avoid-reading-from-vm_io-mappings.patch added to mm-unstable branch
Message-Id: <20250115011725.3CC88C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: virtual_address_range: avoid reading from VM_IO mappings
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-virtual_address_range-avoid-reading-from-vm_io-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-virtual_address_range-avoid-reading-from-vm_io-mappings.patch

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
Subject: selftests/mm: virtual_address_range: avoid reading from VM_IO mappings
Date: Tue, 14 Jan 2025 17:06:48 +0100

The virtual_address_range selftest reads from the start of each mapping
listed in /proc/self/maps.  However not all mappings are valid to be
arbitrarily accessed.

For example the vvar data used for virtual clocks on x86 [vvar_vclock] can
only be accessed if 1) the kernel configuration enables virtual clocks and
2) the hypervisor provided the data for it.  Only the VDSO itself has the
necessary information to know this.  Since commit e93d2521b27f ("x86/vdso:
Split virtual clock pages into dedicated mapping") the virtual clock data
was split out into its own mapping, leading to EFAULT from read() during
the validation.

Check for the VM_IO flag as a proxy.  It is present for the VVAR mappings
and MMIO ranges can be dangerous to access arbitrarily.

Link: https://lkml.kernel.org/r/20250114-virtual_address_range-tests-v4-4-6fd7269934a5@linutronix.de
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202412271148.2656e485-lkp@intel.com
Fixes: e93d2521b27f ("x86/vdso: Split virtual clock pages into dedicated mapping")
Fixes: 010409649885 ("selftests/mm: confirm VA exhaustion without reliance on correctness of mmap()")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/lkml/e97c2a5d-c815-4936-a767-ac42a3220a90@redhat.com/
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |    4 +
 tools/testing/selftests/mm/vm_util.c               |   24 +++++++++++
 tools/testing/selftests/mm/vm_util.h               |    1 
 3 files changed, 29 insertions(+)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-virtual_address_range-avoid-reading-from-vm_io-mappings
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -15,6 +15,7 @@
 #include <sys/time.h>
 #include <fcntl.h>
 
+#include "vm_util.h"
 #include "../kselftest.h"
 
 /*
@@ -159,6 +160,9 @@ static int validate_complete_va_space(vo
 		if (prot[0] != 'r')
 			continue;
 
+		if (check_vmflag_io((void *)start_addr))
+			continue;
+
 		/*
 		 * Confirm whether MAP_CHUNK_SIZE chunk can be found or not.
 		 * If write succeeds, no need to check MAP_CHUNK_SIZE - 1
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-virtual_address_range-avoid-reading-from-vm_io-mappings
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -400,3 +400,27 @@ unsigned long get_free_hugepages(void)
 	fclose(f);
 	return fhp;
 }
+
+bool check_vmflag_io(void *addr)
+{
+	char buffer[MAX_LINE_LENGTH];
+	const char *flags;
+	size_t flaglen;
+
+	flags = __get_smap_entry(addr, "VmFlags:", buffer, sizeof(buffer));
+	if (!flags)
+		ksft_exit_fail_msg("%s: No VmFlags for %p\n", __func__, addr);
+
+	while (true) {
+		flags += strspn(flags, " ");
+
+		flaglen = strcspn(flags, " ");
+		if (!flaglen)
+			return false;
+
+		if (flaglen == strlen("io") && !memcmp(flags, "io", flaglen))
+			return true;
+
+		flags += flaglen;
+	}
+}
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-virtual_address_range-avoid-reading-from-vm_io-mappings
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -53,6 +53,7 @@ int uffd_unregister(int uffd, void *addr
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls);
 unsigned long get_free_hugepages(void);
+bool check_vmflag_io(void *addr);
 
 /*
  * On ppc64 this will only work with radix 2M hugepage size
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are

selftests-mm-virtual_address_range-mmap-without-prot_write.patch
selftests-mm-virtual_address_range-unmap-chunks-after-validation.patch
selftests-mm-vm_util-split-up-proc-self-smaps-parsing.patch
selftests-mm-virtual_address_range-avoid-reading-from-vm_io-mappings.patch

