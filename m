Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683615D742
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 18:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oHBBt9zJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A93EC433C8;
	Mon, 18 Dec 2023 18:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702923949;
	bh=iI6UUD0cj0AP7ysb8buZUZ8enK/XGWf0+EJ/L36FyJ8=;
	h=Date:To:From:Subject:From;
	b=oHBBt9zJaBdWo0Svk4mhvo+NSjnR0+lWALrwBV8HzQ00OzYcLh8rqxmyHYV5hAxQP
	 ge5+BFG3JAERvH0ME4KbzpgyP2i22BWf0RYxj5K+BgqVJLkeku3ZsMqcUKvUzHQ0Fq
	 b+BfJSJo8tG1C3U9b+eK3yxNyvBZUKCA5VMLNMM8=
Date: Mon, 18 Dec 2023 10:25:48 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,mingo@redhat.com,hpa@zytor.com,ebiederm@xmission.com,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,bhe@redhat.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-fix-incorrect-temp_start-value-in-locate_mem_hole_top_down.patch added to mm-nonmm-unstable branch
Message-Id: <20231218182549.2A93EC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_file: fix incorrect temp_start value in locate_mem_hole_top_down()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_file-fix-incorrect-temp_start-value-in-locate_mem_hole_top_down.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-fix-incorrect-temp_start-value-in-locate_mem_hole_top_down.patch

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
Subject: kexec_file: fix incorrect temp_start value in locate_mem_hole_top_down()
Date: Sun, 17 Dec 2023 11:35:27 +0800

temp_end represents the address of the last available byte.  Therefore,
the starting address of the memory segment with temp_end as its last
available byte and a size of `kbuf->memsz`, that is, the value of
temp_start, should be `temp_end - kbuf->memsz + 1` instead of `temp_end -
kbuf->memsz`.

Additionally, use the ALIGN_DOWN macro instead of open-coding it directly
in locate_mem_hole_top_down() to improve code readability.

Link: https://lkml.kernel.org/r/20231217033528.303333-3-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kexec_file.c~kexec_file-fix-incorrect-temp_start-value-in-locate_mem_hole_top_down
+++ a/kernel/kexec_file.c
@@ -434,11 +434,11 @@ static int locate_mem_hole_top_down(unsi
 	unsigned long temp_start, temp_end;
 
 	temp_end = min(end, kbuf->buf_max);
-	temp_start = temp_end - kbuf->memsz;
+	temp_start = temp_end - kbuf->memsz + 1;
 
 	do {
 		/* align down start */
-		temp_start = temp_start & (~(kbuf->buf_align - 1));
+		temp_start = ALIGN_DOWN(temp_start, kbuf->buf_align);
 
 		if (temp_start < start || temp_start < kbuf->buf_min)
 			return 0;
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

