Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B39AB657;
	Fri, 26 Apr 2024 18:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714157537; cv=none; b=fou35finx42G7zXt1j8zlg5yDDRV2Re+O10AmQzL7acy/h/X+qevIO1eLeXMjDjAMeH6SwPdU5E9uj3xoxKJn3gDrrUwHMHBkyyxzM3myIEGWcOc6ju2LzYs/4D9YGsI6yiXGWWzVxWpayasXh2zfq9xHV5/DCcqTEf4vR0pzyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714157537; c=relaxed/simple;
	bh=vDw4KaQtTb6UzLo/WW5goxFjbqkEyLTriCieESp7lUk=;
	h=Date:To:From:Subject:Message-Id; b=B9S6D7PWewKCexKbDcff4DaVOcsG4pZ0BwD15ge1yEX7r/5Z7LGAIfLZRRDlXCa8FFaLEbB+VWMzJrEd6GV15y5BDMCWmZuZ7ZJ3EpAdopX/42duGHgTXLs7lkfb39itOpZlvzeqo/KzfMDDSrM+yD3EZ1nJHtTh8sI9ii7SN64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tu8DbgiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tu8DbgiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE84C113CD;
	Fri, 26 Apr 2024 18:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714157537;
	bh=vDw4KaQtTb6UzLo/WW5goxFjbqkEyLTriCieESp7lUk=;
	h=Date:To:From:Subject:From;
	b=Tu8DbgiX72vKvfCGSh02uq2L5UWgDsym7wLOcXm7/58PY3GwRZ0IIswaGOEzmgERI
	 g7zC7NqdDtZALiTOoKwMo0QSDzLsL2yiJnPShlL7KX+RDCc/6Ps5AhOpvSg0626A4y
	 5UDal8jgEnurvzBHWJdgSjcMxLf2BOLbOyrWcgV8=
Date: Fri, 26 Apr 2024 11:52:16 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ojeda@kernel.org,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-compiler_types-declare-__no_sanitize_or_inline.patch added to mm-hotfixes-unstable branch
Message-Id: <20240426185217.2BE84C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmsan: compiler_types: declare __no_sanitize_or_inline
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kmsan-compiler_types-declare-__no_sanitize_or_inline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-compiler_types-declare-__no_sanitize_or_inline.patch

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
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: compiler_types: declare __no_sanitize_or_inline
Date: Fri, 26 Apr 2024 11:16:22 +0200

It turned out that KMSAN instruments READ_ONCE_NOCHECK(), resulting in
false positive reports, because __no_sanitize_or_inline enforced inlining.

Properly declare __no_sanitize_or_inline under __SANITIZE_MEMORY__, so
that it does not __always_inline the annotated function.

Link: https://lkml.kernel.org/r/20240426091622.3846771-1-glider@google.com
Fixes: 5de0ce85f5a4 ("kmsan: mark noinstr as __no_sanitize_memory")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: syzbot+355c5bb8c1445c871ee8@syzkaller.appspotmail.com
Link: https://lkml.kernel.org/r/000000000000826ac1061675b0e3@google.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler_types.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/compiler_types.h~kmsan-compiler_types-declare-__no_sanitize_or_inline
+++ a/include/linux/compiler_types.h
@@ -278,6 +278,17 @@ struct ftrace_likely_data {
 # define __no_kcsan
 #endif
 
+#ifdef __SANITIZE_MEMORY__
+/*
+ * Similarly to KASAN and KCSAN, KMSAN loses function attributes of inlined
+ * functions, therefore disabling KMSAN checks also requires disabling inlining.
+ *
+ * __no_sanitize_or_inline effectively prevents KMSAN from reporting errors
+ * within the function and marks all its outputs as initialized.
+ */
+# define __no_sanitize_or_inline __no_kmsan_checks notrace __maybe_unused
+#endif
+
 #ifndef __no_sanitize_or_inline
 #define __no_sanitize_or_inline __always_inline
 #endif
_

Patches currently in -mm which might be from glider@google.com are

kmsan-compiler_types-declare-__no_sanitize_or_inline.patch

