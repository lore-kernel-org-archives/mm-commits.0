Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E074F887
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xRsK5WW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2277EC433C9;
	Wed, 20 Dec 2023 23:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113424;
	bh=CfpeJLPEluu8xLrqe8LeMclwA6BbGrOQA+balIN+7IA=;
	h=Date:To:From:Subject:From;
	b=xRsK5WW+I83NofVgTsi4/vBDsKHfpJi6FnO3OIGBfIavji+GLtfMmMo6L5amV2nPs
	 7yE/FfgW8gRfqbFrEBXyxcNOZSza/sOR0W5IZaMe2aeddNjj5FjxvCG3cqUkhQp60L
	 XCH8PgoubwrIN0/O30roYl55BAN0gPlRsFzHK3is=
Date: Wed, 20 Dec 2023 15:03:43 -0800
To: mm-commits@vger.kernel.org,ebiederm@xmission.com,bhe@redhat.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-use-align-macro-instead-of-open-coding-it.patch removed from -mm tree
Message-Id: <20231220230344.2277EC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: use ALIGN macro instead of open-coding it
has been removed from the -mm tree.  Its filename was
     kexec-use-align-macro-instead-of-open-coding-it.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuntao Wang <ytcoode@gmail.com>
Subject: kexec: use ALIGN macro instead of open-coding it
Date: Tue, 12 Dec 2023 22:27:06 +0800

Use ALIGN macro instead of open-coding it to improve code readability.

Link: https://lkml.kernel.org/r/20231212142706.25149-1-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kexec_core.c~kexec-use-align-macro-instead-of-open-coding-it
+++ a/kernel/kexec_core.c
@@ -432,7 +432,7 @@ static struct page *kimage_alloc_crash_c
 
 	pages = NULL;
 	size = (1 << order) << PAGE_SHIFT;
-	hole_start = (image->control_page + (size - 1)) & ~(size - 1);
+	hole_start = ALIGN(image->control_page, size);
 	hole_end   = hole_start + size - 1;
 	while (hole_end <= crashk_res.end) {
 		unsigned long i;
@@ -449,7 +449,7 @@ static struct page *kimage_alloc_crash_c
 			mend   = mstart + image->segment[i].memsz - 1;
 			if ((hole_end >= mstart) && (hole_start <= mend)) {
 				/* Advance the hole to the end of the segment */
-				hole_start = (mend + (size - 1)) & ~(size - 1);
+				hole_start = ALIGN(mend, size);
 				hole_end   = hole_start + size - 1;
 				break;
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

