Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B89D15AD1
	for <mm-commits@vger.kernel.org>; Tue,  2 Jan 2024 17:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nWyHr+rY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DA5C433C7;
	Tue,  2 Jan 2024 17:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704218042;
	bh=qW2hV5apv7IukFPzTEGJAhpZIGSaeVduQ6foRsTI8ww=;
	h=Date:To:From:Subject:From;
	b=nWyHr+rYgEnFDZSwuVu2QaomnqraBA+S+m70BFAxvaHuW95BvyrYQHYsPDKqiFelu
	 N6wESfropjiSDXdRlnfEXJgc/Puk7Zl5No58yiqez/ibpfGcSFcus2INBwbppCTYfk
	 YmqhB/rlK53Tf5ALHOh4n5Zd5kzf1uBhhOTzc1B0=
Date: Tue, 02 Jan 2024 09:54:01 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,tiwai@suse.de,tglx@linutronix.de,sourabhjain@linux.ibm.com,mingo@redhat.com,hpa@zytor.com,hbathini@linux.ibm.com,dyoung@redhat.com,dave.hansen@linux.intel.com,bp@alien8.de,bhe@redhat.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-crash-use-sz_1m-macro-instead-of-hardcoded-value.patch added to mm-nonmm-unstable branch
Message-Id: <20240102175401.E9DA5C433C7@smtp.kernel.org>
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
Date: Tue, 2 Jan 2024 22:49:04 +0800

Use SZ_1M macro instead of hardcoded 1<<20 to make code more readable.

Link: https://lkml.kernel.org/r/20240102144905.110047-3-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
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

x86-crash-remove-the-unused-image-parameter-from-prepare_elf_headers.patch
x86-crash-use-sz_1m-macro-instead-of-hardcoded-value.patch
crash_core-fix-and-simplify-the-logic-of-crash_exclude_mem_range.patch
x86-crash-fix-potential-cmem-ranges-array-overflow.patch
crash_core-optimize-crash_exclude_mem_range.patch

