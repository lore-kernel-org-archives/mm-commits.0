From: akpm@linux-foundation.org
Subject: + mm-exitc-reorder-wait_opts-to-remove-padding-on-64-bit-builds.patch added to -mm tree
Date: Mon, 11 May 2009 14:03:03 -0700
Message-ID: <200905112103.n4BL3359018662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757383AbZEKVGx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 17:06:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, mingo@elte.hu, oleg@redhat.com, roland@redhat.com


The patch titled
     mm: exit.c reorder wait_opts to remove padding on 64 bit builds
has been added to the -mm tree.  Its filename is
     mm-exitc-reorder-wait_opts-to-remove-padding-on-64-bit-builds.patch

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
Subject: mm: exit.c reorder wait_opts to remove padding on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>

Reorder struct wait_opts to remove 8 bytes of alignment padding on 64 bit
builds.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~mm-exitc-reorder-wait_opts-to-remove-padding-on-64-bit-builds kernel/exit.c
--- a/kernel/exit.c~mm-exitc-reorder-wait_opts-to-remove-padding-on-64-bit-builds
+++ a/kernel/exit.c
@@ -1080,8 +1080,8 @@ SYSCALL_DEFINE1(exit_group, int, error_c
 
 struct wait_opts {
 	enum pid_type		wo_type;
-	struct pid		*wo_pid;
 	int			wo_flags;
+	struct pid		*wo_pid;
 
 	struct siginfo __user	*wo_info;
 	int __user		*wo_stat;
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

mm-exitc-reorder-wait_opts-to-remove-padding-on-64-bit-builds.patch

