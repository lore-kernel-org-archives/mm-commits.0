Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E89E17BEBF
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006267; cv=none; b=gXbUJyTMjxI71BQmq52fdtWcvLidlrkhLEMjMrT4HCyQvc8X7tue+p3mBTUAyny6PJtcxCld7AZHepcYAgOLPFGlnpy3K/TQKhYoqpnACnKzO05w8Fn/RTp2Akhl0BwpZMgB2Dm5KKUFPqE4gbHTHypLGVNHXtf7YCbdOTRx/I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006267; c=relaxed/simple;
	bh=JX1tNVTR+3jdQwlB3ibSh7v9bzTzrh7GEmVpbYSiTHA=;
	h=Date:To:From:Subject:Message-Id; b=k07pCIzoa2OPq6uIdVHs/UjORtqbnlYd1T6sDM/LQ31nfhDWPIgqLrCE74OY4NgLIRIA7Kf5y+e4xeO9Wpb9XehwGOAZJSTtK6s/1iGwbRgVp4MeIe8IlLVHVAz4+gyHONB0jsM2nDfwDDV+mVbC/h4DIIIzFLHDd1hig4ZR5Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0DSZ+1/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0DSZ+1/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB67C4CED6;
	Thu, 16 Jan 2025 05:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006267;
	bh=JX1tNVTR+3jdQwlB3ibSh7v9bzTzrh7GEmVpbYSiTHA=;
	h=Date:To:From:Subject:From;
	b=0DSZ+1/T8oHtsMblmGHlzEW7ABGs8zJYqkwqMwM+ocxmoaHTbCFe5M0Jm5S8yRBfC
	 c/y1vFmhfoAbgyv3JoYXRJPzrFDAYuLxoV4U302QLzw8uSbJWtADzq1d3oKdGW7bc8
	 /Rp8xA8QjHA5CgA2NrcQCImuBD0WRLKBS/0gnr5A=
Date: Wed, 15 Jan 2025 21:44:26 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mips-vdso-prefer-do_mmap-to-mmap_region.patch removed from -mm tree
Message-Id: <20250116054427.0DB67C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: vdso: prefer do_mmap() to mmap_region()
has been removed from the -mm tree.  Its filename was
     mips-vdso-prefer-do_mmap-to-mmap_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Jann Horn <jannh@google.com>
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


