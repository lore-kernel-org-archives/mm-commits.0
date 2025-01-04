Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A812914
	for <mm-commits@vger.kernel.org>; Sat,  4 Jan 2025 02:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735957368; cv=none; b=HcmOs8dC8itf8ag/usjmYHyqsGMeZ+AxTdHqeuQw3RG4eaoI0GCbguSFHzoj+UtlkIiql6ilZeHi5tDDBbTVHpO0x0wONOkwceC1m/p5e5qHZd3uEnGK7jpAU0Nzw2TEXb1nSq+NlEupggzGj0VvyzmUy3gAq09THX2bHq64en4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735957368; c=relaxed/simple;
	bh=fxB3Ti3hjwmH3Qo/7EwrmFnP37wQdhf6eFCNDYeJi0E=;
	h=Date:To:From:Subject:Message-Id; b=Y6CyUVGIN8OYCrg29r3B+mYvtEbIXdBOipHz2XqxK1tQJYEppnZeHf1S8Gxjod/0woIy02tp0WhImSYwObf7qI3vvHo1zPi4cVTm1zxD4fxaILypoq3YOxMrm2LGKU/BL/B+srxaS9RGExggnkQKkWIG05Y8IFPeG0mJbg51/XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jxc92nS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jxc92nS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468F4C4CED6;
	Sat,  4 Jan 2025 02:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735957368;
	bh=fxB3Ti3hjwmH3Qo/7EwrmFnP37wQdhf6eFCNDYeJi0E=;
	h=Date:To:From:Subject:From;
	b=Jxc92nS7UXAwa21oJuO+9GJjhJ8oB3eDtumLlQPuLC9mHCfTaedrsdD5f0U/Viqz5
	 trOancYajniXmHgCrRa2Lf2b6tlU0cg8kZKno4IshmzPC9ymdPVSss26NJissNbRjg
	 YE4P7UbtzNXe0lL/gL8wSfsYFrfT7U7LiUOzUuBo=
Date: Fri, 03 Jan 2025 18:22:47 -0800
To: mm-commits@vger.kernel.org,zzqq0103.hey@gmail.com,willy@infradead.org,shr@devkernel.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-div-by-zero-in-bdi_ratio_from_pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20250104022248.468F4C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix div by zero in bdi_ratio_from_pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-div-by-zero-in-bdi_ratio_from_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-div-by-zero-in-bdi_ratio_from_pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: fix div by zero in bdi_ratio_from_pages
Date: Fri, 3 Jan 2025 17:20:37 -0800

During testing it has been detected, that it is possible to get div by
zero error in bdi_set_min_bytes.  The error is caused by the function
bdi_ratio_from_pages().  bdi_ratio_from_pages() calls global_dirty_limits.
If the dirty threshold is 0, the div by zero is raised.  This can happen
if the root user is setting:

echo 0 > /proc/sys/vm/dirty_ration.

The following is a test case:

echo 0 > /proc/sys/vm/dirty_ratio
cd /sys/class/bdi/<device>
echo 1 > strict_limit
echo 8192 > min_bytes

==> error is raised.

The problem is addressed by returning -EINVAL if dirty_ratio or
dirty_bytes is set to 0.

Link: https://lkml.kernel.org/r/20250104012037.159386-1-shr@devkernel.io
Reported-by: cheung wall <zzqq0103.hey@gmail.com>
Closes: https://lore.kernel.org/linux-mm/87pll35yd0.fsf@devkernel.io/T/#t
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Qiang Zhang <zzqq0103.hey@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page-writeback.c~mm-fix-div-by-zero-in-bdi_ratio_from_pages
+++ a/mm/page-writeback.c
@@ -692,6 +692,8 @@ static unsigned long bdi_ratio_from_page
 	unsigned long ratio;
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
+	if (!dirty_thresh)
+		return -EINVAL;
 	ratio = div64_u64(pages * 100ULL * BDI_RATIO_SCALE, dirty_thresh);
 
 	return ratio;
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-fix-div-by-zero-in-bdi_ratio_from_pages.patch

