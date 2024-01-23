Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E14E5C9C
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970673; cv=none; b=sgTocsl9VtGR1VGibLK9gRirDbiOGB6+BaJ1kAp5pVnQXHsOjIeZwtLfGKY2WxbL8CcS9xrLBmhiYbKXj4Gn8I7xhsoc3z1BZPDWj+ftQhAgXqfS3K+o0fmzEfSdvBnWgr9qvMOmSOWAbVV5Mm9MqNLqmsYMP7oyjVeZMMbNhiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970673; c=relaxed/simple;
	bh=5sKysFVGPknq2Ssw+fjbg/Z7uE4LLnJQobOkZBBlDcY=;
	h=Date:To:From:Subject:Message-Id; b=XcLINFwUTZqPsA+5bDP1Fz97CKUn7Cz7bqwQ4BTrMr5dmlnLGNRRHUaLj8Xu2e3oV5cbA2G0ODqlTvVte3TTYtjyusHsICRdhm292OEP0NIa3m5dn/eWE67LGEdOLguBhhRAhZBFtT2oWLYI3YQifTLYAcSKkHc0iuuSdJjWEas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0jjFarys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0jjFarys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE3BC43390;
	Tue, 23 Jan 2024 00:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970673;
	bh=5sKysFVGPknq2Ssw+fjbg/Z7uE4LLnJQobOkZBBlDcY=;
	h=Date:To:From:Subject:From;
	b=0jjFarysev/GrNy4ecT5j1CbWmb+nN4WqZrpSDIHdZh4DEgEQc0YwMcmFPXjdp0HB
	 0SKXR4J8t1F66c/GBq4X4RWHtHFmKuieUZjSGLNL78L+keGrTiqSBpRBQq20qSABEX
	 8ZAyF3Vs7DegN9PIFrV4D0EIhrb7w1TUNvAkEbgI=
Date: Mon, 22 Jan 2024 16:44:30 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,piliu@redhat.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch added to mm-unstable branch
Message-Id: <20240123004432.BAE3BC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm, crash: wrap crash dumping code into crash related ifdefs
has been added to the -mm mm-unstable branch.  Its filename is
     arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: arm, crash: wrap crash dumping code into crash related ifdefs
Date: Mon, 15 Jan 2024 22:32:19 -0500

Now crash codes under kernel/ folder has been split out from kexec code,
crash dumping can be separated from kexec reboot in config items on arm
with some adjustments.

Here use CONFIG_CRASH_RESERVE ifdef to replace CONFIG_KEXEC ifdef.

Link: https://lkml.kernel.org/r/Zax5kXfiREk2bDbu@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/setup.c~arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/arm/kernel/setup.c
@@ -979,7 +979,7 @@ static int __init init_machine_late(void
 }
 late_initcall(init_machine_late);
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_CRASH_RESERVE
 /*
  * The crash region must be aligned to 128MB to avoid
  * zImage relocating below the reserved region.
@@ -1066,7 +1066,7 @@ static void __init reserve_crashkernel(v
 }
 #else
 static inline void reserve_crashkernel(void) {}
-#endif /* CONFIG_KEXEC */
+#endif /* CONFIG_CRASH_RESERVE*/
 
 void __init hyp_mode_check(void)
 {
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmalloc-remove-vmap_area_list.patch
kexec-split-crashkernel-reservation-code-out-from-crash_corec.patch
crash-split-vmcoreinfo-exporting-code-out-from-crash_corec.patch
crash-remove-dependency-of-fa_dump-on-crash_dump.patch
crash-split-crash-dumping-code-out-from-kexec_corec.patch
crash-clean-up-kdump-related-config-items.patch
x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump.patch
s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
panic-suppress-gnu_printf-warning.patch

