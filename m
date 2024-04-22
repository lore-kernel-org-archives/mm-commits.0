Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A80F1CD2E
	for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2024 22:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713823294; cv=none; b=Qxl6An4dj7cLEWQ9KVHAcvvnW8V+I+XEEwgibqK5VVqRbkCGj+BwiIdYt8N3FcXHR8wYjgOrA7Ao59BjOVoGCP6RW7ciahOjYC+oZPccK+G0NH2CP+UgrQ0PooFNL7UuwB+tWk5RzvAp3xiRGhnnwNor8w+azm68y+U2Cp7IQf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713823294; c=relaxed/simple;
	bh=q59dXgS1ogwRkXKxIhjVrUzPeRWSSyP409AFYu2ntUQ=;
	h=Date:To:From:Subject:Message-Id; b=aAkiuYO5PKMBA0k7K6tHDuxWR+3c+9hsN8lEy89LJD8zuM5JJqN2PTg3Oqed5GzhXv5SS1pP3lZIX8UTCBHKdV9gy/ENkyJLxCFxiUqeyiLpo4/XiyilJgtAaqURdEET3c4Wc2CPTh+TZTr0+O2+dCNHQ25Gsp0TG0e3WcQF2Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1LbCELGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1LbCELGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EC9C113CC;
	Mon, 22 Apr 2024 22:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713823293;
	bh=q59dXgS1ogwRkXKxIhjVrUzPeRWSSyP409AFYu2ntUQ=;
	h=Date:To:From:Subject:From;
	b=1LbCELGusmvogXcKGWInhogKu1ARp+455ZyZoI2u2yOoIYSNKc6l4Xq1+Dflh6plZ
	 pe79tssTgwZpw/DBt1cysubYA/UkoLaybzPHbmxBLfhhY5hfMdDyS8piIGw+8oRG6U
	 JkNsfLneykQ2oK+9wL/zJ7xjAtjKxcVWDQLKzfhs=
Date: Mon, 22 Apr 2024 15:01:32 -0700
To: mm-commits@vger.kernel.org,viro@ZenIV.linux.org.uk,keescook@chromium.org,jack@suse.cz,ebiederm@xmission.com,brauner@kernel.org,jcmvbkbc@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + binfmt_elf_fdpic-fix-proc-pid-auxv.patch added to mm-nonmm-unstable branch
Message-Id: <20240422220133.65EC9C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: binfmt_elf_fdpic: fix /proc/<pid>/auxv
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     binfmt_elf_fdpic-fix-proc-pid-auxv.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/binfmt_elf_fdpic-fix-proc-pid-auxv.patch

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
From: Max Filippov <jcmvbkbc@gmail.com>
Subject: binfmt_elf_fdpic: fix /proc/<pid>/auxv
Date: Fri, 22 Mar 2024 12:54:18 -0700

Althought FDPIC linux kernel provides /proc/<pid>/auxv files they are
empty because there's no code that initializes mm->saved_auxv in the FDPIC
ELF loader.

Synchronize FDPIC ELF aux vector setup with ELF.  Replace entry-by-entry
aux vector copying to userspace with initialization of mm->saved_auxv
first and then copying it to userspace as a whole.

Link: https://lkml.kernel.org/r/20240322195418.2160164-1-jcmvbkbc@gmail.com
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |   90 +++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 47 deletions(-)

