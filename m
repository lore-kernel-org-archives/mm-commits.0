From: akpm@linux-foundation.org
Subject: [merged] fork_init-update-max_threads-comment.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:19:39 -0700
Message-ID: <5535514b.3TiURNe3qhOjfhKs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbDTTNS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fork_init: update max_threads comment
has been removed from the -mm tree.  Its filename was
     fork_init-update-max_threads-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: fork_init: update max_threads comment

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

origin.patch
linux-next.patch

