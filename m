Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A2E30F954
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 21:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766008240; cv=none; b=K9d+nsHQRZMyKBMZEGbz2R4nYCUPgTLaHc8CRJD8ydDPaDFLDyqA0yB87lBDBRgsTMWmsxvpHp21zT26tIh4ZSgvcrPAzYHY3u2NrU0bTxbrgYtTtgquVqdghV4mGcydeJozg7Wjk4xfvOUnAm3W0mXOOLlzjaafa1ayrxnWTUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766008240; c=relaxed/simple;
	bh=eQFOqaM58UPEuGNkUiHOjxgg26OODhbLR5CkK7HhvFQ=;
	h=Date:To:From:Subject:Message-Id; b=Nv21FFFd6YXHV3NpODKrS5qB5u6rk5C+CD4d+s0FBymXCdyTHUYEg0/ng/menito/gDJhbMBZMggek6eRhckkDO9ydpphbwhLXLJ2Icwf4U2234lX7zkIKBmVPIBeXJGRE4NJEiP2MTaZbsgMTvPvts/2FvrizPyHh9GWokpCIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OH42KHuM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OH42KHuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1DCC4CEF5;
	Wed, 17 Dec 2025 21:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766008239;
	bh=eQFOqaM58UPEuGNkUiHOjxgg26OODhbLR5CkK7HhvFQ=;
	h=Date:To:From:Subject:From;
	b=OH42KHuMNTRRKSaP3LZ+S85uJShm5SQgv2FBduB4TuHzwTw9JVAR+2ZKHwcodOM3R
	 odpuYUiZW4NT8atmxWVLRLZANmhSZmkjVcnu01lCartAv7yoJ6O7yH2stoKk7po1Yj
	 mR20EcRq9R0FzfV9mIeOHseePfG7BqcijUWpfOZU=
Date: Wed, 17 Dec 2025 13:50:39 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,john@groves.net,gourry@gourry.net,djwong@kernel.org,dan.j.williams@intel.com,bsingharora@gmail.com,apopple@nvidia.com,John@Groves.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memremap-fix-spurious-large-folio-warning-for-fs-dax.patch added to mm-hotfixes-unstable branch
Message-Id: <20251217215039.BA1DCC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memremap: fix spurious large folio warning for FS-DAX
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memremap-fix-spurious-large-folio-warning-for-fs-dax.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremap-fix-spurious-large-folio-warning-for-fs-dax.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: John Groves <John@Groves.net>
Subject: mm/memremap: fix spurious large folio warning for FS-DAX
Date: Wed, 17 Dec 2025 15:13:10 -0600

This patch addresses a warning that I discovered while working on famfs,
which is an fs-dax file system that virtually always does PMD faults (next
famfs patch series coming after the holidays).

However, XFS also does PMD faults in fs-dax mode, and it also triggers the
warning.  It takes some effort to get XFS to do a PMD fault, but
instructions to reproduce it are below.

The VM_WARN_ON_ONCE(folio_test_large(folio)) check in
free_zone_device_folio() incorrectly triggers for MEMORY_DEVICE_FS_DAX
when PMD (2MB) mappings are used.

FS-DAX legitimately creates large file-backed folios when handling PMD
faults.  This is a core feature of FS-DAX that provides significant
performance benefits by mapping 2MB regions directly to persistent memory.
When these mappings are unmapped, the large folios are freed through
free_zone_device_folio(), which triggers the spurious warning.

The warning was introduced by commit that added support for large zone
device private folios.  However, that commit did not account for FS-DAX
file-backed folios, which have always supported large (PMD-sized)
mappings.

The check distinguishes between anonymous folios (which clear
AnonExclusive flags for each sub-page) and file-backed folios.  For
file-backed folios, it assumes large folios are unexpected - but this
assumption is incorrect for FS-DAX.

The fix is to exempt MEMORY_DEVICE_FS_DAX from the large folio warning,
allowing FS-DAX to continue using PMD mappings without triggering false
warnings.

=== How to reproduce ===

A reproducer is available at:

    git clone https://github.com/jagalactic/dax-pmd-test.git
    cd xfs-dax-test
    make
    sudo make test

This will set up XFS on pmem with 2MB stripe alignment and run a test that
triggers the warning.

Alternatively, follow the manual steps below.

Prerequisites:
  - Linux kernel with FS-DAX support and CONFIG_DEBUG_VM=y
  - A pmem device (real or emulated)
  - An fsdax namespace configured via ndctl as /dev/pmem0

Manual steps:

1. Create an fsdax namespace (if not already present):
   # ndctl create-namespace -m fsdax -e namespace0.0

2. Create XFS with 2MB stripe alignment:
   # mkfs.xfs -f -d su=2m,sw=1 /dev/pmem0
   # mount -o dax /dev/pmem0 /mnt/pmem

3. Compile and run the reproducer:
   # gcc -Wall -O2 -o dax_pmd_test dax_pmd_test.c
   # ./dax_pmd_test /mnt/pmem/testfile

4. Check dmesg for the warning:
   WARNING: mm/memremap.c:431 at free_zone_device_folio+0x.../0x...

Note: The 2MB stripe alignment (-d su=2m,sw=1) is critical.  XFS normally
allocates blocks at arbitrary offsets, causing PMD faults to fall back to
PTE faults.  The stripe alignment forces 2MB-aligned allocations, allowing
PMD faults to succeed and exposing this bug.

Link: https://lkml.kernel.org/r/20251217211310.98772-1-john@groves.net
Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
Signed-off-by: John Groves <john@groves.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/memremap.c~mm-memremap-fix-spurious-large-folio-warning-for-fs-dax
+++ a/mm/memremap.c
@@ -428,7 +428,12 @@ void free_zone_device_folio(struct folio
 		for (i = 0; i < nr; i++)
 			__ClearPageAnonExclusive(folio_page(folio, i));
 	} else {
-		VM_WARN_ON_ONCE(folio_test_large(folio));
+		/*
+		 * FS_DAX legitimately uses large file-mapped folios for
+		 * PMD mappings, so only warn for other device types.
+		 */
+		VM_WARN_ON_ONCE(pgmap->type != MEMORY_DEVICE_FS_DAX &&
+				folio_test_large(folio));
 	}
 
 	/*
_

Patches currently in -mm which might be from John@Groves.net are

mm-memremap-fix-spurious-large-folio-warning-for-fs-dax.patch

