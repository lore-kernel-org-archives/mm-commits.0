From: akpm@linux-foundation.org
Subject: - documentation-build-source-files-in-documentation-sub-dir-update.patch removed from -mm tree
Date: Mon, 28 Apr 2008 00:04:10 -0700
Message-ID: <200804280704.m3S74AS6013192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765235AbYD1HE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 03:04:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     documentation: build source files in Documentation sub-dir (update)
has been removed from the -mm tree.  Its filename was
     documentation-build-source-files-in-documentation-sub-dir-update.patch

This patch was dropped because it was folded into documentation-build-source-files-in-documentation-sub-dir.patch

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

origin.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
kernel-doc-detect-prevent-duplicate-doc-section-names.patch
kernel-doc-detect-trailing-kernel-doc-line-trash.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-update.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch

