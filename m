Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A07B674
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 03:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744343146; cv=none; b=AGdzpsPnukVudWqdzWsAKkY6n5P5l4SdsjQS21Uaa0HZsAXnCTjlIUmovtowrDv84HC7+y0v8nuhvhdWHAlIkJHM57tyo9B3BB7MqVCFu1vwG1ywV2qDhKQUlJWtE1U6RNTwe1s4UlWbMOB/07oTNtTLvzv7J9S5nhrQfhrAQRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744343146; c=relaxed/simple;
	bh=+KUphjNyy/YROdwlKJbBetJowKkVgyjyJf0yzLNQalE=;
	h=Date:To:From:Subject:Message-Id; b=bPbXMQ7y29S6Wznoo0KR2etGuvsog15F7iupQ4lWH2ZyiZlKNy7DokL2Hj5JcsxoMT/D7Dgtamd7ZTkwVm5/qx3kqLRIwcojjSUwF3u13HbSnTkoyQjxCHiA6q25nVUl6upw1myJSHVn9dKqg3/aDAM+/2WgUAhf1th0QETwrCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XI/r/z4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XI/r/z4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA31C4CEE2;
	Fri, 11 Apr 2025 03:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744343144;
	bh=+KUphjNyy/YROdwlKJbBetJowKkVgyjyJf0yzLNQalE=;
	h=Date:To:From:Subject:From;
	b=XI/r/z4vrKScWGD8IF+q+4R2zd0RVgyxeo2YlTjJxSl8SxdPq4z1Tpxm008DoEJS3
	 Wha1rJGhu7hAdh8p+Of3KubXGeo/mUhk/TNaaUGHgab71g41iS8ZCYD8dLXFF2BUDA
	 AcR6alRcf+mzFgffkYWr/t3wtEbav4wIO374m7DQ=
Date: Thu, 10 Apr 2025 20:45:43 -0700
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,osalvador@suse.de,david@redhat.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch added to mm-new branch
Message-Id: <20250411034544.1AA31C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: fix wrongly calculated returned value in fault_in_safe_writeable()
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch

This patch will later appear in the mm-new branch at
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
From: Baoquan He <bhe@redhat.com>
Subject: mm/gup: fix wrongly calculated returned value in fault_in_safe_writeable()
Date: Thu, 10 Apr 2025 11:57:14 +0800

Patch series "mm/gup: Minor fix, cleanup and improvements", v4.

These were made from code inspection in mm/gup.c.


This patch (of 4):

Not like fault_in_readable() or fault_in_writeable(), in
fault_in_safe_writeable() local variable 'start' is increased page by page
to loop till the whole address range is handled.  However, it mistakenly
calculates the size of the handled range with 'uaddr - start'.

Fix it here.

Link: https://lkml.kernel.org/r/20250410035717.473207-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20250410035717.473207-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Fixes: fe673d3f5bf1 ("mm: gup: make fault_in_safe_writeable() use fixup_user_fault()")
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yanjun.Zhu <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable
+++ a/mm/gup.c
@@ -2207,8 +2207,8 @@ size_t fault_in_safe_writeable(const cha
 	} while (start != end);
 	mmap_read_unlock(mm);
 
-	if (size > (unsigned long)uaddr - start)
-		return size - ((unsigned long)uaddr - start);
+	if (size > start - (unsigned long)uaddr)
+		return size - (start - (unsigned long)uaddr);
 	return 0;
 }
 EXPORT_SYMBOL(fault_in_safe_writeable);
_

Patches currently in -mm which might be from bhe@redhat.com are

maintainers-add-andrew-and-myself-as-kexec-maintainer.patch
mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch
mm-gup-remove-unneeded-checking-in-follow_page_pte.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
mm-gup-clean-up-codes-in-fault_in_xxx-functions.patch

