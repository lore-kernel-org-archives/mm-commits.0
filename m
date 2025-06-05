Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A20F207A3A
	for <mm-commits@vger.kernel.org>; Thu,  5 Jun 2025 21:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749159905; cv=none; b=oJWxR6eecUR3TRYP1qTB033VY9Rmhc4b43cuIk1BIavrng9wueK0dUY0lS8a4V7IyWEduqSjhPR27iJGzzuO9YIgw6EpWcZX7g/7g6gi2pyP05scraPbxL28DH6OGYsykWUZOY0pBBVHeRjOdQwXoIyLnthjFt9r3JViMSd1pvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749159905; c=relaxed/simple;
	bh=/378/CyLklIBSTEz6wavEkJ73iTGPBfEFP9BPYYAUUg=;
	h=Date:To:From:Subject:Message-Id; b=BzJ43Z6t+odPD/X46VN53z+OBmb7KjyUKcG96mBrq2t9L5p6x1NPAA6vNrrq4EIBH3zBpq66t0k7VhGRJvxixzwMrhIjiIDLBdsdLwvTUi4q+/rNUHJcXaWrf8KuwEc8vNw7O2n1WkyUdjkwTAg2i77rf6cpL0NmiY0iHC4LimE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cX8lQ9+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cX8lQ9+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBA7C4CEE7;
	Thu,  5 Jun 2025 21:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749159905;
	bh=/378/CyLklIBSTEz6wavEkJ73iTGPBfEFP9BPYYAUUg=;
	h=Date:To:From:Subject:From;
	b=cX8lQ9+27KmZH/JhkhAUEb0j/9u/57VZHZgS75061klBkkP1EQBQdpnxSGMHjWGil
	 iY0jFbidHK7xPYDGB6QAxOgTguxP3WrzlOo6lHJ89aR9OqABCd8Ig/K/06xs5cVB0b
	 72YoaFVvMdJj16xVM8waKIfGKhzjVUZd+1FKQKIk=
Date: Thu, 05 Jun 2025 14:45:04 -0700
To: mm-commits@vger.kernel.org,rick.p.edgecombe@intel.com,kirill.shutemov@linux.intel.com,ast@kernel.org,adobriyan@gmail.com,wangzijie1@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-clear-fmode_lseek-flag-correctly-for-permanent-pde.patch added to mm-nonmm-unstable branch
Message-Id: <20250605214505.1DBA7C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: clear FMODE_LSEEK flag correctly for permanent pde
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-clear-fmode_lseek-flag-correctly-for-permanent-pde.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-clear-fmode_lseek-flag-correctly-for-permanent-pde.patch

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
From: wangzijie <wangzijie1@honor.com>
Subject: proc: clear FMODE_LSEEK flag correctly for permanent pde
Date: Thu, 5 Jun 2025 14:52:52 +0800

Clearing FMODE_LSEEK flag should not rely on whether proc_open ops exists,
fix it.

Link: https://lkml.kernel.org/r/20250605065252.900317-1-wangzijie1@honor.com
Fixes: ad7f4ea6e36e ("proc: avoid use-after-free in proc_reg_open()")
Signed-off-by: wangzijie <wangzijie1@honor.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/proc/inode.c~proc-clear-fmode_lseek-flag-correctly-for-permanent-pde
+++ a/fs/proc/inode.c
@@ -474,12 +474,11 @@ static int proc_reg_open(struct inode *i
 	struct pde_opener *pdeo;
 
 	if (pde_is_permanent(pde)) {
+		if (!pde->proc_ops->proc_lseek)
+			file->f_mode &= ~FMODE_LSEEK;
 		open = pde->proc_ops->proc_open;
-		if (open) {
-			if (!pde->proc_ops->proc_lseek)
-				file->f_mode &= ~FMODE_LSEEK;
+		if (open)
 			rv = open(inode, file);
-		}
 		return rv;
 	}
 
_

Patches currently in -mm which might be from wangzijie1@honor.com are

proc-avoid-use-after-free-in-proc_reg_open.patch
proc-clear-fmode_lseek-flag-correctly-for-permanent-pde.patch

