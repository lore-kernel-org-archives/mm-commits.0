From: akpm@linux-foundation.org
Subject: [merged] proc-constify-status-array.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:40 -0700
Message-ID: <201105271956.p4RJujDu017595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757206Ab1E0UJE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:09:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: constify status array
has been removed from the -mm tree.  Its filename was
     proc-constify-status-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: constify status array
From: Mike Frysinger <vapier@gentoo.org>

No need for this local array to be writable, so mark it const.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/array.c~proc-constify-status-array fs/proc/array.c
--- a/fs/proc/array.c~proc-constify-status-array
+++ a/fs/proc/array.c
@@ -131,7 +131,7 @@ static inline void task_name(struct seq_
  * you can test for combinations of others with
  * simple bit tests.
  */
-static const char *task_state_array[] = {
+static const char * const task_state_array[] = {
 	"R (running)",		/*   0 */
 	"S (sleeping)",		/*   1 */
 	"D (disk sleep)",	/*   2 */
@@ -147,7 +147,7 @@ static const char *task_state_array[] = 
 static inline const char *get_task_state(struct task_struct *tsk)
 {
 	unsigned int state = (tsk->state & TASK_REPORT) | tsk->exit_state;
-	const char **p = &task_state_array[0];
+	const char * const *p = &task_state_array[0];
 
 	BUILD_BUG_ON(1 + ilog2(TASK_STATE_MAX) != ARRAY_SIZE(task_state_array));
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
backlight-new-driver-for-the-adp8870-backlight-devices.patch
backlight-add-backlight-type-fix.patch
linux-next.patch

