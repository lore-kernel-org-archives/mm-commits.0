Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2642C33F7
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 05:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736660100; cv=none; b=V0v3JClw8EZLCh4o9SR3N+EgnisYfdQDvtCqf+u1Tk94dMD7td/t4bUOxLFOrSDQ2Ty4dbsAsLjaEhggNPV26ljDAdtaXrKtY99eIx+gTlg/dtRyUtHxIEEG/tKcJNy+Q6KfnvtGMi7UlT5W4slgy16gWi8YR/wmg3GZSee3OJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736660100; c=relaxed/simple;
	bh=wyR1nBfXt7X3gkAxYtE37kP+uR8oEExnCMOMawVbc38=;
	h=Date:To:From:Subject:Message-Id; b=RtFSUOw9WfF9n4bFe7N69R8rFG6g+hQF7K3hD+rax/oZHivgCuivneO7EdkLNvF3swJ050esb1kfSWWx1Pm8HmRocxkSU3w4Owho1gfpx3tPvsmSZgkiPZuFd30BiMCJsM3G3e1Wx1TNLqE+JvvLr51vpwehshhClB4pwoQqvaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WQdkw8Vg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WQdkw8Vg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC377C4CEE0;
	Sun, 12 Jan 2025 05:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736660100;
	bh=wyR1nBfXt7X3gkAxYtE37kP+uR8oEExnCMOMawVbc38=;
	h=Date:To:From:Subject:From;
	b=WQdkw8Vg62uqgnvpL5FybLvQMpjTS+hxDS1rJSYc6qaMDWW6CCPH61XdxaqYUxveI
	 q8v4mXLCZ8HqOxutCiUBVYCTDGUep40F5yNDNOfmkTlXZwxbINc/2r5+Pnrnu35LCW
	 uA2pdZb7CXTOtHD3K/zUNamkacYuavBy0Z7frKjQ=
Date: Sat, 11 Jan 2025 21:34:59 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-utilc-complete-the-kernel-doc-function-descriptions.patch added to mm-nonmm-unstable branch
Message-Id: <20250112053459.EC377C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ipc/util.c: complete the kernel-doc function descriptions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-utilc-complete-the-kernel-doc-function-descriptions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-utilc-complete-the-kernel-doc-function-descriptions.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: ipc/util.c: complete the kernel-doc function descriptions
Date: Fri, 10 Jan 2025 22:29:05 -0800

Move the function descriptive comments so that they conform to
kernel-doc format, eliminating the kernel-doc warnings.

util.c:618: warning: missing initial short description on line:
 * ipc_obtain_object_idr
util.c:640: warning: missing initial short description on line:
 * ipc_obtain_object_check

Link: https://lkml.kernel.org/r/20250111062905.910576-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/ipc/util.c~ipc-utilc-complete-the-kernel-doc-function-descriptions
+++ a/ipc/util.c
@@ -615,12 +615,11 @@ void ipc64_perm_to_ipc_perm(struct ipc64
 }
 
 /**
- * ipc_obtain_object_idr
+ * ipc_obtain_object_idr - Look for an id in the ipc ids idr and
+ *   return associated ipc object.
  * @ids: ipc identifier set
  * @id: ipc id to look for
  *
- * Look for an id in the ipc ids idr and return associated ipc object.
- *
  * Call inside the RCU critical section.
  * The ipc object is *not* locked on exit.
  */
@@ -637,13 +636,11 @@ struct kern_ipc_perm *ipc_obtain_object_
 }
 
 /**
- * ipc_obtain_object_check
+ * ipc_obtain_object_check - Similar to ipc_obtain_object_idr() but
+ *   also checks the ipc object sequence number.
  * @ids: ipc identifier set
  * @id: ipc id to look for
  *
- * Similar to ipc_obtain_object_idr() but also checks the ipc object
- * sequence number.
- *
  * Call inside the RCU critical section.
  * The ipc object is *not* locked on exit.
  */
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-zsmalloc-fix-function-parameter-kernel-doc-notation.patch
kasan-use-correct-kernel-doc-format.patch
latencytop-use-correct-kernel-doc-format-for-func-params.patch
kthread-modify-kernel-doc-function-name-to-match-code.patch
gcov-clang-use-correct-function-param-names.patch
ipc-utilc-complete-the-kernel-doc-function-descriptions.patch

