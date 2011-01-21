From: akpm@linux-foundation.org
Subject: + select-remove-unused-max_select_seconds.patch added to -mm tree
Date: Fri, 21 Jan 2011 15:36:07 -0800
Message-ID: <201101212336.p0LNa7uC007739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753722Ab1AUXgJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 18:36:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, arjan@linux.intel.com


The patch titled
     select: remove unused MAX_SELECT_SECONDS
has been added to the -mm tree.  Its filename is
     select-remove-unused-max_select_seconds.patch

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
