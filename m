Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FF31A0BE1
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 22:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648749; cv=none; b=MRMfC0j0Rk4G/Mu7WRyby243v/ZFO//aoZEqC85c3eiJgOkf/jfHkNhmEpt3sseun5LlMHbKSvOHeQqnvyBnXJfUkSjZ/nQZWRscDrDnMb4Q9K/JMhAUDwLSPpAoEfKsmGp4lbYyfmXheGI8+1s+t/doj2lX7KaeNgzjQ5b4a+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648749; c=relaxed/simple;
	bh=GQVfzXD5+XtY2JfwBQH3rrSSXTEVNKwyUo+5u2JbVco=;
	h=Date:To:From:Subject:Message-Id; b=bqARf+NKT2B0stYgdj/tdZE7wMf0PQaGnKUbA4JvXgJZ8ZgNDSDrDfmfC5QYH6sI5J4/sxxy5MYMV1I2gW1iS3fqFjQqcXmdhvrYyoOAd3p41LX8iTSnD/NF0iahUAHKVHOCcvmRjCIwCrAOWTd5mVKo21hZmr012EtRPfEtY2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p4n6chBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p4n6chBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3CFC4CECE;
	Thu, 19 Dec 2024 22:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734648748;
	bh=GQVfzXD5+XtY2JfwBQH3rrSSXTEVNKwyUo+5u2JbVco=;
	h=Date:To:From:Subject:From;
	b=p4n6chBcHbmmm/8CXNS4L+Ol8i92LjcPhWiP+sdDqr+PntAuxEFDYgMLXQqZZbx7j
	 pdJ3b7uGG8ziF8YOsxXGw4kL4PF9unq8Ql/JrahZEnInFpiqcHfYmdvFmxizMc+kvY
	 H4wi7xAwHZ5snZ0F0yTJDY5lwb5Sqji6vabMdZsc=
Date: Thu, 19 Dec 2024 14:52:28 -0800
To: mm-commits@vger.kernel.org,ubizjak@gmail.com,tj@kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,gal@nvidia.com,dennis@kernel.org,cl@linux.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-remove-intermediate-variable-in-percpu_ptr-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20241219225228.8F3CFC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu-remove-intermediate-variable-in-percpu_ptr-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     percpu-remove-intermediate-variable-in-percpu_ptr-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-remove-intermediate-variable-in-percpu_ptr-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: percpu-remove-intermediate-variable-in-percpu_ptr-fix
Date: Thu Dec 19 02:46:23 PM PST 2024

simplification, per Uros

Cc: Gal Pressman <gal@nvidia.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-defs.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/percpu-defs.h~percpu-remove-intermediate-variable-in-percpu_ptr-fix
+++ a/include/linux/percpu-defs.h
@@ -221,9 +221,7 @@ do {									\
 } while (0)
 
 #define PERCPU_PTR(__p)							\
-({									\
-	(typeof(*(__p)) __force __kernel *)((__force unsigned long)(__p)); \
-})
+	(typeof(*(__p)) __force __kernel *)((__force unsigned long)(__p))
 
 #ifdef CONFIG_SMP
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch
ocfs2-fix-slab-use-after-free-due-to-dangling-pointer-dqi_priv-checkpatch-fixes.patch
percpu-remove-intermediate-variable-in-percpu_ptr-fix.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
replace-free-hugepage-folios-after-migration-fix.patch
xarray-port-tests-to-kunit-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

