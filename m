Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B3A1459EA;
	Fri, 13 Dec 2024 04:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734063191; cv=none; b=IxxzphEy4iLSsMvsC901aD8AQ8KZRePRHalPAVMEak01+xdtub9EHKySlBh//cwPHdvHAq2NbQ5KyWKR/FiOwIa6Avq+WBIgu/md1W7GDsfwaLF/t1hcgtWxSUwtRjnedkuEL7kgoYslHANM6PpuD9oNmydAktQ3JieMLW0RiZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734063191; c=relaxed/simple;
	bh=FVOSKvHjdMqdpUwOdhEquny2EJt+xZan/P8d4+oyGHY=;
	h=Date:To:From:Subject:Message-Id; b=jXN+YXvPupoUFqP5yiJxXTRpvDtl8rbuLY5kOWNfxTC7l5P5MR/GUaml8AzWx1q/MiScHHYtdl3V8XjmE4QpX79WeTpBOUcTnKYJn5d5vkarUTC4KNa1r6AaSXJiRnpa4+6zHwsVVx7tRB6+Y1UnoKN/yaIUYJCwOElYfUpPtnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mp7E8GSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mp7E8GSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A6FC4CED2;
	Fri, 13 Dec 2024 04:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734063190;
	bh=FVOSKvHjdMqdpUwOdhEquny2EJt+xZan/P8d4+oyGHY=;
	h=Date:To:From:Subject:From;
	b=Mp7E8GSJuAjGnzhp/+gstZ1XABsYBoFxyPQwmbzZxhkdshnQ062746xRzuVB6gdd8
	 7QcOb9ZwFbR2+Hjb9vf6j6kpZkv73o8MdXsP2w8L1IF0rVPT9QJ+AMJ7CS89UBzDcP
	 wlbcQ8zUI+JGDUvlAj85VcXvSAluwMUtsVIFx81o=
Date: Thu, 12 Dec 2024 20:13:10 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,surenb@google.com,stable@vger.kernel.org,oliver.sang@intel.com,kent.overstreet@linux.dev,00107082@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-codetag-clear-tags-before-swap.patch added to mm-hotfixes-unstable branch
Message-Id: <20241213041310.A8A6FC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/codetag: clear tags before swap
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-codetag-clear-tags-before-swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-codetag-clear-tags-before-swap.patch

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
From: David Wang <00107082@163.com>
Subject: mm/codetag: clear tags before swap
Date: Fri, 13 Dec 2024 09:33:32 +0800

When CONFIG_MEM_ALLOC_PROFILING_DEBUG is set, kernel WARN would be
triggered when calling __alloc_tag_ref_set() during swap:

	alloc_tag was not cleared (got tag for mm/filemap.c:1951)
	WARNING: CPU: 0 PID: 816 at ./include/linux/alloc_tag.h...

Clear code tags before swap can fix the warning. And this patch also fix
a potential invalid address dereference in alloc_tag_add_check() when
CONFIG_MEM_ALLOC_PROFILING_DEBUG is set and ref->ct is CODETAG_EMPTY,
which is defined as ((void *)1).

Link: https://lkml.kernel.org/r/20241213013332.89910-1-00107082@163.com
Fixes: 51f43d5d82ed ("mm/codetag: swap tags when migrate pages")
Signed-off-by: David Wang <00107082@163.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202412112227.df61ebb-lkp@intel.com
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |    2 +-
 lib/alloc_tag.c           |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/alloc_tag.h~mm-codetag-clear-tags-before-swap
+++ a/include/linux/alloc_tag.h
@@ -140,7 +140,7 @@ static inline struct alloc_tag_counters
 #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
 static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag *tag)
 {
-	WARN_ONCE(ref && ref->ct,
+	WARN_ONCE(ref && ref->ct && !is_codetag_empty(ref),
 		  "alloc_tag was not cleared (got tag for %s:%u)\n",
 		  ref->ct->filename, ref->ct->lineno);
 
--- a/lib/alloc_tag.c~mm-codetag-clear-tags-before-swap
+++ a/lib/alloc_tag.c
@@ -209,6 +209,13 @@ void pgalloc_tag_swap(struct folio *new,
 		return;
 	}
 
+	/*
+	 * Clear tag references to avoid debug warning when using
+	 * __alloc_tag_ref_set() with non-empty reference.
+	 */
+	set_codetag_empty(&ref_old);
+	set_codetag_empty(&ref_new);
+
 	/* swap tags */
 	__alloc_tag_ref_set(&ref_old, tag_new);
 	update_page_tag_ref(handle_old, &ref_old);
_

Patches currently in -mm which might be from 00107082@163.com are

mm-codetag-clear-tags-before-swap.patch

