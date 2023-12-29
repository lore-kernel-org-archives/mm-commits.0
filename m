Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3221426D
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xPw+ZIr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC590C433C9;
	Fri, 29 Dec 2023 20:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881411;
	bh=7wUwn+IATHFFqNFQbmWwTKdz6leiEtoFN6Gcy9emFlY=;
	h=Date:To:From:Subject:From;
	b=xPw+ZIr7YLjbbNwr78LWQLvh51vQr8iEMuUnv/3yZ+8qvziboi2A19jGczL+CZLv1
	 F3ye0SaLlvfo+XLY0sc+zFqbg4G/THx09hturo95nrZj6Q/UtHOMq7lRCzle0q5xw9
	 t1REdnbS2bOaOUkY+HVZq6EdgkqU6paidNZPIj9U=
Date: Fri, 29 Dec 2023 12:23:31 -0800
To: mm-commits@vger.kernel.org,ebiederm@xmission.com,bhe@redhat.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec_core-fix-the-assignment-to-kimage-control_page.patch removed from -mm tree
Message-Id: <20231229202331.CC590C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec_core: fix the assignment to kimage->control_page
has been removed from the -mm tree.  Its filename was
     kexec_core-fix-the-assignment-to-kimage-control_page.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuntao Wang <ytcoode@gmail.com>
Subject: kexec_core: fix the assignment to kimage->control_page
Date: Thu, 21 Dec 2023 12:23:08 +0800

image->control_page represents the starting address for allocating the
next control page, while hole_end represents the address of the last valid
byte of the currently allocated control page.

This bug actually does not affect the correctness of allocating control
pages, because image->control_page is currently only used in
kimage_alloc_crash_control_pages(), and this function, when allocating
control pages, will first align image->control_page up to the nearest
`(1 << order) << PAGE_SHIFT` boundary, then use this value as the
starting address of the next control page.  This ensures that the newly
allocated control page will use the correct starting address and not
overlap with previously allocated control pages.

Although it does not affect the correctness of the final result, it is
better for us to set image->control_page to the correct value, in case
it might be used elsewhere in the future, potentially causing errors.

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

