Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27C7F4E7
	for <mm-commits@vger.kernel.org>; Mon, 16 Sep 2024 06:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726466989; cv=none; b=YZZ1SeCWP5dLUEHIWK89byyr3Oy+AgnAuKKL1FERpeQMggJVrGfw1bnGDBqugPXkDFpIQ8BE5GBhki2w1jP2J1U5e5NvVfy16T4IyyhEwsj29wfLONnVMc9FEN4jMfD7lWFaiRYJB+4yQJtfHyeM4p4W4PLzEbADGQFvRJIdsJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726466989; c=relaxed/simple;
	bh=FaDu2DHdpeFFq+akyCY7zB1HmdYRLljmCMsY25xVe2s=;
	h=Date:To:From:Subject:Message-Id; b=iOr02eAWqcuYXpwF/CQf+ckUnhZsZ7Z9SDNCZ2YSJprz9cggwf0Kr7d87uG8QKtMx+zlHqqVVtMx3UQi7eB2HXV+LPa2hPD0ARtYYGVXj1RGoZncxBgqwE0gpxGx1F5VBnOnZnX7Uss3ti+YBHGr1V2kEfINh/OjKXsXjQscGBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sruw/3Ok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sruw/3Ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F53C4CEC4;
	Mon, 16 Sep 2024 06:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726466989;
	bh=FaDu2DHdpeFFq+akyCY7zB1HmdYRLljmCMsY25xVe2s=;
	h=Date:To:From:Subject:From;
	b=sruw/3Ok2VidlgHyE8lp19zIKCwxfwRNPQShApK034KgSrlNqXcyCuHIbR0k9N2Ch
	 ANr3fZNLpDsxnFER3ZTVxEM2ZmC6GmmzD+CfrSI8rfN8Mv2TljwEE5DrNTR1Y+KBEi
	 Zzc1vcY6F32WAWzIVVPh9mVi/k61wS2b07KccYRo=
Date: Sun, 15 Sep 2024 23:09:45 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rientjes@google.com,minchan@kernel.org,Liam.Howlett@Oracle.com,keescook@chromium.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-process_madvise-drop-capability-check-if-same-mm.patch added to mm-hotfixes-unstable branch
Message-Id: <20240916060948.76F53C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: process_madvise() drop capability check if same mm
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-madvise-process_madvise-drop-capability-check-if-same-mm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-process_madvise-drop-capability-check-if-same-mm.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/madvise: process_madvise() drop capability check if same mm
Date: Fri, 13 Sep 2024 15:06:28 +0100

In commit 96cfe2c0fd23 ("mm/madvise: replace ptrace attach requirement for
process_madvise") process_madvise() was updated to require the caller to
possess the CAP_SYS_NICE capability to perform the operation, in addition
to a check against PTRACE_MODE_READ performed by mm_access().

The mm_access() function explicitly checks to see if the address space of
the process being referenced is the current one, in which case no check is
performed.

We, however, do not do this when checking the CAP_SYS_NICE capability. This
means that we insist on the caller possessing this capability in order to
perform madvise() operations on its own address space, which seems
nonsensical.

Simply add a check to allow for an invocation of this function with pidfd
set to the current process without elevation.

Link: https://lkml.kernel.org/r/20240913140628.77047-1-lorenzo.stoakes@oracle.com
Fixes: 96cfe2c0fd23 ("mm/madvise: replace ptrace attach requirement for process_madvise")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-process_madvise-drop-capability-check-if-same-mm
+++ a/mm/madvise.c
@@ -1527,7 +1527,7 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 	 * Require CAP_SYS_NICE for influencing process performance. Note that
 	 * only non-destructive hints are currently supported.
 	 */
-	if (!capable(CAP_SYS_NICE)) {
+	if (mm != current->mm && !capable(CAP_SYS_NICE)) {
 		ret = -EPERM;
 		goto release_mm;
 	}
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-madvise-process_madvise-drop-capability-check-if-same-mm.patch

