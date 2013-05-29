From: akpm@linux-foundation.org
Subject: +
 documentation-kdump-kdumptxt-remove-dev-oldmem-description.patch added to
 -mm tree
Date: Wed, 29 May 2013 15:20:22 -0700
Message-ID: <51a67f26.MotuwsfjYVQ0NiGS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965980Ab3E2WUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 18:20:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, tony.luck@intel.com, schwidefsky@de.ibm.com, ralf@linux-mips.org, paulus@samba.org, matt.fleming@intel.com, hpa@zytor.com, holzheu@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, fenghua.yu@intel.com, ebiederm@xmission.com, dave@sr71.net, benh@kernel.crashing.org, zhangyanfei@cn.fujitsu.com

Subject: + documentation-kdump-kdumptxt-remove-dev-oldmem-description.patch added to -mm tree
To: zhangyanfei@cn.fujitsu.com,benh@kernel.crashing.org,dave@sr71.net,ebiederm@xmission.com,fenghua.yu@intel.com,heiko.carstens@de.ibm.com,holzheu@linux.vnet.ibm.com,hpa@zytor.com,matt.fleming@intel.com,paulus@samba.org,ralf@linux-mips.org,schwidefsky@de.ibm.com,tony.luck@intel.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 15:20:22 -0700


The patch titled
     Subject: Documentation/kdump/kdump.txt: remove /dev/oldmem description
has been added to the -mm tree.  Its filename is
     documentation-kdump-kdumptxt-remove-dev-oldmem-description.patch

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
Subject: Documentation/kdump/kdump.txt: remove /dev/oldmem description

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
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
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt |   31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff -puN Documentation/kdump/kdump.txt~documentation-kdump-kdumptxt-remove-dev-oldmem-description Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~documentation-kdump-kdumptxt-remove-dev-oldmem-description
+++ a/Documentation/kdump/kdump.txt
@@ -47,19 +47,12 @@ parameter. Optionally the size of the EL
 when using the elfcorehdr=[size[KMG]@]offset[KMG] syntax.
 
 
-With the dump-capture kernel, you can access the memory image, or "old
-memory," in two ways:
-
-- Through a /dev/oldmem device interface. A capture utility can read the
-  device file and write out the memory in raw format. This is a raw dump
-  of memory. Analysis and capture tools must be intelligent enough to
-  determine where to look for the right information.
-
-- Through /proc/vmcore. This exports the dump as an ELF-format file that
-  you can write out using file copy commands such as cp or scp. Further,
-  you can use analysis tools such as the GNU Debugger (GDB) and the Crash
-  tool to debug the dump file. This method ensures that the dump pages are
-  correctly ordered.
+With the dump-capture kernel, you can access the memory image through
+/proc/vmcore. This exports the dump as an ELF-format file that you can
+write out using file copy commands such as cp or scp. Further, you can
+use analysis tools such as the GNU Debugger (GDB) and the Crash tool to
+debug the dump file. This method ensures that the dump pages are correctly
+ordered.
 
 
 Setup and Installation
@@ -423,18 +416,6 @@ the following command:
 
    cp /proc/vmcore <dump-file>
 
-You can also access dumped memory as a /dev/oldmem device for a linear
-and raw view. To create the device, use the following command:
-
-    mknod /dev/oldmem c 1 12
-
-Use the dd command with suitable options for count, bs, and skip to
-access specific portions of the dump.
-
-To see the entire memory, use the following command:
-
-   dd if=/dev/oldmem of=oldmem.001
-
 
 Analysis
 ========
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

