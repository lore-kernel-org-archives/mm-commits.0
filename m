Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4609348C70
	for <mm-commits@vger.kernel.org>; Thu, 20 Aug 2026 02:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787194538; cv=none; b=A1Z4eOEfqCYslIzAzIrfwXxdqZnQMrRS3Ev5rEf//7C0JoVmLCbNkp10s66eqqs49xaPUuJd0kkZbmYIq5ICPaK9+RUORTBf/+UalvwBBPMbXAsjg8BC82fYQ6+l1+VwY8kIDl4WzlI8K251kBibcDTKRvHIOl5gaB0tjDjdbt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787194538; c=relaxed/simple;
	bh=lcVXOO+3auEL9dttxCeSyPwo2psb/b9126y5eou0yBk=;
	h=Date:To:From:Subject:Message-Id; b=irfzNjLxO2dNrFzOJWjYwU4mP8JSCB4p3AWkJpvVgu4lATp0l5ar8HrubjpE6InL1bURkW2g2v8PfYJ0k+sUNksL+CNpDy01fZd3VVdCwEcdctDtkOJibhhGJ/2fuzhE6dWScaUxFLfyunDAuIGuhQ++m754Si8VGgC1c+p9Lws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tg4ynbbz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tg4ynbbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552B61F000E9;
	Thu, 20 Aug 2026 02:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787194536;
	bh=uL2l+GMxcMRneo3pu2LRXpfI81kfR4/6+/zix1/kS+s=;
	h=Date:To:From:Subject;
	b=Tg4ynbbzrp/cz3uALc3WifBxapvENrfMHk9FkIkrKJ82DnUfNv+R/pq2+Cs3dgDoE
	 WtUnh14OwUpfLD2bUhyMpZVzzlaO+8goSGWdyGXzhvJeFo3IFJZt2CauU4tCKEVshs
	 f9h4GM44HR1yQV6dp1qnAzE2xdOwelhga8yPwTyc=
Date: Wed, 19 Aug 2026 19:55:35 -0700
To: mm-commits@vger.kernel.org,gorcunov@openvz.org,adobriyan@gmail.com,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] prctl-fix-pr_set_mm_auxv-losing-the-forced-at_null-terminator.patch removed from -mm tree
Message-Id: <20260820025536.552B61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: prctl: fix PR_SET_MM_AUXV losing the forced AT_NULL terminator
has been removed from the -mm tree.  Its filename was
     prctl-fix-pr_set_mm_auxv-losing-the-forced-at_null-terminator.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bradley Morgan <include@grrlz.net>
Subject: prctl: fix PR_SET_MM_AUXV losing the forced AT_NULL terminator
Date: Sun, 9 Aug 2026 00:29:01 +0000

prctl_set_auxv() copies the user vector into a stack buffer, forces
AT_NULL on the last two entries there, and then copies only len bytes into
mm->saved_auxv.  Which is fine until the vector is shorter than the
buffer, because then the forced terminator sits past the end of the copy
and never lands in saved_auxv at all.

The code even says

	/* Make sure the last entry is always AT_NULL */

and it does, just not in the part that gets copied.

So mm->saved_auxv keeps the stale tail from exec.  Reproducing it is easy:
from a process with CAP_SYS_RESOURCE (just run it as root), call
prctl(PR_SET_MM, PR_SET_MM_AUXV, ...) with a vector that has a couple of
entries and no AT_NULL inside len (32 bytes on arm64), and then hexdump
/proc/self/auxv, or gcore the process and look at the AUXV note with
readelf -n.  This is arm64, the new vector was just { AT_UID, 0x1111,
AT_GID, 0x2222 }:

    idx  before (from exec)               after the prctl
    [0]  AT_SYSINFO_EHDR   0x7ed1d6e000   AT_UID    0x1111    <- new
    [1]  AT_MINSIGSTKSZ    0x1270         AT_GID    0x2222    <- new
    [2]  AT_HWCAP          0x119fff       AT_HWCAP  0x119fff  <- stale
    [3]  AT_PAGESZ         0x1000         AT_PAGESZ 0x1000    <- stale
    ...  16 more entries                  ...                 <- stale
    [20] AT_NULL           0x0            AT_NULL   0x0

21 entries before the prctl, still 21 after: the two new ones plus all 19
left over from exec.

Every consumer walks the vector until AT_NULL, so what they get now is a
vector that never existed at exec, the head from the prctl glued onto the
tail of the old binary.  gdb and crash pull the AUXV note out of coredumps
to find AT_PHDR, AT_ENTRY, AT_SYSINFO_EHDR and friends, and a mixed vector
points them at the wrong layout.  /proc/<pid>/auxv and PR_GET_AUXV hand
the same mess out to live processes too.  Nothing crashes, everything just
quietly reads a frankenstein auxv.

And callers that terminate their own vector hide the whole thing, which is
likely why nobody noticed since PR_SET_MM_AUXV landed in 2012.  Nothing
exciting security wise either, I mean it needs CAP_SYS_RESOURCE to begin
with.

prctl_set_mm_map() right above already copies the whole buffer for exactly
this reason, so just do the same here.  user_auxv is zero initialized and
only partially filled from userspace, so the rest is zeros and nothing
leaks.

Link: https://lore.kernel.org/20260809002901.32591-1-include@grrlz.net
Fixes: fe8c7f5cbf91 ("c/r: prctl: extend PR_SET_MM to set up more mm_struct entries")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Cyrill Gorcuno <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sys.c~prctl-fix-pr_set_mm_auxv-losing-the-forced-at_null-terminator
+++ a/kernel/sys.c
@@ -2189,7 +2189,7 @@ static int prctl_set_auxv(struct mm_stru
 	BUILD_BUG_ON(sizeof(user_auxv) != sizeof(mm->saved_auxv));
 
 	task_lock(current);
-	memcpy(mm->saved_auxv, user_auxv, len);
+	memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
 	task_unlock(current);
 
 	return 0;
_

Patches currently in -mm which might be from include@grrlz.net are

taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch

