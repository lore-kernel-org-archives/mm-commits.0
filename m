From: akpm@linux-foundation.org
Subject: + documentation-build-source-files-in-documentation-sub-dir-update.patch added to -mm tree
Date: Wed, 09 Apr 2008 12:48:50 -0700
Message-ID: <200804091948.m39Jmoqe027106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685AbYDITtx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2008 15:49:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, sam@ravnborg.org


The patch titled
     documentation: build source files in Documentation sub-dir (update)
has been added to the -mm tree.  Its filename is
     documentation-build-source-files-in-documentation-sub-dir-update.patch

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
Subject: documentation: build source files in Documentation sub-dir (update)
From: Randy Dunlap <randy.dunlap@oracle.com>

Change all -I$(srctree) in Makefiles to -I$(objtree).
New (full) patch file with only that change is below.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/Makefile |    2 +-
 Documentation/auxdisplay/Makefile |    2 +-
 Documentation/connector/Makefile  |    2 +-
 Documentation/pcmcia/Makefile     |    2 +-
 Documentation/spi/Makefile        |    4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

diff -puN Documentation/accounting/Makefile~documentation-build-source-files-in-documentation-sub-dir-update Documentation/accounting/Makefile
--- a/Documentation/accounting/Makefile~documentation-build-source-files-in-documentation-sub-dir-update
+++ a/Documentation/accounting/Makefile
@@ -7,4 +7,4 @@ hostprogs-y := getdelays
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
 
-HOSTCFLAGS_getdelays.o += -I$(srctree)/usr/include
+HOSTCFLAGS_getdelays.o += -I$(objtree)/usr/include
diff -puN Documentation/auxdisplay/Makefile~documentation-build-source-files-in-documentation-sub-dir-update Documentation/auxdisplay/Makefile
--- a/Documentation/auxdisplay/Makefile~documentation-build-source-files-in-documentation-sub-dir-update
+++ a/Documentation/auxdisplay/Makefile
@@ -7,4 +7,4 @@ hostprogs-y := cfag12864b-example
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
 
-HOSTCFLAGS_cfag12864b-example.o += -I$(srctree)/usr/include
+HOSTCFLAGS_cfag12864b-example.o += -I$(objtree)/usr/include
diff -puN Documentation/connector/Makefile~documentation-build-source-files-in-documentation-sub-dir-update Documentation/connector/Makefile
--- a/Documentation/connector/Makefile~documentation-build-source-files-in-documentation-sub-dir-update
+++ a/Documentation/connector/Makefile
@@ -6,4 +6,4 @@ hostprogs-y := ucon
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
 
-HOSTCFLAGS_ucon.o += -I$(srctree)/usr/include
+HOSTCFLAGS_ucon.o += -I$(objtree)/usr/include
diff -puN Documentation/pcmcia/Makefile~documentation-build-source-files-in-documentation-sub-dir-update Documentation/pcmcia/Makefile
--- a/Documentation/pcmcia/Makefile~documentation-build-source-files-in-documentation-sub-dir-update
+++ a/Documentation/pcmcia/Makefile
@@ -7,4 +7,4 @@ hostprogs-y := crc32hash
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
 
-HOSTCFLAGS_crc32hash.o += -I$(srctree)/usr/include
+HOSTCFLAGS_crc32hash.o += -I$(objtree)/usr/include
diff -puN Documentation/spi/Makefile~documentation-build-source-files-in-documentation-sub-dir-update Documentation/spi/Makefile
--- a/Documentation/spi/Makefile~documentation-build-source-files-in-documentation-sub-dir-update
+++ a/Documentation/spi/Makefile
@@ -7,5 +7,5 @@ hostprogs-y := spidev_test spidev_fdx
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
 
-HOSTCFLAGS_spidev_test.o += -I$(srctree)/usr/include
-HOSTCFLAGS_spidev_fdx.o += -I$(srctree)/usr/include
+HOSTCFLAGS_spidev_test.o += -I$(objtree)/usr/include
+HOSTCFLAGS_spidev_fdx.o += -I$(objtree)/usr/include
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

