Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325C3F9E8;
	Sun,  1 Dec 2024 02:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733021643; cv=none; b=jWqrN6uyX3REsv4sU+JgB3TmkpQyVsFq1TmEYH3/eq1pT7tqbZBa96KBSgrQKrGxmExxuD/cuK4yZm6VnpQpS7s72zqX7NhIzd1h56CeJ3Ljq1wUC8UBJgNbLn9IHxNwQsUJ3RAdHxh3DGxMomff4KkQWbcE8u/ekZXu3hpclXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733021643; c=relaxed/simple;
	bh=lmfeuP5lb9av1sWuiSW6xlX3b+YRDSd8g69BdxhRgSg=;
	h=Date:To:From:Subject:Message-Id; b=IRkWmGapRQmEcg9gHiACR87XrZH5dF9Fx2HtXKNGy6/2N8wbIzHAsWrEs17SEhem2Fo9azrLCTnjqIznx55ww9tDPXdRpf91RHoyZE95mt45DqfcByHxuUIsU6iceUpELFbqdulwxktgihs+iEewoiWjjDJ8md5G7zUgBK11kcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aIfvMrTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aIfvMrTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1BAC4CECC;
	Sun,  1 Dec 2024 02:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733021642;
	bh=lmfeuP5lb9av1sWuiSW6xlX3b+YRDSd8g69BdxhRgSg=;
	h=Date:To:From:Subject:From;
	b=aIfvMrTutoJiig8yUXmSx8MYFzvYUhjKEcXDxSrJzqrnnlS+oKt/XKEPJqlcztpiw
	 RfGwHlpitpUTKl/OynhK4kcFWvIKqBG86kHxNYNV9Lynqc4SEuemtEw7mCc1vepOMP
	 jr/K7Txw58uBIoQNOlplURSDOKnOrb6Ft4GzoU6w=
Date: Sat, 30 Nov 2024 18:54:01 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,dafna.hirschfeld@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-change-enospc-to-enomem-in-alloc_hugetlb_folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20241201025402.7E1BAC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: change ENOSPC to ENOMEM in alloc_hugetlb_folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-change-enospc-to-enomem-in-alloc_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-change-enospc-to-enomem-in-alloc_hugetlb_folio.patch

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
From: Dafna Hirschfeld <dafna.hirschfeld@intel.com>
Subject: mm/hugetlb: change ENOSPC to ENOMEM in alloc_hugetlb_folio
Date: Sun, 1 Dec 2024 03:03:41 +0200

The error ENOSPC is translated in vmf_error to VM_FAULT_SIGBUS which is
further translated in EFAULT in i.e.  pin/get_user_pages.  But when
running out of pages/hugepages we expect to see ENOMEM and not EFAULT.

Link: https://lkml.kernel.org/r/20241201010341.1382431-1-dafna.hirschfeld@intel.com
Fixes: 8f34af6f93ae ("mm, hugetlb: move the error handle logic out of normal code path")
Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@intel.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-change-enospc-to-enomem-in-alloc_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -3113,7 +3113,7 @@ out_end_reservation:
 	if (!memcg_charge_ret)
 		mem_cgroup_cancel_charge(memcg, nr_pages);
 	mem_cgroup_put(memcg);
-	return ERR_PTR(-ENOSPC);
+	return ERR_PTR(-ENOMEM);
 }
 
 int alloc_bootmem_huge_page(struct hstate *h, int nid)
_

Patches currently in -mm which might be from dafna.hirschfeld@intel.com are

mm-hugetlb-change-enospc-to-enomem-in-alloc_hugetlb_folio.patch

