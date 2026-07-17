Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A23F335BA8
	for <mm-commits@vger.kernel.org>; Fri, 17 Jul 2026 04:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784261585; cv=none; b=fpgG7Wn8yCSiwhRIFV0eZbHrWeVJMkRKvVnbCdi1bx7WjsFHnJprHveAv+QsasV3XWb4740lioK0MRBBhLgQgVLeNbth0ZiuIDaun4FufL9Tt8A/tbqVyy4Ju1/wICIb/19ivDdSq2A96gNX5KW5/hnLZUOCVY2tIdJ4dx3iaoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784261585; c=relaxed/simple;
	bh=MCxvasjbYluabANEXCQ6ZXxYd58rYrsXocCggNlj/ig=;
	h=Date:To:From:Subject:Message-Id; b=r8r9V5oBdSACWm4t1lhHuBpmY+uzOdHPaUY87VWhpX3RnrvyvwcubPYPwQ9Vc2UpL7NU+G1IrGn/eHssLBxXLRchmmjLiZLsUviRGVbcg9AMwTggkm32oed/ePXMypoqEqnXMOLiKHBNCClGpO28PLHHSI3f+plFQCnTgzNMGFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xjp+ct7x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xjp+ct7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FD51F000E9;
	Fri, 17 Jul 2026 04:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784261583;
	bh=ZL6NdRvO0H0zchChCD7yOcpw+eD0IzCHPhFf6DTVUPo=;
	h=Date:To:From:Subject;
	b=Xjp+ct7xZ7YbfXgeify4uHdUviO/bA6tpTEsSBrhXcPGixUnzHLZxkRXP3NgYszRA
	 h6UJz73ofZsut+UPeheMXIZpdwK1gUh4e+Rag3lSunFNxrDxunHdqwWqekiG1dC8MO
	 Vl5D8q8zW7jpFCwK1uZqh2zlJ4k1YHvQ1arhmvV4=
Date: Thu, 16 Jul 2026 21:13:02 -0700
To: mm-commits@vger.kernel.org,shivankg@amd.com,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-use-migrate_info-field-instead-of-private-fix.patch added to mm-unstable branch
Message-Id: <20260717041303.26FD51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: add missing kernel-doc for @migrate_info
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-use-migrate_info-field-instead-of-private-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-use-migrate_info-field-instead-of-private-fix.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/migrate: add missing kernel-doc for @migrate_info
Date: Thu, 16 Jul 2026 19:21:46 -0700

Add a kernel-doc comment for @migrate_info so that kernel-doc won't
produce a warning about it:

WARNING: include/linux/mm_types.h:507 struct member 'migrate_info' not described in 'folio'

Link: https://lore.kernel.org/20260717022146.1290242-1-rdunlap@infradead.org
Fixes: f3768940afdc ("mm/migrate: use migrate_info field instead of private")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/mm_types.h~mm-migrate-use-migrate_info-field-instead-of-private-fix
+++ a/include/linux/mm_types.h
@@ -368,6 +368,8 @@ typedef unsigned short mm_id_t;
  *    dax_associate_entry.
  * @private: Filesystem per-folio data (see folio_attach_private()).
  * @swap: Used for swp_entry_t if folio_test_swapcache().
+ * @migrate_info: Stores migration state (anon_vma pointer and
+ *    FOLIO_WAS_* markers).
  * @_mapcount: Do not access this member directly.  Use folio_mapcount() to
  *    find out how many times this folio is mapped by userspace.
  * @_refcount: Do not access this member directly.  Use folio_ref_count()
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-migrate-use-migrate_info-field-instead-of-private-fix.patch
mm-page_owner-document-page_owner-filter-fix.patch
radix-tree-add-correct-some-kernel-doc.patch
delaytop-sort-by-max-delay-to-highlight-top-latency-processes-fix.patch

