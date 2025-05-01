Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8C8367
	for <mm-commits@vger.kernel.org>; Thu,  1 May 2025 19:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746127349; cv=none; b=NvmvhDZkZjC11QcJOZI1iBprXpdchug1Mu1SzZrQj//t71Jowmw+zYf7//XtKmQn0RbJ30McgqRv6bgAXrk4O/tT6yoObKZIK1sAJ4NkKo5jlCNP2C8PHB5pA1Sg+ubf2j+ukvClUtfOlEwA9ZkyH9r/lYEHbLsyMdzOnZr8mb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746127349; c=relaxed/simple;
	bh=nap0nNzbjhKhTZy4ylGPWOVjeh/vT9/NBsD/eBZrBEI=;
	h=Date:To:From:Subject:Message-Id; b=D399m1X0Uj5gP9mpQYpFX3BuL1Unlmdko/d7t1iZFx5sOdmIq5F+RTUpv9t86w/4R4dAUwjC9sCpW6DVipeeBHf+1WpkXzsZTZy88slQln0LFp0cAx284GNA7uwQkuwX3O37+bgDexhHpzyCLIJdYb068Y8BGBE7RQt1O4wbbJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mHFe5Fqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mHFe5Fqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6254CC4CEE3;
	Thu,  1 May 2025 19:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746127348;
	bh=nap0nNzbjhKhTZy4ylGPWOVjeh/vT9/NBsD/eBZrBEI=;
	h=Date:To:From:Subject:From;
	b=mHFe5FqtCKPGHl5MGGBVDc/o6cFzn8xAX6eXK9Jg8qzfRrInji81rN/vPnCa5vL+j
	 nEjs80B8NR2Bp3Pe7YcptS0Y7N5GmpTFlzy6AI1uKTiGB7aKCTm97H9O26keJIws+m
	 cp19JVhrx3nGOVUiXFpkYIJlK1NoqJRmv6u83N3w=
Date: Thu, 01 May 2025 12:22:27 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + jfs-implement-migrate_folio-for-jfs_metapage_aops-fix.patch added to mm-unstable branch
Message-Id: <20250501192228.6254CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: jfs: fix kernel-doc warning in jfs_metapage.c
has been added to the -mm mm-unstable branch.  Its filename is
     jfs-implement-migrate_folio-for-jfs_metapage_aops-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/jfs-implement-migrate_folio-for-jfs_metapage_aops-fix.patch

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
From: Shivank Garg <shivankg@amd.com>
Subject: jfs: fix kernel-doc warning in jfs_metapage.c
Date: Thu, 1 May 2025 11:10:54 +0000

Change comment style from "/**" to "/*" as the metapage_migrate_folio
function comment is not kernel-doc.

Link: https://lkml.kernel.org/r/1967593d-8084-4a4a-b384-35d5adc54eb4@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505011647.L0LGO7Lm-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/jfs_metapage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jfs/jfs_metapage.c~jfs-implement-migrate_folio-for-jfs_metapage_aops-fix
+++ a/fs/jfs/jfs_metapage.c
@@ -629,7 +629,7 @@ static bool metapage_release_folio(struc
 	return ret;
 }
 
-/**
+/*
  * metapage_migrate_folio - Migration function for JFS metapages
  */
 static int metapage_migrate_folio(struct address_space *mapping, struct folio *dst,
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-add-folio_expected_ref_count-for-reference-count-calculation.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix.patch

