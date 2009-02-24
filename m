From: akpm@linux-foundation.org
Subject: + init-mainc-fix-sparse-warnings-context-imbalance.patch added to -mm tree
Date: Tue, 24 Feb 2009 12:24:45 -0800
Message-ID: <200902242024.n1OKOjAl008347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758578AbZBXUZ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 15:25:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@hanneseder.net, mingo@elte.hu


The patch titled
     init/main.c: fix sparse warnings: context imbalance
has been added to the -mm tree.  Its filename is
     init-mainc-fix-sparse-warnings-context-imbalance.patch

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
Subject: init/main.c: fix sparse warnings: context imbalance
From: Hannes Eder <hannes@hanneseder.net>

Impact: Attribute function 'init_post' with __releases(...).

Fix these sparse warnings:
  init/main.c:805:21: warning: context imbalance in 'init_post' - unexpected unlock
  init/main.c:899:9: warning: context imbalance in 'kernel_init' - wrong count at exit

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/main.c~init-mainc-fix-sparse-warnings-context-imbalance init/main.c
--- a/init/main.c~init-mainc-fix-sparse-warnings-context-imbalance
+++ a/init/main.c
@@ -808,6 +808,7 @@ int initmem_now_dynamic;
  * makes it inline to init() and it becomes part of init.text section
  */
 static noinline int init_post(void)
+	__releases(kernel_lock)
 {
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
_

Patches currently in -mm which might be from hannes@hanneseder.net are

linux-next.patch
init-mainc-fix-sparse-warnings-context-imbalance.patch

