Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86375258
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752358090; cv=none; b=R9FKOSDxQegQe3SXs6N5c9o4MQpqisk4qvuwi0JfO7+guAIEbkasq9RM6a7XfcKERVUJRPhFKd0kI1egv09YQBhdwBCYlW5KPHjEYZ6jdet5cYyAjfsN0Y9ysH3FPfxaC9KNx2BD9cFUsu6a8zlg7ASjiZzTC//PthI1xhLUHMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752358090; c=relaxed/simple;
	bh=eQZZVUXbdTJboyC1vCxDzb50eRTrPBey/5iUN4OCSF4=;
	h=Date:To:From:Subject:Message-Id; b=F+SKT6urSb/r9AruuOlCMTVOtPCFjT3aN0YRWdZRS+/TdTH0YiFogQ67vQkgtMqdlLEfKnLzL9T3qNmlshIjwIqt3TgHrT/u8m2TXIhQrpJ5l5ZXLrPGhrP05OZeoefWnFyHfeqNI4sZRikRrRIL1C8fiYM6PAoY6S6hLKqOYb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1lBMG9gV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1lBMG9gV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722FDC4CEEF;
	Sat, 12 Jul 2025 22:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752358090;
	bh=eQZZVUXbdTJboyC1vCxDzb50eRTrPBey/5iUN4OCSF4=;
	h=Date:To:From:Subject:From;
	b=1lBMG9gV/k9z34Q8cqI22F2cRRzhtywNoqYBUSHBHsslrkvxHW94ZVeHjgkX9IQ+8
	 AAGmw+yKgB7MDIFioqUOrSqGKNO8JYXLjZkOJRE3Z+cTFc3w8eQI8EnMQ0wIhYtWii
	 Go4cknkQk5TZUgQmbeiU9wwINwkg/ET/eaOUfA+M=
Date: Sat, 12 Jul 2025 15:08:09 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-replace-deprecated-strcpy-with-memcpy-in-alloc_name.patch added to mm-new branch
Message-Id: <20250712220810.722FDC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd: replace deprecated strcpy() with memcpy() in alloc_name()
has been added to the -mm mm-new branch.  Its filename is
     mm-memfd-replace-deprecated-strcpy-with-memcpy-in-alloc_name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-replace-deprecated-strcpy-with-memcpy-in-alloc_name.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/memfd: replace deprecated strcpy() with memcpy() in alloc_name()
Date: Sat, 12 Jul 2025 19:45:17 +0200

strcpy() is deprecated; use memcpy() instead.

Not copying the NUL terminator is safe because strncpy_from_user() would
overwrite it anyway by appending uname to the destination buffer at index
MFD_NAME_PREFIX_LEN.

No functional changes intended.

Link: https://github.com/KSPP/linux/issues/88
Link: https://lkml.kernel.org/r/20250712174516.64243-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memfd.c~mm-memfd-replace-deprecated-strcpy-with-memcpy-in-alloc_name
+++ a/mm/memfd.c
@@ -411,7 +411,7 @@ static char *alloc_name(const char __use
 	if (!name)
 		return ERR_PTR(-ENOMEM);
 
-	strcpy(name, MFD_NAME_PREFIX);
+	memcpy(name, MFD_NAME_PREFIX, MFD_NAME_PREFIX_LEN);
 	/* returned length does not include terminating zero */
 	len = strncpy_from_user(&name[MFD_NAME_PREFIX_LEN], uname, MFD_NAME_MAX_LEN + 1);
 	if (len < 0) {
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mm-hugetlb-use-str_plural-in-report_hugepages.patch
mm-cma-use-str_plural-in-cma_declare_contiguous_multi.patch
mm-memfd-replace-deprecated-strcpy-with-memcpy-in-alloc_name.patch

