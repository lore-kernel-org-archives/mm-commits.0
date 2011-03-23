From: akpm@linux-foundation.org
Subject: [merged] crc32-add-missed-brackets-in-macro.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:28 -0700
Message-ID: <201103232044.p2NKi4Cu029029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933459Ab1CWUoH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     crc32: add missed brackets in macro
has been removed from the -mm tree.  Its filename was
     crc32-add-missed-brackets-in-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: crc32: add missed brackets in macro
From: Konstantin Khlebnikov <khlebnikov@openvz.org>

Add brackets around typecasted argument in crc32() macro.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crc32.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/crc32.h~crc32-add-missed-brackets-in-macro include/linux/crc32.h
--- a/include/linux/crc32.h~crc32-add-missed-brackets-in-macro
+++ a/include/linux/crc32.h
@@ -11,7 +11,7 @@
 extern u32  crc32_le(u32 crc, unsigned char const *p, size_t len);
 extern u32  crc32_be(u32 crc, unsigned char const *p, size_t len);
 
-#define crc32(seed, data, length)  crc32_le(seed, (unsigned char const *)data, length)
+#define crc32(seed, data, length)  crc32_le(seed, (unsigned char const *)(data), length)
 
 /*
  * Helpers for hash table generation of ethernet nics:
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
proc-hide-kernel-addresses-via-%pk-in-proc-pid-stack.patch

