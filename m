Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE2C82863
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218896; cv=none; b=nJrotam1zugQzNrTzxvr8z8KdLfrUz3YQkFXNIKqsuX9qJ2auIPHZ14Fr5S+WdSTuLakerdE7Yr1FujaoUIq7YvBlacEnby1EiXyEnop85xPMLajI2Prk7P0l+XsDiKJVoI5GAZt+t0i8tlDGHIvOuXci54zwZsitZSHKsDqJ4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218896; c=relaxed/simple;
	bh=l4L07tD3fyxHE5uTDbu/mt/4DCtOg8OWrR/zN5Wn2dg=;
	h=Date:To:From:Subject:Message-Id; b=kO6NVpEx9gYOH7AtLSbNU8H3Lsrlg4vSbKkDVJ7v26VTdqpNbOV1/tNc9KKPVXBoC4ktzpjv+2ZCl8myBPWRBtjp4QozMA1m3IeD9xF0fyzgOA8NFK0mK7LJ87sUFzY7belPHPz9+1l1///u+8sj4gC2D1MJIOxsmskTsHXDtOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B4nckfPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B4nckfPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F24C116B1;
	Wed, 12 Jun 2024 19:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718218896;
	bh=l4L07tD3fyxHE5uTDbu/mt/4DCtOg8OWrR/zN5Wn2dg=;
	h=Date:To:From:Subject:From;
	b=B4nckfPR5TOL6BkLNV5+QDLkP9/dF9VPbYsxAosmM6u/wW/gf+X6ahuH3rPJZgD1W
	 zaC8kjwyo1JYRqyAGw3neDWOgY8AZOWSGEbUOw7yN9c+R5HHYfXhgM2OX7W9CdB5wd
	 4457iDa74CBj672uKlR9lvLkyy8wsrfnaqHe8UyU=
Date: Wed, 12 Jun 2024 12:01:35 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-remove-unneeded-empty-string.patch added to mm-unstable branch
Message-Id: <20240612190136.00F24C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: remove unneeded empty string
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-remove-unneeded-empty-string.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-remove-unneeded-empty-string.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: remove unneeded empty string
Date: Wed, 12 Jun 2024 15:18:27 +0800

Remove unneeded empty string in definition of macro pr_fmt.  No functional
change intended.

Link: https://lkml.kernel.org/r/20240612071835.157004-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-unneeded-empty-string
+++ a/mm/memory-failure.c
@@ -2518,7 +2518,7 @@ static int __init memory_failure_init(vo
 core_initcall(memory_failure_init);
 
 #undef pr_fmt
-#define pr_fmt(fmt)	"" fmt
+#define pr_fmt(fmt)	fmt
 #define unpoison_pr_info(fmt, pfn, rs)			\
 ({							\
 	if (__ratelimit(rs))				\
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-simplify-put_ref_page.patch
mm-memory-failure-remove-mf_msg_slab.patch
mm-memory-failure-add-macro-get_page_max_retry_num.patch
mm-memory-failure-save-some-page_folio-calls.patch
mm-memory-failure-remove-unneeded-empty-string.patch
mm-memory-failure-remove-confusing-initialization-to-count.patch
mm-memory-failure-dont-export-hwpoison_filter-when-config_hwpoison_inject.patch
mm-memory-failure-use-helper-macro-task_pid_nr.patch
mm-memory-failure-remove-obsolete-comment-in-unpoison_memory.patch
mm-memory-failure-move-some-function-declarations-into-internalh.patch
mm-memory-failure-fix-comment-of-get_hwpoison_page.patch
mm-memory-failure-remove-obsolete-comment-in-kill_proc.patch
mm-memory-failure-correct-comment-in-me_swapcache_dirty.patch

