Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61D012E4D
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 17:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712253274; cv=none; b=RbNg4IAeY/dxNSYFAtK7czmYDMYGkUG62BCAtfFxTaZy+7rej9nBNGl1LelYt81HmzkHlQ1EBnPZIUG42Ie61WSUz37Mnnc+pJv5oggRGC6DrezgCX9iihzkYI2HZ5TcTCUhK9e3fSsesrZAMBazYws8pbYsuy6CIv5OXB6pqhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712253274; c=relaxed/simple;
	bh=qqWbKLJxse4giUT/mvJyFRFk3pzeH+cX4/JMbsF89lQ=;
	h=Date:To:From:Subject:Message-Id; b=IuFvVm9BMpkYbiDU4ZkTrdn2qK1goZEwgDWiLgHUwjG30PCt33TNj3k2noqAP13ledJO48PAufsEvTkkrKQRBt07YAAWzl/4UyyK85mR/VWYfD/Nm1w2zREUuF7CBx0RQz34HZlcOqbjzq1bi2Ny28UvK9CW+EYzLvlfiswX1i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pso8J8xX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pso8J8xX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0C2C433C7;
	Thu,  4 Apr 2024 17:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712253274;
	bh=qqWbKLJxse4giUT/mvJyFRFk3pzeH+cX4/JMbsF89lQ=;
	h=Date:To:From:Subject:From;
	b=Pso8J8xX0cau9ZsZ6o9E1zL/Jo0qHNpxy6BOpZWnh5lU3rbG3Zl0LnYIVGrr8dvnf
	 /NrUowTbqaDeJ5mDpJe0GJmPkKpmAbduW9jLRZvypltYfcApssgR1ou0EzJSiwTQFm
	 IMiXvE/7inNsIarX6QvxA9oEFr0xN2E2WE5FBi+0=
Date: Thu, 04 Apr 2024 10:54:33 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + __mod_memcg_lruvec_state-enhance-diagnostics-fix.patch added to mm-unstable branch
Message-Id: <20240404175434.2A0C2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: __mod_memcg_lruvec_state-enhance-diagnostics-fix
has been added to the -mm mm-unstable branch.  Its filename is
     __mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: __mod_memcg_lruvec_state-enhance-diagnostics-fix
Date: Thu Apr  4 10:51:39 AM PDT 2024

VM_WARN_ON_IRQS_ENABLED is broken

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~__mod_memcg_lruvec_state-enhance-diagnostics-fix
+++ a/mm/memcontrol.c
@@ -864,7 +864,8 @@ void __mod_memcg_lruvec_state(struct lru
 				pr_warn("stat item index: %d\n", idx);
 			break;
 		default:
-			if (VM_WARN_ON_IRQS_ENABLED())
+			VM_WARN_ON_IRQS_ENABLED();
+			if (!irqs_disabled())
 				pr_warn("stat item index: %d\n", idx);
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

