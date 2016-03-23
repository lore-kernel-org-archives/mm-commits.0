From: akpm@linux-foundation.org
Subject: + mmoom-remove-undefined-oom_kills_count-note_oom_kill.patch
 added to -mm tree
Date: Wed, 23 Mar 2016 14:20:14 -0700
Message-ID: <56f3088e.S5iD1MAsxaPN5x42%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbcCWVUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 17:20:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/oom.h: remove undefined oom_kills_count()/note_oom_kill()
has been added to the -mm tree.  Its filename is
     mmoom-remove-undefined-oom_kills_count-note_oom_kill.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmoom-remove-undefined-oom_kills_count-note_oom_kill.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmoom-remove-undefined-oom_kills_count-note_oom_kill.patch

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
Subject: include/linux/oom.h: remove undefined oom_kills_count()/note_oom_kill()

A leftover from c32b3cbe0d06 ("oom, PM: make OOM detection in the freezer
path raceless").

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/oom.h~mmoom-remove-undefined-oom_kills_count-note_oom_kill include/linux/oom.h
--- a/include/linux/oom.h~mmoom-remove-undefined-oom_kills_count-note_oom_kill
+++ a/include/linux/oom.h
@@ -76,8 +76,6 @@ extern unsigned long oom_badness(struct
 		struct mem_cgroup *memcg, const nodemask_t *nodemask,
 		unsigned long totalpages);
 
-extern int oom_kills_count(void);
-extern void note_oom_kill(void);
 extern void oom_kill_process(struct oom_control *oc, struct task_struct *p,
 			     unsigned int points, unsigned long totalpages,
 			     struct mem_cgroup *memcg, const char *message);
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

oom-oom_reaper-protect-oom_reaper_list-using-simpler-way.patch
mmoom-remove-undefined-oom_kills_count-note_oom_kill.patch

