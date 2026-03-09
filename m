Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD942C08BC
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 19:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773085046; cv=none; b=cvfNVpWsFq1WbEjCpIqXiiDcm9Aw+uNV4e6Zykdw5cHHGbaFbrgsUPgRzR0RNk920zGz8WOSXfnbmAB9HGLxmyxnSaFNWxGa8ogmIvU4RC1KBuVOOIl5MPQ1mlWAoBkJf+LXjaozewZhDF2f2HvGX+8iv3nvzRgug0Pa1/4lMMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773085046; c=relaxed/simple;
	bh=hCq9uUVfhkDv241mH5q4l4kcUrYMjp7ZPLvWvOswfVE=;
	h=Date:To:From:Subject:Message-Id; b=AsfBrg+5xURt1V2G96OO2rA36z9qeuHcOXu+dgkqrqoZoE2IeYbnrl5gePQTUD+JnFT2sRl1mVPYuAopsIGAu+k7XaIVfxqDS15oowaNO1hXrK1G4EiaAwcxNvW3BxyxB5DyEO0w/LYxieKrJ9mrwvi3FP7ejqb3z4OG0TOYApQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MTtXN6Ku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MTtXN6Ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1897FC4CEF7;
	Mon,  9 Mar 2026 19:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773085046;
	bh=hCq9uUVfhkDv241mH5q4l4kcUrYMjp7ZPLvWvOswfVE=;
	h=Date:To:From:Subject:From;
	b=MTtXN6KuCTnIe5n8jWzSMAd+2evobgU4Vq5pRpW79PQH/SahcOt/fkRb6by5r42Gt
	 dZk/iizsjP/WZPa3OsH5BoV6UcYSg4fBGnCXEeMr8t53/K2WJZch/tr6PhufwXBS82
	 3SMykaKY8AqVXbdKyroYw++w5BxZC1QmGuhEM0Ew=
Date: Mon, 09 Mar 2026 12:37:25 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,usama.arif@linux.dev,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch added to mm-unstable branch
Message-Id: <20260309193726.1897FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix
Date: Mon Mar  9 12:35:33 PM PDT 2026

fix comment typo, per Usama.  Reflow comment to 80 cols

Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix
+++ a/mm/memcontrol.c
@@ -4059,8 +4059,9 @@ free_objcg:
 		if (pn && pn->orig_objcg) {
 			obj_cgroup_put(pn->orig_objcg);
 			/*
-			 * Reset pn->orig_objcg to NULL to prevent obj_cgroup_put()
-			 * from being called agagin in __mem_cgroup_free().
+			 * Reset pn->orig_objcg to NULL to prevent
+			 * obj_cgroup_put() from being called again in
+			 * __mem_cgroup_free().
 			 */
 			pn->orig_objcg = NULL;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch

