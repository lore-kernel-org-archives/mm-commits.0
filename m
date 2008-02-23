From: akpm@linux-foundation.org
Subject: + fix-b43-driver-build-for-arm.patch added to -mm tree
Date: Sat, 23 Feb 2008 10:26:50 -0800
Message-ID: <200802231826.m1NIQp97009230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753503AbYBWS2J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 13:28:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gordonfarquharson@gmail.com, linville@tuxdriver.com, mb@bu3sch.de, rmk@arm.linux.org.uk


The patch titled
     Fix b43 driver build for arm
has been added to the -mm tree.  Its filename is
     fix-b43-driver-build-for-arm.patch

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
Subject: Fix b43 driver build for arm
From: "Gordon Farquharson" <gordonfarquharson@gmail.com>

Align the members of the SSB device structure to a 32 bit boundary so that
the b43 driver can be built for arm using a cross compiler.  This alignment
is required so that the test in scripts/mod/file2alias.c that checks that
the size of the device ID type against the size of the section in the
object file succeeds (see comment and http://lkml.org/lkml/2008/2/18/481
for explanation).

Signed-off-by: Gordon Farquharson <gordonfarquharson@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Acked-by: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mod_devicetable.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/mod_devicetable.h~fix-b43-driver-build-for-arm include/linux/mod_devicetable.h
--- a/include/linux/mod_devicetable.h~fix-b43-driver-build-for-arm
+++ a/include/linux/mod_devicetable.h
@@ -351,7 +351,13 @@ struct sdio_device_id {
 struct ssb_device_id {
 	__u16	vendor;
 	__u16	coreid;
-	__u8	revision;
+	/* Explicit padding to support a broken sanity check in file2alias.c.
+	 * The check compares the size of the structure in the kernel
+	 * object file to the size of the structure reported in userspace for
+	 * the system on which the kernel is compiled. The check breaks on
+	 * cross-compilation, and the padding is a workaround for this. */
+	__u8	revision
+		__attribute__((aligned(sizeof(__u32))));
 };
 #define SSB_DEVICE(_vendor, _coreid, _revision)  \
 	{ .vendor = _vendor, .coreid = _coreid, .revision = _revision, }
_

Patches currently in -mm which might be from gordonfarquharson@gmail.com are

fix-b43-driver-build-for-arm.patch
