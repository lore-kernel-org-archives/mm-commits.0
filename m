From: akpm@linux-foundation.org
Subject: + memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch added to -mm tree
Date: Thu, 18 Oct 2012 15:31:23 -0700
Message-ID: <20121018223124.B9B2820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:44940 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2JRWb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 18:31:28 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so557292wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 15:31:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, cl@linux.com, dave@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, len.brown@intel.com, liuj97@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, paulus@samba.org, rientjes@google.com, wency@cn.fujitsu.com


The patch titled
     Subject: memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix
has been added to the -mm tree.  Its filename is
     memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix

cleanup ifdefs

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/sparse.c~memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix mm/sparse.c
--- a/mm/sparse.c~memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix
+++ a/mm/sparse.c
@@ -788,6 +788,10 @@ static void clear_hwpoisoned_pages(struc
 		}
 	}
 }
+#else
+static inline void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
+{
+}
 #endif
 
 void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
@@ -803,10 +807,7 @@ void sparse_remove_one_section(struct zo
 		ms->pageblock_flags = NULL;
 	}
 
-#ifdef CONFIG_MEMORY_FAILURE
 	clear_hwpoisoned_pages(memmap, PAGES_PER_SECTION);
-#endif
-
 	free_section_usemap(memmap, usemap);
 }
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

pidns-remove-recursion-from-free_pid_ns-v5-fix.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

