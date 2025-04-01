Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3E2216E23
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545911; cv=none; b=JiNZbVAjgpzV/myv9R9dsRPS2E/HgSyTr+CtB3QWaTBjoSDrCj3iiAHzqjuCZh1wMMZ5yAbXEW5qlYLYzWp+4XcrtJyqVMW4ptrQpcZ2mbMXk5ArXqH7FAAf6N7yt3rM+h8hI61tPqKXfRcmSGRKYW+7lBU+82T7sY+gEVW2EpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545911; c=relaxed/simple;
	bh=spIuGka/O9U+y6f2BbUfI5MrNYqdK4azfvQOllpfHfI=;
	h=Date:To:From:Subject:Message-Id; b=E63Q/fbg/CNrMpe5UoHFxfVngxwwZL9EgqqtTzXRId+X+NN83GdzMDnHeHVFvhxbxTKvXbNxfuoIgexg1ljeOunN756yVQ5kd0yIQG2+UCyGTWPDlrSxEhajauQeigWiHJTtUHXO8yxo7GIGdL3Jz6NUvlF2q8C6LFxRe+qTpZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z7datSQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z7datSQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E351AC4CEE9;
	Tue,  1 Apr 2025 22:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545911;
	bh=spIuGka/O9U+y6f2BbUfI5MrNYqdK4azfvQOllpfHfI=;
	h=Date:To:From:Subject:From;
	b=z7datSQne5QI/cPEQhZZ+YRnrL6nxstph5rJhA7ycu3xe2Kkiw53I4mSgGxTnGCih
	 ROUkkRVEgN6BOuNuZcP8SP6zc/bQS6wjxmrxBOI609uOd4Wbn7564l6OS7FjlTb0Hd
	 5qRpbhU+mPjevfOoAGTIHi79PPDZsqdTngrw189Y=
Date: Tue, 01 Apr 2025 15:18:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.weissschuh@linutronix.de,sroettger@google.com,rientjes@google.com,rdunlap@infradead.org,peterx@redhat.com,pedro.falcato@gmail.com,oleg@redhat.com,ojeda@kernel.org,mpe@ellerman.id.au,mingo@kernel.org,mike.rapoport@gmail.com,mhocko@suse.com,mark.rutland@arm.com,lorenzo.stoakes@oracle.com,linus.walleij@linaro.org,Liam.Howlett@oracle.com,kees@kernel.org,jorgelo@chromium.org,johannes@sipsolutions.net,jason@zx2c4.com,jannh@google.com,hch@lst.de,hca@linux.ibm.com,groeck@chromium.org,gerg@kernel.org,f.fainelli@gmail.com,enh@google.com,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,benjamin@sipsolutions.net,avagin@gmail.com,ardb@kernel.org,anna-maria@linutronix.de,aleksandr.mikhalitsyn@canonical.com,adobriyan@gmail.com,adhemerval.zanella@linaro.org,42.hyeyoo@gmail.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mseal-sysmap-enable-x86-64.patch removed from -mm tree
Message-Id: <20250401221830.E351AC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mseal sysmap: enable x86-64
has been removed from the -mm tree.  Its filename was
     mseal-sysmap-enable-x86-64.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Xu <jeffxu@chromium.org>
Subject: mseal sysmap: enable x86-64
Date: Wed, 5 Mar 2025 02:17:07 +0000

Provide support for CONFIG_MSEAL_SYSTEM_MAPPINGS on x86-64, covering the
vdso, vvar, vvar_vclock.

Production release testing passes on Android and Chrome OS.

Link: https://lkml.kernel.org/r/20250305021711.3867874-4-jeffxu@google.com
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

 arch/x86/Kconfig          |    1 +
 arch/x86/entry/vdso/vma.c |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/entry/vdso/vma.c~mseal-sysmap-enable-x86-64
+++ a/arch/x86/entry/vdso/vma.c
@@ -162,7 +162,8 @@ static int map_vdso(const struct vdso_im
 				       text_start,
 				       image->size,
 				       VM_READ|VM_EXEC|
-				       VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
+				       VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
+				       VM_SEALED_SYSMAP,
 				       &vdso_mapping);
 
 	if (IS_ERR(vma)) {
@@ -181,7 +182,7 @@ static int map_vdso(const struct vdso_im
 				       VDSO_VCLOCK_PAGES_START(addr),
 				       VDSO_NR_VCLOCK_PAGES * PAGE_SIZE,
 				       VM_READ|VM_MAYREAD|VM_IO|VM_DONTDUMP|
-				       VM_PFNMAP,
+				       VM_PFNMAP|VM_SEALED_SYSMAP,
 				       &vvar_vclock_mapping);
 
 	if (IS_ERR(vma)) {
--- a/arch/x86/Kconfig~mseal-sysmap-enable-x86-64
+++ a/arch/x86/Kconfig
@@ -27,6 +27,7 @@ config X86_64
 	# Options that are inherently 64-bit kernel only:
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_HAS_PTDUMP
+	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
 	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
_

Patches currently in -mm which might be from jeffxu@chromium.org are


