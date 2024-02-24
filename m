Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73B94A07
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739000; cv=none; b=CmJq2ycq0RtopjfBk9iKe9ZroFaANgUbTgBHlUu1EeJulwdyt3ytxQLVuWiK5B+1hvzC80cQ3BUDhQ5QvqGxInkR6aa1Eynr4C8OL9QjpyK7JyEdsUxQ8I++ydWWjU9TLu1kw/D9d+hNzYAIjvEkMd/qXlIxfs0/VJGKA4d6240=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739000; c=relaxed/simple;
	bh=9Q70GTrocqJWGQ7jOvXx1oHQRre3lZn+ZjXWpO8BMuY=;
	h=Date:To:From:Subject:Message-Id; b=MorF2cHkEdCdSHJezqI/yg5MFaBHnQOjcwOz3eY3930F8LqTMY72OMdkbp0aD3yQkCemjINMAUpJJ85WbGs+DZMWpWMY7Vx4GiAvlBIQW7BKXbC0H4yPBHoGvinrzaSdMcDIBaELxxOsSURETXcsDM4/jgcUjUcPrqhrYxMD2Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KX+LL9oX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KX+LL9oX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8AFC433C7;
	Sat, 24 Feb 2024 01:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739000;
	bh=9Q70GTrocqJWGQ7jOvXx1oHQRre3lZn+ZjXWpO8BMuY=;
	h=Date:To:From:Subject:From;
	b=KX+LL9oXr6c2hI7z5rFzv4s0TgkRzpXceikWfaTBkCWk80a+8CmKmk9GUgP8l2wCc
	 PlNc9Jp1YqATcHu1cUjzMl6kR30J/9fYbMnHQSjrNKkWLv7kkRRSeVwCNS4Ckam68O
	 n+KXAhx+3fkL0xc4kRzYRYSNfDY0oRGkqK5rtTpg=
Date: Fri, 23 Feb 2024 17:43:20 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix.patch removed from -mm tree
Message-Id: <20240224014320.8F8AFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix
has been removed from the -mm tree.  Its filename was
     ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix.patch

This patch was dropped because it was folded into ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump.patch

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix
Date: Thu, 25 Jan 2024 22:29:07 +0800

I reproduced the failure with allnoconfig on ppc, and found below change
can fix it too. And the change makes ARCH_SELECTS_KEXEC consistent with
ARCH_SELECTS_KEXEC_FILE on the dependency. What do you think?

Link: https://lkml.kernel.org/r/ZbJwMyCpz4HDySoo@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/Kconfig~ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix
+++ a/arch/powerpc/Kconfig
@@ -610,6 +610,7 @@ config ARCH_SUPPORTS_KEXEC
 
 config ARCH_SELECTS_KEXEC
 	def_bool y
+	depends on KEXEC
 	select CRASH_DUMP
 
 config ARCH_SUPPORTS_KEXEC_FILE
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
mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc.patch

