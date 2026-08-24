Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF33F360EC3;
	Mon, 24 Aug 2026 18:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787597375; cv=none; b=bG+UoyUWSL7AXlyBZQTpR4XbX3whF2VnwGuhBU2fvzY+n7xTEGKwcVc3nY036FK2T/l3hI0EbsAc10k4LrQL2dIjZeF1R1XoFQhXmAPuLzaGMn2aa/OvXRd1DiG4rKt4p74tc3HWNtYgPQNLIK4svVNKEuhWQ8ZyDpNjedkIL9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787597375; c=relaxed/simple;
	bh=YQyq2030kjfN2C15fcwvih8Xt2cKjaiZ+6chbnqnSOM=;
	h=Date:To:From:Subject:Message-Id; b=H4Uq5TaHtk0rXhxd+18C86T8DI1V/AtH52qW+qyi53XcB21buuGUD+g5HHIOGeHvHj8MFeolgiHOmcMsHYFuO0cKTf48sj83lqFlgNvSJXs3v6RvbXp1L4R5Mt1QPhUa1AMCX0/Z6IhIvzC0rXqOXBbcGRN7N9GF33JU7PoZXVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JYr1JUbl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JYr1JUbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466421F000E9;
	Mon, 24 Aug 2026 18:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787597373;
	bh=ok9+nB/bIijFJaZb2sHeVx/K3TmQFcVWFWkxlsxtBZ4=;
	h=Date:To:From:Subject;
	b=JYr1JUblDXSRuN0lWqvHMhA/NbUcv4Tnr5iCBdIwU776VlsiA9HcoqFqKnIhCjq4m
	 rrIp8FMH8ZCf5LcYJt1iCnFuPAt9ty3gA+kSSh3bgTEpKnsqva6xrqbb22Lv5FP0RN
	 BxWeIOOIhcL6JJk/JwFUB07NKkOvMp9QK4AD/HOQ=
Date: Mon, 24 Aug 2026 11:49:32 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,samitolvanen@google.com,petr.pavlu@suse.com,mcgrof@kernel.org,atomlin@atomlin.com,akpm@linux-foundation.org,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + module-fix-lost-error-code-from-codetag_load_module.patch added to mm-hotfixes-unstable branch
Message-Id: <20260824184933.466421F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: module: fix lost error code from codetag_load_module()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     module-fix-lost-error-code-from-codetag_load_module.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/module-fix-lost-error-code-from-codetag_load_module.patch

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
From: Hao Ge <hao.ge@linux.dev>
Subject: module: fix lost error code from codetag_load_module()
Date: Mon, 24 Aug 2026 09:47:36 +0800

If codetag_load_module() fails, err is not set to reflect the failure and
load_module() returns 0 after the module has been torn down.

Link: https://lore.kernel.org/20260824014736.35026-1-hao.ge@linux.dev
Fixes: 044d2aee6c57 ("alloc_tag: handle module codetag load errors as module load failures")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/module/main.c~module-fix-lost-error-code-from-codetag_load_module
+++ a/kernel/module/main.c
@@ -3568,7 +3568,8 @@ static int load_module(struct load_info
 			goto sysfs_cleanup;
 	}
 
-	if (codetag_load_module(mod))
+	err = codetag_load_module(mod);
+	if (err)
 		goto sysfs_cleanup;
 
 	/* Get rid of temporary copy. */
_

Patches currently in -mm which might be from hao.ge@linux.dev are

module-fix-lost-error-code-from-codetag_load_module.patch

