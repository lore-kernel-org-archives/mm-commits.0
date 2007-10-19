From: akpm@linux-foundation.org
Subject: - add-documentation-for-extended-crashkernel-syntax.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:54:13 -0700
Message-ID: <200710192254.l9JMsDK3024509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60659 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967016AbXJSXGv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, ak@suse.de, benh@kernel.crashing.org, ebiederm@xmission.com, lethal@linux-sh.org, paulus@samba.org, tony.luck@intel.com, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Add documentation for extended crashkernel syntax
has been removed from the -mm tree.  Its filename was
     add-documentation-for-extended-crashkernel-syntax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add documentation for extended crashkernel syntax
From: Bernhard Walle <bwalle@suse.de>

This adds the documentation for the extended crashkernel syntax into
Documentation/kdump/kdump.txt.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt       |   26 ++++++++++++++++++++++++++
 Documentation/kernel-parameters.txt |    7 +++++++
 2 files changed, 33 insertions(+)

diff -puN Documentation/kdump/kdump.txt~add-documentation-for-extended-crashkernel-syntax Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~add-documentation-for-extended-crashkernel-syntax
+++ a/Documentation/kdump/kdump.txt
@@ -231,6 +231,32 @@ Dump-capture kernel config options (Arch
   any space below the alignment point will be wasted.
 
 
+Extended crashkernel syntax
+===========================
+
+While the "crashkernel=size[@offset]" syntax is sufficient for most
+configurations, sometimes it's handy to have the reserved memory dependent
+on the value of System RAM -- that's mostly for distributors that pre-setup
+the kernel command line to avoid a unbootable system after some memory has
+been removed from the machine.
+
+The syntax is:
+
+    crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
+    range=start-[end]
+
+For example:
+
+    crashkernel=512M-2G:64M,2G-:128M
+
+This would mean:
+
+    1) if the RAM is smaller than 512M, then don't reserve anything
+       (this is the "rescue" case)
+    2) if the RAM size is between 512M and 2G, then reserve 64M
+    3) if the RAM size is larger than 2G, then reserve 128M
+
+
 Boot into System Kernel
 =======================
 
diff -puN Documentation/kernel-parameters.txt~add-documentation-for-extended-crashkernel-syntax Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~add-documentation-for-extended-crashkernel-syntax
+++ a/Documentation/kernel-parameters.txt
@@ -497,6 +497,13 @@ and is between 256 and 4096 characters. 
 			[KNL] Reserve a chunk of physical memory to
 			hold a kernel to switch to with kexec on panic.
 
+	crashkernel=range1:size1[,range2:size2,...][@offset]
+			[KNL] Same as above, but depends on the memory
+			in the running system. The syntax of range is
+			start-[end] where start and end are both
+			a memory unit (amount[KMG]). See also
+			Documentation/kdump/kdump.txt for a example.
+
 	cs4232=		[HW,OSS]
 			Format: <io>,<irq>,<dma>,<dma2>,<mpuio>,<mpuirq>
 
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
kexec-add-bss-to-resource-tree.patch
kexec-add-bss-to-resource-tree-checkpatch-fixes.patch
kexec-introduce-bootmem_exclusive.patch
kexec-introduce-bootmem_exclusive-checkpatch-fixes.patch
kexec-use-bootmem_exclusive-on-x86.patch
