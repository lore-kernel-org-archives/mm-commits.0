Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3184C4FB9B3
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 20:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788467077; cv=none; b=fkiYLoq8un99Si0PHD0hjbl2w4Ch1Nqy1gau3SOlD/GEReS81TB1j24Dx9mePIkuLyMHYRBW8AUea14zy/nkLxJpbL3E9XlhOvykGR6YRuCJHo5e5F1mzlggOQWWwEDxujF1XaqkVjFkb4G9ak+v+JXVu7aSdofNzxBbVkbWrVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788467077; c=relaxed/simple;
	bh=91tOBAtUNTPvyl8zADJQ64SnfC7LZMb9iFzDVTr5+B0=;
	h=Date:To:From:Subject:Message-Id; b=kqdA8Tf+QrA/0W5owZKzpQznkl2Q02Hmr3Opm1Mz8mFzAwtZ3p6Xp8kJg0FXt2ea1mkPRUDket7EMX6XVsoLAG9e6xBYyIhRX0/1wNE97dJucqMax/OOn8+sMMJqp7Re9QPxB8WmDT4r4Ap6dPwq5vEi0ibnhzP/wt0/mkqF+6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gVfusjtG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gVfusjtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1656A1F000E9;
	Thu,  3 Sep 2026 20:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788467070;
	bh=BUIUsx45qxQqyLxGyhmpEwRWA61aRb+Tpylb9mVyJXs=;
	h=Date:To:From:Subject;
	b=gVfusjtGxNyPgA1builnrBGBurmcEm7vOXg2KrKD20uRzI+ZaujWCSQM/rCwFK1Xh
	 idlmLKed3ivGTeqEwdmx7S8mHTrq4zVQg1a+QXNaFwqymh9ftbIDbVE8XfIurCSjFw
	 quHpIYuBW9BDE5K2EGNukl19UG9JmhykM/Z2rVb4=
Date: Thu, 03 Sep 2026 13:24:29 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-a-template-based-fast-path-for-zone-device-page-init-fix.patch added to mm-unstable branch
Message-Id: <20260903202430.1656A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-a-template-based-fast-path-for-zone-device-page-init-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-a-template-based-fast-path-for-zone-device-page-init-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-a-template-based-fast-path-for-zone-device-page-init-fix.patch

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
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: mm-add-a-template-based-fast-path-for-zone-device-page-init-fix
Date: Thu, 3 Sep 2026 10:58:06 +0800

whitespace fix, per Mike

Link: https://lore.kernel.org/20260903025806.70825-1-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mm_init.c~mm-add-a-template-based-fast-path-for-zone-device-page-init-fix
+++ a/mm/mm_init.c
@@ -1139,8 +1139,7 @@ void __ref memmap_init_zone_device(struc
 	for (; pfn < end_pfn; pfn += pfns_per_compound) {
 		page = pfn_to_page(pfn);
 
-		zone_device_page_init_from_template(page, pfn,
-						    &template);
+		zone_device_page_init_from_template(page, pfn, &template);
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

mm-fix-stale-zone_device-refcount-comment.patch
mm-add-a-set_page_section_from_pfn-helper.patch
mm-add-a-template-based-fast-path-for-zone-device-page-init.patch
mm-add-a-template-based-fast-path-for-zone-device-page-init-fix.patch
mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch
string-introduce-memcpy_nontemporal.patch
mm-use-memcpy_nontemporal-in-zone-device-template-copies.patch
x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch

