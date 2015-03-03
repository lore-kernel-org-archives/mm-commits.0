From: akpm@linux-foundation.org
Subject: + fork_init-update-max_threads-comment.patch added to -mm tree
Date: Mon, 02 Mar 2015 16:05:35 -0800
Message-ID: <54f4facf.6TFbtSsSte2ddfNP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbbCCAFg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 19:05:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fork_init: Update max_threads comment
has been added to the -mm tree.  Its filename is
     fork_init-update-max_threads-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fork_init-update-max_threads-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fork_init-update-max_threads-comment.patch

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
Subject: fork_init: Update max_threads comment

The comment explaining what value max_threads is set to is outdated.  The
maximum memory consumption ratio for thread structures was 1/2 until
February 2002, then it was briefly changed to 1/16 before being set to 1/8
which we still use today.  The comment was never updated to reflect that
change, it's about time.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/fork.c~fork_init-update-max_threads-comment kernel/fork.c
--- a/kernel/fork.c~fork_init-update-max_threads-comment
+++ a/kernel/fork.c
@@ -270,8 +270,8 @@ void __init fork_init(unsigned long memp
 
 	/*
 	 * The default maximum number of threads is set to a safe
-	 * value: the thread structures can take up at most half
-	 * of memory.
+	 * value: the thread structures can take up at most one
+	 * eighth of the memory.
 	 */
 	max_threads = mempages / (8 * THREAD_SIZE / PAGE_SIZE);
 
_

Patches currently in -mm which might be from jdelvare@suse.de are

fork_init-update-max_threads-comment.patch
linux-next.patch

