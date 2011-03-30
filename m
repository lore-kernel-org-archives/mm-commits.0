From: akpm@linux-foundation.org
Subject: + proc-constify-status-array.patch added to -mm tree
Date: Tue, 29 Mar 2011 23:14:45 -0700
Message-ID: <201103300613.p2U6DsrS028509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812Ab1C3GN6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 02:13:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, adobriyan@gmail.com


The patch titled
     proc: constify status array
has been added to the -mm tree.  Its filename is
     proc-constify-status-array.patch

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
linux-next.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
proc-constify-status-array.patch

