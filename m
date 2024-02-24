Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE614A06
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738895; cv=none; b=GHOHaBo6vAUoMwjQkee+lmJYy6LOpp+bTUZ6muKCCog9xRFlg5OYkE+K3ERfOAAG2ISCIDEONbuGCet57kghJ8EV0bKw2y4lg4S9u1lLeK0ZFnK/gURqc4bwkbmohw7ZdHyJ1e5tTIO4k5sn6FCTQHEvKs2mY7GxkRy/ngdD9Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738895; c=relaxed/simple;
	bh=xG/0Jp6AFieLMvQHcHq0NdyuZdZgOzBL0teBBPtjtqs=;
	h=Date:To:From:Subject:Message-Id; b=dh5cVg+SL5D5Qya8ultzAzqAMNKztyv3Q4lyF3jWr+LuCmEqzuMe3OzwBnp/9S/88V5dcLs8Mi1xlR+VyBiA7wY49vCsdJvD1BRr2sE6PjfnWY7mwVFJJDPwBCy5Bb3gnZUtkTda/1z5uy6x2RyedjVRmye53QAaPJi4sMUBx0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BJCD8WYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BJCD8WYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A38C433F1;
	Sat, 24 Feb 2024 01:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708738894;
	bh=xG/0Jp6AFieLMvQHcHq0NdyuZdZgOzBL0teBBPtjtqs=;
	h=Date:To:From:Subject:From;
	b=BJCD8WYhtpvK94EMfluYnFBq8VbTLVMLKuAWn+9DrKUWaGF7GnSt+URawU5j/U9xB
	 vy2l/wfmyIKIGkawFagRUVCooDPUnR1ae1N0JSJWNh2C+5TF8h8IOb6sP5rSd4bcmc
	 x+/SJ0JJEUdfU5OPaBmFizaYpILiWmY8z/AfXZsA=
Date: Fri, 23 Feb 2024 17:41:34 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] crash-remove-dependency-of-fa_dump-on-crash_dump-fix.patch removed from -mm tree
Message-Id: <20240224014134.A7A38C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: power/fadump: make FA_DUMP select CRASH_DUMP
has been removed from the -mm tree.  Its filename was
     crash-remove-dependency-of-fa_dump-on-crash_dump-fix.patch

This patch was dropped because it was folded into crash-remove-dependency-of-fa_dump-on-crash_dump.patch

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: power/fadump: make FA_DUMP select CRASH_DUMP
Date: Sun, 4 Feb 2024 11:06:54 +0800

FA_DUMP which is similar with kdump needs vmcoreinfo exporting,
crashkernel reservation and /proc/vmcore file . After refactoring crash
related codes and Kconfig items, make FA_DUMP select CRASH_DUMP. Now
the dependency layout is like below:

                           ---->VMCORE_INFO
                         /|
FA_DUMP--> CRASH_DUMP-->/-|---->CRASH_RESERVE
                        \ |
                          \---->PROC_VMCORE

Link: https://lkml.kernel.org/r/Zb8D1ASrgX0qVm9z@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
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

 arch/powerpc/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/powerpc/Kconfig~crash-remove-dependency-of-fa_dump-on-crash_dump-fix
+++ a/arch/powerpc/Kconfig
@@ -690,8 +690,7 @@ config ARCH_SELECTS_CRASH_DUMP
 config FA_DUMP
 	bool "Firmware-assisted dump"
 	depends on PPC64 && (PPC_RTAS || PPC_POWERNV)
-	select VMCORE_INFO
-	select CRASH_RESERVE
+	select CRASH_DUMP
 	help
 	  A robust mechanism to get reliable kernel crash dump with
 	  assistance from firmware. This approach does not use kexec,
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmalloc-remove-vmap_area_list.patch
kexec-split-crashkernel-reservation-code-out-from-crash_corec.patch
crash-split-vmcoreinfo-exporting-code-out-from-crash_corec.patch
crash-remove-dependency-of-fa_dump-on-crash_dump.patch
crash-split-crash-dumping-code-out-from-kexec_corec.patch
crash-clean-up-kdump-related-config-items.patch
x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch
arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump.patch
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix.patch
s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc.patch

