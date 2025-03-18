Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F541C6FF8
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274656; cv=none; b=u538Xf+mIyaz9Bv+rvAqiGSQ9b4j7tCoHaxhQ+GIaGzKM5db58Bqli7TwIHYNRfyQUF3sUYFVjJ3s9IA4C3tffEjtjoqTHjnruV3JA+o8YOktsIZrT/MbCJ/QfaZJlbVzdH27kaWg/h2J9DEd2ENyvtsHDDDtttfy9CDP+4qXkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274656; c=relaxed/simple;
	bh=LmYBUU9CvG2U3NTPadXFX//OLs0l6YlxedTSBdTsuwc=;
	h=Date:To:From:Subject:Message-Id; b=Txh7KVijHeFhOOHcEVf+9X0q3i9/CClecvbYPFxRlPVi4F3zbHpfM2YDw5HnH3VehENu6oXMi62K7HXoXsAaQEkrWg/7RT4xI2Z3iaWbo6qIfDA2kEgxTsZ5mOA5AuIALcmQxc9NffwT5SniraJmTE03ATyv95tsVU8FLs0chbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LftaUlsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LftaUlsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A745C4CEDD;
	Tue, 18 Mar 2025 05:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274656;
	bh=LmYBUU9CvG2U3NTPadXFX//OLs0l6YlxedTSBdTsuwc=;
	h=Date:To:From:Subject:From;
	b=LftaUlsZOrz7i2sDyO2RmYgfv47TklY17iU8gKIu1xPII9nY7UuWtNrWzY5uPNHI5
	 nqwUHrDo6WnVkM8iZLtxAmgM/tpn5rMQrIyKMB3tGvfTdvIeCHVDz7ZeIKzGZ369Oq
	 X70QgGrsM+i5lXh+5VUJrouqHDSg2hDgtASNs1Sc=
Date: Mon, 17 Mar 2025 22:10:56 -0700
To: mm-commits@vger.kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug-add-line-breaks.patch removed from -mm tree
Message-Id: <20250318051056.9A745C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/debug: add line breaks
has been removed from the -mm tree.  Its filename was
     mm-debug-add-line-breaks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Ye <liuye@kylinos.cn>
Subject: mm/debug: add line breaks
Date: Wed, 12 Mar 2025 17:37:17 +0800

Missing a newline character at the end of the format string.

Link: https://lkml.kernel.org/r/20250312093717.364031-1-liuye@kylinos.cn
Signed-off-by: Liu Ye <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/debug.c~mm-debug-add-line-breaks
+++ a/mm/debug.c
@@ -173,7 +173,7 @@ dump:
 void dump_page(const struct page *page, const char *reason)
 {
 	if (PagePoisoned(page))
-		pr_warn("page:%p is uninitialized and poisoned", page);
+		pr_warn("page:%p is uninitialized and poisoned\n", page);
 	else
 		__dump_page(page);
 	if (reason)
_

Patches currently in -mm which might be from liuye@kylinos.cn are


