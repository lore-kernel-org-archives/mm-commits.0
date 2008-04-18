From: akpm@linux-foundation.org
Subject: - 8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch removed from -mm tree
Date: Fri, 18 Apr 2008 13:49:39 -0700
Message-ID: <200804182049.m3IKndox014793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755855AbYDRUuU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Apr 2008 16:50:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     ne2: needs more 8390 support functions
has been removed from the -mm tree.  Its filename was
     8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch

This patch was dropped because it was folded into 8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ne2: needs more 8390 support functions
From: Randy Dunlap <randy.dunlap@oracle.com>

ne2 (MCA) needs both 8390.o and 8390p.o functions:

drivers/built-in.o: In function `ne_close':
ne2.c:(.text+0x30544): undefined reference to `eip_close'
drivers/built-in.o: In function `ne_open':
ne2.c:(.text+0x30554): undefined reference to `eip_open'
drivers/built-in.o: In function `ne2_probe':
(.init.text+0x1bce): undefined reference to `__alloc_eip_netdev'
drivers/built-in.o: In function `ne2_probe':
(.init.text+0x1dd9): undefined reference to `eip_interrupt'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/Makefile~8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix drivers/net/Makefile
--- a/drivers/net/Makefile~8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix
+++ a/drivers/net/Makefile
@@ -107,7 +107,7 @@ obj-$(CONFIG_68360_ENET) += 68360enet.o
 obj-$(CONFIG_WD80x3) += wd.o 8390.o
 obj-$(CONFIG_EL2) += 3c503.o 8390p.o
 obj-$(CONFIG_NE2000) += ne.o 8390p.o
-obj-$(CONFIG_NE2_MCA) += ne2.o 8390.o
+obj-$(CONFIG_NE2_MCA) += ne2.o 8390.o 8390p.o
 obj-$(CONFIG_HPLAN) += hp.o 8390p.o
 obj-$(CONFIG_HPLAN_PLUS) += hp-plus.o 8390p.o
 obj-$(CONFIG_ULTRA) += smc-ultra.o 8390.o
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-x86.patch
rapidio-fix-docbook-references.patch
kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch
git-net.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-unionfs.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
docbook-some-kernel-locking-fixes.patch
kernel-doc-detect-prevent-duplicate-doc-section-names.patch
kernel-doc-detect-trailing-kernel-doc-line-trash.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-update.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
dma-add-dma_map_attrs-interfaces.patch
dma-document-dma_map_attrs-interfaces.patch
dma-ia64-update-ia64-machvecs-swiotlbc.patch
ib-expand-ib_umem_get-prototype.patch
doc-fix-dma-api-function-parameters.patch
basic-braille-screen-reader-support-makefile-fix.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
profile-likely-unlikely-macros.patch

