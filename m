From: akpm@linux-foundation.org
Subject: + documentation-additions-to-submitchecklist.patch added to -mm tree
Date: Thu, 22 Apr 2010 14:11:01 -0700
Message-ID: <201004222111.o3MLB10R011261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755257Ab0DVVLH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 17:11:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     Documentation: additions to SubmitChecklist
has been added to the -mm tree.  Its filename is
     documentation-additions-to-submitchecklist.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
uv_irqc-fix-all-sparse-warnings.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
led-driver-for-the-soekris-net5501-board-fix-2.patch
leds-route-kbd-leds-through-the-generic-leds-layer-leds-input-depends-on-input.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
usb-fix-serial-build-when-sysrq-is-disabled.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
documentation-submittingdrivers-resources.patch
documentation-additions-to-submitchecklist.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

