Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C7F8F47
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 20:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719435288; cv=none; b=sCwPU7HLIBoPaBJ2v/kKUYqhsFvU6zSB0eONxgs1q9JIB13UNLOhnaSKgjYG9yhC9W4KvCddqLOy0KovO14rVsSEv+sctwQGyh5ft49baPPbwT5Xb0rns+6g40VFP94R5AxWV+b++ORde6CLU8v5J1FagpWy62fch/lm846gtYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719435288; c=relaxed/simple;
	bh=tYlGk4aLoslGU6SfOQ69y5tuuDBjzzwXK+hELYP6RuA=;
	h=Date:To:From:Subject:Message-Id; b=u+fklQuWzjy+xt3/s/ApJ4K/y9gPjTvfzoAJlhm4MfXG9/jGC1UEkV9rMQhKXPSad+deWNkDG+FuNeRiEh6Ulp08867DAg/rE7WiTVOCMebeM/GATPNk5Lb0Lk9vDUxah+7xl4BHOGjhkthmr3uXKJhHyL6hs5ZUM/2QWPziV3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gq/MMBrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gq/MMBrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27C2C116B1;
	Wed, 26 Jun 2024 20:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719435288;
	bh=tYlGk4aLoslGU6SfOQ69y5tuuDBjzzwXK+hELYP6RuA=;
	h=Date:To:From:Subject:From;
	b=gq/MMBrEfDCLyUPUWknx58nXnlJ7VnvsrZelk82R5a8KT+8EqB+lB8Hx9Ibpuzqz8
	 LEzy+6tEJEDI6qLfCIWpr879Km/zc+B0e+O2zUeNpkDHNlSvpliAZrz11/e2Dnztlo
	 d+fnpZhMGVVH6ofr0CMKqbPhW2Ih4zRHeaOCQSIY=
Date: Wed, 26 Jun 2024 13:54:47 -0700
To: mm-commits@vger.kernel.org,mhocko@suse.com,ebiederm@xmission.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + get_task_mm-check-pf_kthread-lockless.patch added to mm-unstable branch
Message-Id: <20240626205447.E27C2C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: get_task_mm: check PF_KTHREAD lockless
has been added to the -mm mm-unstable branch.  Its filename is
     get_task_mm-check-pf_kthread-lockless.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_task_mm-check-pf_kthread-lockless.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: get_task_mm: check PF_KTHREAD lockless
Date: Wed, 26 Jun 2024 21:10:17 +0200

Nowadays PF_KTHREAD is sticky and it was never protected by ->alloc_lock. 
Move the PF_KTHREAD check outside of task_lock() section to make this code
more understandable.

Link: https://lkml.kernel.org/r/20240626191017.GA20031@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/kernel/fork.c~get_task_mm-check-pf_kthread-lockless
+++ a/kernel/fork.c
@@ -1536,14 +1536,13 @@ struct mm_struct *get_task_mm(struct tas
 {
 	struct mm_struct *mm;
 
+	if (task->flags & PF_KTHREAD)
+		return NULL;
+
 	task_lock(task);
 	mm = task->mm;
-	if (mm) {
-		if (task->flags & PF_KTHREAD)
-			mm = NULL;
-		else
-			mmget(mm);
-	}
+	if (mm)
+		mmget(mm);
 	task_unlock(task);
 	return mm;
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

memcg-mm_update_next_owner-kill-the-retry-logic.patch
memcg-mm_update_next_owner-move-for_each_thread-into-try_to_set_owner.patch
get_task_mm-check-pf_kthread-lockless.patch
zap_pid_ns_processes-dont-send-sigkill-to-sub-threads.patch
coredump-simplify-zap_process.patch

