Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF27C15665C
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 23:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779405339; cv=none; b=d5VHRoqbqpjR/5qA3BdtzzrSdErzmZksLgwHwdjQ1dpX+28Jm6NZfD+MmG4hw5R0XrbipXX/Nbg0a5LqSFPspZLujZAXnFMQ3GoK/gJAUe2eVkO5FCTmV/smRMrqTg+LluafV6NUAeGrQtSTERdBrwENrrWy9KQpPw75PKtAhr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779405339; c=relaxed/simple;
	bh=iryREmpMtBdCHCpEM60g+osdEPeKJasT2lGJ0wccMVY=;
	h=Date:To:From:Subject:Message-Id; b=NWajaUL+KgUekXqdVng8XUCwIcDkQ6T97iuOB/aNxeiQlDjzhnGRpDim2yUrozqgOJ+gymAq4fzDDgJWt79N5dh88W7rHqsH+i2IuGFpXYic6WcEUGmUaRlu3QasKyLt0dr0U4RSKNR2nAkPvNLBCd4ztrlO9/43UtzYDuD+d2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bTXZjuyS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bTXZjuyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F58D1F000E9;
	Thu, 21 May 2026 23:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779405338;
	bh=GsqFM5NAFJRUig18DUkJa6NfsNyTp/n+14Vmx2XAuhI=;
	h=Date:To:From:Subject;
	b=bTXZjuySXZo02JH3Z8CkNNoNYD9jrRSf8yLcPNxVGSIVX68ULJmEO+nIYoZ4m9CPZ
	 MVi31undQ0RFFG5xdX72QiSqx3UcMqHjO+317Zh4JOqRfatmtbw0wIc3Ee3dowBMSz
	 EY/8f3NwRMoxpQA+SPUuX//CEMtVNRdf/+hgez8g=
Date: Thu, 21 May 2026 16:15:38 -0700
To: mm-commits@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260521231538.6F58D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix-fix
Date: Wed, 20 May 2026 20:21:29 +0200

move and reword sentence on simultaneous normal/remote collection

Link: https://lore.kernel.org/20260520-kcov-docs-v2-1-819f78778763@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Suggested-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kcov.rst |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/dev-tools/kcov.rst~kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix-fix
+++ a/Documentation/dev-tools/kcov.rst
@@ -237,6 +237,9 @@ Both ``kcov_remote_start`` and ``kcov_re
 collection sections. The way a handle is used depends on the context where the
 matching code section executes.
 
+A thread can use two separate KCOV instances to collect remote coverage and
+normal coverage at the same time.
+
 KCOV supports collecting remote coverage from the following contexts:
 
 1. Global kernel background tasks. These are the tasks that are spawned during
@@ -246,8 +249,6 @@ KCOV supports collecting remote coverage
 2. Local kernel background tasks. These are spawned when a userspace process
    interacts with some kernel interface and are usually killed when the process
    exits (e.g. vhost workers).
-   This can be combined with another KCOV instance that is configured for normal
-   coverage collection.
 
 3. Soft interrupts.
 
_

Patches currently in -mm which might be from jannh@google.com are

kcov-refactor-common-handle-id-into-kcov_common_handle_id.patch
kcov-allow-simultaneous-kcov_enable-kcov_remote_enable.patch
kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-v2.patch
kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix.patch
kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix-fix.patch

