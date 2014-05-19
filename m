From: akpm@linux-foundation.org
Subject: +
 fs-fat-cleanup-string-initializations-char-instead-of-char.patch added to
 -mm tree
Date: Mon, 19 May 2014 15:55:35 -0700
Message-ID: <537a8be7.GyVqTfz6ZrH20rDM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaESWzg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 May 2014 18:55:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, manuel.schoelling@gmx.de

Subject: + fs-fat-cleanup-string-initializations-char-instead-of-char.patch added to -mm tree
To: manuel.schoelling@gmx.de,hirofumi@mail.parknet.co.jp
From: akpm@linux-foundation.org
Date: Mon, 19 May 2014 15:55:35 -0700


The patch titled
     Subject: fs/fat/inode.c: clean up string initializations (char[] instead of char *)
has been added to the -mm tree.  Its filename is
     fs-fat-cleanup-string-initializations-char-instead-of-char.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-fat-cleanup-string-initializations-char-instead-of-char.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-fat-cleanup-string-initializations-char-instead-of-char.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Manuel Schölling <manuel.schoelling@gmx.de>
Subject: fs/fat/inode.c: clean up string initializations (char[] instead of char *)

Initializations like 'char *foo = "bar"' will create two variables: a
static string and a pointer (foo) to that static string.  Instead 'char
foo[] = "bar"' will declare a single variable and will end up in shorter
assembly (according to Jeff Garzik on the KernelJanitor's TODO list).

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fs-fat-cleanup-string-initializations-char-instead-of-char fs/fat/inode.c
--- a/fs/fat/inode.c~fs-fat-cleanup-string-initializations-char-instead-of-char
+++ a/fs/fat/inode.c
@@ -421,7 +421,7 @@ struct inode *fat_iget(struct super_bloc
 
 static int is_exec(unsigned char *extension)
 {
-	unsigned char *exe_extensions = "EXECOMBAT", *walk;
+	unsigned char exe_extensions[] = "EXECOMBAT", *walk;
 
 	for (walk = exe_extensions; *walk; walk += 3)
 		if (!strncmp(extension, walk, 3))
_

Patches currently in -mm which might be from manuel.schoelling@gmx.de are

fs-fat-cleanup-string-initializations-char-instead-of-char.patch

