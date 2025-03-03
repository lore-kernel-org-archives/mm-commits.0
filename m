Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0867820E313
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 22:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741040677; cv=none; b=SQu01bUsXk5qXDJYlvlF0wb59RXeM4YVolR6jnJX+cCV3YbOe/gXN8pIR0ckL6sDxXHmGFETCJb4uIoEjiHrB1uRN5z+1vkgRusJNTadGo55j/r45wZYe87QJPc/vtTYfsq33d2EZnBuhjOgbWJNwNYOEH3Nw7Bw4UwTVolvA7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741040677; c=relaxed/simple;
	bh=jyVOvt38InYN6AfiWAiMGFNkFJw/uqUaihRFtso959Y=;
	h=Date:To:From:Subject:Message-Id; b=JVgikW9o9cZRxY8N1cyynPLIvJMn98kw3bpfFR0hkEg5coKL2i8k8Np6CS9sEXLtBvPM6qAyydlqWE/KNUzoLEwNXaaBpBXGbVoOsZYDRcSgZ88zW5fx35QmxzGIDYS/oaGZrOOWnd5Uuqc8W5i8YpeL58ogSTCBki8KM0iALqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tXcI77xz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tXcI77xz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1E8C4CED6;
	Mon,  3 Mar 2025 22:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741040676;
	bh=jyVOvt38InYN6AfiWAiMGFNkFJw/uqUaihRFtso959Y=;
	h=Date:To:From:Subject:From;
	b=tXcI77xz4COW4A686HmDACBf50dQRuCpxA8e5MoRipVi4S3jc+PhgWFJOVyFkbjOm
	 s4/NnT8hJVuiAi+jhTKMdvrMEteeBP1wDNYsOsFQ5YM33hPKqaiygG5O++dlbf4/OG
	 1WK9k3XYRd1RZDbypyKyo+LugsnyNBJeRP+A0y4Q=
Date: Mon, 03 Mar 2025 14:24:35 -0800
To: mm-commits@vger.kernel.org,oleg@redhat.com,mjguzik@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250303222436.5F1E8C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix
Date: Mon Mar  3 02:22:48 PM PST 2025

add unlikely() as well

Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/signal.c~signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix
+++ a/kernel/signal.c
@@ -177,7 +177,7 @@ static bool recalc_sigpending_tsk(struct
 void recalc_sigpending(void)
 {
 	if (!recalc_sigpending_tsk(current) && !freezing(current)) {
-		if (test_thread_flag(TIF_SIGPENDING))
+		if (unlikely(test_thread_flag(TIF_SIGPENDING)))
 			clear_thread_flag(TIF_SIGPENDING);
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch

