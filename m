Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50689188006
	for <mm-commits@vger.kernel.org>; Thu,  2 Jan 2025 22:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735857119; cv=none; b=B46dIho2LIov3gi2slItDB3kZ2+tIZwvm1JKx+3UCz5U4BXNkgNuisdiwftDb9PY459LC6lPbiOb5wi62SDYFMDjiS7G/z4RIjpmzFZnfareZfwoi7ybG2az51G0n1aGMniak1XeDbm/7p1g96tZHMzEtSC18Ucp9j2dwtyPbMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735857119; c=relaxed/simple;
	bh=L8wjD+JSLI5nO86eItzH6mRnvzt5aG3eLF+IvrULkW4=;
	h=Date:To:From:Subject:Message-Id; b=mZFaeQr+T4w/eaINJqBAGrMTaHv0KIwHN7HIy3g2LQXdjLxSou9M+Vr0GhScvTFEO3qHZWFXF+svR83y+5BgogeapxDjEZ3GQh8LEIlo8oyeqIDrBueLzzrCj0vMJR7eLvVTU2l04kw9T7nxbeynWB5oGpEQsX2lT1c9iDcid9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hlK3niUu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hlK3niUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF740C4CED0;
	Thu,  2 Jan 2025 22:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735857118;
	bh=L8wjD+JSLI5nO86eItzH6mRnvzt5aG3eLF+IvrULkW4=;
	h=Date:To:From:Subject:From;
	b=hlK3niUuJu/dLWiM6nueWAUNrZmwh/acpWS/XioLxeERpGZJrEkQYeckB4kyFHqoF
	 82DlQH5UtkUjvAgwPqbvTtbLdqFSz2rwpjbzssKxXet4OuuKG7ePrzNYzsmXmJxPC9
	 QFHTD9VA8t7ijEKyDI7ofwiKx5ToUzYP9MmEFlUg=
Date: Thu, 02 Jan 2025 14:31:58 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-vdso-prefer-do_mmap-to-mmap_region.patch added to mm-unstable branch
Message-Id: <20250102223158.CF740C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mips: vdso: prefer do_mmap() to mmap_region()
has been added to the -mm mm-unstable branch.  Its filename is
     mips-vdso-prefer-do_mmap-to-mmap_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-vdso-prefer-do_mmap-to-mmap_region.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mips: vdso: prefer do_mmap() to mmap_region()
Date: Thu, 2 Jan 2025 12:10:51 +0000

Patch series "mm: update mips to use do_mmap(), make mmap_region()
internal".

Currently the only user of mmap_region() outside of the memory management
code is the MIPS VDSO implementation.

This uses mmap_region() to map a 'delay slot emulation page' at the top of
the stack which is read-only and executable.

This mapping requires that an already-acquired mmap write lock is utilised
and that uffd and populate logic is ignored. This rules out vm_mmap(),
however do_mmap() fits the bill.

Adapt this code to use do_mmap() and then once done, make mmap_region()
internal and userland testable, and avoid any other uses of mmap_region(),
which is absolutely and strictly an internal mm function which bypasses a
great number of checks and logic.


This patch (of 2):

mmap_region() is an internal memory management implementation detail that
is not intended to be used outside of the memory management subsystem.

Map the delay slot emulation page using do_mmap() which makes use of the
already-held mmap write lock and bypasses unneeded populate and
userfaultfd logic.

This should have the precise same behaviour as the existing logic.

Link: https://lkml.kernel.org/r/cover.1735819274.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/ef076e381570f709e5c2c142dc030ec5b3309a0e.1735819274.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/vdso.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/mips/kernel/vdso.c~mips-vdso-prefer-do_mmap-to-mmap_region
+++ a/arch/mips/kernel/vdso.c
@@ -11,6 +11,7 @@
 #include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/mman.h>
 #include <linux/random.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -97,11 +98,12 @@ int arch_setup_additional_pages(struct l
 		return -EINTR;
 
 	if (IS_ENABLED(CONFIG_MIPS_FP_SUPPORT)) {
+		unsigned long unused;
+
 		/* Map delay slot emulation page */
-		base = mmap_region(NULL, STACK_TOP, PAGE_SIZE,
-				VM_READ | VM_EXEC |
-				VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC,
-				0, NULL);
+		base = do_mmap(NULL, STACK_TOP, PAGE_SIZE, PROT_READ | PROT_EXEC,
+			       MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, 0, 0, &unused,
+			       NULL);
 		if (IS_ERR_VALUE(base)) {
 			ret = base;
 			goto out;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch
mm-enforce-__must_check-on-vma-merge-and-split.patch
mm-perform-all-memfd-seal-checks-in-a-single-place.patch
mm-perform-all-memfd-seal-checks-in-a-single-place-fix.patch
maintainers-update-memory-mapping-section.patch
mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region.patch
mm-add-comments-to-do_mmap-mmap_region-and-vm_mmap.patch
tools-testing-add-simple-__mmap_region-userland-test.patch
mips-vdso-prefer-do_mmap-to-mmap_region.patch
mm-make-mmap_region-internal.patch

