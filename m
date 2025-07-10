Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95491286D60
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127177; cv=none; b=li+Zo9jOlR0CUTq+wovcIhAZL7P1cUlKb9qMy0zhmxUVLgKKe48Rnr5r+ynfd5FZH+Rfks3OjOSPCSDIffbzcDn4p0f7So3LgKi2hYtl+jE8WWMh1S+P4Cz7BF+eCwvgF/YWJq9TPKU6YrKP/wVet0Qx1V0P+qCf0UVcWT2VlDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127177; c=relaxed/simple;
	bh=ShWK36Ev95IuKSaA9A8z05YUg6Y9HGzMXc+4FuHKY0o=;
	h=Date:To:From:Subject:Message-Id; b=Xt7i1OuyeE6n/8OeJQ9VeF0Q2LdOSAHcjovZDwmKEjB+zvBa2QMNc9Dz82YUvuja8+I7lsVA0NbzZYOc19g8bwxa43jnx17e7pFpnkn1Mdh8SL1nDH8NvpnV2sfQzLoH3p0x7AjthgT6S/4RbbyehKq8N+2mn8DIG428a8yCphQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nibBaV6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nibBaV6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB60C4CEE3;
	Thu, 10 Jul 2025 05:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127177;
	bh=ShWK36Ev95IuKSaA9A8z05YUg6Y9HGzMXc+4FuHKY0o=;
	h=Date:To:From:Subject:From;
	b=nibBaV6e4KG69FFfdmO754sTUxewzFahrnwXMHAjEXJ9jwrhzpc3ejMscpozjIs3L
	 DikmlT/eL/S0TZq7EZBCMZ1XMAzC4Ejaf3r55DnBulN42SSmDmLcaGmpzMllyZwP3F
	 UgPd2Xjv+bOYMS2/S+IgJ930V4MQuXmZ5HFgTikw=
Date: Wed, 09 Jul 2025 22:59:36 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,mingzhu.wang@transsion.com,ebiederm@xmission.com,jqqlijiazi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kthread-update-comment-for-__to_kthread.patch removed from -mm tree
Message-Id: <20250710055937.6AB60C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kthread: update comment for __to_kthread
has been removed from the -mm tree.  Its filename was
     kthread-update-comment-for-__to_kthread.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


