Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D33F349CDD
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 23:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779404870; cv=none; b=O8QnSSk81QFjdutTs/FLTzFQrG4Wh3t++CKh1DXYWwQYlkHf60rrByeTtXQP7HAt2kcauSyDsfw4PVA2Lb4Hs+1QyQV0zOJujCek37dsaSqbqApgOOOqfJzVx4n5VEXgyVMHCb9FJL86bbpAMTdCF7QyeydEeRgUX3c9NyjSP0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779404870; c=relaxed/simple;
	bh=VxJ4gbiNfbntLjm4mANH7lKmUo2fsNJCXS2JbfpaYVk=;
	h=Date:To:From:Subject:Message-Id; b=nckM2KEgj1Epgj1xIgaVl9ltHFYQz8exxJE0ABFvU8m1YNctlFCrYXhU6sf17R+x3wOChot3eCtibMWj8hPp3BSTaHd6ThaGmlDwiRAnFCCYC3x61KFO3swINQPacb77tZXYQDxuuR+kUZeZtbx61h8ZKNCfHuDwAw3xWa7ItkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Ws/5YGB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Ws/5YGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99031F000E9;
	Thu, 21 May 2026 23:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779404869;
	bh=NGG1k8VZ/wN3lAHxlq4lGBVPSqQJU9r3FFE7/vsZ8/A=;
	h=Date:To:From:Subject;
	b=0Ws/5YGBp7Hm4n3JUhdhU7XAN8Y1DMfjOMv2upibvUIiIMjxGRdLa1id4iONeZFl4
	 KSEU/n1qxBWL1RFcBhEWNXBq5vMikMKA/7BVaKD7Nbf6s7ThxgTZBp30LwdKD9OdqD
	 55ZurIRfEEWIGQaO1JY9OMiONNUE329aUemnkyqs=
Date: Thu, 21 May 2026 16:07:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-more-files-to-page-cache-section.patch added to mm-new branch
Message-Id: <20260521230748.D99031F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add more files to PAGE CACHE section
has been added to the -mm mm-new branch.  Its filename is
     maintainers-add-more-files-to-page-cache-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-more-files-to-page-cache-section.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: MAINTAINERS: add more files to PAGE CACHE section
Date: Wed, 20 May 2026 17:17:12 -0400

Add include/linux/writeback.h and
include/trace/events/{filemap.h,readahead.h,writeback.h}.

Link: https://lore.kernel.org/20260520-page-cache-maintainers-v1-1-f93438d2186d@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++++
 1 file changed, 4 insertions(+)

--- a/MAINTAINERS~maintainers-add-more-files-to-page-cache-section
+++ a/MAINTAINERS
@@ -20173,6 +20173,10 @@ T:	git git://git.infradead.org/users/wil
 F:	Documentation/filesystems/locking.rst
 F:	Documentation/filesystems/vfs.rst
 F:	include/linux/pagemap.h
+F:	include/linux/writeback.h
+F:	include/trace/events/filemap.h
+F:	include/trace/events/readahead.h
+F:	include/trace/events/writeback.h
 F:	mm/filemap.c
 F:	mm/page-writeback.c
 F:	mm/readahead.c
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-filemap-fix-page_cache_prev_miss-when-no-hole-is-found.patch
maintainers-add-more-files-to-page-cache-section.patch

