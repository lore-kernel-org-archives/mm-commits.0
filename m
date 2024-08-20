Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7960C44C77
	for <mm-commits@vger.kernel.org>; Tue, 20 Aug 2024 05:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724130358; cv=none; b=Jv3bVAsl0Ld+NoT1cEYfcE0r4fiZWDvA5bJofz6hKXbw+ny3WyNP41ZvQKNtAow2OJ3xQpoBwvO3zsEjClFmu9ZI6bb/w4xcx57ygD83zUneIcdAekgkHc4yYc7kEarJwi/STR+jhbdM27uWNdP0geeYXpmpOTudQ8damR4U4IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724130358; c=relaxed/simple;
	bh=xDMW/A2k9xfsdhu/GkrRl7vfIiq2ehoywpnXnXCvYAU=;
	h=Date:To:From:Subject:Message-Id; b=SmATRxVDSTJlPdyQ73GkQ3fykd1hRp2lxFM5TmUjYdULYIPAeiLz+3+lbDtzxxtAsRhItEeo1vnxko38Iz5TTmxGfQva2Q4QKYCYFZfqTLf/u/JSVGJNDak/Jo4ek50GTVZVQIi9L1fRDfgm0qEMvSkBP9lvVzG1pdRuyUTaAjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xyvbjX7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xyvbjX7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17452C4AF09;
	Tue, 20 Aug 2024 05:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724130358;
	bh=xDMW/A2k9xfsdhu/GkrRl7vfIiq2ehoywpnXnXCvYAU=;
	h=Date:To:From:Subject:From;
	b=xyvbjX7uIqpvqDvVoIJI2XKce86h0jeY3memi4HdG9okeo3PzWvryx2GGKR1BF1zZ
	 Lem81Za1FtBrnigZFKGbJAKfQT5GYS5a7eSzS9EhpMu3R/2+igEPj/11hH7RHWOatH
	 VU5G3p1F8jmVZF3AhoAgedAVNfpRquJHVoQiMOho=
Date: Mon, 19 Aug 2024 22:05:57 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryan.roberts@arm.com,naresh.kamboju@linaro.org,lkft@linaro.org,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,chrisl@kernel.org,anders.roxell@linaro.org,21cnbao@gmail.com,ryncsn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-separate-ssd-allocation-from-scan_swap_map_slots-fix.patch added to mm-unstable branch
Message-Id: <20240820050558.17452C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: fix array-bounds error with CONFIG_THP_SWAP=n
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-separate-ssd-allocation-from-scan_swap_map_slots-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-separate-ssd-allocation-from-scan_swap_map_slots-fix.patch

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
From: Kairui Song <ryncsn@gmail.com>
Subject: mm: swap: fix array-bounds error with CONFIG_THP_SWAP=n
Date: Mon, 19 Aug 2024 19:44:25 +0800

Link: https://lkml.kernel.org/r/CAMgjq7Bz0DY+rY0XgCoH7-Q=uHLdo3omi8kUr4ePDweNyofsbQ@mail.gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Closes: https://lkml.kernel.org/r/CA+G9fYuFDon59=Nw6WCdgp0FanZ1oE3dCkoq71EK0Bxe6Jhe_g@mail.gmail.com
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-separate-ssd-allocation-from-scan_swap_map_slots-fix
+++ a/mm/swapfile.c
@@ -659,7 +659,7 @@ new_cluster:
 	if (order)
 		goto done;
 
-	for (int o = 1; o < PMD_ORDER; o++) {
+	for (int o = 1; o < SWAP_NR_ORDERS; o++) {
 		if (!list_empty(&si->nonfull_clusters[o])) {
 			ci = list_first_entry(&si->nonfull_clusters[o], struct swap_cluster_info,
 					      list);
_

Patches currently in -mm which might be from ryncsn@gmail.com are

mm-swap-separate-ssd-allocation-from-scan_swap_map_slots-fix.patch
mm-swap-add-a-adaptive-full-cluster-cache-reclaim-fix.patch

