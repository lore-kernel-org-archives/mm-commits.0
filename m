Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1579115B12F
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714663791; cv=none; b=lLrQpWI34AtH6zbl9oyeTXP8/QAl3ysOjz7Nd0f0sO7u9gbwVyNCW9uqIoiY27OXD9vW2M4DRVYFUGJs2GsuAXlicZmTsUkfxirHtJ84yyCMtVnD6IA2xmzlR/CELfxJI79aDhss6T9XjyOjN4yIYZvDpMb2YLyQLFDO+snyKlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714663791; c=relaxed/simple;
	bh=vuNd3dw9/W0IXuCEuWaLl+LuSExDOLEA9LgKh0kfSRQ=;
	h=Date:To:From:Subject:Message-Id; b=f48KjspTVXuxBMkf8etbxWczy60wS6UUBRV2ZVtV0HX3pnO95Cew2IQKzA41kFu0ctz5HWH35Z3ESd/v4hI/oHUnlQ+S0nrwRPR2c5sFc99rXzD9kS2UCpiaiVgAEPIR7YI5pHH2Oqwsn/YWAPqAJ42/fImZMP5027nYGE1GoBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bcRdVS9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bcRdVS9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F14C113CC;
	Thu,  2 May 2024 15:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714663790;
	bh=vuNd3dw9/W0IXuCEuWaLl+LuSExDOLEA9LgKh0kfSRQ=;
	h=Date:To:From:Subject:From;
	b=bcRdVS9qnUImTzKyLTjN/xz4knttB0Wicg82KV4SjEV9gHEX0To8VXFvNsHuQNWSI
	 kNC7mPL0W3oZAartkjk2FilEMNRr6zwkpwrliR6ihjrmHlNhWWPl4kvfOKlCgC9wfI
	 opAmz/H5ME7Cq3ishIMAnK9IdKuTKN99PXgbeZoU=
Date: Thu, 02 May 2024 08:29:49 -0700
To: mm-commits@vger.kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison.patch added to mm-unstable branch
Message-Id: <20240502152950.64F14C113CC@smtp.kernel.org>
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
Date: Wed, 1 May 2024 17:24:57 -0600

The soft hwpoison injector via madvise(MADV_HWPOISON) operates in a
synchrous way in a sense, the injector is also a process under test, and
should it have the poisoned page mapped in its address space, it should
legitimately get killed as much as in a real UE situation.

Link: https://lkml.kernel.org/r/20240501232458.3919593-3-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
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
mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch

