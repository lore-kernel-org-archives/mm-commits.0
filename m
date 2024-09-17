Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFE717C9
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 07:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726559935; cv=none; b=oGcBymwjeLa3tes75rJHUhei+IRoAO9Jbzqe8lEF89boz3MnW20KJo71ivjPwv24aD/SGePjlrz+lzF6KTrn3vwZpcwpPN8EwOugSy/A5PUNqgJY6YSQlcLpXdI+6qzp+4TLP7z/xBpsCP1miOEY+/t24Mnh33ojrWSdiO4D2p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726559935; c=relaxed/simple;
	bh=RS0ItbKJ6x0n/BCgcVoQQAqXOsB3J09xoGXcjXyOvJE=;
	h=Date:To:From:Subject:Message-Id; b=M43+Ln8y7o1KIXLW5zHjbliQtIksz0YTiivU0rNksRQD6cg6KV5tu2Rc3d+MTDLd98pyMuit9TUZxr/Kftwp+tPHZnP7XlbS208r8YUB9sQBcaPAatGPjYb0VwrdY3PGspMncG3kWPAc0WiqQrI3fVyxmxyXE49uWt2Y7w3SiR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BQVOZppf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BQVOZppf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45069C4CEC6;
	Tue, 17 Sep 2024 07:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726559934;
	bh=RS0ItbKJ6x0n/BCgcVoQQAqXOsB3J09xoGXcjXyOvJE=;
	h=Date:To:From:Subject:From;
	b=BQVOZppfgsfrnuM0EzlxRgbh/zr2v6fFrKVYMOjwlRxE0N/GtqhltC5RBxvarRCsh
	 1hKraNmBiAZhOVF0ZHPfJ0cyJs4tFYfSso9kq4tkR13vIUH69YgaNmuOvdGBJn3VGZ
	 tXkp6eiO/9nkjpvqGc255f6MfKUexDLXuZSCBUD8=
Date: Tue, 17 Sep 2024 00:58:51 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rientjes@google.com,minchan@kernel.org,Liam.Howlett@Oracle.com,keescook@chromium.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-madvise-process_madvise-drop-capability-check-if-same-mm.patch removed from -mm tree
Message-Id: <20240917075854.45069C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: process_madvise() drop capability check if same mm
has been removed from the -mm tree.  Its filename was
     mm-madvise-process_madvise-drop-capability-check-if-same-mm.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


