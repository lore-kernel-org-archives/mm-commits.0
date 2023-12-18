Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF1F1DDD1
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 18:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IDSOkj1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B70C433C9;
	Mon, 18 Dec 2023 18:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702925444;
	bh=kRWVadAj6CF/uCUWbTt9uMT28Q0IeBSbk9i0KIbU2fI=;
	h=Date:To:From:Subject:From;
	b=IDSOkj1+KJNZLiEJRxWhOu5f1St6nliuXM/S72pxfGoZkM94/lTH1nn9WzwplFNOk
	 Cy4TM1ZQVt5paRtyNNur4DBIdqHcDmnnEVnOYlvB8Rq8esbWlj22WRq7U5p8oAMbBV
	 75sjkRDRsbE6sNtJ+Gru4C0LR+1q9Jb5fKa/4e+Y=
Date: Mon, 18 Dec 2023 10:50:43 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,tiwai@suse.de,tglx@linutronix.de,seanjc@google.com,mingo@redhat.com,hpa@zytor.com,hbathini@linux.ibm.com,dyoung@redhat.com,dave.hansen@linux.intel.com,bp@alien8.de,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-crash-fix-potential-cmem-ranges-array-overflow.patch added to mm-nonmm-unstable branch
Message-Id: <20231218185044.69B70C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/crash: fix potential cmem->ranges array overflow
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-crash-fix-potential-cmem-ranges-array-overflow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-crash-fix-potential-cmem-ranges-array-overflow.patch

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
Subject: x86/crash: fix potential cmem->ranges array overflow
Date: Mon, 18 Dec 2023 16:19:14 +0800

The max_nr_ranges field of cmem allocated in crash_setup_memmap_entries()
is not initialized, its default value is 0.

When elfcorehdr is allocated from the middle of crashk_res due to any
potential reason, that is, `image->elf_load_addr > crashk_res.start &&
image->elf_load_addr + image->elf_headers_sz - 1 < crashk_res.end`,
executing memmap_exclude_ranges() will cause a range split to occur in
crash_exclude_mem_range(), which eventually leads to an overflow of the
cmem->ranges array.

Set cmem->max_nr_ranges to 1 to make crash_exclude_mem_range() return
-ENOMEM instead of causing cmem->ranges array overflow even when a split
happens.

Link: https://lkml.kernel.org/r/20231218081915.24120-2-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/crash.c~x86-crash-fix-potential-cmem-ranges-array-overflow
+++ a/arch/x86/kernel/crash.c
@@ -282,10 +282,6 @@ int crash_setup_memmap_entries(struct ki
 	struct crash_memmap_data cmd;
 	struct crash_mem *cmem;
 
-	cmem = vzalloc(struct_size(cmem, ranges, 1));
-	if (!cmem)
-		return -ENOMEM;
-
 	memset(&cmd, 0, sizeof(struct crash_memmap_data));
 	cmd.params = params;
 
@@ -321,6 +317,11 @@ int crash_setup_memmap_entries(struct ki
 	}
 
 	/* Exclude some ranges from crashk_res and add rest to memmap */
+	cmem = vzalloc(struct_size(cmem, ranges, 1));
+	if (!cmem)
+		return -ENOMEM;
+	cmem->max_nr_ranges = 1;
+
 	ret = memmap_exclude_ranges(image, cmem, crashk_res.start, crashk_res.end);
 	if (ret)
 		goto out;
_

Patches currently in -mm which might be from ytcoode@gmail.com are

kexec-use-align-macro-instead-of-open-coding-it.patch
x86-kexec-simplify-the-logic-of-mem_region_callback.patch
x86-crash-remove-the-unused-image-parameter-from-prepare_elf_headers.patch
x86-crash-use-sz_1m-macro-instead-of-hardcoded-value.patch
crash_core-fix-and-simplify-the-logic-of-crash_exclude_mem_range.patch
x86-crash-fix-potential-cmem-ranges-array-overflow.patch
kexec-modify-the-meaning-of-the-end-parameter-in-kimage_is_destination_range.patch
kexec_file-fix-incorrect-temp_start-value-in-locate_mem_hole_top_down.patch

