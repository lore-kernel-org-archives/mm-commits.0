Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AE9DF78
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337161; cv=none; b=MiljGD3pQTaC2QMJA/0tpPcPrujwZU4GWW1i1ZfqaGf/IA3GvFA13lO/iL+V9hNlNo+fHW0j3fGftI8VyqmNALkEzkhJS6sYh4zwS8grLTnw3LvF21iFqr8RPdVU89kGVGwtNUbRqpETtuXD7kbSu4acy6TJmYgvIPm02dE4ueU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337161; c=relaxed/simple;
	bh=svkVYAP7oAwYRoku8e63szQhM57fdILZN5iz99qh/Og=;
	h=Date:To:From:Subject:Message-Id; b=HGZ27S7BcgGturS4+lHtlqrbH/w3/fxGTKhDeSoMsVd98XR5zPNwpFTc1WMI//vGPwPGvnQ609rWvDIZ338F8f/stiOHLn3ozKQuuGlL83PvC7OZdC+DvtSg2PNXokfmuWU3xese0dinqizBnJvelKlBuLV/gkpkFKbZQLGvRKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XzzfCvNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XzzfCvNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D66C4CED6;
	Mon, 20 Jan 2025 01:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337160;
	bh=svkVYAP7oAwYRoku8e63szQhM57fdILZN5iz99qh/Og=;
	h=Date:To:From:Subject:From;
	b=XzzfCvNnHF9dd69AoqwepZuxi56Ryu9Csxd+AsyTtnJiV+owHcCsHaVfCYMgZE0l2
	 FMmrgHSZdXnrYV7L4z77rupZP+zxwzan5Vqz8IRMxyQdbJ2cE6ioJif0cHtyocnXfv
	 n2+Zk1fWyO7od0foRT7W8ivNR+aKbaZZLErs0dIM=
Date: Sun, 19 Jan 2025 17:39:19 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,shuah@kernel.org,oliver.sang@intel.com,khandual@linux.vnet.ibm.com,dev.jain@arm.com,david@redhat.com,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-virtual_address_range-avoid-reading-from-vm_io-mappings.patch removed from -mm tree
Message-Id: <20250120013920.84D66C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: virtual_address_range: avoid reading from VM_IO mappings
has been removed from the -mm tree.  Its filename was
     selftests-mm-virtual_address_range-avoid-reading-from-vm_io-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


