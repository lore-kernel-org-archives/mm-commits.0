Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DDB7E10B
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 21:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716414575; cv=none; b=Xbo6Jojo3/gOr21gcNzAxTaqNrosVVbpbsWNsfqtvJgl+4KNykJPzgTV4s7XuZNe83SfQZYNWbeABAqvE/ZX9zj8fBRp7/WYXZdEty7Y3A2xdrF3bK52XzxCBFtubNNuEcPZzDP+pLjIyeiKSYfqL3bGp2EtA2bePevnQLpMVY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716414575; c=relaxed/simple;
	bh=SU5r1JGjxbvb9sLdW8YarYmMVlw1QFodC+tey0tlob0=;
	h=Date:To:From:Subject:Message-Id; b=muti5jhykGSEoWBOfeP3T05Z4Welth+PLOqEhpiwvanNpkBpa6YERpuQNungoqRVnMK4wg6dKfEN4vQW0PgZlVS+Z0WUSeWwvkt+/LUOppHoR/KUFFlZNpJMSfYYRJtPAfq2uM3KVVPEpJDjT5yxkB+ONAzIW6ctmTJB3CZuIh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DBJHDiG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DBJHDiG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DD7C2BBFC;
	Wed, 22 May 2024 21:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716414575;
	bh=SU5r1JGjxbvb9sLdW8YarYmMVlw1QFodC+tey0tlob0=;
	h=Date:To:From:Subject:From;
	b=DBJHDiG6o8UBvmdTZV5EXFab8LcuvwkmW72l7Aa11/xxSdLzwrhb/XfUeUwWeB83s
	 +0geM8gWXMniPnHfzu8wk2WhMELUUYEemu5ztdRUXNl+RGhB16Gf4rlxJS+zfr5uzz
	 Rq9CFwFjjX8Auy4o0MglqP/6xus7CSWq4o4s5X0g=
Date: Wed, 22 May 2024 14:49:34 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,oalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison.patch added to mm-unstable branch
Message-Id: <20240522214935.10DD7C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: add MF_ACTION_REQUIRED to madvise(MADV_HWPOISON)
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison.patch

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
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/madvise: add MF_ACTION_REQUIRED to madvise(MADV_HWPOISON)
Date: Tue, 21 May 2024 17:54:26 -0600

The soft hwpoison injector via madvise(MADV_HWPOISON) operates in a
synchrous way in a sense, the injector is also a process under test, and
should it have the poisoned page mapped in its address space, it should
get killed as much as in a real UE situation.  Doing so align with what
the madvise(2) man page says: " "This operation may result in the calling
process receiving a SIGBUS and the page being unmapped."

Link: https://lkml.kernel.org/r/20240521235429.2368017-3-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Oscar Salvador <oalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
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

mm-memory-failure-try-to-send-sigbus-even-if-unmap-failed.patch
mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison.patch
mm-memory-failure-improve-memory-failure-action_result-messages.patch
mm-memory-failure-move-hwpoison_filter-higher-up.patch
mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch

