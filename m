Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0C4351C1D
	for <mm-commits@vger.kernel.org>; Wed,  4 Mar 2026 17:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646319; cv=none; b=EiI/+Eb9mAu3PufrHDVtowI83pmMkO4ftdvUkBfecVlGBBVBnKy870sLXZZsyLcs5z98WR1OkfMzsffHyX+KIUnNN4j0KXe8bYRZKMShgj/CjNBQQ8nmtUO7OqKDkdR7ryjnOmZW+yzD2yi8L/glxOp43VaZBp1O9CudIftxBZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646319; c=relaxed/simple;
	bh=hRK2aJWefyfHkslxSHjNQii7eTaoDwotSo7ME27m0hQ=;
	h=Date:To:From:Subject:Message-Id; b=eOt6JHHxfQE7yHgngi+u9IGq8+pJgwb5aykvzp48h0Y4+cNnrbUYa/KmlfoOUrCiBiD1U+tQujBRTSCVaYKCwbhMrdvL0kSO3AyX1fuhFUVrcANRJvLdrOme965KRPlVt+lANnTdFHuhCMI7YJ2LXNvX+ZyGkk8Om6m9ZQCsqPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sglC5oUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sglC5oUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8619CC19425;
	Wed,  4 Mar 2026 17:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772646319;
	bh=hRK2aJWefyfHkslxSHjNQii7eTaoDwotSo7ME27m0hQ=;
	h=Date:To:From:Subject:From;
	b=sglC5oUZNXk7v/XkKQ9DPZI48sjm/CcWM26JzxBdv98XpuOiPFout2AhgUXtpjpJx
	 bk944iBtcGI/mvVIn+atLVzGnwcIFxrcWkNTixWYmx3wgEESyxslyAPEsNLpHoNHOl
	 HcgZxoFTLNrFhVpgRnleeM+se/G+Bi7vYGUTjS4A=
Date: Wed, 04 Mar 2026 09:45:19 -0800
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] uaccess-correct-kernel-doc-parameter-format.patch removed from -mm tree
Message-Id: <20260304174519.8619CC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: uaccess: correct kernel-doc parameter format
has been removed from the -mm tree.  Its filename was
     uaccess-correct-kernel-doc-parameter-format.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: uaccess: correct kernel-doc parameter format
Date: Sun, 1 Mar 2026 16:52:29 -0800

Use the correct kernel-doc function parameter format to avoid kernel-doc
warnings:

Warning: include/linux/uaccess.h:814 function parameter 'uptr' not
 described in 'scoped_user_rw_access_size'
Warning: include/linux/uaccess.h:826 function parameter 'uptr' not
 described in 'scoped_user_rw_access'

Link: https://lkml.kernel.org/r/20260302005229.3471955-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uaccess.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/uaccess.h~uaccess-correct-kernel-doc-parameter-format
+++ a/include/linux/uaccess.h
@@ -806,7 +806,7 @@ for (bool done = false; !done; done = tr
 
 /**
  * scoped_user_rw_access_size - Start a scoped user read/write access with given size
- * @uptr	Pointer to the user space address to read from and write to
+ * @uptr:	Pointer to the user space address to read from and write to
  * @size:	Size of the access starting from @uptr
  * @elbl:	Error label to goto when the access region is rejected
  *
@@ -817,7 +817,7 @@ for (bool done = false; !done; done = tr
 
 /**
  * scoped_user_rw_access - Start a scoped user read/write access
- * @uptr	Pointer to the user space address to read from and write to
+ * @uptr:	Pointer to the user space address to read from and write to
  * @elbl:	Error label to goto when the access region is rejected
  *
  * The size of the access starting from @uptr is determined via sizeof(*@uptr)).
_

Patches currently in -mm which might be from rdunlap@infradead.org are

build_bugh-correct-function-parameters-names-in-kernel-doc.patch

