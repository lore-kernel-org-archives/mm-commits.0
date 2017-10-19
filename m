From: akpm@linux-foundation.org
Subject: + initramfs-use-time64_t-timestamps.patch added to -mm tree
Date: Thu, 19 Oct 2017 12:20:28 -0700
Message-ID: <59e8fafc.HkLQHVZy1Y7OMk1q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41972 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753396AbdJSTU3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Oct 2017 15:20:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, daniel.thompson@linaro.org, deepa.kernel@gmail.com, lokeshvutla@ti.com, shorne@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: use time64_t timestamps
has been added to the -mm tree.  Its filename is
     initramfs-use-time64_t-timestamps.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initramfs-use-time64_t-timestamps.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initramfs-use-time64_t-timestamps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -108,7 +108,7 @@ static void __init free_hash(void)
 	}
 }
 
-static long __init do_utime(char *filename, time_t mtime)
+static long __init do_utime(char *filename, time64_t mtime)
 {
 	struct timespec64 t[2];
 
@@ -124,10 +124,10 @@ static __initdata LIST_HEAD(dir_list);
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
@@ -149,7 +149,7 @@ static void __init dir_utime(void)
 	}
 }
 
-static __initdata time_t mtime;
+static __initdata time64_t mtime;
 
 /* cpio header parsing */
 
@@ -176,7 +176,7 @@ static void __init parse_header(char *s)
 	uid = parsed[2];
 	gid = parsed[3];
 	nlink = parsed[4];
-	mtime = parsed[5];
+	mtime = parsed[5]; /* breaks in y2106 */
 	body_len = parsed[6];
 	major = parsed[7];
 	minor = parsed[8];
_

Patches currently in -mm which might be from arnd@arndb.de are

initramfs-use-time64_t-timestamps.patch
pcmcia-badge4-avoid-unused-function-warning.patch

