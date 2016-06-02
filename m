From: akpm@linux-foundation.org
Subject: + mmoom-remove-unused-argument-from-oom_scan_process_thread.patch added to -mm tree
Date: Thu, 02 Jun 2016 16:12:14 -0700
Message-ID: <5750bd4e.iRZHHQwZ+QPSU5+6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416AbcFBXMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 19:12:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,oom: remove unused argument from oom_scan_process_thread().
has been added to the -mm tree.  Its filename is
     mmoom-remove-unused-argument-from-oom_scan_process_thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmoom-remove-unused-argument-from-oom_scan_process_thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmoom-remove-unused-argument-from-oom_scan_process_thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm,oom: remove unused argument from oom_scan_process_thread().

oom_scan_process_thread() does not use totalpages argument.  oom_badness()
uses it.

Link: http://lkml.kernel.org/r/1463796041-7889-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    2 +-
 mm/memcontrol.c     |    2 +-
 mm/oom_kill.c       |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/oom.h~mmoom-remove-unused-argument-from-oom_scan_process_thread include/linux/oom.h
--- a/include/linux/oom.h~mmoom-remove-unused-argument-from-oom_scan_process_thread
+++ a/include/linux/oom.h
@@ -92,7 +92,7 @@ extern void check_panic_on_oom(struct oo
 			       enum oom_constraint constraint);
 
 extern enum oom_scan_t oom_scan_process_thread(struct oom_control *oc,
-		struct task_struct *task, unsigned long totalpages);
+					       struct task_struct *task);
 
 extern bool out_of_memory(struct oom_control *oc);
 
diff -puN mm/memcontrol.c~mmoom-remove-unused-argument-from-oom_scan_process_thread mm/memcontrol.c
--- a/mm/memcontrol.c~mmoom-remove-unused-argument-from-oom_scan_process_thread
+++ a/mm/memcontrol.c
@@ -1290,7 +1290,7 @@ static bool mem_cgroup_out_of_memory(str
 
 		css_task_iter_start(&iter->css, &it);
 		while ((task = css_task_iter_next(&it))) {
-			switch (oom_scan_process_thread(&oc, task, totalpages)) {
+			switch (oom_scan_process_thread(&oc, task)) {
 			case OOM_SCAN_SELECT:
 				if (chosen)
 					put_task_struct(chosen);
diff -puN mm/oom_kill.c~mmoom-remove-unused-argument-from-oom_scan_process_thread mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom-remove-unused-argument-from-oom_scan_process_thread
+++ a/mm/oom_kill.c
@@ -274,7 +274,7 @@ static enum oom_constraint constrained_a
 #endif
 
 enum oom_scan_t oom_scan_process_thread(struct oom_control *oc,
-			struct task_struct *task, unsigned long totalpages)
+					struct task_struct *task)
 {
 	if (oom_unkillable_task(task, NULL, oc->nodemask))
 		return OOM_SCAN_CONTINUE;
@@ -311,7 +311,7 @@ static struct task_struct *select_bad_pr
 	for_each_process(p) {
 		unsigned int points;
 
-		switch (oom_scan_process_thread(oc, p, totalpages)) {
+		switch (oom_scan_process_thread(oc, p)) {
 		case OOM_SCAN_SELECT:
 			chosen = p;
 			chosen_points = ULONG_MAX;
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

mmoom_reaper-dont-call-mmput_async-without-atomic_inc_not_zero.patch
mmoom-remove-unused-argument-from-oom_scan_process_thread.patch

