Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3DF208BD
	for <mm-commits@vger.kernel.org>; Thu, 14 Dec 2023 18:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q5j+9SVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17F2C433C9;
	Thu, 14 Dec 2023 18:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702580354;
	bh=AJNx+SomW2DeTaNVRDacbJxYMC0tyUk4wmsLLmG+tvc=;
	h=Date:To:From:Subject:From;
	b=Q5j+9SVtNUYH34sQbQYFpnJYuOcoTT7W8iZHsRt+ccXAg9f1ueCgsp/catX8GULkv
	 Vp9OjnfRPwFrDtU7HzK0WWQshHz3SSXpZ9JY5L/DedIYsAO55+V/95Ju3gYmEWthK6
	 +sSQKl3DSM4ZmdaHRBdyJmk+DxaEPFCbmhEHMZwE=
Date: Thu, 14 Dec 2023 10:59:14 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,tiwai@suse.de,tglx@linutronix.de,sourabhjain@linux.ibm.com,seanjc@google.com,mingo@redhat.com,lijiang@redhat.com,hpa@zytor.com,hbathini@linux.ibm.com,eric.devolder@oracle.com,dyoung@redhat.com,dave.hansen@linux.intel.com,bp@alien8.de,bhe@redhat.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-crash-use-sz_1m-macro-instead-of-hardcoded-value.patch added to mm-nonmm-unstable branch
Message-Id: <20231214185914.C17F2C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/crash: use SZ_1M macro instead of hardcoded value
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-crash-use-sz_1m-macro-instead-of-hardcoded-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-crash-use-sz_1m-macro-instead-of-hardcoded-value.patch

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
Subject: x86/crash: use SZ_1M macro instead of hardcoded value
Date: Fri, 15 Dec 2023 00:38:41 +0800

Use SZ_1M macro instead of hardcoded 1<<20 to make code more readable.

Link: https://lkml.kernel.org/r/20231214163842.129139-3-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric DeVolder <eric.devolder@oracle.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Lianbo Jiang <lijiang@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/crash.c~x86-crash-use-sz_1m-macro-instead-of-hardcoded-value
+++ a/arch/x86/kernel/crash.c
@@ -170,7 +170,7 @@ static int elf_header_exclude_ranges(str
 	int ret = 0;
 
 	/* Exclude the low 1M because it is always reserved */
-	ret = crash_exclude_mem_range(cmem, 0, (1<<20)-1);
+	ret = crash_exclude_mem_range(cmem, 0, SZ_1M - 1);
 	if (ret)
 		return ret;
 
_

Patches currently in -mm which might be from ytcoode@gmail.com are

kexec-use-align-macro-instead-of-open-coding-it.patch
x86-kexec-simplify-the-logic-of-mem_region_callback.patch
x86-crash-remove-the-unused-image-parameter-from-prepare_elf_headers.patch
x86-crash-use-sz_1m-macro-instead-of-hardcoded-value.patch
crash_core-fix-and-simplify-the-logic-of-crash_exclude_mem_range.patch

