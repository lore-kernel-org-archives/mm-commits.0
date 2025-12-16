Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2469D2367AC
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 03:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765854291; cv=none; b=ACI0xIlK3zMjbkHAyFMePPTS22qY16lE8WWGjxblxR8sEOiBW4tTMjD3QKuJAMREzHP2zmx/cXkTk9V3MpmX3pSWOydvhVnnxpLVfCGf439A7IAacGbmFz2BheL17+uuvpoMMeXCB4QcZn1srMukoBrQFC/+xo3IVMFMT0vk4rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765854291; c=relaxed/simple;
	bh=DA2MGuwYfVElIkUHSYQtJAe2A0YnM+eaIC+UmiW3t8s=;
	h=Date:To:From:Subject:Message-Id; b=MrUdR0/MyNsAdRdiiiEdv9IAo1/ctEkIWkV7m12jh2GtG8R6Ei42/XXiAzn/fOKHKThAp6ATUYVl4OxMXOeixk2B1VXtDCuDZkF1FVW3J/yxFSqPETYfTvKfMDkBcIf0V5UHu+j7jCytOrtgHJ/+oBJmJpmk20HIbwutA8s8PII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=udx0pTaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="udx0pTaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB12C4CEF5;
	Tue, 16 Dec 2025 03:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765854290;
	bh=DA2MGuwYfVElIkUHSYQtJAe2A0YnM+eaIC+UmiW3t8s=;
	h=Date:To:From:Subject:From;
	b=udx0pTaYtEWNh1k7quWwnq3yArKESpOsn8/2hKFl9IhdNZ3U85H+nDhfxJkrUfVHF
	 ITzhV3ZCz0ab+UYakyAslzcv09Sw84YAUXCbfi0hDvHTQcGozU1co4h7L9wgY6iCqG
	 rtwkTz1JaxyzH8tZITZfXteWqDqoGSI80IX6CklE=
Date: Mon, 15 Dec 2025 19:04:50 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,torvalds@linux-foundation.org,mhocko@suse.com,macro@orcam.me.uk,linux@rasmusvillemoes.dk,kees@kernel.org,jannh@google.com,glider@google.com,elver@google.com,dvyukov@google.com,chris.bazley.wg14@gmail.com,alx@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-fix-off-by-one-benign-bugs.patch added to mm-nonmm-unstable branch
Message-Id: <20251216030450.9EB12C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel: fix off-by-one benign bugs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-fix-off-by-one-benign-bugs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-fix-off-by-one-benign-bugs.patch

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
Subject: kernel: fix off-by-one benign bugs
Date: Thu, 11 Dec 2025 11:44:00 +0100

We were wasting a byte due to an off-by-one bug.  s[c]nprintf() doesn't
write more than $2 bytes including the null byte, so trying to pass
'size-1' there is wasting one byte.

This is essentially the same as the previous commit, in a different
file.

Link: https://lkml.kernel.org/r/b4a945a4d40b7104364244f616eb9fb9f1fa691f.1765449750.git.alx@kernel.org
Signed-off-by: Alejandro Colomar <alx@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Christopher Bazley <chris.bazley.wg14@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcsan/kcsan_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kcsan/kcsan_test.c~kernel-fix-off-by-one-benign-bugs
+++ a/kernel/kcsan/kcsan_test.c
@@ -176,7 +176,7 @@ static bool __report_matches(const struc
 
 	/* Title */
 	cur = expect[0];
-	end = &expect[0][sizeof(expect[0]) - 1];
+	end = ARRAY_END(expect[0]);
 	cur += scnprintf(cur, end - cur, "BUG: KCSAN: %s in ",
 			 is_assert ? "assert: race" : "data-race");
 	if (r->access[1].fn) {
@@ -200,7 +200,7 @@ static bool __report_matches(const struc
 
 	/* Access 1 */
 	cur = expect[1];
-	end = &expect[1][sizeof(expect[1]) - 1];
+	end = ARRAY_END(expect[1]);
 	if (!r->access[1].fn)
 		cur += scnprintf(cur, end - cur, "race at unknown origin, with ");
 
_

Patches currently in -mm which might be from alx@kernel.org are

array_sizeh-add-array_end.patch
mm-fix-benign-off-by-one-bugs.patch
kernel-fix-off-by-one-benign-bugs.patch
mm-use-array_end-instead-of-open-coding-it.patch

