Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D0914263
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZgKnNt6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19BCC433C8;
	Fri, 29 Dec 2023 20:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881410;
	bh=CSjd5v7jw+o64bwRFGEuoBv+GczIRYr6HnnnFmSKFn8=;
	h=Date:To:From:Subject:From;
	b=ZgKnNt6h8TyPoTalL1RHyghbJn3mQ5z8/++8ddxjue3ZzlBk+ziQYzYrcbavPe1kL
	 rdIuqMy5S1ovDxbhb2nXSJVNBLfyEfISbWtFYkvPkpMBccktEYHLmaCzzQiNpT09+C
	 /QO7KUv+6kjeCVqR13lVVwnvBMjnxfa6d/jF2t4I=
Date: Fri, 29 Dec 2023 12:23:30 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,mingo@redhat.com,hpa@zytor.com,horms@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,bhe@redhat.com,bhelgaas@google.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-kexec-fix-incorrect-end-address-passed-to-kernel_ident_mapping_init.patch removed from -mm tree
Message-Id: <20231229202330.D19BCC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/kexec: fix incorrect end address passed to kernel_ident_mapping_init()
has been removed from the -mm tree.  Its filename was
     x86-kexec-fix-incorrect-end-address-passed-to-kernel_ident_mapping_init.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuntao Wang <ytcoode@gmail.com>
Subject: x86/kexec: fix incorrect end address passed to kernel_ident_mapping_init()
Date: Thu, 21 Dec 2023 18:17:02 +0800

kernel_ident_mapping_init() takes an exclusive memory range [pstart, pend)
where pend is not included in the range, while res represents an inclusive
memory range [start, end] where end is considered part of the range.

Passing [start, end] rather than [start, end+1) to
kernel_ident_mapping_init() may result in the identity mapping for the
end address not being set up.

For example, when res->start is equal to res->end,
kernel_ident_mapping_init() will not establish any identity mapping. 
Similarly, when the value of res->end is a multiple of 2M and the page
table maps 2M pages, kernel_ident_mapping_init() will also not set up
identity mapping for res->end.

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

