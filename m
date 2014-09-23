From: akpm@linux-foundation.org
Subject: + tools-add-more-endianh-macros.patch added to -mm tree
Date: Tue, 23 Sep 2014 15:59:32 -0700
Message-ID: <5421fb54.QBkp+iTZGvWCi2OV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbaIWW7d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Sep 2014 18:59:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pefoley2@pefoley.com, ashutosh.dixit@intel.com, gregkh@linuxfoundation.org, nikhil.rao@intel.com, rdunlap@infradead.org, sudeep.dutt@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/include/tools/endian.h: add more macros
has been added to the -mm tree.  Its filename is
     tools-add-more-endianh-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-add-more-endianh-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-add-more-endianh-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Foley <pefoley2@pefoley.com>
Subject: tools/include/tools/endian.h: add more macros

Add some more macros to tools/endian.h to allow mpssd to be compiled
against glibc < 2.9.

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Nikhil Rao <nikhil.rao@intel.com>
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/tools/endian.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN tools/include/tools/endian.h~tools-add-more-endianh-macros tools/include/tools/endian.h
--- a/tools/include/tools/endian.h~tools-add-more-endianh-macros
+++ a/tools/include/tools/endian.h
@@ -15,6 +15,18 @@
 #define htole64(x) (x)
 #endif
 
+#ifndef le16toh
+#define le16toh(x) (x)
+#endif
+
+#ifndef le32toh
+#define le32toh(x) (x)
+#endif
+
+#ifndef le64toh
+#define le64toh(x) (x)
+#endif
+
 #else /* __BYTE_ORDER */
 
 #ifndef htole16
@@ -27,6 +39,18 @@
 #define htole64(x) __bswap_64(x)
 #endif
 
+#ifndef le16toh
+#define le16toh(x) __bswap_16(x)
+#endif
+
+#ifndef le32toh
+#define le32toh(x) __bswap_32(x)
+#endif
+
+#ifndef le64toh
+#define le64toh(x) __bswap_64(x)
+#endif
+
 #endif
 
 #endif /* _TOOLS_ENDIAN_H */
_

Patches currently in -mm which might be from pefoley2@pefoley.com are

linux-next.patch
tools-add-more-endianh-macros.patch

