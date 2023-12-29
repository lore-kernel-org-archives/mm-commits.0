Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F6714015
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y/MKKIAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B422CC433C7;
	Fri, 29 Dec 2023 20:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881407;
	bh=SqSID4/8o6ATilGDN5wQksx3+AW4yMZ4iNAOyTo7+uk=;
	h=Date:To:From:Subject:From;
	b=Y/MKKIAYI+jmCE0wLc5KG+7s1D5kCfNJedJcWMJEjluGJTK6lGV7gf8RXRmQk2mlD
	 Dk5vOIf5DI2whikjaL666HZUOi948kAyN8IKiQYxlSr6BtpwgOroJAE2do+zLTrok5
	 rh8CGdcnrbbSVLoiyo1bokqZG6YEBg2ok7C9qsZA=
Date: Fri, 29 Dec 2023 12:23:27 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] stacktrace-fix-kernel-doc-typo.patch removed from -mm tree
Message-Id: <20231229202327.B422CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: stacktrace: fix kernel-doc typo
has been removed from the -mm tree.  Its filename was
     stacktrace-fix-kernel-doc-typo.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


