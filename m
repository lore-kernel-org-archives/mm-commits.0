From: akpm@linux-foundation.org
Subject: [merged] documentation-additions-to-submitchecklist.patch removed from -mm tree
Date: Tue, 27 Apr 2010 11:02:24 -0400
Message-ID: <201004271803.o3RI3veF011028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756551Ab0D0SIF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 14:08:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Documentation: additions to SubmitChecklist
has been removed from the -mm tree.  Its filename was
     documentation-additions-to-submitchecklist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: additions to SubmitChecklist
From: Randy Dunlap <randy.dunlap@oracle.com>

Add build testing using 'O=builddir'.

Add build testing with various kconfig symbols disabled, listing
common ones that are known to cause build problems.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmitChecklist |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN Documentation/SubmitChecklist~documentation-additions-to-submitchecklist Documentation/SubmitChecklist
--- a/Documentation/SubmitChecklist~documentation-additions-to-submitchecklist
+++ a/Documentation/SubmitChecklist
@@ -18,6 +18,8 @@ kernel patches.
 
 2b: Passes allnoconfig, allmodconfig
 
+2c: Builds successfully when using O=builddir
+
 3: Builds on multiple CPU architectures by using local cross-compile tools
    or some other build farm.
 
@@ -95,3 +97,13 @@ kernel patches.
 
 25: If any ioctl's are added by the patch, then also update
     Documentation/ioctl/ioctl-number.txt.
+
+26: If your modified source code depends on or uses any of the kernel
+    APIs or features that are related to the following kconfig symbols,
+    then test multiple builds with the related kconfig symbols disabled
+    and/or =m (if that option is available) [not all of these at the
+    same time, just various/random combinations of them]:
+
+    CONFIG_SMP, CONFIG_SYSFS, CONFIG_PROC_FS, CONFIG_INPUT, CONFIG_PCI,
+    CONFIG_BLOCK, CONFIG_PM, CONFIG_HOTPLUG, CONFIG_MAGIC_SYSRQ,
+    CONFIG_NET, CONFIG_INET=n (but latter with CONFIG_NET=y)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
led-driver-for-the-soekris-net5501-board-fix-2.patch
leds-route-kbd-leds-through-the-generic-leds-layer-leds-input-depends-on-input.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
laptop-mode-make-flushes-per-device-fix.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
documentation-submittingdrivers-resources.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

