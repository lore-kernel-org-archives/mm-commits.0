Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F226136
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 22:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750631093; cv=none; b=kxJ2pOIZP19Fn+/PRPzz/3S+qwwsmT3EsqaVOf/CKB6i6sUzaQu42mY4x0qHAMpoLfz3y/6Yq0h37IZnoTbKP2weAP+Pmui8UpwLqIjmqG8cPlsz0C04kShBYAWpl63ov1RpOGnd5PVvDyI3WwXc1vng1HLH1gbU++y5ZAEjlGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750631093; c=relaxed/simple;
	bh=ZyAmjJ8CuV9D6CLkpiv+aA8jrP0wYPGu4Ryb67ss3DM=;
	h=Date:To:From:Subject:Message-Id; b=enp1mo56gWj7IE8hVviaj0Alr0D+5kKAfB+AefHtk2jq0zFJ76Jp8tJ7droXjoL6E3IuK9UkNOlF4b9NdPqzr+WkA+H6ub4a3BTBlkzRvVPx7Okls3sinz9VloqzJ66MPQC3Mk3LM84zf5DtyFkC0p3ScUb7UDXmnyyHshmG24U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E/YGpuHy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E/YGpuHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD14C4CEE3;
	Sun, 22 Jun 2025 22:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750631092;
	bh=ZyAmjJ8CuV9D6CLkpiv+aA8jrP0wYPGu4Ryb67ss3DM=;
	h=Date:To:From:Subject:From;
	b=E/YGpuHyBJFJdgnYroBEI7/3MPryi5WKg07cXzn+UEIOnoVmLvUxqc6yzz9i9OPYG
	 mUPh+RC2csR6R4vIVVcHIRK7BsO+ZY5Ee/P0qhvJpHPgnbsCU67nprm6H12JueKUdJ
	 fv58N3W+dupkijRTOveAPgGN3d9GVnz26ldl9fJ4=
Date: Sun, 22 Jun 2025 15:24:51 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,mingzhu.wang@transsion.com,ebiederm@xmission.com,jqqlijiazi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kthread-update-comment-for-__to_kthread.patch added to mm-nonmm-unstable branch
Message-Id: <20250622222452.5AD14C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kthread: update comment for __to_kthread
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kthread-update-comment-for-__to_kthread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kthread-update-comment-for-__to_kthread.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Jiazi Li <jqqlijiazi@gmail.com>
Subject: kthread: update comment for __to_kthread
Date: Fri, 20 Jun 2025 18:07:56 +0800

With commit 343f4c49f243 ("kthread: Don't allocate kthread_struct for init
and umh") and commit 753550eb0ce1 ("fork: Explicitly set PF_KTHREAD"), umh
task no longer have struct kthread and PF_KTHREAD flag.

Update the comment to describe what the current rules are to detect
is something is a kthread.

Link: https://lkml.kernel.org/r/20250620100801.23185-1-jqqlijiazi@gmail.com
Signed-off-by: Jiazi Li <jqqlijiazi@gmail.com>
Signed-off-by: mingzhu.wang <mingzhu.wang@transsion.com>
Suggested-by Eric W . Biederman <ebiederm@xmission.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/kernel/kthread.c~kthread-update-comment-for-__to_kthread
+++ a/kernel/kthread.c
@@ -88,13 +88,12 @@ static inline struct kthread *to_kthread
 /*
  * Variant of to_kthread() that doesn't assume @p is a kthread.
  *
- * Per construction; when:
+ * When "(p->flags & PF_KTHREAD)" is set the task is a kthread and will
+ * always remain a kthread.  For kthreads p->worker_private always
+ * points to a struct kthread.  For tasks that are not kthreads
+ * p->worker_private is used to point to other things.
  *
- *   (p->flags & PF_KTHREAD) && p->worker_private
- *
- * the task is both a kthread and struct kthread is persistent. However
- * PF_KTHREAD on it's own is not, kernel_thread() can exec() (See umh.c and
- * begin_new_exec()).
+ * Return NULL for any task that is not a kthread.
  */
 static inline struct kthread *__to_kthread(struct task_struct *p)
 {
_

Patches currently in -mm which might be from jqqlijiazi@gmail.com are

kthread-update-comment-for-__to_kthread.patch

