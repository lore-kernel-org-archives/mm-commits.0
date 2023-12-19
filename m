Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B5D3A262
	for <mm-commits@vger.kernel.org>; Tue, 19 Dec 2023 20:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oVnucibv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15971C433C7;
	Tue, 19 Dec 2023 20:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703018967;
	bh=MZCGpy6eeHkBAJEgqvwsRvXKOAibn8eSs1naW3TNN3w=;
	h=Date:To:From:Subject:From;
	b=oVnucibvmtuK12EUxyZ+SkQH+lPOGdsb29ObuvSQtb3QQJoF5vhauZTHsJk1otpDI
	 N0H72ir1zqD2HuG/22DQrETvNb7hK3wVeDMaepDchAL63qexwK9/JBr5jyhwIiRk/k
	 xVP1lA1qJl7fvqNvqNDHL9NII+jLQZ+VlFLM6Mik=
Date: Tue, 19 Dec 2023 12:49:26 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,tiwai@suse.de,tglx@linutronix.de,seanjc@google.com,mingo@redhat.com,hpa@zytor.com,hbathini@linux.ibm.com,dyoung@redhat.com,dave.hansen@linux.intel.com,bp@alien8.de,bhe@redhat.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_core-optimize-crash_exclude_mem_range.patch added to mm-nonmm-unstable branch
Message-Id: <20231219204927.15971C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash_core: optimize crash_exclude_mem_range()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_core-optimize-crash_exclude_mem_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_core-optimize-crash_exclude_mem_range.patch

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
Subject: crash_core: optimize crash_exclude_mem_range()
Date: Wed, 20 Dec 2023 00:34:18 +0800

Because memory ranges in mem->ranges are stored in ascending order, when
we detect `p_end < start`, we can break the for loop early, as the
subsequent memory ranges must also be outside the range we are looking
for.

Link: https://lkml.kernel.org/r/20231219163418.108591-1-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
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

 kernel/crash_core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/crash_core.c~crash_core-optimize-crash_exclude_mem_range
+++ a/kernel/crash_core.c
@@ -575,9 +575,12 @@ int crash_exclude_mem_range(struct crash
 		p_start = mstart;
 		p_end = mend;
 
-		if (p_start > end || p_end < start)
+		if (p_start > end)
 			continue;
 
+		if (p_end < start)
+			break;
+
 		/* Truncate any area outside of range */
 		if (p_start < start)
 			p_start = start;
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

