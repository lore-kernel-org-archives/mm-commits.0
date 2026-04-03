Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9E42248A5;
	Fri,  3 Apr 2026 17:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775237858; cv=none; b=qqYeQYBd2/XbsWFEESePVKbIA0/SEN5Sl+zeUbgHdu7gAwQKaLA28LzqTa3pCSy4QYWPmfAsAhnF24522mEmCqIw7V50EHxZo+7UP4WQMi3Ocomzc4TIDSW0rQ/W7PZyT0ALyBkEf1RC3t2KCZiYWxE4Pe0YYWJRbifOPbTJ4Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775237858; c=relaxed/simple;
	bh=Juyu0y0I7u0FUKOOGT6Lg8UpSGHgVDhvKFGuqHaUDng=;
	h=Date:To:From:Subject:Message-Id; b=RCjtHIKDZmDNJk/22KUjMPkNr8WT0lYSET7qrcOQ6s0cbURgET692tOgzEQ+qJb4iTcyDZknMlsVZk48nE3m7wqjXdCkhuuVr+0y/YUOGqA758xO7rFHMXgQ4A2J5wBrho/y54vNSLElXlHjIM52ziPX/wK+ol4pBlM/khyhYaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eQrK2ogI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eQrK2ogI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EE8C4CEF7;
	Fri,  3 Apr 2026 17:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775237858;
	bh=Juyu0y0I7u0FUKOOGT6Lg8UpSGHgVDhvKFGuqHaUDng=;
	h=Date:To:From:Subject:From;
	b=eQrK2ogI22G0H19mJuL11Eo7FMW2f9vSUiYNB9yVq3JOMOfKrNSIfyZbmHalLI3si
	 u6hz/iHoFihIe/hFcr3t6jyA1gl6gVZQ9lM9YESVTc2KVRXU/2O+1P/4VLvZwNqhJD
	 7iaI4LKyMT6nlloCesQvFg6IHNXRjjGUsewhp2yM=
Date: Fri, 03 Apr 2026 10:37:37 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jason@zx2c4.com,jannh@google.com,david@kernel.org,broonie@kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-mmap-errno-value-when-map_droppable-is-not-supported.patch added to mm-unstable branch
Message-Id: <20260403173738.24EE8C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix mmap errno value when MAP_DROPPABLE is not supported
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-mmap-errno-value-when-map_droppable-is-not-supported.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-mmap-errno-value-when-map_droppable-is-not-supported.patch

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
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: mm: fix mmap errno value when MAP_DROPPABLE is not supported
Date: Thu, 2 Apr 2026 16:59:32 -0700

Patch series "fix MAP_DROPPABLE not supported errno".

Mark Brown reported seeing a regression in -next on 32 bit arm with the
mlock selftests.  Before exiting and marking the tests failed, the
following message was logged after an attempt to create a MAP_DROPPABLE
mapping:

Bail out! mmap error: Unknown error 524

It turns out error 524 is ENOTSUPP which is an error that userspace is not
supposed to see, but it indicates in this instance that MAP_DROPPABLE is
not supported.

The first patch changes the errno returned to EOPNOTSUPP.  The second
patch is a second version of a prior patch to introduce selftests to
verify locking behavior with droppable mappings with the additonal change
to skip the tests when MAP_DROPPABLE is not supported.


This patch (of 2):

On configs where MAP_DROPPABLE is not supported (currently any 32-bit
config except for PPC32), mmap fails with errno set to ENOTSUPP.  However,
ENOTSUPP is not a standard error value that userspace knows about.  The
acceptable userspace-visible errno to use is EOPNOTSUPP.  checkpatch.pl
has a warning to this effect.

Link: https://lkml.kernel.org/r/20260402235933.10588-1-anthony.yznaga@oracle.com
Link: https://lkml.kernel.org/r/20260402235933.10588-2-anthony.yznaga@oracle.com
Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Acked-by: David Hildenbrand <david@kernel.org>
Reported-by: Mark Brown <broonie@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-fix-mmap-errno-value-when-map_droppable-is-not-supported
+++ a/mm/mmap.c
@@ -504,7 +504,7 @@ unsigned long do_mmap(struct file *file,
 			break;
 		case MAP_DROPPABLE:
 			if (VM_DROPPABLE == VM_NONE)
-				return -ENOTSUPP;
+				return -EOPNOTSUPP;
 			/*
 			 * A locked or stack area makes no sense to be droppable.
 			 *
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are

mm-fix-mmap-errno-value-when-map_droppable-is-not-supported.patch
selftests-mm-verify-droppable-mappings-cannot-be-locked.patch

