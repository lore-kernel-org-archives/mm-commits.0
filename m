From: akpm@linux-foundation.org
Subject: + hid-example-fix-some-build-issues.patch added to -mm tree
Date: Wed, 20 Apr 2011 15:17:10 -0700
Message-ID: <201104202217.p3KMHA3U030386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755677Ab1DTWRV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 18:17:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, alan@signal11.us, jkosina@suse.cz


The patch titled
     hid-example: fix some build issues
has been added to the -mm tree.  Its filename is
     hid-example-fix-some-build-issues.patch

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
hid-example-fix-some-build-issues.patch
drivers-staging-olpc_dcon-olpc_dcon_xo_1c-needs-delayh.patch
drivers-leds-leds-pca9532c-add-gpio-capability.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

