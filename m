From: akpm@linux-foundation.org
Subject: [patch 11/26] include/linux/fs.h: fix unsigned enum warning with
 gcc-4.2
Date: Thu, 09 Mar 2017 16:16:57 -0800
Message-ID: <58c1f079.NECD8WuQw+4h64g0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51304 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753944AbdCJAQ7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 19:16:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de, brendan.d.gregg@gmail.com, rmk+kernel@armlinux.org.uk

From: Arnd Bergmann <arnd@arndb.de>
Subject: include/linux/fs.h: fix unsigned enum warning with gcc-4.2

With arm-linux-gcc-4.2, almost every file we build in the kernel ends up
with this warning:

include/linux/fs.h:2648: warning: comparison of unsigned expression < 0 is always false

Later versions don't have this problem, but it's easy enough to
work around.

Link: http://lkml.kernel.org/r/20161216105634.235457-12-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/fs.h~fs-fix-unsigned-enum-warning-with-gcc-42 include/linux/fs.h
--- a/include/linux/fs.h~fs-fix-unsigned-enum-warning-with-gcc-42
+++ a/include/linux/fs.h
@@ -2678,7 +2678,7 @@ static const char * const kernel_read_fi
 
 static inline const char *kernel_read_file_id_str(enum kernel_read_file_id id)
 {
-	if (id < 0 || id >= READING_MAX_ID)
+	if ((unsigned)id >= READING_MAX_ID)
 		return kernel_read_file_str[READING_UNKNOWN];
 
 	return kernel_read_file_str[id];
_
