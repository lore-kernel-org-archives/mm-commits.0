Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9186134
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970687; cv=none; b=OGGf29jjYhR+3B4r3nF4hx1fZh6LUghtglxiqPAdtXe4SoLBGWw4D/HKg55YeBR3zSTdPON6L4hXIW9D5D6m3jhScJHOaSst3HAZD9X7qSJ5of8asrI2IZcIxN120e/6uQezZO+vkzOXjCORhIMMn3v+8D0ZWgHCakigrnSdD3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970687; c=relaxed/simple;
	bh=rWo1APHUZ1TA96f/8KIJ+SgrUUnLS4UuJ3bY4c4l0Ng=;
	h=Date:To:From:Subject:Message-Id; b=TZJ9rcoBwAK08JEtEDLCal6FzfLz+On9YjfIG9kMU6DO3ydNIERmr1DesQcUljj9z9/tQ+npP5MP0YdCgAOsjdm2CFpHze9rwaradUYgrp+s+6re+i34bLoyicbsHp6ZnUkiQC3Com1sYLLwWuSeONJGbSsR58IWLpjfDww9iN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t6wEZA2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t6wEZA2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352DAC433C7;
	Tue, 23 Jan 2024 00:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970687;
	bh=rWo1APHUZ1TA96f/8KIJ+SgrUUnLS4UuJ3bY4c4l0Ng=;
	h=Date:To:From:Subject:From;
	b=t6wEZA2l46S+GNWWM83Ha3qfb5J45xHkBn+aQ3S1RwK/W8Fm09nIpjGM0i59x4OWA
	 otrEtsOCpBeL9fYh6r/cEMS48Pl0WE4SJjjP1LMqxiibNTVrVfVM47t8eyegfC48Gp
	 bW9oVvq+S90udgTBD8FXp1MpzBFfZrreUBeVIgTo=
Date: Mon, 22 Jan 2024 16:44:44 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,riel@surriel.com,muchun.song@linux.dev,lstoakes@gmail.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map.patch added to mm-hotfixes-unstable branch
Message-Id: <20240123004447.352DAC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: run_vmtests.sh: add hugetlb_madv_vs_map
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: selftests/mm: run_vmtests.sh: add hugetlb_madv_vs_map
Date: Wed, 17 Jan 2024 09:10:58 -0800

hugetlb_madv_vs_map selftest was not part of the mm test-suite since we
didn't have a fix for the problem it found.

Now that the problem is already fixed (see previous commit), let's
enable this selftest in the default test-suite.

Link: https://lkml.kernel.org/r/20240117171058.2192286-2-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -253,6 +253,7 @@ nr_hugepages_tmp=$(cat /proc/sys/vm/nr_h
 # For this test, we need one and just one huge page
 echo 1 > /proc/sys/vm/nr_hugepages
 CATEGORY="hugetlb" run_test ./hugetlb_fault_after_madv
+CATEGORY="hugetlb" run_test ./hugetlb_madv_vs_map
 # Restore the previous number of huge pages, since further tests rely on it
 echo "$nr_hugepages_tmp" > /proc/sys/vm/nr_hugepages
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-hugetlb-restore-the-reservation-if-needed.patch
selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map.patch
selftests-mm-new-test-that-steals-pages.patch

