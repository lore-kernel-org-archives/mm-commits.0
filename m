Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA632236F8;
	Tue, 24 Jun 2025 23:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750808103; cv=none; b=BWe+iZ4kSEHt9S2ynHJeecIsMoKIbtTnAs1wKB5DcSSPwaNxIFHvYXUMn1Ql7/eWfVhqXHmQQ8lryx4eRzrWWS63atG6FBqm0erV80YClfRM5fyt41O7vEYDUIh5lWuP7Dt42SqkhWkznxQbJlrSZFwyyp77OVDLm6+T4DBfCzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750808103; c=relaxed/simple;
	bh=lW8txp33VDiuFyIqPTIUlrNuTQBB2phoz4id7VUo1Y0=;
	h=Date:To:From:Subject:Message-Id; b=JDxAmrAfqEI41otlL7fO1lllkWhe2m4XLx51IPR5CBfElLZgkWzXBjENR4UGQ75cYCPtrURzjKa8crw31CrhbmvTdrdcB1MTMFmsH/vjs7dXaQ1ps2L5U5GtwG3WAcA9Bi6P4xVloOjvFKG4/xQUb7ijIQ9kJj4+fMKiSn676/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LFv5wuG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LFv5wuG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1063EC4CEE3;
	Tue, 24 Jun 2025 23:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750808103;
	bh=lW8txp33VDiuFyIqPTIUlrNuTQBB2phoz4id7VUo1Y0=;
	h=Date:To:From:Subject:From;
	b=LFv5wuG7JAsZEzLPcy2depQSBhQH1ZsVY7noXthtlmeDrOd7CfpPRgzYiYaydmbuw
	 8JkiF33ct+DlEf6fevDuwGerX9iQAkhk7miyf+flXXpgpWLIXiZDrmkVamuaUypyNA
	 8MBLnIhesnmPfj0pG4YGTMFBCC14XD81WvaZE0o4=
Date: Tue, 24 Jun 2025 16:35:02 -0700
To: mm-commits@vger.kernel.org,yzhong@purestorage.com,surenb@google.com,stable@vger.kernel.org,oliver.sang@intel.com,kent.overstreet@linux.dev,cachen@purestorage.com,00107082@163.com,harry.yoo@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20250624233503.1063EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users-v3
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users-v3.patch

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
From: Harry Yoo <harry.yoo@oracle.com>
Subject: lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users-v3
Date: Tue, 24 Jun 2025 16:25:13 +0900

Link: https://lkml.kernel.org/r/20250624072513.84219-1-harry.yoo@oracle.com
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202506181351.bba867dd-lkp@intel.com
Closes: https://lore.kernel.org/oe-lkp/202506131711.5b41931c-lkp@intel.com
Fixes: 780138b12381 ("alloc_tag: check mem_profiling_support in alloc_tag_init")
Fixes: 1438d349d16b ("lib: add memory allocations report in show_mem()")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Casey Chen <cachen@purestorage.com>
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yuanyuan Zhong <yzhong@purestorage.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/alloc_tag.c~lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users-v3
+++ a/lib/alloc_tag.c
@@ -137,7 +137,8 @@ size_t alloc_tag_top_users(struct codeta
 
 	if (IS_ERR_OR_NULL(alloc_tag_cttype))
 		return 0;
-	else if (can_sleep)
+
+	if (can_sleep)
 		codetag_lock_module_list(alloc_tag_cttype, true);
 	else if (!codetag_trylock_module_list(alloc_tag_cttype))
 		return 0;
_

Patches currently in -mm which might be from harry.yoo@oracle.com are

lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users.patch
lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users-v3.patch

