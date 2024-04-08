Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25640433BD
	for <mm-commits@vger.kernel.org>; Mon,  8 Apr 2024 19:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712603486; cv=none; b=CoHcZlp9gH1LoIBdJng6vJANYdLfdAhS6yYY7JyFzDwCHF7DsjtRN89mhZ2XnexdYDBW4vPWbpjNq9XaGz8I40wY64I0zEGN3OM139g1216rM2yIjbOEOHYXG7GM4D+zqPzspQoou43X5XQolXvQzQ4kJhJTzldIVM7VkSd2X8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712603486; c=relaxed/simple;
	bh=Spo2oB1nREUYhc32NbWReEjYiTmHgl+KbExmg52ZOx8=;
	h=Date:To:From:Subject:Message-Id; b=ikmCAdfDFF40j7IljMpkPOaNYmctpgrLtGFkPzIFIA6Tkp+B6iz/G0KnM7pLhhWAbvHs/FeYSYcGxNgGyIRl++kzZdiETfmIKpYllGiSX5E1EsVKZX9UVLJTS3ZSRD5ualcVX9lPxi6sRJpauitWOA0qyE8NWpX3u8r9JUJnZeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yex3F2BO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yex3F2BO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B36DC433F1;
	Mon,  8 Apr 2024 19:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712603485;
	bh=Spo2oB1nREUYhc32NbWReEjYiTmHgl+KbExmg52ZOx8=;
	h=Date:To:From:Subject:From;
	b=Yex3F2BOhF8YsNDAJrDS4IaRN+iZQzrINM9wa5Sh8pGYXwtce6PcAwcvwssxx8Kjj
	 tmwcDBdqYKE6HGsuKJoSbMkc7t7W56WrGXXXHhR8KhI7XsufnoDNytTE5QSx+zCOH9
	 SP/a3jLqnWooyHLzEotYwxQwHpp+aRjjFfumjIvA=
Date: Mon, 08 Apr 2024 12:11:25 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,klarasmodin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-3.patch added to mm-unstable branch
Message-Id: <20240408191125.9B36DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memprofiling: explicitly include irqflags.h in alloc_tag.h
has been added to the -mm mm-unstable branch.  Its filename is
     lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-3.patch

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
From: Klara Modin <klarasmodin@gmail.com>
Subject: mm/memprofiling: explicitly include irqflags.h in alloc_tag.h
Date: Sun, 7 Apr 2024 15:32:52 +0200

linux/alloc_tag.h uses the macro this_cpu_inc which eventually expands to:

 #define this_cpu_generic_to_op(pcp, val, op)				\
 do {									\
 	unsigned long __flags;						\
 	raw_local_irq_save(__flags);					\
 	raw_cpu_generic_to_op(pcp, val, op);				\
 	raw_local_irq_restore(__flags);					\
 } while (0)

The macros raw_local_irq_save and raw_local_irq_restore are defined in
linux/irqflags.h which is not included implicitly on all configs.
Therefore, include it explicitly.

Link: https://lkml.kernel.org/r/20240407133252.173636-1-klarasmodin@gmail.com
Fixes: ac906a377c67 ("lib: add allocation tagging support for memory allocation profiling")
Link: https://lore.kernel.org/lkml/6b8149f3-80e6-413c-abcb-1925ecda9d8c@gmail.com/
Signed-off-by: Klara Modin <klarasmodin@gmail.com>
Acked-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/alloc_tag.h~lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-3
+++ a/include/linux/alloc_tag.h
@@ -12,6 +12,7 @@
 #include <asm/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/static_key.h>
+#include <linux/irqflags.h>
 
 struct alloc_tag_counters {
 	u64 bytes;
_

Patches currently in -mm which might be from klarasmodin@gmail.com are

lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-3.patch

