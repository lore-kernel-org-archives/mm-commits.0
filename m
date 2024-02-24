Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6665D625
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739047; cv=none; b=Rb+DWH0rdrKtrQA0V/QOk4PSjF4HxwI+/zCssmNXEvQShBLsCFOxqVAv/MxfODw6vhFf/lyflHn0jMQ+jE0hS+hrmoV2zMiJ3t1ZONG7lC/3+VDM16RFqc12kpo94QhS2ACOsUOZkwApBzpBGHpG0suBln9zhxZn6D59OHi35IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739047; c=relaxed/simple;
	bh=/i4YxX0DkzoH0zDYZupF+pzbKSFx6uSJmvRyvwxwVG0=;
	h=Date:To:From:Subject:Message-Id; b=FKGRfLOYJ+TN7EzzpZKURpjDkfokDjDZGLD7gQLnsaCnGV4D143ik7eiZ/CwQ8U+9a0zrhybi+3gNVd9VAGa79sLnPI+p5dTYj0SrckDg440JBUan4q4aTusgXBY0kXzzjOqBZzQhIdSnDPiqipZdnsDCWnqrHlc1jzrnLJaXdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RtjYsQBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RtjYsQBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86322C433F1;
	Sat, 24 Feb 2024 01:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739046;
	bh=/i4YxX0DkzoH0zDYZupF+pzbKSFx6uSJmvRyvwxwVG0=;
	h=Date:To:From:Subject:From;
	b=RtjYsQBq8KakiUtgV/Bu8aPWgesyctrQFfgQffr9C2VQK0bxqE+535zpmGhpACG0a
	 te39IEu1VRioEQmiIyXttSXZIh77FrPy/PKLEhXMZKySvp7e4G9ZLqsr2++nDOlV/M
	 N2WxFFcSfroRYPE8rvk+PLi25IhyVwX+5zZ1f29I=
Date: Fri, 23 Feb 2024 17:44:06 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch removed from -mm tree
Message-Id: <20240224014406.86322C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix
has been removed from the -mm tree.  Its filename was
     arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch

This patch was dropped because it was folded into arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix
Date: Thu Feb 15 05:33:42 PM PST 2024

remove stray newlines at eof

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baoquan He <bhe@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kexec/vmcore_info.c |    2 --
 arch/s390/kernel/vmcore_info.c   |    2 --
 arch/sh/kernel/vmcore_info.c     |    2 --
 3 files changed, 6 deletions(-)

--- a/arch/powerpc/kexec/vmcore_info.c~arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix
+++ a/arch/powerpc/kexec/vmcore_info.c
@@ -30,5 +30,3 @@ void arch_crash_save_vmcoreinfo(void)
 	vmcoreinfo_append_str("NUMBER(RADIX_MMU)=%d\n", early_radix_enabled());
 	vmcoreinfo_append_str("KERNELOFFSET=%lx\n", kaslr_offset());
 }
-
-
--- a/arch/s390/kernel/vmcore_info.c~arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix
+++ a/arch/s390/kernel/vmcore_info.c
@@ -19,5 +19,3 @@ void arch_crash_save_vmcoreinfo(void)
 	abs_lc->vmcore_info = paddr_vmcoreinfo_note();
 	put_abs_lowcore(abs_lc);
 }
-
-
--- a/arch/sh/kernel/vmcore_info.c~arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix
+++ a/arch/sh/kernel/vmcore_info.c
@@ -13,5 +13,3 @@ void arch_crash_save_vmcoreinfo(void)
 	VMCOREINFO_CONFIG(X2TLB);
 #endif
 }
-
-
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc.patch
mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch
hugetlb-parallelize-1g-hugetlb-initialization-fix.patch
mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix.patch

