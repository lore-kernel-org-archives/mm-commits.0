Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932BD2B9A8
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 04:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734062644; cv=none; b=sJNOuqAUta9oKuaAu2i67WEyS9pu6yR/QiiVZyPbH4gy/9NyOJ/2x5kPU9xaaW23t04OnhQYZuRZqExbo/zlPWeRdC3t9ljp92oY1dKFblQmYdZjRREidCPDYv8xn9rFNs6lM4CUklPbZSY8CGHesf6a6sneakP5RrlH8cX+I9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734062644; c=relaxed/simple;
	bh=fLKv7oUsyirLp2hRdEoOJ98D2jXdIiNt7RXJKoyya08=;
	h=Date:To:From:Subject:Message-Id; b=Tt3F0UdjlaS/8rpYMtFgUYPzIOYq4efFa2xTgLzWTF6n2wiRdatgo8+EmqSYdwO6e5CTtGPdUzU4tfez4d4fTkMMsMk9VCfLoWaEL746f/J0gW2rY5rZLy1m5cwxj4GbluLq5ggRKVHTZrpAViRyUj6aZ7h2KmjB7Xup4lCyTZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q997+I38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q997+I38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3EBC4CED2;
	Fri, 13 Dec 2024 04:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734062644;
	bh=fLKv7oUsyirLp2hRdEoOJ98D2jXdIiNt7RXJKoyya08=;
	h=Date:To:From:Subject:From;
	b=q997+I38tdOOkdaGMJ8VTTVByArJ8nXZXxaVlmdroJgINXL5AzNVHuRTVKBNYeoDF
	 k+NenkZUVG9e1bcN1VL/AscmKTRpvnG/dzIrQGpw/hkFdd7TW91tT94C/payOT9289
	 FdcxnUXitbnCjR+Xzukq2GvPFuPnvMQ/V0R968tc=
Date: Thu, 12 Dec 2024 20:04:03 -0800
To: mm-commits@vger.kernel.org,alexjlzheng@tencent.com,alexjlzheng@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault.patch added to mm-unstable branch
Message-Id: <20241213040404.5D3EBC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix outdated incorrect code comments for handle_mm_fault()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault.patch

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
From: Jinliang Zheng <alexjlzheng@gmail.com>
Subject: mm: fix outdated incorrect code comments for handle_mm_fault()
Date: Fri, 13 Dec 2024 11:18:20 +0800

Link: https://lkml.kernel.org/r/20241213031820.778342-1-alexjlzheng@tencent.com
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault
+++ a/mm/memory.c
@@ -6140,7 +6140,8 @@ static vm_fault_t sanitize_fault_flags(s
 }
 
 /*
- * By the time we get here, we already hold the mm semaphore
+ * By the time we get here, we already hold either the VMA lock or the
+ * mmap_Lock (FAULT_FLAG_VMA_LOCK tells you which).
  *
  * The mmap_lock may have been released depending on flags and our
  * return value.  See filemap_fault() and __folio_lock_or_retry().
_

Patches currently in -mm which might be from alexjlzheng@gmail.com are

mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault.patch

