Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B25937CD4F
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 22:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779143107; cv=none; b=JdziEUNYbdu182+e34uiIQbRyVhkSAHDGjVWFFYzXqORiYc3wQ9i6MLAnr7kdPH2fbhQCXlZ9DbTiBuI2XkJpEFR/D+33g/9ss63u09EosdJL67B8p7dsLZbar/CCUAMGhr51N8FOyzBCJKQpQGrrwih4hn2duu2fDFAXjeh+4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779143107; c=relaxed/simple;
	bh=hhVe8dOlNyGKN4h06AMz/tEHsJJPbn2u8ATWeeaEoyg=;
	h=Date:To:From:Subject:Message-Id; b=dc7Lw4U0OgPAqU5Wg+LFLt9ymUE9a/Af1U+GMEPKQWmsFGGamL8lFDUhbpm06NCKIrb8Jj62YDq7ayif55+wqzu+ld4Y90aMLBcjJgW87gk5b1TjiKjAxszHlvt1aovOMR603QBLYKUVbkR9rwgZAwaZpCbVRMDXdEK8LkJRPsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B94klI4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B94klI4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12265C2BCB7;
	Mon, 18 May 2026 22:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779143107;
	bh=hhVe8dOlNyGKN4h06AMz/tEHsJJPbn2u8ATWeeaEoyg=;
	h=Date:To:From:Subject:From;
	b=B94klI4ehPGjsT1f6qiTTNRmzr1jj1F+BAl8gHas6dyXUH8RPCAkCPdJIrcyUE2IE
	 pVf1MZp4SatGWELsDfFSWvx7gD/qqaqp/RhJKI/iblPtSWdp2GDPdXwWNuNg2A7u7A
	 +VY6whzDdWxWcUOVh/tpq+yfjUvtQ2lo8SSOACto=
Date: Mon, 18 May 2026 15:25:06 -0700
To: mm-commits@vger.kernel.org,ssh1326@icloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-fix-typo-in-process_addrsrst.patch added to mm-new branch
Message-Id: <20260518222507.12265C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/mm: fix typo in process_addrs.rst
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-fix-typo-in-process_addrsrst.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-fix-typo-in-process_addrsrst.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Sakurai Shun <ssh1326@icloud.com>
Subject: docs/mm: fix typo in process_addrs.rst
Date: Sun, 17 May 2026 19:36:35 +0900

Replace "presense" with "presence"

Link: https://lore.kernel.org/20260517103640.45444-1-ssh1326@icloud.com
Signed-off-by: Sakurai Shun <ssh1326@icloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/process_addrs.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/process_addrs.rst~docs-mm-fix-typo-in-process_addrsrst
+++ a/Documentation/mm/process_addrs.rst
@@ -775,7 +775,7 @@ lock, releasing or downgrading the mmap
 lock so there is no :c:func:`!vma_end_write` function.
 
 Note that when write-locking a VMA lock, the :c:member:`!vma.vm_refcnt` is temporarily
-modified so that readers can detect the presense of a writer. The reference counter is
+modified so that readers can detect the presence of a writer. The reference counter is
 restored once the vma sequence number used for serialisation is updated.
 
 This ensures the semantics we require - VMA write locks provide exclusive write
_

Patches currently in -mm which might be from ssh1326@icloud.com are

docs-mm-fix-typo-in-process_addrsrst.patch

