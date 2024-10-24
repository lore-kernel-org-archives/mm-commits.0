Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F7D376F1
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 02:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729738539; cv=none; b=uGZZtEeGfJsRm0oVTOmY94r5KeGdppiyVx2ZP1pv7HyF0dHXXV5efxlvR0YsPtHG2s99+AhD/+M4Ns/bTXfs8y/5DOMfDdRl0ekDAAQy0kI6yNIpmwOK7UB7fHK1YVKeSgn16zS1jO7ANZgHPbl4/p5J7KXBjErv5kkIKG7U2wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729738539; c=relaxed/simple;
	bh=O9JLygHQKteodKz5qb9H4CmF1gNLWL66S/nt9r6KjoQ=;
	h=Date:To:From:Subject:Message-Id; b=KFaTHcK5uDkpZ7yrnDo6Mxa5WuPxA1AtzHBhoBqOm8I15zelZ1skbJWubgQ9vJjd32li9ZtUzj2fy0qSyUeYZILQfrxR2hQWN7RARzm/fx1t8bVZ6okaqHVWVZSympz6tYmL+ndC/5C/To28WAxyrzLSAsndCH9LT96Un3p8EHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OrFEFwyj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OrFEFwyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FCFC4CEC6;
	Thu, 24 Oct 2024 02:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729738538;
	bh=O9JLygHQKteodKz5qb9H4CmF1gNLWL66S/nt9r6KjoQ=;
	h=Date:To:From:Subject:From;
	b=OrFEFwyjLpGY8RJcy04VFAUBiQZZb7OD7iPB1jy0eZEGgxVNYHHor2OCM12VjJIIV
	 /0CiluNPtP2jnMwhX0tSYHis4xLtHbS4NP5oh0KPcBL/iwTjFBD1DcUundWKbGZbSF
	 x3goHgHdsntCoPbG+ZHHlhmLKHzQCGT73OfBv2JY=
Date: Wed, 23 Oct 2024 19:55:36 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-merge-verify_percpu_ptr-into-its-only-user.patch added to mm-nonmm-unstable branch
Message-Id: <20241024025538.73FCFC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: merge VERIFY_PERCPU_PTR() into its only user
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     percpu-merge-verify_percpu_ptr-into-its-only-user.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-merge-verify_percpu_ptr-into-its-only-user.patch

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

perf-hw_breakpoint-use-err_ptr_pcpu-is_err_pcpu-and-ptr_err_pcpu-macros.patch
percpu-merge-verify_percpu_ptr-into-its-only-user.patch
percpu-introduce-percpu_ptr-macro.patch
percpu-cast-percpu-pointer-in-percpu_ptr-via-unsigned-long.patch

