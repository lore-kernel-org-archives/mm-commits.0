From: akpm@linux-foundation.org
Subject: + rtc-rtc-s35390ac-needs-the-bitreverse-library.patch added to -mm tree
Date: Wed, 09 Apr 2008 11:43:21 -0700
Message-ID: <200804091843.m39IhLMx024588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753009AbYDISoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2008 14:44:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, a.zummo@towertech.it


The patch titled
     rtc: rtc-s35390a.c needs the bitreverse library
has been added to the -mm tree.  Its filename is
     rtc-rtc-s35390ac-needs-the-bitreverse-library.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

rtc-rtc-s35390ac-needs-the-bitreverse-library.patch
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

