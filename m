Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366681DDEA
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757245; cv=none; b=geF2snFA1ryp6J0k56TK7nyeomiozBySiyYvj3Sh8R5pG1af5TzbotV1xhU+zd6sVKEC74AHt1byyr/b8sE+0jfoFgT7YL4t+6hinicZ3NyN3CNhU9WZ4xAGpMUXVg1IrURd6ujELzHBcG0YHHztq6kXhzMsjlKCSnRXcjwReCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757245; c=relaxed/simple;
	bh=usjudPjV+7M/jo1wlLPA5/kBEGY97iyoWPBPOdndHj4=;
	h=Date:To:From:Subject:Message-Id; b=EeLXhwS7kKXE47pMelCNn4FdMTPBBMYk0Ju0i9Sq0tynS++p7Fi9mXMErujherT6vulEnHOqj9/iF70aWoORJ84tkDZ/5UT4f3i7umr1bAZnIdFAAK+Rexp75WTLsrkL/exCZXbzH6PGmCpj4ce5CRuxtzD3YtXfuv3pQrp2WqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A64uEbnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A64uEbnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADACDC4CECC;
	Thu, 28 Nov 2024 01:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732757244;
	bh=usjudPjV+7M/jo1wlLPA5/kBEGY97iyoWPBPOdndHj4=;
	h=Date:To:From:Subject:From;
	b=A64uEbnI3Q2cD+jM9wEBeEJ+j4yi3sVPsXdPF4VCfFAM/JY60yl7G298MgoEQYH3u
	 LV5mKeyLsKDdsr6UuDOSs1CbDYeY3HfkEmJwqkxGodFKVX/ptoPrTBo+Uh47jmuUjp
	 UT/H0wqkF4ecrQrr6pzSwI/6r8SX8i7Ps4LjfIyM=
Date: Wed, 27 Nov 2024 17:27:24 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,pintu.ping@gmail.com,quic_pintu@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cgroup-avoid-useless-return-in-void-function.patch added to mm-unstable branch
Message-Id: <20241128012724.ADACDC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_cgroup: avoid useless return in void function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_cgroup-avoid-useless-return-in-void-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cgroup-avoid-useless-return-in-void-function.patch

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
From: Pintu Kumar <quic_pintu@quicinc.com>
Subject: mm/hugetlb_cgroup: avoid useless return in void function
Date: Fri, 22 Nov 2024 23:05:58 +0530

The return statement at the end of void function is unnecessary.  Just
remove it as part of cleanup.

Link: https://lkml.kernel.org/r/20241122173558.20670-1-quic_pintu@quicinc.com
Signed-off-by: Pintu Kumar <quic_pintu@quicinc.com>
Cc: Pintu Agarwal <pintu.ping@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-avoid-useless-return-in-void-function
+++ a/mm/hugetlb_cgroup.c
@@ -917,7 +917,6 @@ void hugetlb_cgroup_migrate(struct folio
 	set_hugetlb_cgroup_rsvd(new_folio, h_cg_rsvd);
 	list_move(&new_folio->lru, &h->hugepage_activelist);
 	spin_unlock_irq(&hugetlb_lock);
-	return;
 }
 
 static struct cftype hugetlb_files[] = {
_

Patches currently in -mm which might be from quic_pintu@quicinc.com are

mm-hugetlb_cgroup-avoid-useless-return-in-void-function.patch

