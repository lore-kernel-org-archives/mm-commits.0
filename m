Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D69577F39
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AeO/dz6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA83C433C7;
	Thu, 21 Dec 2023 22:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703196223;
	bh=gJkABi0Jo9VQx9KjiipXZezFALxtzxNOFm6rRBWNQAU=;
	h=Date:To:From:Subject:From;
	b=AeO/dz6Xv+Xl6XY1fCyPd3gaZ8chVvCdkbz1+CTFqRHKQdEPTMuNdFozJJwdXkLLJ
	 7/6Mtm3BzLNeahY8eljcHjDBDgpxVFsYG4+ZYm+5j+PxxFcKZd5d6OoReuWLhiT/sW
	 raW0s6GbrCEMAQCmQPCKw77TVebw1DYRtnap3Jgw=
Date: Thu, 21 Dec 2023 14:03:42 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,mingo@redhat.com,hpa@zytor.com,horms@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,bhe@redhat.com,bhelgaas@google.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kexec-fix-incorrect-end-address-passed-to-kernel_ident_mapping_init.patch added to mm-nonmm-unstable branch
Message-Id: <20231221220343.0BA83C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kexec: fix incorrect end address passed to kernel_ident_mapping_init()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-kexec-fix-incorrect-end-address-passed-to-kernel_ident_mapping_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kexec-fix-incorrect-end-address-passed-to-kernel_ident_mapping_init.patch

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
Subject: x86/kexec: fix incorrect end address passed to kernel_ident_mapping_init()
Date: Thu, 21 Dec 2023 18:17:02 +0800

kernel_ident_mapping_init() takes an exclusive memory range [pstart, pend)
where pend is not included in the range, while res represents an inclusive
memory range [start, end] where end is considered part of the range.

Therefore, passing res->end directly to kernel_ident_mapping_init() is
incorrect, the correct end address should be `res->end + 1`.

Link: https://lkml.kernel.org/r/20231221101702.20956-1-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/machine_kexec_64.c~x86-kexec-fix-incorrect-end-address-passed-to-kernel_ident_mapping_init
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -44,7 +44,7 @@ static int mem_region_callback(struct re
 	struct init_pgtable_data *data = arg;
 
 	return kernel_ident_mapping_init(data->info, data->level4p,
-					 res->start, res->end);
+					 res->start, res->end + 1);
 }
 
 static int
_

Patches currently in -mm which might be from ytcoode@gmail.com are

x86-crash-remove-the-unused-image-parameter-from-prepare_elf_headers.patch
x86-crash-use-sz_1m-macro-instead-of-hardcoded-value.patch
crash_core-fix-and-simplify-the-logic-of-crash_exclude_mem_range.patch
x86-crash-fix-potential-cmem-ranges-array-overflow.patch
crash_core-optimize-crash_exclude_mem_range.patch
kexec-modify-the-meaning-of-the-end-parameter-in-kimage_is_destination_range.patch
kexec_file-fix-incorrect-temp_start-value-in-locate_mem_hole_top_down.patch
x86-kexec-use-pr_err-instead-of-kexec_dprintk-when-an-error-occurs.patch
x86-kexec-fix-incorrect-argument-passed-to-kexec_dprintk.patch
x86-kexec-fix-incorrect-end-address-passed-to-kernel_ident_mapping_init.patch

