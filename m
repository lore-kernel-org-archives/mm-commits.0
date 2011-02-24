From: akpm@linux-foundation.org
Subject: + crc32-add-missed-brackets-in-macro.patch added to -mm tree
Date: Wed, 23 Feb 2011 16:37:18 -0800
Message-ID: <201102240037.p1O0bI5d001641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173Ab1BXAhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 19:37:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org


The patch titled
     crc32: add missed brackets in macro
has been added to the -mm tree.  Its filename is
     crc32-add-missed-brackets-in-macro.patch

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

crc32-add-missed-brackets-in-macro.patch
proc-hide-kernel-addresses-via-%pk-in-proc-pid-stack.patch

