From: akpm@linux-foundation.org
Subject: - rtc-rtc-s35390ac-needs-the-bitreverse-library.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:39:34 -0700
Message-ID: <200804130239.m3D2dYW4032401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755474AbYDMCkb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:40:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc-s35390a.c needs the bitreverse library
has been removed from the -mm tree.  Its filename was
     rtc-rtc-s35390ac-needs-the-bitreverse-library.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-s35390a.c needs the bitreverse library
From: Randy Dunlap <randy.dunlap@oracle.com>

rtc-s35390a uses BITREVERSE functions so it needs to select that config symbol
to ensure that the functions are built.

drivers/built-in.o: In function `s35390a_set_datetime':
linux-2.6.25-rc8-git7/drivers/rtc/rtc-s35390a.c:144: undefined reference to `byte_rev_table'
drivers/built-in.o: In function `s35390a_get_datetime':
linux-2.6.25-rc8-git7/drivers/rtc/rtc-s35390a.c:163: undefined reference to `byte_rev_table'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/Kconfig~rtc-rtc-s35390ac-needs-the-bitreverse-library drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-rtc-s35390ac-needs-the-bitreverse-library
+++ a/drivers/rtc/Kconfig
@@ -252,6 +252,7 @@ config RTC_DRV_TWL92330
 
 config RTC_DRV_S35390A
 	tristate "Seiko Instruments S-35390A"
+	select BITREVERSE
 	help
 	  If you say yes here you will get support for the Seiko
 	  Instruments S-35390A.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-x86.patch
rapidio-fix-docbook-references.patch
kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch
git-net.patch
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

