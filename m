Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB962C324C;
	Mon,  2 Jun 2025 23:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748905436; cv=none; b=Bf23uMHtgNUdgjnfyyd4unQcZGVw1LXjz4Bm44NuHNP6JIeRGMEdn2LEk1Cm4EGMkZigyWD+Y8GzWe4jHeFeKNUXg08P8y4JvET3YSY4uwRaYGRarYB+02ggVMYYSBVfQ+Sxtvux99v2tVm5aKWM4ruZgiqz2eDSDGYdwwRg9Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748905436; c=relaxed/simple;
	bh=enesM/kbKXtB2Fn8FJwXky/zWaZKJtb8khx/YedFwto=;
	h=Date:To:From:Subject:Message-Id; b=WoC/GRZ4V4rg9JZDe21vgbL2WfNs96ePMXLRCdC+q26C0CPIALFvPBfJsOhPHL1oPQ9li8ptaNDmygdt/U96RMXdC5BJ5qSEm69Du1wgC6BNAEAXAfhXQL6RkYcYbtuUTgUFsyj/tSD9z7y4tTTmRrWmq2VUeD1hm4vxy0OX4uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lhZtiN85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lhZtiN85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC2CC4CEEB;
	Mon,  2 Jun 2025 23:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748905435;
	bh=enesM/kbKXtB2Fn8FJwXky/zWaZKJtb8khx/YedFwto=;
	h=Date:To:From:Subject:From;
	b=lhZtiN856tX5Bt9CWoPyr4Hbv8VososHEElS4rcfrlwSsZBl0/p875HV7Jx6XZVnH
	 PI2i1rXomTvb9746dx69bXWk95tuVGb4bIOlPR+VgTzc4b0u8qm8avfdDEQYSeSRP7
	 lP8J4/1fVWUfpaoNNTlSBMxFauhiL8SAN2M2uqrU=
Date: Mon, 02 Jun 2025 16:03:55 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,baohua@kernel.org,21cnbao@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-handle-madvise_lock-failure-during-race-unwinding.patch added to mm-hotfixes-unstable branch
Message-Id: <20250602230355.CBC2CC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: handle madvise_lock() failure during race unwinding
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-madvise-handle-madvise_lock-failure-during-race-unwinding.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-handle-madvise_lock-failure-during-race-unwinding.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/madvise: handle madvise_lock() failure during race unwinding
Date: Mon, 2 Jun 2025 10:49:26 -0700

When unwinding race on -ERESTARTNOINTR handling of process_madvise(),
madvise_lock() failure is ignored.  Check the failure and abort remaining
works in the case.

Link: https://lkml.kernel.org/r/20250602174926.1074-1-sj@kernel.org
Fixes: 4000e3d0a367 ("mm/madvise: remove redundant mmap_lock operations from process_madvise()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Barry Song <21cnbao@gmail.com>
Closes: https://lore.kernel.org/CAGsJ_4xJXXO0G+4BizhohSZ4yDteziPw43_uF8nPXPWxUVChzw@mail.gmail.com
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-handle-madvise_lock-failure-during-race-unwinding
+++ a/mm/madvise.c
@@ -1881,7 +1881,9 @@ static ssize_t vector_madvise(struct mm_
 			/* Drop and reacquire lock to unwind race. */
 			madvise_finish_tlb(&madv_behavior);
 			madvise_unlock(mm, behavior);
-			madvise_lock(mm, behavior);
+			ret = madvise_lock(mm, behavior);
+			if (ret)
+				goto out;
 			madvise_init_tlb(&madv_behavior, mm);
 			continue;
 		}
@@ -1892,6 +1894,7 @@ static ssize_t vector_madvise(struct mm_
 	madvise_finish_tlb(&madv_behavior);
 	madvise_unlock(mm, behavior);
 
+out:
 	ret = (total_len - iov_iter_count(iter)) ? : ret;
 
 	return ret;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-handle-madvise_lock-failure-during-race-unwinding.patch
mm-damon-kconfig-set-damon_vaddrpaddrsysfs-default-to-damon.patch
mm-damon-kconfig-enable-config_damon-by-default.patch

