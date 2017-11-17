From: akpm@linux-foundation.org
Subject: [patch 82/94] initramfs: use time64_t timestamps
Date: Fri, 17 Nov 2017 15:31:04 -0800
Message-ID: <20171117233104.kzORAP31l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56126 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966968AbdKQXbG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:31:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, daniel.thompson@linaro.org, deepa.kernel@gmail.com, lokeshvutla@ti.com, mm-commits@vger.kernel.org, shorne@gmail.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Arnd Bergmann <arnd@arndb.de>
Subject: initramfs: use time64_t timestamps

The cpio format uses a 32-bit number to encode file timestamps, which
breaks initramfs support in 2038.  This reinterprets the timestamp as
unsigned, to give us another 68 years and avoids breaking until 2106.

Link: http://lkml.kernel.org/r/20171019095536.801199-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Stafford Horne <shorne@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN init/initramfs.c~initramfs-use-time64_t-timestamps init/initramfs.c
--- a/init/initramfs.c~initramfs-use-time64_t-timestamps
+++ a/init/initramfs.c
@@ -109,7 +109,7 @@ static void __init free_hash(void)
 	}
 }
 
-static long __init do_utime(char *filename, time_t mtime)
+static long __init do_utime(char *filename, time64_t mtime)
 {
 	struct timespec64 t[2];
 
@@ -125,10 +125,10 @@ static __initdata LIST_HEAD(dir_list);
 struct dir_entry {
 	struct list_head list;
 	char *name;
-	time_t mtime;
+	time64_t mtime;
 };
 
-static void __init dir_add(const char *name, time_t mtime)
+static void __init dir_add(const char *name, time64_t mtime)
 {
 	struct dir_entry *de = kmalloc(sizeof(struct dir_entry), GFP_KERNEL);
 	if (!de)
@@ -150,7 +150,7 @@ static void __init dir_utime(void)
 	}
 }
 
-static __initdata time_t mtime;
+static __initdata time64_t mtime;
 
 /* cpio header parsing */
 
@@ -177,7 +177,7 @@ static void __init parse_header(char *s)
 	uid = parsed[2];
 	gid = parsed[3];
 	nlink = parsed[4];
-	mtime = parsed[5];
+	mtime = parsed[5]; /* breaks in y2106 */
 	body_len = parsed[6];
 	major = parsed[7];
 	minor = parsed[8];
_
