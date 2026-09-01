Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C760E442386
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 03:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788234473; cv=none; b=i34s6CfPNJ8hpJFnlSNE/ik599vmNCQZoMGta1HU1pDK3JWG/menowoWLWXkL2goNA3fxW0nN7Z7yxc8Weh8ny664rRCshQSz1RKdWclNaVF/cblS2HXy/pm0luKv2Ko268DAvw1uXWOi/puWO5DuTqvIZEPjTxHt8mvU8MXXZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788234473; c=relaxed/simple;
	bh=rlnYpIpl/qlzak+xuJH3SQI6iFq4OIUb/8541cOhzq0=;
	h=Date:To:From:Subject:Message-Id; b=pEz7BLCB2Q34HwIGccpXxVL+JnmbZq9whZWOBvTQpMXqBu8bnqpqqIvQfSfFCaad1Q/FQ68c3E3Nz7Y5BAqzXopZ92wfxuUC9/mOqI0/AKa91R2lskABwRrnGWoJUfhE7wZJy1LelSgX0/GpsgbadnKfgLLzZKSZwgBhF9cGXhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mkkbWZ5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mkkbWZ5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4836A1F000E9;
	Tue,  1 Sep 2026 03:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788234471;
	bh=+tgtADD+Hkj0owD8DKj8by60IaCxbNEqKdNr7+s3Olc=;
	h=Date:To:From:Subject;
	b=mkkbWZ5qcabsOPLG/raoXvX2YTzUFuskAzUX2vGmFHdig/tFPgG2mIX2safBgWzgy
	 LBHWk9D30oY+/1/m3eoG6xSm4VipobuuUnMRHsAe4qPxKEGwuf+cUK/d5wklgVU+ec
	 Ic8xIg7t83Vyj5pH/HWXltpQ1fY05GtawwHkhk0U=
Date: Mon, 31 Aug 2026 20:47:50 -0700
To: mm-commits@vger.kernel.org,jim.cromie@gmail.com,jbaron@akamai.com,yuntao.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dyndbg-clean-up-dynamic_debug_init-to-improve-readability.patch added to mm-nonmm-unstable branch
Message-Id: <20260901034751.4836A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dyndbg: clean up dynamic_debug_init() to improve readability
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     dyndbg-clean-up-dynamic_debug_init-to-improve-readability.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dyndbg-clean-up-dynamic_debug_init-to-improve-readability.patch

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
Subject: dyndbg: clean up dynamic_debug_init() to improve readability
Date: Tue, 11 Aug 2026 20:18:31 +0800

Keep variable assignments in the same order throughout the function to
make the code easier to follow.

No functional changes.

Link: https://lore.kernel.org/20260811121831.577848-3-yuntao.wang@linux.dev
Signed-off-by: Yuntao Wang <yuntao.wang@linux.dev>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/lib/dynamic_debug.c~dyndbg-clean-up-dynamic_debug_init-to-improve-readability
+++ a/lib/dynamic_debug.c
@@ -1442,28 +1442,29 @@ static int __init dynamic_debug_init(voi
 	i = mod_sites = mod_ct = 0;
 
 	for (; iter < __stop___dyndbg; iter++, i++, mod_sites++) {
-
 		if (strcmp(modname, iter->modname)) {
-			mod_ct++;
-			di.num_descs = mod_sites;
 			di.descs = iter_mod_start;
+			di.num_descs = mod_sites;
 			ret = ddebug_add_module(&di, modname);
 			if (ret)
 				goto out_err;
 
-			mod_sites = 0;
-			modname = iter->modname;
+			mod_ct++;
+
 			iter_mod_start = iter;
+			modname = iter->modname;
+			mod_sites = 0;
 		}
 	}
 
-	mod_ct++;
-	di.num_descs = mod_sites;
 	di.descs = iter_mod_start;
+	di.num_descs = mod_sites;
 	ret = ddebug_add_module(&di, modname);
 	if (ret)
 		goto out_err;
 
+	mod_ct++;
+
 	ddebug_init_success = 1;
 	vpr_info("%d prdebugs in %d modules, %d KiB in ddebug tables, %d kiB in __dyndbg section\n",
 		 i, mod_ct, (int)((mod_ct * sizeof(struct ddebug_table)) >> 10),
_

Patches currently in -mm which might be from yuntao.wang@linux.dev are

dyndbg-fix-incorrect-mod_ct-value-in-dynamic_debug_init.patch
dyndbg-clean-up-dynamic_debug_init-to-improve-readability.patch

