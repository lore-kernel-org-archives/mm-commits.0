From: akpm@linux-foundation.org
Subject: + init-properly-placing-noinline-keyword.patch added to -mm tree
Date: Mon, 20 Oct 2008 15:12:54 -0700
Message-ID: <200810202212.m9KMCsNY028724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826AbYJTWM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 18:12:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com


The patch titled
     init: properly placing noinline keyword
has been added to the -mm tree.  Its filename is
     init-properly-placing-noinline-keyword.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
@@ -462,7 +462,7 @@ static void __init setup_command_line(ch
  * gcc-3.4 accidentally inlines this function, so use noinline.
  */
 
-static void noinline __init_refok rest_init(void)
+static noinline void __init_refok rest_init(void)
 	__releases(kernel_lock)
 {
 	int pid;
@@ -863,7 +863,7 @@ int initmem_now_dynamic;
 /* This is a non __init function. Force it to be noinline otherwise gcc
  * makes it inline to init() and it becomes part of init.text section
  */
-static int noinline init_post(void)
+static noinline int init_post(void)
 {
 	int retry_count = 1;
 	free_initmem();
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

origin.patch
init-properly-placing-noinline-keyword.patch

