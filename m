Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6733721660F
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545913; cv=none; b=fzb7D5411JtwhsQocJBCweYnOXXX9Q3ppXrD2ZU+YmwpjE7SneMmCoviJuRYvzxhRMwgEQQy4p+MJ3CeBxFrMCB8NWHoCWJffgief/qitiSWR28e39UzxFI1q334ba6SvGhiwkRrvvaBK+prj7uIRGLIRwLDjGyUrtCw9NrPuZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545913; c=relaxed/simple;
	bh=thEz+zvxHiiCh/0oP09UD9VoigXRl6lvuWPecNyFmVk=;
	h=Date:To:From:Subject:Message-Id; b=u5PrLO/2FmCNvxEqL1sZMX3K4LLgwNdApCI8gna48Uj+cfxdR0AJ5NHmCpIFcOz+EaYi40+ffrOq1NBiCYgzi5fT22hm44j32jg2oKTpwgvvAzDgwhCU9DoR3Y5ZFvHS4MM4Al/dCRg5eBuXlMHKqqJpGttMtK/KwtUuxUe9dL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=poUU6VWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="poUU6VWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C19C4CEE4;
	Tue,  1 Apr 2025 22:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545913;
	bh=thEz+zvxHiiCh/0oP09UD9VoigXRl6lvuWPecNyFmVk=;
	h=Date:To:From:Subject:From;
	b=poUU6VWRO/GnPnJz7okHF36Uo63belmvFNi6QyP8jK/3srgRtVhiFp0Izt2tU/71b
	 VrNDEJEY+eeWsx/T6HBmOLRlq7bNGtCVqqWNVoPM0aUsi+ZgCaS0U/2sDflLAJQhtA
	 zZONLRlYAtgkL+XkrlqGlqGfke1kZzJCLmLifUXI=
Date: Tue, 01 Apr 2025 15:18:32 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.weissschuh@linutronix.de,sroettger@google.com,rientjes@google.com,rdunlap@infradead.org,peterx@redhat.com,pedro.falcato@gmail.com,oleg@redhat.com,ojeda@kernel.org,mpe@ellerman.id.au,mingo@kernel.org,mike.rapoport@gmail.com,mhocko@suse.com,mark.rutland@arm.com,lorenzo.stoakes@oracle.com,linus.walleij@linaro.org,Liam.Howlett@oracle.com,kees@kernel.org,jorgelo@chromium.org,johannes@sipsolutions.net,jason@zx2c4.com,jannh@google.com,hch@lst.de,hca@linux.ibm.com,groeck@chromium.org,gerg@kernel.org,f.fainelli@gmail.com,enh@google.com,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,benjamin@sipsolutions.net,avagin@gmail.com,ardb@kernel.org,anna-maria@linutronix.de,aleksandr.mikhalitsyn@canonical.com,adobriyan@gmail.com,adhemerval.zanella@linaro.org,42.hyeyoo@gmail.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mseal-sysmap-enable-arm64.patch removed from -mm tree
Message-Id: <20250401221833.32C19C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mseal sysmap: enable arm64
has been removed from the -mm tree.  Its filename was
     mseal-sysmap-enable-arm64.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Xu <jeffxu@chromium.org>
Subject: mseal sysmap: enable arm64
Date: Wed, 5 Mar 2025 02:17:08 +0000

Provide support for CONFIG_MSEAL_SYSTEM_MAPPINGS on arm64, covering the
vdso, vvar, and compat-mode vectors and sigpage mappings.

Production release testing passes on Android and Chrome OS.

Link: https://lkml.kernel.org/r/20250305021711.3867874-5-jeffxu@google.com
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Cc: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Cc: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Berg <benjamin@sipsolutions.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Elliot Hughes <enh@google.com>
Cc: Florian Faineli <f.fainelli@gmail.com>
Cc: Greg Ungerer <gerg@kernel.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Linus Waleij <linus.walleij@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <mike.rapoport@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Röttger <sroettger@google.com>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig       |    1 +
 arch/arm64/kernel/vdso.c |    9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/arch/arm64/Kconfig~mseal-sysmap-enable-arm64
+++ a/arch/arm64/Kconfig
@@ -38,6 +38,7 @@ config ARM64
 	select ARCH_HAS_KEEPINITRD
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_MEM_ENCRYPT
+	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_NONLEAF_PMD_YOUNG if ARM64_HAFT
--- a/arch/arm64/kernel/vdso.c~mseal-sysmap-enable-arm64
+++ a/arch/arm64/kernel/vdso.c
@@ -130,7 +130,8 @@ static int __setup_additional_pages(enum
 	mm->context.vdso = (void *)vdso_base;
 	ret = _install_special_mapping(mm, vdso_base, vdso_text_len,
 				       VM_READ|VM_EXEC|gp_flags|
-				       VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
+				       VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
+				       VM_SEALED_SYSMAP,
 				       vdso_info[abi].cm);
 	if (IS_ERR(ret))
 		goto up_fail;
@@ -256,7 +257,8 @@ static int aarch32_kuser_helpers_setup(s
 	 */
 	ret = _install_special_mapping(mm, AARCH32_VECTORS_BASE, PAGE_SIZE,
 				       VM_READ | VM_EXEC |
-				       VM_MAYREAD | VM_MAYEXEC,
+				       VM_MAYREAD | VM_MAYEXEC |
+				       VM_SEALED_SYSMAP,
 				       &aarch32_vdso_maps[AA32_MAP_VECTORS]);
 
 	return PTR_ERR_OR_ZERO(ret);
@@ -279,7 +281,8 @@ static int aarch32_sigreturn_setup(struc
 	 */
 	ret = _install_special_mapping(mm, addr, PAGE_SIZE,
 				       VM_READ | VM_EXEC | VM_MAYREAD |
-				       VM_MAYWRITE | VM_MAYEXEC,
+				       VM_MAYWRITE | VM_MAYEXEC |
+				       VM_SEALED_SYSMAP,
 				       &aarch32_vdso_maps[AA32_MAP_SIGPAGE]);
 	if (IS_ERR(ret))
 		goto out;
_

Patches currently in -mm which might be from jeffxu@chromium.org are


