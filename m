From: akpm@linux-foundation.org
Subject: - init-properly-placing-noinline-keyword.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:03 -0800
Message-ID: <200901072215.n07MF34T014925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757979AbZAGWPG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, mm-commits@vger.kernel.org


The patch titled
     init: properly placing noinline keyword
has been removed from the -mm tree.  Its filename was
     init-properly-placing-noinline-keyword.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init: properly placing noinline keyword
From: "Rakib Mullick" <rakib.mullick@gmail.com>

checkpatch warns about 'static void noinline'.  It wants `static noinline
void'.

Both are permissible, but the kernel consistently uses `static inline' and
`static noinline', and consistency is good.  Hence let's keep the
checkpatch warning and fix up this code site.

[akpm@linux-foundation.org: rewrote changelog]
Signed-off-by: Md.Rakib H. Mullick <rakib.mullick@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN init/main.c~init-properly-placing-noinline-keyword init/main.c
--- a/init/main.c~init-properly-placing-noinline-keyword
+++ a/init/main.c
@@ -447,7 +447,7 @@ static void __init setup_command_line(ch
  * gcc-3.4 accidentally inlines this function, so use noinline.
  */
 
-static void noinline __init_refok rest_init(void)
+static noinline void __init_refok rest_init(void)
 	__releases(kernel_lock)
 {
 	int pid;
@@ -786,7 +786,7 @@ static void run_init_process(char *init_
 /* This is a non __init function. Force it to be noinline otherwise gcc
  * makes it inline to init() and it becomes part of init.text section
  */
-static int noinline init_post(void)
+static noinline int init_post(void)
 {
 	free_initmem();
 	unlock_kernel();
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

origin.patch
linux-next.patch

