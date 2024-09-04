Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEE52F34
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725421607; cv=none; b=bOygwwvZrPowVWQ95Es91/YLAANa6+bdFRHbYE81jOm1y3TBxS/+YOvVFkfrMsHXRLx992dDWqiWU7Zi+W4wJtpfqauTrickUwJyoAcew/Nn0h05QKhPN0BA8uEHte95leoaAh6kpUwdYI0tytDNGBl4FYlnV70jiC5faCLzEwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725421607; c=relaxed/simple;
	bh=XAzSfPCoV+3WrEs4eTQ2i0TDiJTOf2dv4d3VllS47JA=;
	h=Date:To:From:Subject:Message-Id; b=pElC4GN92MlBg0wkbgGxueISeOvuxBYF1n5TvYKwdIiAB3v5ypdGbSwpxrDbFpdz5awTmwL6Q/u44cd5NXFHstbp/mFthGaKQCKVCkmpSstAgVskcA/WRe3b7lzG9rl/4vbFTco5bQuKlmv6b3jK1Mt0K+MvMz5wOaYRPNHiXgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v61FTaLp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v61FTaLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CD4C4CEC2;
	Wed,  4 Sep 2024 03:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725421605;
	bh=XAzSfPCoV+3WrEs4eTQ2i0TDiJTOf2dv4d3VllS47JA=;
	h=Date:To:From:Subject:From;
	b=v61FTaLpirzFGmIr1si/x1/QbT0c3AzdE0D6KYzaCkA8HttdT5MQ6OApgwwxJ04KD
	 dAsiuKBBr2puujDn9e+jmHhlfQC8FrRufB6buJGtz3tdh0/73OnnN2bkmWtCX5t2+r
	 D70BtJeHslQJsJP76hzVahrnOFXEYLQDqPY8/eos=
Date: Tue, 03 Sep 2024 20:46:45 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryan.roberts@arm.com,naresh.kamboju@linaro.org,lkft@linaro.org,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,chrisl@kernel.org,anders.roxell@linaro.org,21cnbao@gmail.com,ryncsn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-separate-ssd-allocation-from-scan_swap_map_slots-fix.patch removed from -mm tree
Message-Id: <20240904034645.C3CD4C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: fix array-bounds error with CONFIG_THP_SWAP=n
has been removed from the -mm tree.  Its filename was
     mm-swap-separate-ssd-allocation-from-scan_swap_map_slots-fix.patch

This patch was dropped because it was folded into mm-swap-separate-ssd-allocation-from-scan_swap_map_slots.patch

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

mm-swap-separate-ssd-allocation-from-scan_swap_map_slots.patch
mm-swap-add-a-adaptive-full-cluster-cache-reclaim-fix.patch

