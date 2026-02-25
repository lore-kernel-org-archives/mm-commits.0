Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74F5319875
	for <mm-commits@vger.kernel.org>; Wed, 25 Feb 2026 22:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772057293; cv=none; b=GiDxhNGe9t3llY4bnufL1V83K7RD8HCq0uBJA0QI7S7iBN9C6gc04hdopbiQNTrvLXScVKX1AeyNE/3Q+iQijUcf8cLknr+ZTiLElzWYNzrWJPcbgfKIVRj4hIG3BokGBOKVujGGv32H58+gA+p8dql5PDFk79VgfcY23etJ/Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772057293; c=relaxed/simple;
	bh=cfWSqBmceRNdvmx7SvzBJJymnlqmnLW65hAjXwwAXwA=;
	h=Date:To:From:Subject:Message-Id; b=TZNqAKREZJzKwnZMTQpCxfFizVNMyAADV+ZMuR2C490hYaibx7fga+KUOvu2t94CZyasn2N2MBaYCIxT7+gFGykVuZ7UkupKk1YmKXjQv9UtiIq4+lUOEmetPGmVe5671VkJTOpsrmSb7IsicsR0B3629tjfxezxwvTU/HdDTrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wLWOScqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wLWOScqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D95C116D0;
	Wed, 25 Feb 2026 22:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772057293;
	bh=cfWSqBmceRNdvmx7SvzBJJymnlqmnLW65hAjXwwAXwA=;
	h=Date:To:From:Subject:From;
	b=wLWOScqDiLP47LPsYYTf1WarjDYh6wRkiacVy9lZJulTUAd9Qe0g2iek8EJyLLmkD
	 FRd4fVdAEpruGu5KmtMRIn10l+DOax49tuzny3xT3Ir+jU+46dkfW8hvMBeNbJjm7U
	 y1LHp7bGCkUCMyYLN6tFsMlL8T/vitnCF32R9aGE=
Date: Wed, 25 Feb 2026 14:08:12 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tstaudt@de.ibm.com,sourabhjain@linux.ibm.com,ryncsn@gmail.com,robh@kernel.org,lkp@intel.com,krzk@kernel.org,kernelfans@gmail.com,dyoung@redhat.com,chleroy@kernel.org,bhe@redhat.com,arnaud.lefebvre@clever-cloud.com,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-align-the-declaration-of-crash_load_dm_crypt_keys-with-config_crash_dm_crypt.patch added to mm-nonmm-unstable branch
Message-Id: <20260225220813.33D95C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: align the declaration of crash_load_dm_crypt_keys with CONFIG_CRASH_DM_CRYPT
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-align-the-declaration-of-crash_load_dm_crypt_keys-with-config_crash_dm_crypt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-align-the-declaration-of-crash_load_dm_crypt_keys-with-config_crash_dm_crypt.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Coiby Xu <coxu@redhat.com>
Subject: crash: align the declaration of crash_load_dm_crypt_keys with CONFIG_CRASH_DM_CRYPT
Date: Wed, 25 Feb 2026 14:03:45 +0800

This will prevent a compilation failure when CONFIG_CRASH_DUMP is enabled
but CONFIG_CRASH_DM_CRYPT is disabled,

       arch/powerpc/kexec/elf_64.c: In function 'elf64_load':
    >> arch/powerpc/kexec/elf_64.c:82:23: error: implicit declaration of function 'crash_load_dm_crypt_keys' [-Werror=implicit-function-declaration]
          82 |                 ret = crash_load_dm_crypt_keys(image);
             |                       ^~~~~~~~~~~~~~~~~~~~~~~~
       cc1: some warnings being treated as errors

Link: https://lkml.kernel.org/r/20260225060347.718905-3-coxu@redhat.com
Signed-off-by: Coiby Xu <coxu@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202602120648.RgQALnnI-lkp@intel.com/
Cc: Arnaud Lefebvre <arnaud.lefebvre@clever-cloud.com>
Cc: Baoquan he <bhe@redhat.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Staudt <tstaudt@de.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_core.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/crash_core.h~crash-align-the-declaration-of-crash_load_dm_crypt_keys-with-config_crash_dm_crypt
+++ a/include/linux/crash_core.h
@@ -34,13 +34,6 @@ static inline void arch_kexec_protect_cr
 static inline void arch_kexec_unprotect_crashkres(void) { }
 #endif
 
-#ifdef CONFIG_CRASH_DM_CRYPT
-int crash_load_dm_crypt_keys(struct kimage *image);
-ssize_t dm_crypt_keys_read(char *buf, size_t count, u64 *ppos);
-#else
-static inline int crash_load_dm_crypt_keys(struct kimage *image) {return 0; }
-#endif
-
 #ifndef arch_crash_handle_hotplug_event
 static inline void arch_crash_handle_hotplug_event(struct kimage *image, void *arg) { }
 #endif
@@ -96,4 +89,11 @@ static inline void crash_save_cpu(struct
 static inline int kimage_crash_copy_vmcoreinfo(struct kimage *image) { return 0; };
 #endif /* CONFIG_CRASH_DUMP*/
 
+#ifdef CONFIG_CRASH_DM_CRYPT
+int crash_load_dm_crypt_keys(struct kimage *image);
+ssize_t dm_crypt_keys_read(char *buf, size_t count, u64 *ppos);
+#else
+static inline int crash_load_dm_crypt_keys(struct kimage *image) {return 0; }
+#endif
+
 #endif /* LINUX_CRASH_CORE_H */
_

Patches currently in -mm which might be from coxu@redhat.com are

crash_dump-dm-crypt-dont-print-in-arch-specific-code.patch
crash-align-the-declaration-of-crash_load_dm_crypt_keys-with-config_crash_dm_crypt.patch
arm64ppc64le-kdump-pass-dm-crypt-keys-to-kdump-kernel.patch

