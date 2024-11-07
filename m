Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC1B21766E
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731019125; cv=none; b=nitBwb7Yy4xX5Oavlzn7DU7bE5P4Skgjwukt2cu4eD3eVX21Rk7aTdv2n5+sV5Eo/iWvQH6qHS02wcYOug8EhNV4BNcgJ+clRl17iKOSO3Idnun5+OHWimXTugxYsh366V4TRzVJPoSS+VkKnfUcWQeqnocpQESFvy3KLBXQqj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731019125; c=relaxed/simple;
	bh=PJ5Cp+ZUG+PmYOPFjfBALgt7VNSdY5HSF8DkdEq+nVM=;
	h=Date:To:From:Subject:Message-Id; b=U7eRlxlWWnkETiu73rZCI83Ckje0c5JzwxtW2FWpg2wD+GdmtgAe45ODBcua2OmsOZ6nTREjTP/EPl/rg9kl4OQAOITL9mv10HMM+mklQmaSjoaDRnfbbLFJzfuoCU9iyB9S/sfy+HwutPQ7+tJC2i81XNulYlu85tJtDjHdQ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DZMSotiR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DZMSotiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D43C4CECC;
	Thu,  7 Nov 2024 22:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731019125;
	bh=PJ5Cp+ZUG+PmYOPFjfBALgt7VNSdY5HSF8DkdEq+nVM=;
	h=Date:To:From:Subject:From;
	b=DZMSotiRS1KpKq4LCPIi06TxbmatqqlVZuAwi2Q6vmPYI4sA0uU1EJy81DVkWrffa
	 h8oW/M7yhp44LBv6Jz/X5B1ZR19ocPqDZvyOHB+PHEYGWTE5HZXbbrIVWh/8IB1fc9
	 rB2w79vUEnF0FcLilWa2biTVCSo9FRTU6+vfsUoM=
Date: Thu, 07 Nov 2024 14:38:44 -0800
To: mm-commits@vger.kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-show_mem-use-str_yes_no-helper-in-show_free_areas.patch removed from -mm tree
Message-Id: <20241107223845.44D43C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/show_mem: use str_yes_no() helper in show_free_areas()
has been removed from the -mm tree.  Its filename was
     mm-show_mem-use-str_yes_no-helper-in-show_free_areas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/show_mem: use str_yes_no() helper in show_free_areas()
Date: Sat, 26 Oct 2024 12:35:53 +0200

Remove hard-coded strings by using the str_yes_no() helper function.

Link: https://lkml.kernel.org/r/20241026103552.6790-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/show_mem.c~mm-show_mem-use-str_yes_no-helper-in-show_free_areas
+++ a/mm/show_mem.c
@@ -285,8 +285,7 @@ static void show_free_areas(unsigned int
 #endif
 			K(node_page_state(pgdat, NR_PAGETABLE)),
 			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
-			pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ?
-				"yes" : "no");
+			str_yes_no(pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES));
 	}
 
 	for_each_populated_zone(zone) {
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are


