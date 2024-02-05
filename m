Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1D413B28B
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 21:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707166885; cv=none; b=ABLVSMshIXsjBleXFizjOWRqx9/xL7qPVpQ/5bCI3muA7eLuDXU0nrxC34Mw5F+KsTDJpEiUt/kdbe6DfddrpYrkOUkdTSLj1HaEFP/Xf2NJ1tKFlyMjzYRvfAHpJun4vtL+8I1oKYBXJizjEZ/VkVojzkaKYIt0+gBgwmLdrrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707166885; c=relaxed/simple;
	bh=KPfztp/ge2utpLYevkYhHkAe7QFy8dsB733FTPjSdTc=;
	h=Date:To:From:Subject:Message-Id; b=qYqxqDf3zNi45W8elNiZUTRXJiOUHxDD7+vNggV6xseyZ1AsS904Lx4bxGsCt3f82cmwvLDDmZML8noNr2LKI4P08E/kY12mkWvNT4ebDLKWi2E6y5NLCepbHwNK3hSH36zORQvrHw+gwFUaorUooU0sQcXpsWrist5xIm3uRiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CKkK7Im9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CKkK7Im9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE580C433C7;
	Mon,  5 Feb 2024 21:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707166885;
	bh=KPfztp/ge2utpLYevkYhHkAe7QFy8dsB733FTPjSdTc=;
	h=Date:To:From:Subject:From;
	b=CKkK7Im9jLb06DjCpjY0hF876B2nI6sZMwVQRJx6TTKxCpwbjTm+LmR0WXiQ+BeJH
	 AviZw33/fA1XPNj24u2RWz0vIT3UvGMdbs7BV2iVuIKGaNjpxtvy7z6LOrUkGFpNo3
	 tdiSPFTDGye5dbDbUmXzdgzK1j1V65K0T8Udtls4=
Date: Mon, 05 Feb 2024 13:01:24 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,muchun.song@linux.dev,mhocko@kernel.org,lstoakes@gmail.com,hannes@cmpxchg.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map.patch added to mm-unstable branch
Message-Id: <20240205210124.DE580C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: run_vmtests.sh: add hugetlb_madv_vs_map
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: selftests/mm: run_vmtests.sh: add hugetlb_madv_vs_map
Date: Mon, 5 Feb 2024 11:18:42 -0800

hugetlb_madv_vs_map selftest was not part of the mm test-suite since we
didn't have a fix for the problem it found.

Now that the problem is already fixed (see previous commit), let's enable
this selftest in the default test-suite.

Link: https://lkml.kernel.org/r/20240205191843.4009640-3-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -264,6 +264,7 @@ nr_hugepages_tmp=$(cat /proc/sys/vm/nr_h
 # For this test, we need one and just one huge page
 echo 1 > /proc/sys/vm/nr_hugepages
 CATEGORY="hugetlb" run_test ./hugetlb_fault_after_madv
+CATEGORY="hugetlb" run_test ./hugetlb_madv_vs_map
 # Restore the previous number of huge pages, since further tests rely on it
 echo "$nr_hugepages_tmp" > /proc/sys/vm/nr_hugepages
 
_

Patches currently in -mm which might be from leitao@debian.org are

selftests-mm-new-test-that-steals-pages.patch
selftests-mm-run_vmtestssh-add-hugetlb-test-category.patch
mm-hugetlb-restore-the-reservation-if-needed.patch
selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map.patch

