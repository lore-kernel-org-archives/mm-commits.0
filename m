Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA9B52FE39
	for <mm-commits@vger.kernel.org>; Tue, 22 Sep 2026 23:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790118433; cv=none; b=u2yh6JB22IRsuGOz1QpfD+5NBcn7yoLF7/ZZM3034wvWAQddAE84SPsKinkNTuSE9WtLL0lj0MHbiPPY3NveGiansOw6Wsr6JAxYvW5iFmxN/5ZWwKsydxwyh24WVZYdsKY4jSV3hWL0St0B777+zbUdmLDU1ShC6dYiOlaJL/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790118433; c=relaxed/simple;
	bh=NMYkIFh3OcrlHWrRNS3phoXRH/vZG+NDRPhr8OnKfD8=;
	h=Date:To:From:Subject:Message-Id; b=HfrguMtujVttk1WeF07hhAr632HwMouGZv4RRWwzVtaFWelsCKTLduc6wqklgmIbsunXYgbkIvZZnObG+fGkiboX1GzO5Yku3uTFIq6vcckyCNvnKBmQds8MoGsTSS1tEu1aesKy88gM1g7WAlwVaPCt7lBmgchqWSq1Si5hQuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gmG4k4r1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gmG4k4r1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E471F000FF;
	Tue, 22 Sep 2026 23:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790118432;
	bh=KRkc4JWaWQZ4pj9EEZnP4CQTV3ypCsqIveyhHYIXIrY=;
	h=Date:To:From:Subject;
	b=gmG4k4r1qRlb67A+msy7KcCJOHLjE5SO5JOM16i724zc6U/jOzJ8wZa5GDBk7VLN3
	 S/mEpOtmc9nQNMjTZJv09m6F1fWB5mTzstwG45+PSOTdvKCBjA9yAE9gazPLWcq1bS
	 Ejze1YIouc2/XwjF3NAi++0ztaIIGfeXN5J4NFVE=
Date: Tue, 22 Sep 2026 16:07:11 -0700
To: mm-commits@vger.kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-mainc-remove-unreachable-check-in-obsolete_checksetup.patch added to mm-nonmm-unstable branch
Message-Id: <20260922230712.34E471F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init/main.c: remove unreachable check in obsolete_checksetup()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-mainc-remove-unreachable-check-in-obsolete_checksetup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-mainc-remove-unreachable-check-in-obsolete_checksetup.patch

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: init/main.c: remove unreachable check in obsolete_checksetup()
Date: Tue, 22 Sep 2026 22:26:27 +0900

Since commit 1ecfea06386c ("init.h: remove long-dead
__setup_null_param() macro"), .init.setup entries cannot have a NULL
setup_func.

So remove the NULL check.

No functional change.

Link: https://lore.kernel.org/20260922132630.177941-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/init/main.c~init-mainc-remove-unreachable-check-in-obsolete_checksetup
+++ a/init/main.c
@@ -215,10 +215,6 @@ static bool __init obsolete_checksetup(c
 				 * params and __setups of same names 8( */
 				if (line[n] == '\0' || line[n] == '=')
 					had_early_param = true;
-			} else if (!p->setup_func) {
-				pr_warn("Parameter %s is obsolete, ignored\n",
-					p->str);
-				return true;
 			} else if (p->setup_func(line + n))
 				return true;
 		}
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

percpu-fix-the-comment-about-which-sizes-share-a-slot.patch
percpu-remove-redundant-assignments-to-bits.patch
percpu-remove-unnecessary-initialization-in-pcpu_build_alloc_info.patch
percpu-remove-unnecessary-cpumask_clear-in-pcpu_build_alloc_info.patch
percpu-remove-unnecessary-return-in-pcpu_populate_pte.patch
mm-swapops-remove-unused-is_hwpoison_entry.patch
bootconfig-remove-redundant-assignment-in-xbc_parse_array.patch
init-mainc-remove-unreachable-check-in-obsolete_checksetup.patch

