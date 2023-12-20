Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72418125AB
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 04:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZlnxS9sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1BDC433C8;
	Wed, 20 Dec 2023 04:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703045658;
	bh=68N1wRcs+HQ/9ZNdrX9io3d1e8xEb108F74jpu2arNo=;
	h=Date:To:From:Subject:From;
	b=ZlnxS9szS7L9SCBrSchkzx/4n5mCxR0N9+FNsLuF6Y7SXOv+//ISTq06pdkwhc0RH
	 s7u0RZS4FlXMtMW5i/p/5QSHINGpEP4k+DeotaaRbMgd2THeI5Z+UOFCj8ckn+Kcuj
	 uKcNFp3BCMkk333eLpacuiO2TsqxQBDQbsR4EOd8=
Date: Tue, 19 Dec 2023 20:14:18 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,mingo@redhat.com,hpa@zytor.com,ebiederm@xmission.com,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,bhe@redhat.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kexec-use-pr_err-instead-of-kexec_dprintk-when-an-error-occurs.patch added to mm-nonmm-unstable branch
Message-Id: <20231220041418.DC1BDC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kexec: use pr_err() instead of kexec_dprintk() when an error occurs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-kexec-use-pr_err-instead-of-kexec_dprintk-when-an-error-occurs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kexec-use-pr_err-instead-of-kexec_dprintk-when-an-error-occurs.patch

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
Subject: x86/kexec: use pr_err() instead of kexec_dprintk() when an error occurs
Date: Wed, 20 Dec 2023 11:01:24 +0800

When detecting an error, the current code uses kexec_dprintk() to output
log message. This is not quite appropriate as kexec_dprintk() is mainly
used for outputting debugging messages, rather than error messages.

Replace kexec_dprintk() with pr_err(). This also makes the output method
for this error log align with the output method for other error logs in
this function.

Additionally, the last return statement in set_page_address() is
unnecessary, remove it.

Link: https://lkml.kernel.org/r/20231220030124.149160-1-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kexec-bzimage64.c |    2 +-
 mm/highmem.c                      |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/arch/x86/kernel/kexec-bzimage64.c~x86-kexec-use-pr_err-instead-of-kexec_dprintk-when-an-error-occurs
+++ a/arch/x86/kernel/kexec-bzimage64.c
@@ -429,7 +429,7 @@ static void *bzImage64_load(struct kimag
 	 * command line. Make sure it does not overflow
 	 */
 	if (cmdline_len + MAX_ELFCOREHDR_STR_LEN > header->cmdline_size) {
-		kexec_dprintk("Appending elfcorehdr=<addr> to command line exceeds maximum allowed length\n");
+		pr_err("Appending elfcorehdr=<addr> to command line exceeds maximum allowed length\n");
 		return ERR_PTR(-EINVAL);
 	}
 
--- a/mm/highmem.c~x86-kexec-use-pr_err-instead-of-kexec_dprintk-when-an-error-occurs
+++ a/mm/highmem.c
@@ -799,8 +799,6 @@ void set_page_address(struct page *page,
 		}
 		spin_unlock_irqrestore(&pas->lock, flags);
 	}
-
-	return;
 }
 
 void __init page_address_init(void)
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

