Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8520C2E8B71;
	Tue, 30 Dec 2025 20:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767127355; cv=none; b=Zosz6Sdx/MEUcWCz68ndz24uNiPUse0MTKGP06vuG3yrBKrq4ggqLtpaN0ga6oXeIij89Cml12vUklU9c97sYg7KD1/zweb0JXFcnz0upRDrZBIfq0Ahw0f92xniCl0KQUdw0hx2OuyJMIBVKPPxaK6YYcqvJus5pdCEz03QVr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767127355; c=relaxed/simple;
	bh=94b1cTH/wqY3MNNv7C5tICWtdj4gSMbnEIyIuCB3OaQ=;
	h=Date:To:From:Subject:Message-Id; b=N7ob97uK6gLBhbZg5OTA9VGe03qhTmLZOH6kCotOHdVuAKTwB0+ZN2jjKhwmgKytVnlWSgDW6tzlZd/aCoEunB6oJ2zufJMrdF/To5xTO8xiDuYK0FQy62j6hwkA6q5ZpQZua5mecZhuDsSW9yCtHhR8wV79NazEhI/78ujCFZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ELP9up+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ELP9up+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D55C4CEFB;
	Tue, 30 Dec 2025 20:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767127355;
	bh=94b1cTH/wqY3MNNv7C5tICWtdj4gSMbnEIyIuCB3OaQ=;
	h=Date:To:From:Subject:From;
	b=ELP9up+ot3pWtd2Tf+QS5f0fWzHnHE5G1uAjD022E458rfpQPaACMOm30OPjTQpAO
	 3ozwHoBxhfCXSqZAc+uhdiSrzZbA+bWqHdrlR4JFvPbps1sS/FNt37c9N3TtfwWdC/
	 LNJ0XfMPnBfLVN7WSdc2rwwln5nYpm7YviZMNwDM=
Date: Tue, 30 Dec 2025 12:42:34 -0800
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,yifei.l.liu@oracle.com,tglx@linutronix.de,stable@vger.kernel.org,sourabhjain@linux.ibm.com,sohil.mehta@intel.com,rppt@kernel.org,paul.x.webb@oracle.com,noodles@fb.com,mingo@redhat.com,joel.granados@kernel.org,jbohac@suse.cz,hpa@zytor.com,henry.willard@oracle.com,guoweikang.kernel@gmail.com,graf@amazon.com,bp@alien8.de,ardb@kernel.org,harshit.m.mogalapalli@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + of-kexec-refactor-ima_get_kexec_buffer-to-use-ima_validate_range.patch added to mm-nonmm-unstable branch
Message-Id: <20251230204235.57D55C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: of/kexec: refactor ima_get_kexec_buffer() to use ima_validate_range()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     of-kexec-refactor-ima_get_kexec_buffer-to-use-ima_validate_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/of-kexec-refactor-ima_get_kexec_buffer-to-use-ima_validate_range.patch

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
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: of/kexec: refactor ima_get_kexec_buffer() to use ima_validate_range()
Date: Mon, 29 Dec 2025 00:15:22 -0800

Refactor the OF/DT ima_get_kexec_buffer() to use a generic helper to
validate the address range.  No functional change intended.

Link: https://lkml.kernel.org/r/20251229081523.622515-3-harshit.m.mogalapalli@oracle.com
Fixes: b69a2afd5afc ("x86/kexec: Carry forward IMA measurement log on kexec")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Henry Willard <henry.willard@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Jonathan McDowell <noodles@fb.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Paul Webb <paul.x.webb@oracle.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Yifei Liu <yifei.l.liu@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/kexec.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/drivers/of/kexec.c~of-kexec-refactor-ima_get_kexec_buffer-to-use-ima_validate_range
+++ a/drivers/of/kexec.c
@@ -128,7 +128,6 @@ int __init ima_get_kexec_buffer(void **a
 {
 	int ret, len;
 	unsigned long tmp_addr;
-	unsigned long start_pfn, end_pfn;
 	size_t tmp_size;
 	const void *prop;
 
@@ -144,17 +143,9 @@ int __init ima_get_kexec_buffer(void **a
 	if (!tmp_size)
 		return -ENOENT;
 
-	/*
-	 * Calculate the PFNs for the buffer and ensure
-	 * they are with in addressable memory.
-	 */
-	start_pfn = PHYS_PFN(tmp_addr);
-	end_pfn = PHYS_PFN(tmp_addr + tmp_size - 1);
-	if (!page_is_ram(start_pfn) || !page_is_ram(end_pfn)) {
-		pr_warn("IMA buffer at 0x%lx, size = 0x%zx beyond memory\n",
-			tmp_addr, tmp_size);
-		return -EINVAL;
-	}
+	ret = ima_validate_range(tmp_addr, tmp_size);
+	if (ret)
+		return ret;
 
 	*addr = __va(tmp_addr);
 	*size = tmp_size;
_

Patches currently in -mm which might be from harshit.m.mogalapalli@oracle.com are

ima-add-ima_validate_range-for-previous-kernel-ima-buffer.patch
of-kexec-refactor-ima_get_kexec_buffer-to-use-ima_validate_range.patch
x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer.patch

