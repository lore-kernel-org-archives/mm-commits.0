From: akpm@linux-foundation.org
Subject: + mips-remove-savemaxmem-parameter-setup.patch added to -mm tree
Date: Wed, 29 May 2013 15:20:23 -0700
Message-ID: <51a67f27.nFIXmfl0+aiwhdV7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966122Ab3E2WUY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 18:20:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, tony.luck@intel.com, schwidefsky@de.ibm.com, ralf@linux-mips.org, paulus@samba.org, matt.fleming@intel.com, hpa@zytor.com, holzheu@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, fenghua.yu@intel.com, ebiederm@xmission.com, dave@sr71.net, benh@kernel.crashing.org, zhangyanfei@cn.fujitsu.com

Subject: + mips-remove-savemaxmem-parameter-setup.patch added to -mm tree
To: zhangyanfei@cn.fujitsu.com,benh@kernel.crashing.org,dave@sr71.net,ebiederm@xmission.com,fenghua.yu@intel.com,heiko.carstens@de.ibm.com,holzheu@linux.vnet.ibm.com,hpa@zytor.com,matt.fleming@intel.com,paulus@samba.org,ralf@linux-mips.org,schwidefsky@de.ibm.com,tony.luck@intel.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 15:20:23 -0700


The patch titled
     Subject: mips: remove savemaxmem parameter setup
has been added to the -mm tree.  Its filename is
     mips-remove-savemaxmem-parameter-setup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mips: remove savemaxmem parameter setup

saved_max_pfn is used to know the amount of memory that the previous
kernel used.  And for powerpc, we set saved_max_pfn by passing the kernel
commandline parameter "savemaxmem=".

The only user of saved_max_pfn in mips is read_oldmem interface.  Since we
have removed read_oldmem, so we don't need this parameter anymore.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/crash_dump.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN arch/mips/kernel/crash_dump.c~mips-remove-savemaxmem-parameter-setup arch/mips/kernel/crash_dump.c
--- a/arch/mips/kernel/crash_dump.c~mips-remove-savemaxmem-parameter-setup
+++ a/arch/mips/kernel/crash_dump.c
@@ -4,16 +4,6 @@
 #include <asm/uaccess.h>
 #include <linux/slab.h>
 
-static int __init parse_savemaxmem(char *p)
-{
-	if (p)
-		saved_max_pfn = (memparse(p, &p) >> PAGE_SHIFT) - 1;
-
-	return 1;
-}
-__setup("savemaxmem=", parse_savemaxmem);
-
-
 static void *kdump_buf_page;
 
 /**
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

linux-next.patch
ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
vmcore-clean-up-read_vmcore.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmcore-treat-memory-chunks-referenced-by-pt_load-program-header-entries-in-page-size-boundary-in-vmcore_list.patch
vmalloc-make-find_vm_area-check-in-range.patch
vmalloc-introduce-remap_vmalloc_range_partial.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-calculate-vmcore-file-size-from-buffer-size-and-total-size-of-vmcore-objects.patch
vmcore-support-mmap-on-proc-vmcore.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
dev-oldmem-remove-the-interface.patch
dev-oldmem-remove-the-interface-fix.patch
documentation-kdump-kdumptxt-remove-dev-oldmem-description.patch
mips-remove-savemaxmem-parameter-setup.patch
powerpc-remove-savemaxmem-parameter-setup.patch
ia64-remove-setting-for-saved_max_pfn.patch
s390-remove-setting-for-saved_max_pfn.patch

