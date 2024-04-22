Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165941CF9B
	for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2024 22:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713823431; cv=none; b=PMuEq0q3rEpadUD3ixUEcnW+MGXrTuuaB8RHBMMRY2p1yrb0SFLnrp37IPRs4nmI36mKSH/fqqHIXyHtI2uLjFUZ/VU54ziKVJOUwvC1eWRh3vbJhe7P+NktRizSCZkybRzrURy/MllSTLmtgCXvrCvpDvxCm/oBtPdMFHhIfB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713823431; c=relaxed/simple;
	bh=3XTL5Zi3x+p1XpKnE/1MQ7gV2zS1MfO2HOz8vkkzaoE=;
	h=Date:To:From:Subject:Message-Id; b=XzvwDba4Dl9HiVU+p70e+SEVnksNMobxyIQLBVsy6YOgRr9E3mmbuxfuQjms1xe9rox1xqLQvX2qcWizx0XsqWyYmK86RUkNCVvlgQ1Do6pQjSaH51bcaeG9eAke+yrxZI1rWddMB40Y4PFBiXj7f8EA6mjuaXYbvKg5CxcOYx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rkJefxH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rkJefxH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751E8C113CC;
	Mon, 22 Apr 2024 22:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713823430;
	bh=3XTL5Zi3x+p1XpKnE/1MQ7gV2zS1MfO2HOz8vkkzaoE=;
	h=Date:To:From:Subject:From;
	b=rkJefxH5/ha1JerwcD0C8i8G1vauwxnc0HB8qzLQJwz3X/4E0tuRH1g2NM5qwUwez
	 0Vb3K/q28jyijPbVpmZ3vluY5Mkrv2FJORIpxQhhDWKkHcCONfWNW8nZvI5IwJOQV8
	 eQvfYtkcB9p4eyKyCigrqgkLczU3HG43TUqi04SA=
Date: Mon, 22 Apr 2024 15:03:49 -0700
To: mm-commits@vger.kernel.org,viro@ZenIV.linux.org.uk,keescook@chromium.org,jcmvbkbc@gmail.com,jack@suse.cz,ebiederm@xmission.com,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch added to mm-nonmm-unstable branch
Message-Id: <20240422220350.751E8C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch

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
Subject: binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes
Date: Mon Apr 22 03:02:28 PM PDT 2024

WARNING: braces {} are not necessary for single statement blocks
#122: FILE: fs/binfmt_elf_fdpic.c:651:
+	if (bprm->have_execfd) {
+		NEW_AUX_ENT(AT_EXECFD, bprm->execfd);
+	}

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/fs/binfmt_elf_fdpic.c~binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes
+++ a/fs/binfmt_elf_fdpic.c
@@ -640,17 +640,12 @@ static int create_elf_fdpic_tables(struc
 	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) from_kgid_munged(cred->user_ns, cred->egid));
 	NEW_AUX_ENT(AT_SECURE,	bprm->secureexec);
 	NEW_AUX_ENT(AT_EXECFN,	bprm->exec);
-	if (k_platform) {
-		NEW_AUX_ENT(AT_PLATFORM,
-			    (elf_addr_t)(unsigned long)u_platform);
-	}
-	if (k_base_platform) {
-		NEW_AUX_ENT(AT_BASE_PLATFORM,
-			    (elf_addr_t)(unsigned long)u_base_platform);
-	}
-	if (bprm->have_execfd) {
+	if (k_platform)
+		NEW_AUX_ENT(AT_PLATFORM, (elf_addr_t)(unsigned long)u_platform);
+	if (k_base_platform)
+		NEW_AUX_ENT(AT_BASE_PLATFORM, (elf_addr_t)(unsigned long)u_base_platform);
+	if (bprm->have_execfd)
 		NEW_AUX_ENT(AT_EXECFD, bprm->execfd);
-	}
 #undef NEW_AUX_ENT
 	/* AT_NULL is zero; clear the rest too */
 	memset(elf_info, 0, (char *)mm->saved_auxv +
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

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
binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch

