Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7688442386
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 03:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788234471; cv=none; b=p50cg4Hrjd7CHJDOb7RJSiQjtiI3cxlBOQbRM6pQ3MfC36yZvGUdna5qXg7Vq8RFBVta54JqKCYpFli2Gv1Ury+omHolM/K2g+Kh6rrbwqyUbmih5E18SLYBQIkDeBraGX6OhZnOPa6bB3qCYQvY2NDxZIlO+uAt7yQZH0ObJFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788234471; c=relaxed/simple;
	bh=SEbFxR0KVoYHKJbTJICiJFH1Q+4iP2DJEB2M9YofPKg=;
	h=Date:To:From:Subject:Message-Id; b=QaJhBkgogEw2bKCn4X46u9oniy1+qPW9IrxR5Z8JMdCmegE70bhPB3x7d8bhm2mEcA+51UX3kixkelsGWArBjnvCE3eU4d1pgAC2bM+GV/kDq5i4BxkPDb3R2CQthpLGy3r8LNEauCdGaJghnmjb+wu5kch3j+VnlO/ku+Bm11Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BXFEXEzB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BXFEXEzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E00E1F000E9;
	Tue,  1 Sep 2026 03:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788234469;
	bh=SguCezHqxNAmBXsNb/ahZ/AKo9AO/qdNUSPPqGHb0CA=;
	h=Date:To:From:Subject;
	b=BXFEXEzBJeHPPb1xR7fc5FmQ0bKRZSxOe+rbT3BjZuGYbtLSWNUgezIeCqONZLDXg
	 fqZKoP0Sl1Hj9iR876U6UkBR9X8LKH5pkXXDVTUjNOZXkHAoqIeh/S+Xq8hQW5qN2h
	 WLPLUylLLm/subr+0PfrnGV3eMOvL4Qo1jhPh89c=
Date: Mon, 31 Aug 2026 20:47:48 -0700
To: mm-commits@vger.kernel.org,jim.cromie@gmail.com,jbaron@akamai.com,yuntao.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dyndbg-fix-incorrect-mod_ct-value-in-dynamic_debug_init.patch added to mm-nonmm-unstable branch
Message-Id: <20260901034749.5E00E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dyndbg: fix incorrect mod_ct value in dynamic_debug_init()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     dyndbg-fix-incorrect-mod_ct-value-in-dynamic_debug_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dyndbg-fix-incorrect-mod_ct-value-in-dynamic_debug_init.patch

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
From: Yuntao Wang <yuntao.wang@linux.dev>
Subject: dyndbg: fix incorrect mod_ct value in dynamic_debug_init()
Date: Tue, 11 Aug 2026 20:18:30 +0800

Patch series "dyndbg: fix incorrect mod_ct value in dynamic_debug_init()".

Fix and clean up dynamic_debug_init().


This patch (of 2):

Suppose all `struct _ddebug` instances belong to the same module, mod_ct
should be 1, but it is currently 0.

mod_ct is incremented only when iter->modname changes, i.e.  when the loop
encounters the first _ddebug entry of a new module:

if (strcmp(modname, iter->modname)) {
	mod_ct++;
	...
}

If all _ddebug entries belong to the same module, strcmp() never returns
nonzero, so mod_ct remains 0.

However, the last (and in this case only) module is added after the loop:

di.num_descs = mod_sites;
di.descs = iter_mod_start;
ret = ddebug_add_module(&di, modname);

Thus, mod_ct should be incremented before adding this final module.

The bug only affects the diagnostic message printed by vpr_info():

"%d prdebugs in %d modules, ..."

It reports one fewer module than the actual number of modules.  There is
no userspace-visible runtime effect; the dynamic debug tables themselves
are initialized correctly.

Fix it.
		
Link: https://lore.kernel.org/20260811121831.577848-1-yuntao.wang@linux.dev
Link: https://lore.kernel.org/20260811121831.577848-2-yuntao.wang@linux.dev
Signed-off-by: Yuntao Wang <yuntao.wang@linux.dev>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/dynamic_debug.c~dyndbg-fix-incorrect-mod_ct-value-in-dynamic_debug_init
+++ a/lib/dynamic_debug.c
@@ -1456,6 +1456,8 @@ static int __init dynamic_debug_init(voi
 			iter_mod_start = iter;
 		}
 	}
+
+	mod_ct++;
 	di.num_descs = mod_sites;
 	di.descs = iter_mod_start;
 	ret = ddebug_add_module(&di, modname);
_

Patches currently in -mm which might be from yuntao.wang@linux.dev are

dyndbg-fix-incorrect-mod_ct-value-in-dynamic_debug_init.patch
dyndbg-clean-up-dynamic_debug_init-to-improve-readability.patch

