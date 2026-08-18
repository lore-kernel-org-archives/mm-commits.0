Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9953A7F57
	for <mm-commits@vger.kernel.org>; Tue, 18 Aug 2026 16:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787072230; cv=none; b=lg1SA75BfLU2SEP8O6MFQ0rrzZsQfrrv8MreC+w79VBllJI5+ZuuxtGNlurkXnS8dURaTb4N/YNcjQYK2vvqwLo/1DUGuidL9uWfxHLunTvLzNLzwvAmaw5L+ZdcMVS8naxOyv0QLw/LHkruhI9r/rHEuzVjrZkdT9uEkT25ylM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787072230; c=relaxed/simple;
	bh=B83fORn3ml6XSPpr7IqcCmNVZMHf84p/7oqrmBXa7gM=;
	h=Date:To:From:Subject:Message-Id; b=i9ODYm/kD8IGdHAiW2qTCFBv3ktmxhRFsQwRlGaprgJ6A0G+Lp0FDJ2044/knIUn4NI+THuCpKf9Fri5ePOR5f5GYafBj8b6ap6jAUc59QrxeOQ95rrKW/4+dE4wMOivE6MfX1USKsdP9mvp+5QTH89CSk8cb2m2lFkQGRiW/xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2idTuxCK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2idTuxCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E911F000E9;
	Tue, 18 Aug 2026 16:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787072226;
	bh=Ne6cnYtKbG/lxK4+++KnqCLRN6vD+LVqlmv2dCJYux4=;
	h=Date:To:From:Subject;
	b=2idTuxCKbvCj5pDEmUPcvGPF0qd1MTeahr+/C3+6Zop6PF0jXazvqBsBhjYXzny5k
	 SOHRAkPVahtUKFdh6X1Xg4Nv5DZdSge+bz5D8bzbI3MP+psHV8febUs7x+y0/wJrO/
	 9z61a0txVro8Hv7a4DQ5QSNDV/lICb+DY+IEUwK8=
Date: Tue, 18 Aug 2026 09:57:05 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,lkp@intel.com,ljs@kernel.org,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-include-swaph-in-swapopsh.patch added to mm-unstable branch
Message-Id: <20260818165705.F2E911F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: include swap.h in swapops.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-include-swaph-in-swapopsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-include-swaph-in-swapopsh.patch

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
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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

mm-include-swaph-in-swapopsh.patch

