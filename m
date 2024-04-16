Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35349137C23
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 18:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293446; cv=none; b=dcc3XhwPKQE/oSbwym+LvUUJJ1hXZ7EdnTvIP1kqJaTvkrFzbVyjAqr2cHYtYasV+FCqm8SIwi2yKqAVjwK21lVF6mELLISDUa+Ar2ZFMfuu81OprYEl+j46T8Ek0hoZaVzxGa9eLO3ogURUlnxPEQArpyr6a70A4OsFj3NAtyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293446; c=relaxed/simple;
	bh=ioCnEat9P/mSDKSO2U3a5wtN07h3JtzZu/G7hNiAsUQ=;
	h=Date:To:From:Subject:Message-Id; b=ZyuRXApL8gnjLOPjZd5CdGJuMgr2ffKd6brlgxXLWlk7cPSFxd3MTeo4hEwRZsbPufW+VXiXL7odT5HI+iQwUllosytKf5e/ldq9b1t3B0ah6Va6cqg5uLbsWGdbA+jitT5MKQ/cufiG1sK7Vt9FfIOH1Mu4NHXMDMiGI3JYLBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PLW+J+Dw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PLW+J+Dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E61C113CE;
	Tue, 16 Apr 2024 18:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713293445;
	bh=ioCnEat9P/mSDKSO2U3a5wtN07h3JtzZu/G7hNiAsUQ=;
	h=Date:To:From:Subject:From;
	b=PLW+J+DwpbuwN+5kYJE8TXgNC1NB4PbFpOOOt1Lc7oo11efd88MLSb8HLyFZkpYwZ
	 IaOCJiIYVHCv1qg89+UIz9WmOMcuEy1p3GeUKKX0aN5hWOPYShtat10LZYNJJPnnl+
	 8j7BmyFg9iq+IbcU5xOg2D9Re3sWIErJG8AmZ3GI=
Date: Tue, 16 Apr 2024 11:50:45 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,qiang4.zhang@intel.com,mhiramat@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20240416185045.96E61C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy-fix
Date: Tue Apr 16 11:47:35 AM PDT 2024

fix kerneldoc

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Qiang Zhang <qiang4.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/bootconfig.c~bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy-fix
+++ a/lib/bootconfig.c
@@ -901,7 +901,8 @@ static int __init xbc_parse_tree(void)
 }
 
 /**
- * xbc_exit() - Clean up all parsed bootconfig
+ * _xbc_exit() - Clean up all parsed bootconfig
+ * @early: in early xbc init error
  *
  * This clears all data structures of parsed bootconfig on memory.
  * If you need to reuse xbc_init() with new boot config, you can
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2-fix.patch
bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy-fix.patch
selftests-harness-remove-use-of-line_max-fix.patch
selftests-harness-remove-use-of-line_max-fix-fix.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

