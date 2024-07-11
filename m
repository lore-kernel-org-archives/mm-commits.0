Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC7115531B
	for <mm-commits@vger.kernel.org>; Thu, 11 Jul 2024 22:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720736648; cv=none; b=Z8fcP6d31q1D1wUHA1XI2yU7E1r2wxRP4Cp/YYgXz2Xo4lLpe7kP8oYsw+JAiu0wXe4+E3hCPbSzyWLEsK6UQ8w2BQPzfQw8YKfSUTuVYfECfYc7h64k7j5RBHFR0WfyL3k8BAztEebOBw0NjQEmIBvE5hDSz69123nvPQcjX9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720736648; c=relaxed/simple;
	bh=BHbVXT+wNjnHj0XSwvqGVNYkCM7X/pqOG8HxCYDu3hA=;
	h=Date:To:From:Subject:Message-Id; b=BjE6nMYp2I1tbxxSvBUqYvAC8RIjAv3qHFCaS2sfMRZAONmi+HfHYnwg8P7fViTnF8ibhOfHSbo2EWcPf4KytteQI/kIxplnkICaSOnpbT/bqciQULgk2xah/8t1clGsLiJiJ8NXPk1+EA1JBPtoE/V5FRInTXTe/aFUszmzyZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aja2iYO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aja2iYO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003E8C116B1;
	Thu, 11 Jul 2024 22:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720736648;
	bh=BHbVXT+wNjnHj0XSwvqGVNYkCM7X/pqOG8HxCYDu3hA=;
	h=Date:To:From:Subject:From;
	b=aja2iYO4WFgCrxeNR7mRABatuPSAUDNVwIdZl9N2VD6NhjvuEVKOOAQ+oubucl1+y
	 3IX8PZ6eq9sMDur7emSQUfdCC5sHKOTJ2F5RFCs0xFhygoOJ0Rcz7HyWlV5zWqBD6c
	 6m3didLLQPWlEovsMFPP2+qRtbkV81EBpGYn8iRk=
Date: Thu, 11 Jul 2024 15:24:07 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,souravpanda@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-missing-newline-character-in-the-warning-message.patch added to mm-unstable branch
Message-Id: <20240711222408.003E8C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: add missing newline character in the warning message
has been added to the -mm mm-unstable branch.  Its filename is
     lib-add-missing-newline-character-in-the-warning-message.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-missing-newline-character-in-the-warning-message.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: lib: add missing newline character in the warning message
Date: Thu, 11 Jul 2024 15:04:55 -0700

Link: https://lkml.kernel.org/r/20240711220457.1751071-1-surenb@google.com
Fixes: 22d407b164ff ("lib: add allocation tagging support for memory allocation profiling")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/alloc_tag.h~lib-add-missing-newline-character-in-the-warning-message
+++ a/include/linux/alloc_tag.h
@@ -122,7 +122,7 @@ static inline void alloc_tag_add_check(u
 		  "alloc_tag was not cleared (got tag for %s:%u)\n",
 		  ref->ct->filename, ref->ct->lineno);
 
-	WARN_ONCE(!tag, "current->alloc_tag not set");
+	WARN_ONCE(!tag, "current->alloc_tag not set\n");
 }
 
 static inline void alloc_tag_sub_check(union codetag_ref *ref)
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-export-memory-allocation-profiling-symbols-used-by-modules.patch
mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros.patch
lib-add-missing-newline-character-in-the-warning-message.patch
lib-reuse-page_ext_data-to-obtain-codetag_ref.patch
alloc_tag-fix-page_ext_get-page_ext_put-sequence-during-page-splitting.patch

