Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3C879F4
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739398; cv=none; b=cSVlhJB0DmqQM5EB1tl/xIa5jHY2Oi2DKOG5PIlt1LkbWOqY7k4+JJygFLfMe2YR9p0JwjJuoce4i8i0pnULDjmh81hf5x0YBDQ8TDgL7dtkSCD2Y5DJfmd7q9x2zjuSpduLm1dptGI1EOz8UamrGyyHo1PuXcG45GnbX2PhIyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739398; c=relaxed/simple;
	bh=CMggzRb7M79VjUgjv4JrZQgqLcd/wVSGU4MXe2G7znQ=;
	h=Date:To:From:Subject:Message-Id; b=A5bXv88XP4OCnMs58HU0j0aHk5kMaOYSiukDw/twv9kwUqlWpEo1G+KDbzZ334WlZ9w8pCHS258rnCGBqjOjGRzFmaTXvpAHsa1SbJC+gKbOvIPEMc13uzzijbFIQzhNc9Spys2ItehL1XL1LNRpHPfn3QKbvHzCGfJ1YgymGWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nwZTyUYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nwZTyUYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712B4C433C7;
	Sat, 24 Feb 2024 01:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739398;
	bh=CMggzRb7M79VjUgjv4JrZQgqLcd/wVSGU4MXe2G7znQ=;
	h=Date:To:From:Subject:From;
	b=nwZTyUYZ4GRBTnh+b34K8jC3jNJn37CEukwRWfspVGdV29963vGBK4ijPTO4wz931
	 UDQof0uGFhf+VSrNJzTSKSknZ0st2zyTxDAdsEgq2FIdskTtbIW4mhiVs9dFz/xQwN
	 pLs2qCDGIVLf+luTJCL/l+LXB+QgCMaN1pklnoXY=
Date: Fri, 23 Feb 2024 17:49:57 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump.patch removed from -mm tree
Message-Id: <20240224014958.712B4C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ppc, crash: enforce KEXEC and KEXEC_FILE to select CRASH_DUMP
has been removed from the -mm tree.  Its filename was
     ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: ppc, crash: enforce KEXEC and KEXEC_FILE to select CRASH_DUMP
Date: Wed, 24 Jan 2024 13:12:48 +0800

In PowerPC, the crash dumping and kexec reboot share code in
arch_kexec_locate_mem_hole(), in which struct crash_mem is used.

Here enfoce enforce KEXEC and KEXEC_FILE to select CRASH_DUMP for now.

[bhe@redhat.com: fix allnoconfig on ppc]
  Link: https://lkml.kernel.org/r/ZbJwMyCpz4HDySoo@MiWiFi-R3L-srv
Link: https://lkml.kernel.org/r/20240124051254.67105-9-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Hari Bathini <hbathini@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/powerpc/Kconfig~ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump
+++ a/arch/powerpc/Kconfig
@@ -608,6 +608,11 @@ config PPC64_SUPPORTS_MEMORY_FAILURE
 config ARCH_SUPPORTS_KEXEC
 	def_bool PPC_BOOK3S || PPC_E500 || (44x && !SMP)
 
+config ARCH_SELECTS_KEXEC
+	def_bool y
+	depends on KEXEC
+	select CRASH_DUMP
+
 config ARCH_SUPPORTS_KEXEC_FILE
 	def_bool PPC64
 
@@ -618,6 +623,7 @@ config ARCH_SELECTS_KEXEC_FILE
 	def_bool y
 	depends on KEXEC_FILE
 	select KEXEC_ELF
+	select CRASH_DUMP
 	select HAVE_IMA_KEXEC if IMA
 
 config PPC64_BIG_ENDIAN_ELF_ABI_V2
_

Patches currently in -mm which might be from bhe@redhat.com are


