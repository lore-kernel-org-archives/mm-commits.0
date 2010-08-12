From: akpm@linux-foundation.org
Subject: + cgroup_freezer-unnecessary-test-in-cgroup_freezing_or_frozen.patch added to -mm tree
Date: Thu, 12 Aug 2010 12:32:29 -0700
Message-ID: <201008121932.o7CJWTSn008580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753158Ab0HLTcm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 15:32:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomasz.buchert@inria.fr, lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com


The patch titled
     cgroup_freezer: unnecessary test in cgroup_freezing_or_frozen()
has been added to the -mm tree.  Its filename is
     cgroup_freezer-unnecessary-test-in-cgroup_freezing_or_frozen.patch

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
Subject: cgroup_freezer: unnecessary test in cgroup_freezing_or_frozen()
From: Tomasz Buchert <tomasz.buchert@inria.fr>

The root freezer_state is always CGROUP_THAWED so we can remove the
special case from the code.  The test itself can be handy and is extracted
to static function.

Signed-off-by: Tomasz Buchert <tomasz.buchert@inria.fr>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_freezer.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN kernel/cgroup_freezer.c~cgroup_freezer-unnecessary-test-in-cgroup_freezing_or_frozen kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~cgroup_freezer-unnecessary-test-in-cgroup_freezing_or_frozen
+++ a/kernel/cgroup_freezer.c
@@ -48,20 +48,19 @@ static inline struct freezer *task_freez
 			    struct freezer, css);
 }
 
-int cgroup_freezing_or_frozen(struct task_struct *task)
+static inline int __cgroup_freezing_or_frozen(struct task_struct *task)
 {
-	struct freezer *freezer;
-	enum freezer_state state;
+	enum freezer_state state = task_freezer(task)->state;
+	return (state == CGROUP_FREEZING) || (state == CGROUP_FROZEN);
+}
 
+int cgroup_freezing_or_frozen(struct task_struct *task)
+{
+	int result;
 	task_lock(task);
-	freezer = task_freezer(task);
-	if (!freezer->css.cgroup->parent)
-		state = CGROUP_THAWED; /* root cgroup can't be frozen */
-	else
-		state = freezer->state;
+	result = __cgroup_freezing_or_frozen(task);
 	task_unlock(task);
