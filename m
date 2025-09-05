Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECCCEEBD
	for <mm-commits@vger.kernel.org>; Fri,  5 Sep 2025 03:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757042362; cv=none; b=e2htKYZIJPlHxvPZBCQtIwxHfGOp3FCFoYWiER/R9RyhEtmK5BwIYoHctvzD5teAf9FzR2+II97gF/b8caSht9azSjoLkFO5A7njZL23NzDMnQ22No0tZqCQ+g/bWXwPek290bKx4PDPGXrSMR7kxuiQzY5Upqilppdlg4prcdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757042362; c=relaxed/simple;
	bh=Q5lK6eqBCmJCFsFehEO3AuXetB9mvzPfn51anU+bvks=;
	h=Date:To:From:Subject:Message-Id; b=LYD4idLGxcfqNuoY5ZES8UebVnhav4Fcbeon/MQ0zi1zVXx0zXv2mna2qPGYVpQJIPl/aIAkLCj/C/IC80rgvHGDuWK6QT3sljGhwmY6MYxYx5wqAjN4zM4t6tC5AjQ+e4DhcYq3eafNcr2XADzWhUA/qbFsa3KYGQBZI/2CB+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AucZnG0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AucZnG0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A26C4CEF0;
	Fri,  5 Sep 2025 03:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757042362;
	bh=Q5lK6eqBCmJCFsFehEO3AuXetB9mvzPfn51anU+bvks=;
	h=Date:To:From:Subject:From;
	b=AucZnG0Ss3x+zar7PMBwkAwL2jnYoSGqgDzvEHRylYr+qIZbPMbPZeVYHIM18lqNx
	 sgmRIxWX//7mFt+RpwdwPs2dt9Y5DnolGkXoQAnmxXijpBqlUdGr3Ga1rE5Lcu2hr+
	 jcJwQx/TYOtVPsf+qPsFOsvXVxBArItoc7RjzNbA=
Date: Thu, 04 Sep 2025 20:19:20 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,tglx@linutronix.de,mingo@redhat.com,hpa@zytor.com,fuqiang.wang@easystack.cn,dyoung@redhat.com,coxu@redhat.com,bp@alien8.de,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-add-kunit-tests-for-crash_exclude_mem_range-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250905031921.E0A26C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash-add-kunit-tests-for-crash_exclude_mem_range-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-add-kunit-tests-for-crash_exclude_mem_range-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-add-kunit-tests-for-crash_exclude_mem_range-fix.patch

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
Subject: crash-add-kunit-tests-for-crash_exclude_mem_range-fix
Date: Thu Sep  4 08:07:47 PM PDT 2025

export crash_exclude_mem_range() to modules, for kernel/crash_core_test.c

Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: fuqiang wang <fuqiang.wang@easystack.cn>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/crash_core.c~crash-add-kunit-tests-for-crash_exclude_mem_range-fix
+++ a/kernel/crash_core.c
@@ -338,6 +338,7 @@ int crash_exclude_mem_range(struct crash
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crash_exclude_mem_range);
 
 ssize_t crash_get_memory_size(void)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
panic-remove-redundant-panic-cpu-backtrace-fix.patch
crash-add-kunit-tests-for-crash_exclude_mem_range-fix.patch

