Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A409349CC4
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622956; cv=none; b=WlhNadIorYc781dZL5IgXgHRiy7t/ApLVB2ulwpnK3Cj6081+oK95jZBMC51k4PEwkGU2rTFWz3EPWXxTKSm58JddwxLhC7xM/4ry3bLhGeHBoRWfZZrTDTOfSm9GCNHVs9LydbvC/UMzo+hEtGxP0k/CUn9rNnxPxCxEdZBP4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622956; c=relaxed/simple;
	bh=/6jmCCyWv/mJtvUZ0scsO/9r/Km/qcLmMCdWXWNur5s=;
	h=Date:To:From:Subject:Message-Id; b=MzClfICYiz3hI9nJEnpy6znj+6UEqVuR/RkrPe8QVeyLhmLIxMYBF1uIo+/38ZCrOyeMHrxYAyXEisa5Fhm6yJXbQY1WYCpY6v2GCqP9SdrHhrE8KAyvcuPSk2BnCssDChx25B1l0plk8N9g0oFaTLuvERWguRjAOAFyZDMJpGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QKOLzeTV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QKOLzeTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D441F000E9;
	Tue, 25 Aug 2026 01:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622955;
	bh=G1xsb1b9Us0wR8guTaqBc6Mzwg7iGfozHCUmEAO9VW4=;
	h=Date:To:From:Subject;
	b=QKOLzeTVfEkfJYvVG6/+00CfcqNj7fN5q8I3YiQXULFpEH6WkKfdA3l27zGYoZdKJ
	 XzNi1tylj0bYxltElQzb8MK/e1eMhDDVHTd6Bda6RZDnZAxFd1AUNS2bU6MA71mgWc
	 9ZsizLov99mBRBItF6qHz8cit5EMLyrm0RCZbhkY=
Date: Mon, 24 Aug 2026 18:55:54 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,lkp@intel.com,ljs@kernel.org,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-include-swaph-in-swapopsh.patch removed from -mm tree
Message-Id: <20260825015555.40D441F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: include swap.h in swapops.h
has been removed from the -mm tree.  Its filename was
     mm-include-swaph-in-swapopsh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm: include swap.h in swapops.h
Date: Tue, 18 Aug 2026 12:50:26 +0100

swapops.h uses MAX_SWAPFILES_SHIFT, SWP_MIGRATION_READ and SWP_PTE_MARKER,
all of which swap.h defines, but does not include swap.h.  It compiles only
where the translation unit pulled swap.h in first.  leafops.h includes
swapops.h on the line above swap.h, so a file whose include list reaches
leafops.h before swap.h gets:

    In file included from include/linux/leafops.h:11:
    include/linux/swapops.h:88:21: error: use of undeclared
    identifier 'MAX_SWAPFILES_SHIFT'

A header that uses a definition has to include the header that provides it.

Link: https://lore.kernel.org/20260818115026.656406-1-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202608181757.mza9RRj7-lkp@intel.com/
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/swapops.h~mm-include-swaph-in-swapopsh
+++ a/include/linux/swapops.h
@@ -5,6 +5,7 @@
 #include <linux/radix-tree.h>
 #include <linux/bug.h>
 #include <linux/mm_types.h>
+#include <linux/swap.h>
 
 #ifdef CONFIG_MMU
 
_

Patches currently in -mm which might be from kas@kernel.org are


