From: akpm@linux-foundation.org
Subject: [merged] hid-example-fix-some-build-issues.patch removed from -mm tree
Date: Tue, 26 Apr 2011 11:38:56 -0700
Message-ID: <201104261833.p3QIXtXZ011076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826Ab1DZSeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Apr 2011 14:34:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, alan@signal11.us, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     hid-example: fix some build issues
has been removed from the -mm tree.  Its filename was
     hid-example-fix-some-build-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hid-example: fix some build issues
From: Randy Dunlap <randy.dunlap@oracle.com>

samples/hid-example.o needs some Kconfig and Makefile additions in order
to build.  It should use <linux/*.h> headers from the build tree, so use
HEADERS_CHECK to require that those header files be present.

Change the kconfig symbol from tristate to bool since userspace cannot be
built as loadable modules.

However, I don't understand why the userspace header files are not present
as reported in Andrew's build log, since it builds OK on x86_64 without
any of these changes.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alan Ott <alan@signal11.us>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/Kconfig         |    4 ++--
 samples/hidraw/Makefile |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN samples/Kconfig~hid-example-fix-some-build-issues samples/Kconfig
--- a/samples/Kconfig~hid-example-fix-some-build-issues
+++ a/samples/Kconfig
@@ -62,8 +62,8 @@ config SAMPLE_KDB
 	  command to the kdb shell.
 
 config SAMPLE_HIDRAW
-	tristate "Build simple hidraw example"
-	depends on HIDRAW
+	bool "Build simple hidraw example"
+	depends on HIDRAW && HEADERS_CHECK
 	help
 	  Build an example of how to use hidraw from userspace.
 
diff -puN samples/hidraw/Makefile~hid-example-fix-some-build-issues samples/hidraw/Makefile
--- a/samples/hidraw/Makefile~hid-example-fix-some-build-issues
+++ a/samples/hidraw/Makefile
@@ -6,3 +6,5 @@ hostprogs-y := hid-example
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
+
+HOSTCFLAGS_hid-example.o += -I$(objtree)/usr/include
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
uml-fix-hppfs-build.patch
drivers-leds-leds-pca9532c-add-gpio-capability.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

