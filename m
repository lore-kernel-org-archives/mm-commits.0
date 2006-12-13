From: akpm@osdl.org
Subject: - document-how-to-decode-an-ioctl-number.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:51:57 -0800
Message-ID: <200612130651.kBD6pvru030386@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57283 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964971AbWLMGwP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:52:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 76306.1226@compuserve.com, mm-commits@vger.kernel.org


The patch titled
     Document how to decode an IOCTL number
has been removed from the -mm tree.  Its filename was
     document-how-to-decode-an-ioctl-number.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Document how to decode an IOCTL number
From: Chuck Ebbert <76306.1226@compuserve.com>

Document how to decode a binary IOCTL number.

Signed-off-by: Chuck Ebbert <76306.1226@compuserve.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/ioctl/ioctl-decoding.txt |   24 +++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN /dev/null Documentation/ioctl/ioctl-decoding.txt
--- /dev/null
+++ a/Documentation/ioctl/ioctl-decoding.txt
@@ -0,0 +1,24 @@
+To decode a hex IOCTL code:
+
+Most architecures use this generic format, but check
+include/ARCH/ioctl.h for specifics, e.g. powerpc
+uses 3 bits to encode read/write and 13 bits for size.
+
+ bits    meaning
+ 31-30	00 - no parameters: uses _IO macro
+	10 - read: _IOR
+	01 - write: _IOW
+	11 - read/write: _IOWR
+
+ 29-16	size of arguments
+
+ 15-8	ascii character supposedly
+	unique to each driver
+
+ 7-0	function #
+
+
+ So for example 0x82187201 is a read with arg length of 0x218,
+character 'r' function 1. Grepping the source reveals this is:
+
+#define VFAT_IOCTL_READDIR_BOTH         _IOR('r', 1, struct dirent [2])
_

Patches currently in -mm which might be from 76306.1226@compuserve.com are

origin.patch

