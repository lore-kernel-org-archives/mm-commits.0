From: akpm@linux-foundation.org
Subject: [merged] select-remove-unused-max_select_seconds.patch removed from -mm tree
Date: Mon, 21 Mar 2011 12:16:39 -0700
Message-ID: <201103211919.p2LJJrfo020235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753876Ab1CUTUZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Mar 2011 15:20:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     select: remove unused MAX_SELECT_SECONDS
has been removed from the -mm tree.  Its filename was
     select-remove-unused-max_select_seconds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: select: remove unused MAX_SELECT_SECONDS
From: Namhyung Kim <namhyung@gmail.com>

Remove the leftover from the commit 8ff3e8e85fa6 ("select: switch select()
and poll() over to hrtimers").

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |    3 ---
 fs/select.c |    3 ---
 2 files changed, 6 deletions(-)

diff -puN fs/compat.c~select-remove-unused-max_select_seconds fs/compat.c
--- a/fs/compat.c~select-remove-unused-max_select_seconds
+++ a/fs/compat.c
@@ -1695,9 +1695,6 @@ int compat_set_fd_set(unsigned long nr, 
  * Update: ERESTARTSYS breaks at least the xview clock binary, so
  * I'm trying ERESTARTNOHAND which restart only when you want to.
  */
-#define MAX_SELECT_SECONDS \
-	((unsigned long) (MAX_SCHEDULE_TIMEOUT / HZ)-1)
-
 int compat_core_sys_select(int n, compat_ulong_t __user *inp,
 	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
 	struct timespec *end_time)
diff -puN fs/select.c~select-remove-unused-max_select_seconds fs/select.c
--- a/fs/select.c~select-remove-unused-max_select_seconds
+++ a/fs/select.c
@@ -517,9 +517,6 @@ int do_select(int n, fd_set_bits *fds, s
  * Update: ERESTARTSYS breaks at least the xview clock binary, so
  * I'm trying ERESTARTNOHAND which restart only when you want to.
  */
-#define MAX_SELECT_SECONDS \
-	((unsigned long) (MAX_SCHEDULE_TIMEOUT / HZ)-1)
