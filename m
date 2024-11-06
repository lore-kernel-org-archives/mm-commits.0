Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E875216FF45
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855637; cv=none; b=JllEc1npenuI+Tmk7ul8gVLxhvNOc9/q7cH39N8jqFz4r9SBLZlX77eQHsFWEjWT/mtiKn7lcY2FcFiMfsXhCnKjZ7f+Nt/8Tk9XikqImhb6LrbjyPUm9ahbj8R1lVUcHdmEac3QG9DmNJ+tY7YDTma3uxhoWKW6G3y2NYjx8qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855637; c=relaxed/simple;
	bh=p/Nnr34bCYVVCii44AlXq2Eq1eYzO8kDMSPwJEestoQ=;
	h=Date:To:From:Subject:Message-Id; b=Tj+d7Jd0h4BO9SICsc+TjYYrTBmXs/nIS1mhRS0whMCWTqI8xIt0RnJLWvi5sd2D57bQv2RjtiLzqc0JbTQusGwNrfFvXN1xRMDJJ4guwN47nuH2NN7zmp28QrPHkehpwmMBS2q1MOUMdShszktY2t3bh9TZugtc8+ryt7pLZI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q16ZtDI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q16ZtDI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC468C4CECF;
	Wed,  6 Nov 2024 01:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855636;
	bh=p/Nnr34bCYVVCii44AlXq2Eq1eYzO8kDMSPwJEestoQ=;
	h=Date:To:From:Subject:From;
	b=q16ZtDI83F3IeLOlaNNBoe+LQS6ckU6oQro1nLgKI9qGy1XiHyRaPtgspm/QP9vwH
	 9pwvayGBdDNRyIaOhb3P7DH9bm3KLOj/P7KVVDkjgs5e3zJbH/rpMjBH9WYKo1URnh
	 VlFzFPtJ6grIQdDE96b2aI9RBph/9aa3t2c4/xaw=
Date: Tue, 05 Nov 2024 17:13:56 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] percpu-merge-verify_percpu_ptr-into-its-only-user.patch removed from -mm tree
Message-Id: <20241106011356.BC468C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: merge VERIFY_PERCPU_PTR() into its only user
has been removed from the -mm tree.  Its filename was
     percpu-merge-verify_percpu_ptr-into-its-only-user.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: percpu: merge VERIFY_PERCPU_PTR() into its only user
Date: Mon, 21 Oct 2024 10:07:36 +0200

Merge VERIFY_PERCPU_PTR() into non-CONFIG_SMP per_cpu_ptr() to make macro
similar to CONFIG_SMP per_cpu_ptr().  This will allow a follow-up patch to
refactor common code to a macro.

No functional changes, non-CONFIG_SMP per_cpu_ptr() was the only user of
VERIFY_PERCPU_PTR().

Link: https://lkml.kernel.org/r/20241021080856.48746-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-defs.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/percpu-defs.h~percpu-merge-verify_percpu_ptr-into-its-only-user
+++ a/include/linux/percpu-defs.h
@@ -254,13 +254,13 @@ do {									\
 
 #else	/* CONFIG_SMP */
 
-#define VERIFY_PERCPU_PTR(__p)						\
+#define per_cpu_ptr(ptr, cpu)						\
 ({									\
-	__verify_pcpu_ptr(__p);						\
-	(typeof(*(__p)) __kernel __force *)(__p);			\
+	(void)(cpu);							\
+	__verify_pcpu_ptr(ptr);						\
+	(typeof(*(ptr)) __kernel __force *)(ptr);			\
 })
 
-#define per_cpu_ptr(ptr, cpu)	({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
 #define raw_cpu_ptr(ptr)	per_cpu_ptr(ptr, 0)
 #define this_cpu_ptr(ptr)	raw_cpu_ptr(ptr)
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are