--- a/fs/binfmt_elf_fdpic.c~binfmt_elf_fdpic-fix-proc-pid-auxv
+++ a/fs/binfmt_elf_fdpic.c
@@ -505,8 +505,9 @@ static int create_elf_fdpic_tables(struc
 	char *k_platform, *k_base_platform;
 	char __user *u_platform, *u_base_platform, *p;
 	int loop;
-	int nr;	/* reset for each csp adjustment */
 	unsigned long flags = 0;
+	int ei_index;
+	elf_addr_t *elf_info;
 
 #ifdef CONFIG_MMU
 	/* In some cases (e.g. Hyper-Threading), we want to avoid L1 evictions
@@ -601,44 +602,24 @@ static int create_elf_fdpic_tables(struc
 	csp -= sp & 15UL;
 	sp -= sp & 15UL;
 
-	/* put the ELF interpreter info on the stack */
-#define NEW_AUX_ENT(id, val)						\
-	do {								\
-		struct { unsigned long _id, _val; } __user *ent, v;	\
-									\
-		ent = (void __user *) csp;				\
-		v._id = (id);						\
-		v._val = (val);						\
-		if (copy_to_user(ent + nr, &v, sizeof(v)))		\
-			return -EFAULT;					\
-		nr++;							\
+	/* Create the ELF interpreter info */
+	elf_info = (elf_addr_t *)mm->saved_auxv;
+	/* update AT_VECTOR_SIZE_BASE if the number of NEW_AUX_ENT() changes */
+#define NEW_AUX_ENT(id, val) \
+	do { \
+		*elf_info++ = id; \
+		*elf_info++ = val; \
 	} while (0)
 
-	nr = 0;
-	csp -= 2 * sizeof(unsigned long);
-	NEW_AUX_ENT(AT_NULL, 0);
-	if (k_platform) {
-		nr = 0;
-		csp -= 2 * sizeof(unsigned long);
-		NEW_AUX_ENT(AT_PLATFORM,
-			    (elf_addr_t) (unsigned long) u_platform);
-	}
-
-	if (k_base_platform) {
-		nr = 0;
-		csp -= 2 * sizeof(unsigned long);
-		NEW_AUX_ENT(AT_BASE_PLATFORM,
-			    (elf_addr_t) (unsigned long) u_base_platform);
-	}
-
-	if (bprm->have_execfd) {
-		nr = 0;
-		csp -= 2 * sizeof(unsigned long);
-		NEW_AUX_ENT(AT_EXECFD, bprm->execfd);
-	}
-
-	nr = 0;
-	csp -= DLINFO_ITEMS * 2 * sizeof(unsigned long);
+#ifdef ARCH_DLINFO
+	/*
+	 * ARCH_DLINFO must come first so PPC can do its special alignment of
+	 * AUXV.
+	 * update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT() in
+	 * ARCH_DLINFO changes
+	 */
+	ARCH_DLINFO;
+#endif
 	NEW_AUX_ENT(AT_HWCAP,	ELF_HWCAP);
 #ifdef ELF_HWCAP2
 	NEW_AUX_ENT(AT_HWCAP2,	ELF_HWCAP2);
@@ -659,17 +640,32 @@ static int create_elf_fdpic_tables(struc
 	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) from_kgid_munged(cred->user_ns, cred->egid));
 	NEW_AUX_ENT(AT_SECURE,	bprm->secureexec);
 	NEW_AUX_ENT(AT_EXECFN,	bprm->exec);
-
-#ifdef ARCH_DLINFO
-	nr = 0;
-	csp -= AT_VECTOR_SIZE_ARCH * 2 * sizeof(unsigned long);
-
-	/* ARCH_DLINFO must come last so platform specific code can enforce
-	 * special alignment requirements on the AUXV if necessary (eg. PPC).
-	 */
-	ARCH_DLINFO;
-#endif
+	if (k_platform) {
+		NEW_AUX_ENT(AT_PLATFORM,
+			    (elf_addr_t)(unsigned long)u_platform);
+	}
+	if (k_base_platform) {
+		NEW_AUX_ENT(AT_BASE_PLATFORM,
+			    (elf_addr_t)(unsigned long)u_base_platform);
+	}
+	if (bprm->have_execfd) {
+		NEW_AUX_ENT(AT_EXECFD, bprm->execfd);
+	}
 #undef NEW_AUX_ENT
+	/* AT_NULL is zero; clear the rest too */
+	memset(elf_info, 0, (char *)mm->saved_auxv +
+	       sizeof(mm->saved_auxv) - (char *)elf_info);
+
+	/* And advance past the AT_NULL entry.  */
+	elf_info += 2;
+
+	ei_index = elf_info - (elf_addr_t *)mm->saved_auxv;
+	csp -= ei_index * sizeof(elf_addr_t);
+
+	/* Put the elf_info on the stack in the right place.  */
+	if (copy_to_user((void __user *)csp, mm->saved_auxv,
+			 ei_index * sizeof(elf_addr_t)))
+		return -EFAULT;
 
 	/* allocate room for argv[] and envv[] */
 	csp -= (bprm->envc + 1) * sizeof(elf_caddr_t);
_

Patches currently in -mm which might be from jcmvbkbc@gmail.com are

binfmt_elf_fdpic-fix-proc-pid-auxv.patch

