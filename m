Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7286717551
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 20:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709758760; cv=none; b=c41s9s6eJAEhxPqB8zGo9MXvPFVx1W05gr8J15Fqa7eNJqHWM357ZFMM7aFnZn2w8kDygLyUrvG1uPMS/FXoYMzfFNSinLjQAJJGLti0DLg9juPIrtE68xAjmK0OAV+/USF5NvVscXkU8jA6K0P/QQ8a2XaWUpOoPLumZsvJygI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709758760; c=relaxed/simple;
	bh=N/CJqp0tH2vYjf9bstemGrT7W52xafWW5mhvoYumWCQ=;
	h=Date:To:From:Subject:Message-Id; b=bNiR+KwxjqMZRojEkF8Btqvmofg8IHh9Ob+XHWM0zJLfgjDvM/3AGGDcmcFHWfgXX7/NB+nbqu/egmlZ82ERL/csx7DUfjG8+9NNNzlr/0CScMesjLMIy1oeaalmzpJbPSK/etE6auSdMLWMTl75/ohT5ZT40xEOagcguZUNku0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pVUDU6YK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pVUDU6YK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AD0C433F1;
	Wed,  6 Mar 2024 20:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709758760;
	bh=N/CJqp0tH2vYjf9bstemGrT7W52xafWW5mhvoYumWCQ=;
	h=Date:To:From:Subject:From;
	b=pVUDU6YK31tPaySnhLKZ17+CCQGKzMRV/xRqouJGgbtdIoIZHHpZwl11jjTXIjpZM
	 8DLimqZC18C8eoN+NFU29CfS2rrJE263dn6G0pKB/heSFjHTH+m2Jkbvh7tFEy6lfK
	 jhyrpnpZk3BQ/c1ZITIOreAe1b+uETt/Qyff/JaY=
Date: Wed, 06 Mar 2024 12:59:19 -0800
To: mm-commits@vger.kernel.org,flyingpeng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + buildid-use-kmap_local_page.patch added to mm-nonmm-unstable branch
Message-Id: <20240306205919.E9AD0C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: buildid: use kmap_local_page()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     buildid-use-kmap_local_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buildid-use-kmap_local_page.patch

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
From: Peng Hao <flyingpeng@tencent.com>
Subject: buildid: use kmap_local_page()
Date: Wed, 6 Mar 2024 11:48:04 +0800

Use kmap_local_page() instead of kmap_atomic() which has been deprecated.

Link: https://lkml.kernel.org/r/20240306034804.62087-1-flyingpeng@tencent.com
Signed-off-by: Peng Hao <flyingpeng@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/buildid.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/buildid.c~buildid-use-kmap_local_page
+++ a/lib/buildid.c
@@ -140,7 +140,7 @@ int build_id_parse(struct vm_area_struct
 		return -EFAULT;	/* page not mapped */
 
 	ret = -EINVAL;
-	page_addr = kmap_atomic(page);
+	page_addr = kmap_local_page(page);
 	ehdr = (Elf32_Ehdr *)page_addr;
 
 	/* compare magic x7f "ELF" */
@@ -156,7 +156,7 @@ int build_id_parse(struct vm_area_struct
 	else if (ehdr->e_ident[EI_CLASS] == ELFCLASS64)
 		ret = get_build_id_64(page_addr, build_id, size);
 out:
-	kunmap_atomic(page_addr);
+	kunmap_local(page_addr);
 	put_page(page);
 	return ret;
 }
_

Patches currently in -mm which might be from flyingpeng@tencent.com are

buildid-use-kmap_local_page.patch

