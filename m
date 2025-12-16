Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9261D61BC
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 03:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765854288; cv=none; b=NxuPtIEqJwKloZL+yUlWbP/6bbV4kyTn5Go6RBICfNTFdsMOrq/myNy3Zq8zhliOTNRIE93BtnUIPIlmsevv7yoeOAVOm39Nn+7HR2ZjLcQDefYNxjEqktUjDUM4BNK3PtHHIf9HwsdeIdGnokRd6ccyUtv1EY5vjqwTQcJLRLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765854288; c=relaxed/simple;
	bh=OtRr7QwP7gzbilvVmKtlL3zW90Y7eAO1D9KGpqkxxq4=;
	h=Date:To:From:Subject:Message-Id; b=QHKewBrCcRJHau3OfEgxt4FhltL1ITgYG8rUv0mDGzeriDqtN6d7LMu65G81fxJLPgMomPzZvorfuXlJEdu6OMen0W3XdiQXxRmkUB6wv/TPaEEHeyUSRNO07AJzDFQbWmTyq1srWP51ybPAOWxBW4AvG1FrWO5eDTm5Zjh/hTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B1YNCt0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B1YNCt0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F34C4CEF5;
	Tue, 16 Dec 2025 03:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765854288;
	bh=OtRr7QwP7gzbilvVmKtlL3zW90Y7eAO1D9KGpqkxxq4=;
	h=Date:To:From:Subject:From;
	b=B1YNCt0oZgTBhMjxPkhRTCybEVGLu5oOobgps/Jnu2o4mP481aQi2uzXul3fo7k0j
	 L2pbOFBilwOjgCDouHXUNGUZI83+hzk40H37JHlL0WuoG+oudSSJulfASL0IRuNYO6
	 E3M/GnKqgs73RwiNlnJMdUJGWy9gCkv0X9PGWCDk=
Date: Mon, 15 Dec 2025 19:04:47 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,torvalds@linux-foundation.org,mhocko@suse.com,macro@orcam.me.uk,linux@rasmusvillemoes.dk,kees@kernel.org,jannh@google.com,glider@google.com,elver@google.com,dvyukov@google.com,chris.bazley.wg14@gmail.com,alx@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-benign-off-by-one-bugs.patch added to mm-nonmm-unstable branch
Message-Id: <20251216030448.13F34C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix benign off-by-one bugs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-fix-benign-off-by-one-bugs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-benign-off-by-one-bugs.patch

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
From: Alejandro Colomar <alx@kernel.org>
Subject: mm: fix benign off-by-one bugs
Date: Thu, 11 Dec 2025 11:43:54 +0100

We were wasting a byte due to an off-by-one bug.  s[c]nprintf() doesn't
write more than $2 bytes including the null byte, so trying to pass
'size-1' there is wasting one byte.

Link: https://lkml.kernel.org/r/9c38dd009c17b0219889c7089d9bdde5aaf28a8e.1765449750.git.alx@kernel.org
Signed-off-by: Alejandro Colomar <alx@kernel.org>
Acked-by: Marco Elver <elver@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Christopher Bazley <chris.bazley.wg14@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/kfence_test.c |    4 ++--
 mm/kmsan/kmsan_test.c   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kfence/kfence_test.c~mm-fix-benign-off-by-one-bugs
+++ a/mm/kfence/kfence_test.c
@@ -110,7 +110,7 @@ static bool report_matches(const struct
 
 	/* Title */
 	cur = expect[0];
-	end = &expect[0][sizeof(expect[0]) - 1];
+	end = ARRAY_END(expect[0]);
 	switch (r->type) {
 	case KFENCE_ERROR_OOB:
 		cur += scnprintf(cur, end - cur, "BUG: KFENCE: out-of-bounds %s",
@@ -140,7 +140,7 @@ static bool report_matches(const struct
 
 	/* Access information */
 	cur = expect[1];
-	end = &expect[1][sizeof(expect[1]) - 1];
+	end = ARRAY_END(expect[1]);
 
 	switch (r->type) {
 	case KFENCE_ERROR_OOB:
--- a/mm/kmsan/kmsan_test.c~mm-fix-benign-off-by-one-bugs
+++ a/mm/kmsan/kmsan_test.c
@@ -105,7 +105,7 @@ static bool report_matches(const struct
 
 	/* Title */
 	cur = expected_header;
-	end = &expected_header[sizeof(expected_header) - 1];
+	end = ARRAY_END(expected_header);
 
 	cur += scnprintf(cur, end - cur, "BUG: KMSAN: %s", r->error_type);
 
_

Patches currently in -mm which might be from alx@kernel.org are

array_sizeh-add-array_end.patch
mm-fix-benign-off-by-one-bugs.patch
kernel-fix-off-by-one-benign-bugs.patch
mm-use-array_end-instead-of-open-coding-it.patch

