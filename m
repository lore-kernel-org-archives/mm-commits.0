From: akpm@linux-foundation.org
Subject: [merged] mm-exitc-reorder-wait_opts-to-remove-padding-on-64-bit-builds.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:04 -0700
Message-ID: <200906182247.n5IMl4Hx006163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758065AbZFRW63 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, mingo@elte.hu, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: exit.c reorder wait_opts to remove padding on 64 bit builds
has been removed from the -mm tree.  Its filename was
     mm-exitc-reorder-wait_opts-to-remove-padding-on-64-bit-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1082,8 +1082,8 @@ SYSCALL_DEFINE1(exit_group, int, error_c
 
 struct wait_opts {
 	enum pid_type		wo_type;
-	struct pid		*wo_pid;
 	int			wo_flags;
+	struct pid		*wo_pid;
 
 	struct siginfo __user	*wo_info;
 	int __user		*wo_stat;
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

origin.patch

