Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4003742069
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 23:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738969639; cv=none; b=MIHqZ8V0xa/yxU1oTiie5qrhh6Bmg02mtnylNtczfXvDeoVyVyROkmU9CLhF4DJXauHdGmJHfXJVWyrkWWZ7q+38+onYF2+jQ4Jyj/oUgp245q3isL6fR4bkicdBbyxAZvklIsh+cYV8MBPRwXbrBdzRKLVd8PT9ARLH9HKVdL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738969639; c=relaxed/simple;
	bh=ygqs+/yV+BKstdD0l07glfFNA4L+OkC72VakwspFJaQ=;
	h=Date:To:From:Subject:Message-Id; b=elYCcBgwwN9r5vcRj4u9xqw9ejiHe4Uvi5iKvd271QCQM0jGmOv7n3ycgtBGgBOS7ThpTaBhi+4xmWaLeNjIjuCqwdB+Gt4lwMkV2HXtjC914YTd/Je0yKkui15PYjGGzAKDwZuEnSEc7IgBC7ySUY2s0I0bT6dGi0bGcLZOvMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vs8ABZ4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vs8ABZ4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AB1C4CED1;
	Fri,  7 Feb 2025 23:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738969636;
	bh=ygqs+/yV+BKstdD0l07glfFNA4L+OkC72VakwspFJaQ=;
	h=Date:To:From:Subject:From;
	b=Vs8ABZ4D3d2nsFpBnQ9l6sNOXwrHa8BLLa58g032IiPZ7Jx8jBuXUuWQ609y5W31z
	 /H5PrHYXM8IuW+d/BQyVyfIGRNRlQFgniEQrUh9lsoVLnLdpU3hb5F7ORaaM5lhIg0
	 sMkZHyZhm/yuZC1UcJXp0yAHnE82MDaJsICEMpeQ=
Date: Fri, 07 Feb 2025 15:07:16 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-add-kexec-handover-kho-generation-helpers-fix.patch added to mm-unstable branch
Message-Id: <20250207230716.C9AB1C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: make kho_reserve_scratch __init
has been added to the -mm mm-unstable branch.  Its filename is
     kexec-add-kexec-handover-kho-generation-helpers-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-add-kexec-handover-kho-generation-helpers-fix.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho: make kho_reserve_scratch __init
Date: Fri, 7 Feb 2025 09:57:09 +0200

Link: https://lkml.kernel.org/r/Z6W90hz6WaXfZCjQ@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kexec_handover.c~kexec-add-kexec-handover-kho-generation-helpers-fix
+++ a/kernel/kexec_handover.c
@@ -396,7 +396,7 @@ static phys_addr_t __init scratch_size(i
  * active. This CMA region will only be used for movable pages which are not a
  * problem for us during KHO because we can just move them somewhere else.
  */
-static void kho_reserve_scratch(void)
+static void __init kho_reserve_scratch(void)
 {
 	phys_addr_t addr, size;
 	int nid, i = 1;
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch
memblock-add-memblock_rsrv_kern-flag.patch
memblock-introduce-memmap_init_kho_scratch.patch
kexec-add-kexec-handover-kho-generation-helpers-fix.patch
kexec-add-kho-parsing-support-fix.patch
x86-setup-use-memblock_reserve_kern-for-memory-used-by-kernel.patch
documentation-kho-add-memblock-bindings.patch

