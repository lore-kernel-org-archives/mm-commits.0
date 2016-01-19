From: akpm@linux-foundation.org
Subject: + libcrc32c-fix-build-warning.patch added to -mm tree
Date: Tue, 19 Jan 2016 14:40:55 -0800
Message-ID: <569ebb77.jz5wycMxwVmXX0Ms%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbcASWk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 17:40:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/libcrc32c.c: fix build warning
has been added to the -mm tree.  Its filename is
     libcrc32c-fix-build-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/libcrc32c-fix-build-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/libcrc32c-fix-build-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: lib/libcrc32c.c: fix build warning

Fix the following build warning:

lib/libcrc32c.c:42:5: warning: no previous prototype for "crc32c" [-Wmissing-prototypes]
 u32 crc32c(u32 crc, const void *address, unsigned int length)
     ^

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/libcrc32c.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/libcrc32c.c~libcrc32c-fix-build-warning lib/libcrc32c.c
--- a/lib/libcrc32c.c~libcrc32c-fix-build-warning
+++ a/lib/libcrc32c.c
@@ -36,6 +36,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/crc32c.h>
 
 static struct crypto_shash *tfm;
 
_

Patches currently in -mm which might be from jdelvare@suse.de are

libcrc32c-fix-build-warning.patch

