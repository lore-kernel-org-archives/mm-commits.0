Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411B448788
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 17:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0hXfhNhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B6BC433C8;
	Wed, 20 Dec 2023 17:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703094201;
	bh=CK6Btq2xgKdAGmwx/Faq42eGVOzh8dsvQ2LRqZ4HgSk=;
	h=Date:To:From:Subject:From;
	b=0hXfhNhyrEShvtsfEZSQX8fD6Q4f1CEjT010aTCxgjBvR27d8ab0EaJFhxWr/eft3
	 PZUnJXaHACCsm7qF2EZJHXcEFPxNktgBmcXh7BsDtyKJ4hmQ0Ou2IcpMSwlj25VrZF
	 a270DAEKz906/hEz9vSOm5uni7FvadtckGNHj3DE=
Date: Wed, 20 Dec 2023 09:43:21 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + stacktrace-fix-kernel-doc-typo.patch added to mm-nonmm-unstable branch
Message-Id: <20231220174321.85B6BC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: stacktrace: fix kernel-doc typo
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     stacktrace-fix-kernel-doc-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/stacktrace-fix-kernel-doc-typo.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: stacktrace: fix kernel-doc typo
Date: Tue, 19 Dec 2023 21:49:45 -0800

Change @task to @tsk to prevent kernel-doc warnings:

kernel/stacktrace.c:138: warning: Excess function parameter 'task' description in 'stack_trace_save_tsk'
kernel/stacktrace.c:138: warning: Function parameter or member 'tsk' not described in 'stack_trace_save_tsk'

Link: https://lkml.kernel.org/r/20231220054945.17663-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stacktrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/stacktrace.c~stacktrace-fix-kernel-doc-typo
+++ a/kernel/stacktrace.c
@@ -126,7 +126,7 @@ EXPORT_SYMBOL_GPL(stack_trace_save);
 
 /**
  * stack_trace_save_tsk - Save a task stack trace into a storage array
- * @task:	The task to examine
+ * @tsk:	The task to examine
  * @store:	Pointer to storage array
  * @size:	Size of the storage array
  * @skipnr:	Number of entries to skip at the start of the stack trace
_

Patches currently in -mm which might be from rdunlap@infradead.org are

maple_tree-fix-typos-spellos-etc.patch
gfp-gfp_typesh-fix-typos-punctuation.patch
rapidio-tsi721-fix-kernel-doc-warnings.patch
freevxfs-bmap-fix-kernel-doc-warnings.patch
freevxfs-immed-fix-kernel-doc-param-name.patch
freevxfs-lookup-fix-function-params-kernel-doc.patch
init-kconfig-move-more-items-into-the-expert-menu.patch
usr-kconfig-fix-typos-of-its.patch
stacktrace-fix-kernel-doc-typo.patch

