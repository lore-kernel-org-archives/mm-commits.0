Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A8C77F03
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xlLvV2TS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D274C433C8;
	Thu, 21 Dec 2023 22:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703196740;
	bh=elXkCIpqFZ4kJPMBX3MBiOClucg5Z8Z8drLtfY72Us4=;
	h=Date:To:From:Subject:From;
	b=xlLvV2TSg20tN3kTqtpx2Le3WoaEjlKvqQV2Wer6JIlHzNKlVOALYcAUZydr29Lng
	 l1Uel9yZY6mzR1o/q8qZB5FbuK5ryg5oGOqYA+pP2onu+uV1zHIPtHPhUqmA6JakjY
	 ynBoP6xvaeGwNWpADS73+q4rquHDGpbTXkdtq22I=
Date: Thu, 21 Dec 2023 14:12:19 -0800
To: mm-commits@vger.kernel.org,ebiederm@xmission.com,bhe@redhat.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_core-fix-the-assignment-to-kimage-control_page.patch added to mm-nonmm-unstable branch
Message-Id: <20231221221220.4D274C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_core: fix the assignment to kimage->control_page
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_core-fix-the-assignment-to-kimage-control_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_core-fix-the-assignment-to-kimage-control_page.patch

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
Subject: kexec_core: fix the assignment to kimage->control_page
Date: Thu, 21 Dec 2023 12:23:08 +0800

image->control_page represents the starting address for allocating the
next control page, while hole_end represents the address of the last valid
byte of the currently allocated control page.

Therefore, after successfully allocating a control page,
image->control_page should be updated to `hole_end + 1`, rather than
hole_end.

Link: https://lkml.kernel.org/r/20231221042308.11076-1-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kexec_core.c~kexec_core-fix-the-assignment-to-kimage-control_page
+++ a/kernel/kexec_core.c
@@ -457,7 +457,7 @@ static struct page *kimage_alloc_crash_c
 		/* If I don't overlap any segments I have found my hole! */
 		if (i == image->nr_segments) {
 			pages = pfn_to_page(hole_start >> PAGE_SHIFT);
-			image->control_page = hole_end;
+			image->control_page = hole_end + 1;
 			break;
 		}
 	}
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
kexec_core-fix-the-assignment-to-kimage-control_page.patch

