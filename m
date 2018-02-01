From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 030/119] include/linux/sched/mm.h: uninline
 mmdrop_async(), etc
Date: Thu, 1 Feb 2018 14:39:44 -0800
Message-ID: <20180201143944.cb6101209f94b37387f6a0fe@linux-foundation.org>
References: <20180201001551.kNXMqDcc6%akpm@linux-foundation.org>
        <20180201094030.GA2269@hirez.programming.kicks-ass.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56116 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751567AbeBAWjp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 17:39:45 -0500
In-Reply-To: <20180201094030.GA2269@hirez.programming.kicks-ass.net>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: mhocko@suse.com, mingo@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com, torvalds@linux-foundation.org

On Thu, 1 Feb 2018 10:40:30 +0100 Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Jan 31, 2018 at 04:15:51PM -0800, akpm@linux-foundation.org wrote:
> > -static inline void mmdrop(struct mm_struct *mm)
> > -{
> > -	if (unlikely(atomic_dec_and_test(&mm->mm_count)))
> > -		__mmdrop(mm);
> > -}
> 
> I would prefer to keep that inline. Doing a CALL+RET for just the
> decrement is a bit silly methinks.

Good point.  I'll let this bake for a while:


From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/sched/mm.h: re-inline mmdrop()

As Peter points out, Doing a CALL+RET for just the decrement is a bit silly.

Fixes: d70f2a14b72a4bc ("include/linux/sched/mm.h: uninline mmdrop_async(), etc")
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    8 +++++++-
 kernel/fork.c            |   10 ++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/sched/mm.h~a include/linux/sched/mm.h
--- a/include/linux/sched/mm.h~a
+++ a/include/linux/sched/mm.h
@@ -35,7 +35,13 @@ static inline void mmgrab(struct mm_stru
 	atomic_inc(&mm->mm_count);
 }
 
-extern void mmdrop(struct mm_struct *mm);
+extern void __mmdrop(struct mm_struct *mm);
+
+static inline void mmdrop(struct mm_struct *mm)
+{
+	if (unlikely(atomic_dec_and_test(&mm->mm_count)))
+		__mmdrop(mm);
+}
 
 /**
  * mmget() - Pin the address space associated with a &struct mm_struct.
diff -puN kernel/fork.c~a kernel/fork.c
--- a/kernel/fork.c~a
+++ a/kernel/fork.c
@@ -591,7 +591,7 @@ static void check_mm(struct mm_struct *m
  * is dropped: either by a lazy thread or by
  * mmput. Free the page directory and the mm.
  */
-static void __mmdrop(struct mm_struct *mm)
+void __mmdrop(struct mm_struct *mm)
 {
 	BUG_ON(mm == &init_mm);
 	mm_free_pgd(mm);
@@ -602,13 +602,7 @@ static void __mmdrop(struct mm_struct *m
 	put_user_ns(mm->user_ns);
 	free_mm(mm);
 }
