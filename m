Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559961386AC
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 19:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713297392; cv=none; b=m24/t3Mt9uoJDjfXqdbJjGZny6HEoL+QsTwN+jzQg6gHVCUGCDS8NpvdrirhyKaPLVvmV3qWTOkb3X5SGyEMF6FKbjSfXmWcUMH2hXF4IUv1Ll5Qr20FRgZv4Iwtr100me0Igt/FVdqM1Xq3lXNBz+QR8Q/JlfMMOv9FBWzMhYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713297392; c=relaxed/simple;
	bh=WSPRC0OyVKbzdaLVQ91taPtcEFBIVlVRer2tsLI+Cbw=;
	h=Date:To:From:Subject:Message-Id; b=GY59garxEAiN9CFi2s/nINsfFc+WGkwj2o3mmPVSACyO5mmfBvfAghz/R1JmyBRznqQ8K/nhPGFL2pinotQfuURPINXjYgW/SvZmwPYeUYxWMLY405h7M2XW6mOJGp52JvYQwmoaojBHXbDE+Rjh1p/9bStrf8vFQVnb0yFEarc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LSOLTfWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LSOLTfWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C93C32781;
	Tue, 16 Apr 2024 19:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713297391;
	bh=WSPRC0OyVKbzdaLVQ91taPtcEFBIVlVRer2tsLI+Cbw=;
	h=Date:To:From:Subject:From;
	b=LSOLTfWKBhlCSLsTjt1sSQsEebj/hubbDehXV1v0ODDkivWfnIvJ0PXYq6yIYYi90
	 vTz35Qxy4iUD/+f2+jZBgY9bzOpEAkeppY4W14UvN8cmFxfukfJ+wNZQAu/X/aE6Jj
	 SuY69ujRyJqn5PnwOAvOSaYyAtvkS9sz9ynC8Raw=
Date: Tue, 16 Apr 2024 12:56:31 -0700
To: mm-commits@vger.kernel.org,yi.zhang@huawei.com,yangerkun@huawei.com,willy@infradead.org,houtao1@huawei.com,leo.lilong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-inline-xas_descend-to-improve-performance.patch added to mm-unstable branch
Message-Id: <20240416195631.D2C93C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray: inline xas_descend to improve performance
has been added to the -mm mm-unstable branch.  Its filename is
     xarray-inline-xas_descend-to-improve-performance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-inline-xas_descend-to-improve-performance.patch

This patch will later appear in the mm-unstable branch at
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
From: Long Li <leo.lilong@huawei.com>
Subject: xarray: inline xas_descend to improve performance
Date: Tue, 16 Apr 2024 14:16:28 +0800

The commit 63b1898fffcd ("XArray: Disallow sibling entries of nodes")
modified the xas_descend function in such a way that it was no longer
being compiled as an inline function, because it increased the size of
xas_descend(), and the compiler no longer optimizes it as inline.  This
had a negative impact on performance, xas_descend is called frequently to
traverse downwards in the xarray tree, making it a hot function.

Inlining xas_descend has been shown to significantly improve performance
by approximately 4.95% in the iozone write test.

  Machine: Intel(R) Xeon(R) Gold 6240 CPU @ 2.60GHz
  #iozone i 0 -i 1 -s 64g -r 16m -f /test/tmptest

Before this patch:

       kB    reclen    write   rewrite     read    reread
 67108864     16384  2230080   3637689  6315197   5496027

After this patch:

       kB    reclen    write   rewrite     read    reread
 67108864     16384  2340360   3666175  6272401   5460782

Percentage change:
                       4.95%     0.78%   -0.68%    -0.64%

This patch introduces inlining to the xas_descend function. While this
change increases the size of lib/xarray.o, the performance gains in
critical workloads make this an acceptable trade-off.

Size comparison before and after patch:
.text		.data		.bss		file
0x3502		    0		   0		lib/xarray.o.before
0x3602		    0		   0		lib/xarray.o.after

Link: https://lkml.kernel.org/r/20240416061628.3768901-1-leo.lilong@huawei.com
Signed-off-by: Long Li <leo.lilong@huawei.com>
Cc: Hou Tao <houtao1@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: yangerkun <yangerkun@huawei.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/xarray.c~xarray-inline-xas_descend-to-improve-performance
+++ a/lib/xarray.c
@@ -200,7 +200,8 @@ static void *xas_start(struct xa_state *
 	return entry;
 }
 
-static void *xas_descend(struct xa_state *xas, struct xa_node *node)
+static __always_inline void *xas_descend(struct xa_state *xas,
+					struct xa_node *node)
 {
 	unsigned int offset = get_offset(xas->xa_index, node);
 	void *entry = xa_entry(xas->xa, node, offset);
_

Patches currently in -mm which might be from leo.lilong@huawei.com are

xarray-inline-xas_descend-to-improve-performance.patch

