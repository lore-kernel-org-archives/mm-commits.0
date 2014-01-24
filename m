From: akpm@linux-foundation.org
Subject: [merged] init-fix-possible-format-string-bug.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 11:02:14 -0800
Message-ID: <52e2b8b6.UF/lfKurXzy/M6D0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbaAXTCO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, penguin-kernel@i-love.sakura.ne.jp

Subject: [merged] init-fix-possible-format-string-bug.patch removed from -mm tree
To: penguin-kernel@i-love.sakura.ne.jp,penguin-kernel@I-love.SAKURA.ne.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:14 -0800


The patch titled
     Subject: init: fix possible format string bug
has been removed from the -mm tree.  Its filename was
     init-fix-possible-format-string-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: init: fix possible format string bug

Use constant format string in case message changes.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    2 +-
 init/main.c      |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN init/initramfs.c~init-fix-possible-format-string-bug init/initramfs.c
--- a/init/initramfs.c~init-fix-possible-format-string-bug
+++ a/init/initramfs.c
@@ -583,7 +583,7 @@ static int __init populate_rootfs(void)
 {
 	char *err = unpack_to_rootfs(__initramfs_start, __initramfs_size);
 	if (err)
-		panic(err);	/* Failed to decompress INTERNAL initramfs */
+		panic("%s", err); /* Failed to decompress INTERNAL initramfs */
 	if (initrd_start) {
 #ifdef CONFIG_BLK_DEV_RAM
 		int fd;
diff -puN init/main.c~init-fix-possible-format-string-bug init/main.c
--- a/init/main.c~init-fix-possible-format-string-bug
+++ a/init/main.c
@@ -278,7 +278,7 @@ static int __init unknown_bootoption(cha
 		unsigned int i;
 		for (i = 0; envp_init[i]; i++) {
 			if (i == MAX_INIT_ENVS) {
-				panic_later = "Too many boot env vars at `%s'";
+				panic_later = "env";
 				panic_param = param;
 			}
 			if (!strncmp(param, envp_init[i], val - param))
@@ -290,7 +290,7 @@ static int __init unknown_bootoption(cha
 		unsigned int i;
 		for (i = 0; argv_init[i]; i++) {
 			if (i == MAX_INIT_ARGS) {
-				panic_later = "Too many boot init vars at `%s'";
+				panic_later = "init";
 				panic_param = param;
 			}
 		}
@@ -582,7 +582,8 @@ asmlinkage void __init start_kernel(void
 	 */
 	console_init();
 	if (panic_later)
-		panic(panic_later, panic_param);
+		panic("Too many boot %s vars at `%s'", panic_later,
+		      panic_param);
 
 	lockdep_info();
 
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

origin.patch
lib-vsprintf-add-%pt-format-specifier.patch

