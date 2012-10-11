From: akpm@linux-foundation.org
Subject: [merged] arch-powerpc-platforms-pseries-hotplug-memoryc-fix-section-handling-code.patch removed from -mm tree
Date: Thu, 11 Oct 2012 13:58:51 -0700
Message-ID: <20121011205853.A65A0100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:62654 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab2JKU6z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 16:58:55 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so251836vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 13:58:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, isimatu.yasuaki@jp.fujitsu.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/powerpc/platforms/pseries/hotplug-memory.c: fix section handling code
has been removed from the -mm tree.  Its filename was
     arch-powerpc-platforms-pseries-hotplug-memoryc-fix-section-handling-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/powerpc/platforms/pseries/hotplug-memory.c: fix section handling code

arch/powerpc/platforms/pseries/hotplug-memory.c: In function 'pseries_remove_memblock':
arch/powerpc/platforms/pseries/hotplug-memory.c:103:17: error: unused variable 'pfn' [-Werror=unused-variable]

Caused by commit d760afd4d257 ("memory-hotplug: suppress "Trying to free
nonexistent resource <XXXXXXXXXXXXXXXX-YYYYYYYYYYYYYYYY>" warning").

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/hotplug-memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/platforms/pseries/hotplug-memory.c~arch-powerpc-platforms-pseries-hotplug-memoryc-fix-section-handling-code arch/powerpc/platforms/pseries/hotplug-memory.c
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c~arch-powerpc-platforms-pseries-hotplug-memoryc-fix-section-handling-code
+++ a/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -101,7 +101,7 @@ static int pseries_remove_memblock(unsig
 	sections_to_remove = (memblock_size >> PAGE_SHIFT) / PAGES_PER_SECTION;
 	for (i = 0; i < sections_to_remove; i++) {
 		unsigned long pfn = start_pfn + i * PAGES_PER_SECTION;
-		ret = __remove_pages(zone, start_pfn,  PAGES_PER_SECTION);
+		ret = __remove_pages(zone, pfn, PAGES_PER_SECTION);
 		if (ret)
 			return ret;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

