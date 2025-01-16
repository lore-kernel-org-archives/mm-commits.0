Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CE214A62A
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006497; cv=none; b=DxnRrIb6wPW4V0YIs2uHGaJrPHv+H08deAdXZcQZ8mL6o4s0jcS1ptH0G1knyM+z7ViNF3vdmqfhJCPjUul2vLnn45c+rcmz3v6FL/6I46/5hCd+faiErqQ2bx9XmTIEBJgJG2n4+ra+9DSOBwdUv8Oe8VWINyzkpXFgPA5UkyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006497; c=relaxed/simple;
	bh=1wawHPTR9DkErwkGEzHSauIO582Si9OLyeQWWYpvxyA=;
	h=Date:To:From:Subject:Message-Id; b=rt4XYbKXycCUIuoVIgX3u4TeKUi+HM+QRgJ6DdICj+4cJcGCzNSSMNvwX6IqIxIkgucj9+kkfRDEJ/Unb+kGFNnnM9JqN+GojQoW+4JrmYcmLLHnuiVAo/y4SmO51zp1yR9U23s8QVVoNv9OX73x5TMUHrNtbw6JmWetJ1xXOWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nb3jr71W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nb3jr71W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C012C4CED6;
	Thu, 16 Jan 2025 05:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006497;
	bh=1wawHPTR9DkErwkGEzHSauIO582Si9OLyeQWWYpvxyA=;
	h=Date:To:From:Subject:From;
	b=nb3jr71WGIZ3KMNB2wAIS75fSc85tGRrWn6N3tm0wzBHUehcl4HOA28uu40uENmzG
	 wxScKjrpHm70Nn7VlqOLprGPqYZdXGpJNESduSv5aFN1CBrdDU+5sTWhp9RJulmBy3
	 a5c6XbwtIqXoS3AcyaSwnJx5t2IcfuOZu8/Um3WA=
Date: Wed, 15 Jan 2025 21:48:16 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xarray-remove-repeat-check-in-xas_squash_marks.patch removed from -mm tree
Message-Id: <20250116054817.3C012C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Xarray: remove repeat check in xas_squash_marks()
has been removed from the -mm tree.  Its filename was
     xarray-remove-repeat-check-in-xas_squash_marks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: Xarray: remove repeat check in xas_squash_marks()
Date: Fri, 13 Dec 2024 20:25:22 +0800

Caller of xas_squash_marks() has ensured xas->xa_sibs is non-zero.  Just
remove repeat check of xas->xa_sibs in xas_squash_marks().

Link: https://lkml.kernel.org/r/20241213122523.12764-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Mattew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/lib/xarray.c~xarray-remove-repeat-check-in-xas_squash_marks
+++ a/lib/xarray.c
@@ -128,9 +128,6 @@ static void xas_squash_marks(const struc
 	unsigned int mark = 0;
 	unsigned int limit = xas->xa_offset + xas->xa_sibs + 1;
 
-	if (!xas->xa_sibs)
-		return;
-
 	do {
 		unsigned long *marks = xas->xa_node->marks[mark];
 		if (find_next_bit(marks, limit, xas->xa_offset + 1) == limit)
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


