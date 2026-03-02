Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF30349B16
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 23:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772495661; cv=none; b=Q0Rpfps8YzrLuPgS5e3aftQ/aggLP8M/MmnmgMDJ5AGbrkfFjWbb1KuaHdsrs6v7weQHaycW/ZSiHf7v+u7B5RSlG/+0gRPx8hVXgGfF/8/Nzvm2VcVMKsv9nXh6ojyuzy89o5PDhCZlvCz8xwN3SNx/AnYajK2b1Ht7nokagic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772495661; c=relaxed/simple;
	bh=ZbcapqefMz4mPZHRme7WPBcxFZeQ2pTVjnDvyMU3rF4=;
	h=Date:To:From:Subject:Message-Id; b=V/4e1xpIss0SscKYbcwpwdP4nFdIzR5aDWE/OQa3/Lslb7Uth4YDPUrccN9/OA1ToOaIzCB04GyhTL+RDqYs6y6hG5HyU11pCHpWzmZLsXPaLCUuw8+0gwxoLUFSL+xbfOn0bbZyx6NdrHtUdSyrp01CREU9QGM1I3hWZ4qN+nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2HlBKvkF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2HlBKvkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B17C19423;
	Mon,  2 Mar 2026 23:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772495660;
	bh=ZbcapqefMz4mPZHRme7WPBcxFZeQ2pTVjnDvyMU3rF4=;
	h=Date:To:From:Subject:From;
	b=2HlBKvkFUspJkedoWJ1jrDuO0qWFbvk1WfgnBL23/FxlaApV7ZzG932Qk4F8Sjw/j
	 7csE6b54wZFSkWM/HbwConSl/Tv3BQgm28YYA7XpBg/KF1ZOSfGBmnvVMhdYT2vCXS
	 04IzlMpoDwBQHc3T3oKbkinJYS+NUYj3V7t+xxIA=
Date: Mon, 02 Mar 2026 15:54:20 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + uaccess-correct-kernel-doc-parameter-format.patch added to mm-hotfixes-unstable branch
Message-Id: <20260302235420.B5B17C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: uaccess: correct kernel-doc parameter format
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     uaccess-correct-kernel-doc-parameter-format.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/uaccess-correct-kernel-doc-parameter-format.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: uaccess: correct kernel-doc parameter format
Date: Sun, 1 Mar 2026 16:52:29 -0800

Use the correct kernel-doc function parameter format to avoid kernel-doc
warnings:

Warning: include/linux/uaccess.h:814 function parameter 'uptr' not
 described in 'scoped_user_rw_access_size'
Warning: include/linux/uaccess.h:826 function parameter 'uptr' not
 described in 'scoped_user_rw_access'

Link: https://lkml.kernel.org/r/20260302005229.3471955-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uaccess.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/uaccess.h~uaccess-correct-kernel-doc-parameter-format
+++ a/include/linux/uaccess.h
@@ -806,7 +806,7 @@ for (bool done = false; !done; done = tr
 
 /**
  * scoped_user_rw_access_size - Start a scoped user read/write access with given size
- * @uptr	Pointer to the user space address to read from and write to
+ * @uptr:	Pointer to the user space address to read from and write to
  * @size:	Size of the access starting from @uptr
  * @elbl:	Error label to goto when the access region is rejected
  *
@@ -817,7 +817,7 @@ for (bool done = false; !done; done = tr
 
 /**
  * scoped_user_rw_access - Start a scoped user read/write access
- * @uptr	Pointer to the user space address to read from and write to
+ * @uptr:	Pointer to the user space address to read from and write to
  * @elbl:	Error label to goto when the access region is rejected
  *
  * The size of the access starting from @uptr is determined via sizeof(*@uptr)).
_

Patches currently in -mm which might be from rdunlap@infradead.org are

uaccess-correct-kernel-doc-parameter-format.patch

