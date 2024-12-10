Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5082E433CE
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 03:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733800075; cv=none; b=YtYC/BfXxMZlR5NfCqqfl3YJbKHuPJRp5QcHOXPVU3gzeSLglhC+pCo2gK+dC6W2BzrD6xkMbaOWk5QQPced7VjFT1XqmQoMgAv6yYOM1NsFfx9RvgDtm0Pb75acI3bp36rQ/uyhgVZtgPpFXgsjmbz1FZ++n94JOssVtCZle0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733800075; c=relaxed/simple;
	bh=az/H3mWUtqZuetEKV1lOceF/+hlgZpQjhX07QKsW8t0=;
	h=Date:To:From:Subject:Message-Id; b=aspViguOvewL/16KxfnGngfCQtjz1JPv4n+X549kIUixMu5Jl1wOfDr+m5pI4otQft5DSzah72m8d2GHwWpQ4BwzltX4mONeJ0bxJ0dbKoS87rywCa09SH5iN5VW314sPkPE+XxuBlolXyLKG3l4Yii85MfUtBaHxTG9s6qskkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WrCCsDJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WrCCsDJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0445C4CEDE;
	Tue, 10 Dec 2024 03:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733800074;
	bh=az/H3mWUtqZuetEKV1lOceF/+hlgZpQjhX07QKsW8t0=;
	h=Date:To:From:Subject:From;
	b=WrCCsDJ1tUrI0kgnALSxURlQiPIEAlTs/4KaJS6nFGFU8j7ducwVOqxfo7P37Jdsg
	 5pDgtSYYh1rvz03Xzwqzrq9jEBpkm23WVSUswzi1jq+T+UZk4kFy/3xe/ijp6l5apv
	 oE4CYy3a3IAJzaZbGtIA/6rRc+k171eWD6QqrXfc=
Date: Mon, 09 Dec 2024 19:07:54 -0800
To: mm-commits@vger.kernel.org,tamird@gmail.com,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-port-tests-to-kunit-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20241210030754.D0445C4CEDE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray-port-tests-to-kunit-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xarray-port-tests-to-kunit-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-port-tests-to-kunit-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: xarray-port-tests-to-kunit-fix
Date: Mon Dec  9 07:06:54 PM PST 2024

Fix cocci warning:

lib/test_xarray.c:1019:52-53: WARNING comparing pointer to 0

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412081700.YXB3vBbg-lkp@intel.com/
Cc: Tamir Duberstein <tamird@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_xarray.c~xarray-port-tests-to-kunit-fix
+++ a/lib/test_xarray.c
@@ -1016,7 +1016,7 @@ static noinline void check_xa_alloc_1(st
 
 	XA_BUG_ON(xa, xa_alloc(xa, &id, xa_mk_index(10), XA_LIMIT(10, 5),
 				GFP_KERNEL) != -EBUSY);
-	XA_BUG_ON(xa, xa_store_index(xa, 3, GFP_KERNEL) != 0);
+	XA_BUG_ON(xa, xa_store_index(xa, 3, GFP_KERNEL) != NULL);
 	XA_BUG_ON(xa, xa_alloc(xa, &id, xa_mk_index(10), XA_LIMIT(10, 5),
 				GFP_KERNEL) != -EBUSY);
 	xa_erase_index(test, xa, 3);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
xarray-port-tests-to-kunit-fix.patch

