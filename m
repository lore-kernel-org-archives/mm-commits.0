Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D363125D6
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 02:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743647648; cv=none; b=N1Wz7mo2L831JjIy25iFpiItd4Bm33oUOWc8grrsyoYUhavl7RwocK6/DRkm6MIK4BM9CRD5fODluGzPDczK1LX/MHfnfkqGzCq1pIHFWIbBfyhgSSGfoLne2Yq844R4QP5REVVJZYSrpG3EykDBevalYRyMBMY3Dk4eI7fIrLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743647648; c=relaxed/simple;
	bh=GXFiotoMwlfthRCpVtSCxYMzgk1MNktPbudheLMPv1s=;
	h=Date:To:From:Subject:Message-Id; b=DRGjZFUsHdiiH/LiSQYTRr/y7GZrOli+Xo1udBLtPQOM82TciGhgpv4NZBJOinRSInW0AjSPqYkhYoS65ZbWyhC5+a/5qS5hleE56SSqVFefXLeoCrZZ1AF0LEg9gvEk1DkOd6BdzO6xJUSfq3rRCp3b6Cp3WGNiy5cQB0RNT4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C4GJZYcl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C4GJZYcl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC6EC4CEDD;
	Thu,  3 Apr 2025 02:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743647647;
	bh=GXFiotoMwlfthRCpVtSCxYMzgk1MNktPbudheLMPv1s=;
	h=Date:To:From:Subject:From;
	b=C4GJZYclAcmES3QtXjVbK3e2kOcEVfw/BKPSM8N8xGEH/WDej4xK+6ibTpP+wWgkH
	 qPs0CnutFNLze+8AqjlKJeaOs5ATofFtrRuL8TsYBbaWIj+beD2RXnsEmZwxriwVNA
	 p3MzQ2RwmijDNtgMXd0X3damhznv/DerkuWUhE5U=
Date: Wed, 02 Apr 2025 19:34:07 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,ying.huang@linux.alibaba.com,vishal.moola@gmail.com,songmuchun@bytedance.com,pankaj.gupta@amd.com,osalvador@suse.de,anshuman.khandual@arm.com,liusongtang@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-redundant-read_once.patch added to mm-new branch
Message-Id: <20250403023407.BAC6EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: remove redundant READ_ONCE
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-remove-redundant-read_once.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-redundant-read_once.patch

This patch will later appear in the mm-new branch at
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
From: Songtang Liu <liusongtang@bytedance.com>
Subject: mm: page_alloc: remove redundant READ_ONCE
Date: Wed, 2 Apr 2025 03:41:16 -0400

In the current code, batch is a local variable, and it cannot be
concurrently modified.  It's unnecessary to use READ_ONCE here, so remove
it.

Link: https://lkml.kernel.org/r/CAA=HWd1kn01ym8YuVFuAqK2Ggq3itEGkqX8T6eCXs_C7tiv-Jw@mail.gmail.com
Fixes: 51a755c56dc0 ("mm: tune PCP high automatically")
Signed-off-by: Songtang Liu <liusongtang@bytedance.com>
Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-redundant-read_once
+++ a/mm/page_alloc.c
@@ -2634,7 +2634,7 @@ static void free_frozen_page_commit(stru
 		free_high = (pcp->free_count >= batch &&
 			     (pcp->flags & PCPF_PREV_FREE_HIGH_ORDER) &&
 			     (!(pcp->flags & PCPF_FREE_HIGH_BATCH) ||
-			      pcp->count >= READ_ONCE(batch)));
+			      pcp->count >= batch));
 		pcp->flags |= PCPF_PREV_FREE_HIGH_ORDER;
 	} else if (pcp->flags & PCPF_PREV_FREE_HIGH_ORDER) {
 		pcp->flags &= ~PCPF_PREV_FREE_HIGH_ORDER;
_

Patches currently in -mm which might be from liusongtang@bytedance.com are

mm-page_alloc-remove-redundant-read_once.patch

