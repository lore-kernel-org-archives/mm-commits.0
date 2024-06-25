Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D417142E81
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291575; cv=none; b=jBJdzbaycgDayRkyq8Y8R8HNovCcFNCZNEDr3N5MMXasGqPYvG3HMKgXD1O7cQg9wTlrQ5tv2R9ATQ2iKE+Fex4fE6id/pl6kiKoOO23GNnFKxJ2rWBdFMNaEACzLBAJpr5xJsYfSImGJJzvFUiecGsrorQJIxIHi1eDRA5mL0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291575; c=relaxed/simple;
	bh=0oj2cI5zq1htHg9tEfvj4KnFCMF6ibM4tXEqJbw6orQ=;
	h=Date:To:From:Subject:Message-Id; b=SQZoxjsqPj7SZHYpAXZMWY16xO6perL1P0W8fJqAIvxW2bAoaE1TxwvTWb1OsAijifn3f9TuWlfnEVCl5XM8gt0hpa2Q8vGngumLhAqi7/vkIY9Qr3sfVUg8XEfrWyCOJGsatADno9XtF4ZfH0+8YOEOks2OgwqllONrHCzhvwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lPwPPOp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lPwPPOp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60382C32782;
	Tue, 25 Jun 2024 04:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291575;
	bh=0oj2cI5zq1htHg9tEfvj4KnFCMF6ibM4tXEqJbw6orQ=;
	h=Date:To:From:Subject:From;
	b=lPwPPOp6wDA94TNh4stCxhUWHeIEXL1hoyZCh9NRbX6mwG/fLZp4THU/en7Hm/jTn
	 qpd2IQp/glpLGUoaBk4es+XRg+mcOG+dNcogfQdcABRhMWkPt97Hnefpd84Pl6SlT7
	 x2JYHpWRayA1mlg7kxbgXbxtxbXcqsCr2fBmwc48=
Date: Mon, 24 Jun 2024 21:59:34 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,oalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison.patch removed from -mm tree
Message-Id: <20240625045935.60382C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: add MF_ACTION_REQUIRED to madvise(MADV_HWPOISON)
has been removed from the -mm tree.  Its filename was
     mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/madvise: add MF_ACTION_REQUIRED to madvise(MADV_HWPOISON)
Date: Fri, 24 May 2024 15:53:03 -0600

The soft hwpoison injector via madvise(MADV_HWPOISON) operates in a
synchrous way in a sense, the injector is also a process under test, and
should it have the poisoned page mapped in its address space, it should
get killed as much as in a real UE situation.  Doing so align with what
the madvise(2) man page says: " "This operation may result in the calling
process receiving a SIGBUS and the page being unmapped."

Link: https://lkml.kernel.org/r/20240524215306.2705454-3-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Oscar Salvador <oalvador@suse.de>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison
+++ a/mm/madvise.c
@@ -1147,7 +1147,7 @@ static int madvise_inject_error(int beha
 		} else {
 			pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
-			ret = memory_failure(pfn, MF_COUNT_INCREASED | MF_SW_SIMULATED);
+			ret = memory_failure(pfn, MF_ACTION_REQUIRED | MF_COUNT_INCREASED | MF_SW_SIMULATED);
 			if (ret == -EOPNOTSUPP)
 				ret = 0;
 		}
_

Patches currently in -mm which might be from jane.chu@oracle.com are


