Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A1A13FF9
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L96BelMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F46C433C7;
	Fri, 29 Dec 2023 20:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881390;
	bh=VHftV4r5IXLZsJ2U7uvnJQLTwYXdUVM9yVrskO0alJQ=;
	h=Date:To:From:Subject:From;
	b=L96BelMQTawmIwJpWs3MFaSUpn6dhfY8a9/3wd7T5gGEhZt25oW2rT/WcakXBro6g
	 2ThC1B+EoREnmKTeZKVxWnAfKv7TZhtK/C4QvPOZR1aSvnL1dZ5TpmQGRVyMw6149E
	 ttvHyEWhQpCt2B+DZ/qdMqBg2rM7FyF70xEK/4rA=
Date: Fri, 29 Dec 2023 12:23:09 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,mingo@redhat.com,hpa@zytor.com,ebiederm@xmission.com,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,bhe@redhat.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-modify-the-meaning-of-the-end-parameter-in-kimage_is_destination_range.patch removed from -mm tree
Message-Id: <20231229202310.61F46C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: modify the meaning of the end parameter in kimage_is_destination_range()
has been removed from the -mm tree.  Its filename was
     kexec-modify-the-meaning-of-the-end-parameter-in-kimage_is_destination_range.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuntao Wang <ytcoode@gmail.com>
Subject: kexec: modify the meaning of the end parameter in kimage_is_destination_range()
Date: Sun, 17 Dec 2023 11:35:26 +0800

The end parameter received by kimage_is_destination_range() should be the
last valid byte address of the target memory segment plus 1.  However, in
the locate_mem_hole_bottom_up() and locate_mem_hole_top_down() functions,
the corresponding value passed to kimage_is_destination_range() is the
last valid byte address of the target memory segment, which is 1 less.

There are two ways to fix this bug.  We can either correct the logic of
the locate_mem_hole_bottom_up() and locate_mem_hole_top_down() functions,
or we can fix kimage_is_destination_range() by making the end parameter
represent the last valid byte address of the target memory segment.  Here,
we choose the second approach.

Due to the modification to kimage_is_destination_range(), we also need to
adjust its callers, such as kimage_alloc_normal_control_pages() and
kimage_alloc_page().

Link: https://lkml.kernel.org/r/20231217033528.303333-2-ytcoode@gmail.com
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

 kernel/kexec_core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/kexec_core.c~kexec-modify-the-meaning-of-the-end-parameter-in-kimage_is_destination_range
+++ a/kernel/kexec_core.c
@@ -278,8 +278,8 @@ int kimage_is_destination_range(struct k
 		unsigned long mstart, mend;
 
 		mstart = image->segment[i].mem;
-		mend = mstart + image->segment[i].memsz;
-		if ((end > mstart) && (start < mend))
+		mend = mstart + image->segment[i].memsz - 1;
+		if ((end >= mstart) && (start <= mend))
 			return 1;
 	}
 
@@ -372,7 +372,7 @@ static struct page *kimage_alloc_normal_
 		pfn   = page_to_boot_pfn(pages);
 		epfn  = pfn + count;
 		addr  = pfn << PAGE_SHIFT;
-		eaddr = epfn << PAGE_SHIFT;
+		eaddr = (epfn << PAGE_SHIFT) - 1;
 		if ((epfn >= (KEXEC_CONTROL_MEMORY_LIMIT >> PAGE_SHIFT)) ||
 			      kimage_is_destination_range(image, addr, eaddr)) {
 			list_add(&pages->lru, &extra_pages);
@@ -718,7 +718,7 @@ static struct page *kimage_alloc_page(st
 
 		/* If the page is not a destination page use it */
 		if (!kimage_is_destination_range(image, addr,
-						  addr + PAGE_SIZE))
+						  addr + PAGE_SIZE - 1))
 			break;
 
 		/*
_

Patches currently in -mm which might be from ytcoode@gmail.com are

x86-crash-remove-the-unused-image-parameter-from-prepare_elf_headers.patch
x86-crash-use-sz_1m-macro-instead-of-hardcoded-value.patch
crash_core-fix-and-simplify-the-logic-of-crash_exclude_mem_range.patch
x86-crash-fix-potential-cmem-ranges-array-overflow.patch
crash_core-optimize-crash_exclude_mem_range.patch

