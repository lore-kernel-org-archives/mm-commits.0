From: akpm@linux-foundation.org
Subject: [merged] proc-more-const-char-pointers.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:39:56 -0700
Message-ID: <53ea6d8c.3m7yj03lrGqnJkE0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:56198 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbaHLTj5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:57 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so1068731igd.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: more "const char *" pointers
has been removed from the -mm tree.  Its filename was
     proc-more-const-char-pointers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: more "const char *" pointers

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~proc-more-const-char-pointers fs/proc/base.c
--- a/fs/proc/base.c~proc-more-const-char-pointers
+++ a/fs/proc/base.c
@@ -105,7 +105,7 @@
  */
 
 struct pid_entry {
-	char *name;
+	const char *name;
 	int len;
 	umode_t mode;
 	const struct inode_operations *iop;
@@ -418,8 +418,8 @@ static int proc_oom_score(struct task_st
 }
 
 struct limit_names {
-	char *name;
-	char *unit;
+	const char *name;
+	const char *unit;
 };
 
 static const struct limit_names lnames[RLIM_NLIMITS] = {
@@ -2056,7 +2056,7 @@ static int show_timer(struct seq_file *m
 	struct k_itimer *timer;
 	struct timers_private *tp = m->private;
 	int notify;
-	static char *nstr[] = {
+	static const char * const nstr[] = {
 		[SIGEV_SIGNAL] = "signal",
 		[SIGEV_NONE] = "none",
 		[SIGEV_THREAD] = "thread",
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch

