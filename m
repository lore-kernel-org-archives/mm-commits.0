From: akpm@linux-foundation.org
Subject: + init-fix-possible-format-string-bug.patch added to -mm tree
Date: Fri, 10 Jan 2014 15:49:28 -0800
Message-ID: <52d08708.z2TU+Kjis54S7sul%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaAJXt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jan 2014 18:49:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, penguin-kernel@i-love.sakura.ne.jp

Subject: + init-fix-possible-format-string-bug.patch added to -mm tree
To: penguin-kernel@i-love.sakura.ne.jp,penguin-kernel@I-love.SAKURA.ne.jp
From: akpm@linux-foundation.org
Date: Fri, 10 Jan 2014 15:49:28 -0800


The patch titled
     Subject: init: fix possible format string bug
has been added to the -mm tree.  Its filename is
     init-fix-possible-format-string-bug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-fix-possible-format-string-bug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-fix-possible-format-string-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

init-fix-possible-format-string-bug.patch

