Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2DF4778C
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sKA5ZCzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE20C433C8;
	Wed, 20 Dec 2023 17:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703092675;
	bh=SsF6YdiArpw4hIIzG11WfvZzVnK4KaSUit0q5RrxKYI=;
	h=Date:To:From:Subject:From;
	b=sKA5ZCzkcP9WFMme1O4oImj4LfD3QMKUENvM3Tb+IUXc/atinEPsCTvC/uK04nBPW
	 3pbRn/9k4C1D8rPtadZus5gNEvX2ZPrwKx66M2sp/bJSWhKr+7YN6kcBO3JEqYF9EC
	 UrMyWhAaOvQOQUWqMO0kBZqfu5oFXs5Boh2I/21I=
Date: Wed, 20 Dec 2023 09:17:54 -0800
To: mm-commits@vger.kernel.org,bhe@redhat.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kexec-fix-incorrect-argument-passed-to-kexec_dprintk.patch added to mm-nonmm-unstable branch
Message-Id: <20231220171755.7CE20C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kexec: fix incorrect argument passed to kexec_dprintk()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-kexec-fix-incorrect-argument-passed-to-kexec_dprintk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kexec-fix-incorrect-argument-passed-to-kexec_dprintk.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Yuntao Wang <ytcoode@gmail.com>
Subject: x86/kexec: fix incorrect argument passed to kexec_dprintk()
Date: Wed, 20 Dec 2023 23:41:05 +0800

kexec_dprintk() expects the last argument to be kbuf.memsz, but the actual
argument being passed is kbuf.bufsz.

Although these two values are currently equal, it is better to pass the
correct one, in case these two values become different in the future.

Link: https://lkml.kernel.org/r/20231220154105.215610-1-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kexec-bzimage64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/kexec-bzimage64.c~x86-kexec-fix-incorrect-argument-passed-to-kexec_dprintk
+++ a/arch/x86/kernel/kexec-bzimage64.c
@@ -496,7 +496,7 @@ static void *bzImage64_load(struct kimag
 		goto out_free_params;
 	bootparam_load_addr = kbuf.mem;
 	kexec_dprintk("Loaded boot_param, command line and misc at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-		      bootparam_load_addr, kbuf.bufsz, kbuf.bufsz);
+		      bootparam_load_addr, kbuf.bufsz, kbuf.memsz);
 
 	/* Load kernel */
 	kbuf.buffer = kernel + kern16_size;
_

Patches currently in -mm which might be from ytcoode@gmail.com are

kexec-use-align-macro-instead-of-open-coding-it.patch
x86-kexec-simplify-the-logic-of-mem_region_callback.patch
x86-crash-remove-the-unused-image-parameter-from-prepare_elf_headers.patch
x86-crash-use-sz_1m-macro-instead-of-hardcoded-value.patch
crash_core-fix-and-simplify-the-logic-of-crash_exclude_mem_range.patch
x86-crash-fix-potential-cmem-ranges-array-overflow.patch
crash_core-optimize-crash_exclude_mem_range.patch
kexec-modify-the-meaning-of-the-end-parameter-in-kimage_is_destination_range.patch
kexec_file-fix-incorrect-temp_start-value-in-locate_mem_hole_top_down.patch
x86-kexec-use-pr_err-instead-of-kexec_dprintk-when-an-error-occurs.patch
x86-kexec-fix-incorrect-argument-passed-to-kexec_dprintk.patch

