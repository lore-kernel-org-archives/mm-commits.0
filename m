From: akpm@linux-foundation.org
Subject: [patch 075/126] mm,oom: remove unused argument from
 oom_scan_process_thread().
Date: Tue, 26 Jul 2016 15:24:39 -0700
Message-ID: <5797e327.0yOdJSaYRGSfJ4cO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758389AbcGZWYk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:24:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, penguin-kernel@I-love.SAKURA.ne.jp, mhocko@suse.com

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
