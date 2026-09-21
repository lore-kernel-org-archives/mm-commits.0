Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B834A64D3
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 22:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790031407; cv=none; b=tIFnaeNjg5xAy/NNwr+fOP3rDEBadFkdFnLWygUSuxKH49HtVmvNGa+J1tlQ2QZJUCxcoZ+G2ikJLjY8eUa3Xi0VVunub3WFiOS2d+I2Eg9IFTQ4upC84tASIWGCmKCHOfBa/4wRukn6YyPid+G4GGEELVLyb+e91FmHkPxjEnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790031407; c=relaxed/simple;
	bh=DMxXMXiiN2t2ZUWu+Twskna+vl2op/HkhsLVj00Pr8o=;
	h=Date:To:From:Subject:Message-Id; b=qF62ZBCJEuCyZmzezRKdgDyvGQ76GJ3GT9ENmGRO6BhFi7ffYg0er0FnKRyryvmGoNHOjfSrcdqIOOuQo7lK8/e9n8kk6W2PRSQifACvekVsDzC1NdD1PxThrY6RgKOY17v/vBqcPo85fyq4ajXJv62GJQldbAI8CtWILCpgjC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mfN2BuQU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mfN2BuQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9EE1F000FF;
	Mon, 21 Sep 2026 22:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790031405;
	bh=Tn7DcPIzGr9MiOD97DX5ZJl3OpQCxieRzr3Imc1Xdvo=;
	h=Date:To:From:Subject;
	b=mfN2BuQUOs3QdTJV7PwLtiopEnp64qMeGJatZe99rowFGfyHnCEVMCUZJDEL1DsfF
	 6ormDBxGzGRKPybxtbIKLuppZFOQzY1qtHQ8SGVf2yUTROCTUC0DYuvcA0KPOS4K7q
	 X41mbi8y1wH6a4SJULqiwfDcReEgeG7+obCzIQH8=
Date: Mon, 21 Sep 2026 15:56:45 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,syzbot+a3c71b9db9c11c270f59@syzkaller.appspotmail.com,hughd@google.com,dennis@kernel.org,cl@gentwo.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,azpijr@gmail.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu_counter-annotate-lockless-read-in-_limited_add.patch added to mm-nonmm-unstable branch
Message-Id: <20260921225645.CE9EE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu_counter: annotate lockless read in _limited_add()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     percpu_counter-annotate-lockless-read-in-_limited_add.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu_counter-annotate-lockless-read-in-_limited_add.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: percpu_counter: annotate lockless read in _limited_add()
Date: Mon, 21 Sep 2026 23:55:04 +0200

syzbot reports a data race on fbc->count between the lockless read in the
fast path of __percpu_counter_limited_add() and the locked update in
percpu_counter_add_batch(), reached via shmem's used_blocks counter: the
alloc path reads it through percpu_counter_limited_add() while the free
path updates it through percpu_counter_sub().

Annotate the read rather than change the logic: the lockless read is
deliberate, only the annotation is missing.  It is an approximation, not a
conservative bound.  A concurrent flush moves value between fbc->count and
a per-cpu counter, and other CPUs' locked slow paths add to fbc->count
too, so a stale low value can let the fast path proceed where the slow
path would refuse.  The error is bounded by the per-cpu slack (unknown =
batch * num_online_cpus()).  This is existing behavior, no functional
change intended.

Read it with data_race(READ_ONCE(fbc->count)): data_race() tells KCSAN the
race is intended (READ_ONCE() alone still triggers the report, because
KCSAN reports against watchpoints set up by plain accesses), while
READ_ONCE() stops the compiler from refetching the value, as in
percpu_counter_read_positive().  The lock-protected accesses stay plain,
so future buggy lockless writes are still caught.

Link: https://lore.kernel.org/20260921215508.141641-1-azpijr@gmail.com
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+a3c71b9db9c11c270f59@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a3c71b9db9c11c270f59
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
---

 lib/percpu_counter.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/lib/percpu_counter.c~percpu_counter-annotate-lockless-read-in-_limited_add
+++ a/lib/percpu_counter.c
@@ -328,6 +328,7 @@ bool __percpu_counter_limited_add(struct
 				  s64 limit, s64 amount, s32 batch)
 {
 	s64 count;
+	s64 gcount;
 	s64 unknown;
 	unsigned long flags;
 	bool good = false;
@@ -338,11 +339,16 @@ bool __percpu_counter_limited_add(struct
 	local_irq_save(flags);
 	unknown = batch * num_online_cpus();
 	count = __this_cpu_read(*fbc->counters);
+	/*
+	 * Lockless on purpose: gcount may be stale, so this is only an
+	 * approximation, bounded by the per-cpu slack ("unknown").
+	 */
+	gcount = data_race(READ_ONCE(fbc->count));
 
 	/* Skip taking the lock when safe */
 	if (abs(count + amount) <= batch &&
-	    ((amount > 0 && fbc->count + unknown <= limit) ||
-	     (amount < 0 && fbc->count - unknown >= limit))) {
+	    ((amount > 0 && gcount + unknown <= limit) ||
+	     (amount < 0 && gcount - unknown >= limit))) {
 		this_cpu_add(*fbc->counters, amount);
 		local_irq_restore(flags);
 		return true;
_

Patches currently in -mm which might be from azpijr@gmail.com are

percpu_counter-annotate-lockless-read-in-_limited_add.patch

