Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFEB7FBAC
	for <mm-commits@vger.kernel.org>; Thu,  6 Nov 2025 00:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762389229; cv=none; b=cMjycFVnk9FUKGJCW9uKCBnEl0f+fGv+dy+HczclLU25oAjAQHJXQAcaIykLsJanWiNU+lKC1rVpvi52MklwQwpYdWfIz/HO6JK7AEarcsPy7wHGcCiA7dBh002BsWAPYChJat0iDMq1UloJOak+WwSrpYBup3waVJ6UspbvhOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762389229; c=relaxed/simple;
	bh=0POmBnuZFJkBKFgFY8j2m69SCu3gtwg4tgy8NOhRQ4g=;
	h=Date:To:From:Subject:Message-Id; b=DRrd+/b98RiON6G4jNIl7NoMAyX4arlortNH4T5xOE1OGA9j9QdlhtHiO+EzxNe3XhK8Wgea9lOhgivgScCZuVm7BiVpHSRFcfweDdqLAuqEvvIz5YYftdlb5AbzcliF8nitwVSQXEhLb68nFPt5QRYTwuLje9H0dVb8Z6TSwgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ODsx9SvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ODsx9SvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CADC4CEF5;
	Thu,  6 Nov 2025 00:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762389228;
	bh=0POmBnuZFJkBKFgFY8j2m69SCu3gtwg4tgy8NOhRQ4g=;
	h=Date:To:From:Subject:From;
	b=ODsx9SvE/joht00Dhde0wgsuuYoj4fKuC0m6lg3zRTJpUb5FWIP9pWndjkQyv7u7b
	 zBz370xLk1tTlbvhQf1OINwmfAc6yltMnLqRNsvkZCQn0Xafn+cXj1Kkscs5qvqNhO
	 n2MiQg1GLg+ufOE4mc7fIWc3uhrB25dpFTH1i4l4=
Date: Wed, 05 Nov 2025 16:33:47 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,kent.overstreet@linux.dev,zengchi@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-use-%pe-format-specifier.patch added to mm-new branch
Message-Id: <20251106003347.D6CADC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/alloc_tag: use %pe format specifier
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-use-%pe-format-specifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-use-%pe-format-specifier.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zeng Chi <zengchi@kylinos.cn>
Subject: lib/alloc_tag: use %pe format specifier
Date: Wed, 5 Nov 2025 10:39:25 +0800

The %pe format specifier is designed to print error pointers.  It prints a
symbolic error name (eg.  -EINVAL) and it makes the code simpler by
omitting PTR_ERR();

This patch fixes this cocci report:
lib/alloc_tag.c:776:63-70: WARNING: Consider using %pe to print PTR_ERR()

Link: https://lkml.kernel.org/r/20251105023925.1447482-1-zeng_chi911@163.com
Signed-off-by: Zeng Chi <zengchi@kylinos.cn>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/alloc_tag.c~alloc_tag-use-%pe-format-specifier
+++ a/lib/alloc_tag.c
@@ -845,7 +845,7 @@ static int __init alloc_tag_init(void)
 
 	alloc_tag_cttype = codetag_register_type(&desc);
 	if (IS_ERR(alloc_tag_cttype)) {
-		pr_err("Allocation tags registration failed, errno = %ld\n", PTR_ERR(alloc_tag_cttype));
+		pr_err("Allocation tags registration failed, errno = %pe\n", alloc_tag_cttype);
 		free_mod_tags_mem();
 		shutdown_mem_profiling(true);
 		return PTR_ERR(alloc_tag_cttype);
_

Patches currently in -mm which might be from zengchi@kylinos.cn are

alloc_tag-use-%pe-format-specifier.patch

