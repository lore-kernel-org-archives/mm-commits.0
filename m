Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6726414EC4C
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 17:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714153785; cv=none; b=RypAIaFLPGxeP6yE650pCCSowaQBjMPlBJFY+6FGj0FOmc45bZNftOd2Z19e3oJ1B35z1s5+73LC9zoPELJAgzBLQxZA9T32TkFVwdMlGmXCouu9uI4cXf3kf+Ij8r91tidnoaePGe9EKmsB7YdT0t7bWEDq+nvuT0c6z/DD6kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714153785; c=relaxed/simple;
	bh=AR0H8azY/ZVsstpeWcblC3MqvupeJVjWvhmQ1Yr3lPU=;
	h=Date:To:From:Subject:Message-Id; b=mJFej48QMMX4mhu3uyzZWHAaYJz7/CCWxhIySzE3UXG1NPxosV6ov5puZg++w9AMnWCW3t+bLiXatrXR3uqdmgXUxUa1fagaKiJbXCyvktRd96Ao9R1JZDJS90NopOKgSlQRr3RqNtokYRwKvXYn6AbDR/Ci6w14lPp7YrSlfuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X8mcs2lF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X8mcs2lF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AB8C113CD;
	Fri, 26 Apr 2024 17:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714153784;
	bh=AR0H8azY/ZVsstpeWcblC3MqvupeJVjWvhmQ1Yr3lPU=;
	h=Date:To:From:Subject:From;
	b=X8mcs2lFXr9Tp7jEtQvW+DNJ+gCjo+twm/hqnNSlmD2Mwd97nUDJ4B8gDOY/cQhTv
	 x3zb9dHpV8A6LaV1IIPC2GCp3GFL9BZDI2ytYhb/TvK3UC/kYZZtR8tvzqcJzV2Bm3
	 cfdgPgiHk2ZfskK79WmRINJD4aYbpHCttZF2o/TA=
Date: Fri, 26 Apr 2024 10:49:44 -0700
To: mm-commits@vger.kernel.org,viro@ZenIV.linux.org.uk,keescook@chromium.org,jcmvbkbc@gmail.com,jack@suse.cz,ebiederm@xmission.com,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20240426174944.C5AB8C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch

This patch was dropped because it was folded into binfmt_elf_fdpic-fix-proc-pid-auxv.patch

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

arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
doc-split-bufferrst-out-of-api-summaryrst-fix-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
binfmt_elf_fdpic-fix-proc-pid-auxv.patch

