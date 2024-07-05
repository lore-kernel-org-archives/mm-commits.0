Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD308D2F0
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141631; cv=none; b=GLi1q49GgpCXjJeHaabMVGxuHhFGLNVpH50jRL/noa5LcyhSGpdlFDbRRgfcdJM0UwYdEpkyrA6Ae9hBppmPZw/BMn6L6VHwi/O/ZUTBI+4sp0HFhpo7MNA60sOtm7KQ5sXXcEiH49XTnQn/TdRQRm+lgBwmac2U4AamKPudOYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141631; c=relaxed/simple;
	bh=qQBNEEzyvig9kjVi/mbtnFMB0uV8uarCA0P5yHrLQSk=;
	h=Date:To:From:Subject:Message-Id; b=jCxogAvZdJWFD39zU6o/Lfh2JD70885pE7/H5IlRlEemUdrZkYFlkFoOAwBEDFXxQWB8Sz3l6nqUTpI/3KKqYUZgC/cqIWavlYH4PFwKK5P2Zf+Hsmn9useX19TebsPYpxBs51oKRQ1NB88DrQL0qiiGEOVz51zw3jZ0YExdF+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w/hYTn8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w/hYTn8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF56C3277B;
	Fri,  5 Jul 2024 01:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141631;
	bh=qQBNEEzyvig9kjVi/mbtnFMB0uV8uarCA0P5yHrLQSk=;
	h=Date:To:From:Subject:From;
	b=w/hYTn8VJCsUwkneM0eGAWYMAocV9dQ8q/0G7OL8s9GSPJj6QBT308fdgwT4tuYPX
	 0GuEfV2ub4s/DOskGG+RcT+n7aKnt/WiYs/8Ohu2eDCuh9VsSN1aGnHuqPYCCTqwdk
	 dicdVQSaOhgnFno8RQBs6C+KRBRACLr2Tww8LB+s=
Date: Thu, 04 Jul 2024 18:07:11 -0700
To: mm-commits@vger.kernel.org,mhocko@suse.com,ebiederm@xmission.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] get_task_mm-check-pf_kthread-lockless.patch removed from -mm tree
Message-Id: <20240705010711.9FF56C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: get_task_mm: check PF_KTHREAD lockless
has been removed from the -mm tree.  Its filename was
     get_task_mm-check-pf_kthread-lockless.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: get_task_mm: check PF_KTHREAD lockless
Date: Wed, 26 Jun 2024 21:10:17 +0200

Nowadays PF_KTHREAD is sticky and it was never protected by ->alloc_lock. 
Move the PF_KTHREAD check outside of task_lock() section to make this code
more understandable.

Link: https://lkml.kernel.org/r/20240626191017.GA20031@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
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

zap_pid_ns_processes-dont-send-sigkill-to-sub-threads.patch
coredump-simplify-zap_process.patch

