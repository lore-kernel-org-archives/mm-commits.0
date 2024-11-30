Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6990A29A0
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 05:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732944405; cv=none; b=DmQ3CGUNGcseuac48xQCNk2zKooBlARuZ87hx9BETqOToTzWy+eM2hn6mIudoKsjMjxs4CTaZFCp408iMPplV6Jjdt+5MSycs4zkPuN1SeNDo+/QkVfsvV29Y94UDeMDPrhxBVYiMOz0FHy9wRWiLvCel2m0yeXL0bkseWqr3js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732944405; c=relaxed/simple;
	bh=LIzuysKqHpxvRH35aiQZW6yELaPUqi756dsVYkLbFUM=;
	h=Date:To:From:Subject:Message-Id; b=ba/DeyQavcIIoWqEhoINEAQSOF+QYVmo/IOwpRcQXsRrrKIUk8kh4lsa1HKdeNHURdpgHatIyVA8Pg1e31RzQMJBymjYUpNuU6xl1Wrszx2ezJDE3eJMOh7JkgQMRUyMERU5PI6EwJtMepY3VnJmCVyN+F5QDbvynra+TpGWl6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aw6EXDjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aw6EXDjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D82FC4CECC;
	Sat, 30 Nov 2024 05:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732944405;
	bh=LIzuysKqHpxvRH35aiQZW6yELaPUqi756dsVYkLbFUM=;
	h=Date:To:From:Subject:From;
	b=aw6EXDjSnUzovOKTXM1rrbjMOGub28ZHXa1cbPSbY5w8MHAffDXZU8IiZek6EzcVF
	 fdT/UnKEs9XsUyrzs9kS8STaYELrlRHmz0OTVPJ2RFLWYgpbB2fU4K/f8TNZIxwPD0
	 LTQ2Fv4ui0DkEWg9tV3O1EKxtKpESHj31PPmSBOs=
Date: Fri, 29 Nov 2024 21:26:44 -0800
To: mm-commits@vger.kernel.org,gaoxiang17@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback.patch added to mm-unstable branch
Message-Id: <20241130052645.0D82FC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: add some detailed comments in can_steal_fallback
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback.patch

This patch will later appear in the mm-unstable branch at
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
From: gaoxiang17 <gaoxiang17@xiaomi.com>
Subject: mm/page_alloc: add some detailed comments in can_steal_fallback
Date: Fri, 20 Sep 2024 20:20:30 +0800

Link: https://lkml.kernel.org/r/20240920122030.159751-1-gxxa03070307@gmail.com
Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback
+++ a/mm/page_alloc.c
@@ -1853,6 +1853,13 @@ static bool can_steal_fallback(unsigned
 	if (order >= pageblock_order)
 		return true;
 
+	/*
+	 * movable pages won't cause permanent fragmentation, so when you alloc small pages,
+	 * you just need to temporarily steal unmovable or reclaimable pages that are closest
+	 * to the request size. After a while, memory compact may occur to form large contiguous
+	 * pages, and the next movable allocation may not need to steal. Unmovable and reclaimable
+	 * allocation need to actually steal pages.
+	 */
 	if (order >= pageblock_order / 2 ||
 		start_mt == MIGRATE_RECLAIMABLE ||
 		start_mt == MIGRATE_UNMOVABLE ||
_

Patches currently in -mm which might be from gaoxiang17@xiaomi.com are

mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback.patch

