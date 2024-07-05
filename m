Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040E21448ED
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 06:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720161823; cv=none; b=i8WnMqqFZuwAiZOtQjV7tKROphMsZdNUtFeMpsBsxol7mTq/JYTawUUirgor3wnwazHF30v4gT6xoclFz+ZG6Kk2GZWpHoF9sxaNwZiLgBZ2wkAAggRkG3XwTVVR+GrsFm18BUbFBnhbgqXhpvN0l6SlEgaA8/udgDGLa3s6WT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720161823; c=relaxed/simple;
	bh=iQVnL42U3L5H6RwYv7PLtW7NsoEz7Q1irj5kiKgvsBE=;
	h=Date:To:From:Subject:Message-Id; b=B5O2C2lKcbvRaUQ69cZd00sv2OZLzK3I3NnE6LRrcVNzMkDwXl0nblscQNLQ+idug2cdjjnQ8r5ubkR+BTsPoWGyFvjMJA/RQIF9CkYNQy+oahEJWIpPicmVl6W0bFklIZPVHFtEPCf3h/9mqyIAD3V38McFckxlL1NquG+Blg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ngGxMfHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ngGxMfHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4685C4AF0A;
	Fri,  5 Jul 2024 06:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720161822;
	bh=iQVnL42U3L5H6RwYv7PLtW7NsoEz7Q1irj5kiKgvsBE=;
	h=Date:To:From:Subject:From;
	b=ngGxMfHUtqTJ/WDIdspc4Vz+UfanC3UDAP3uqHV0YVleH3FuCuwiLwc8CROBDbmgY
	 GQ40j1VYdigqZpjbRSpCkusa+K3ru366G7PvKvZMA57HGGXL2YyIJCCAnm6uwVfWi2
	 UcyUoyHW7y9rfG4P282H7NYcp0LjWeG/uwb92iow=
Date: Thu, 04 Jul 2024 23:43:42 -0700
To: mm-commits@vger.kernel.org,guoren@kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-zlib-add-missing-module_description-macro.patch removed from -mm tree
Message-Id: <20240705064342.B4685C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/zlib: add missing MODULE_DESCRIPTION() macro
has been removed from the -mm tree.  Its filename was
     lib-zlib-add-missing-module_description-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: lib/zlib: add missing MODULE_DESCRIPTION() macro
Date: Thu, 13 Jun 2024 22:01:09 -0700

With ARCH=csky, make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/zlib_deflate/zlib_deflate.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240613-md-csky-lib-zlib_deflate-v1-1-83504d9a27d6@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Guo Ren <guoren@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_deflate/deflate_syms.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/zlib_deflate/deflate_syms.c~lib-zlib-add-missing-module_description-macro
+++ a/lib/zlib_deflate/deflate_syms.c
@@ -17,4 +17,5 @@ EXPORT_SYMBOL(zlib_deflate);
 EXPORT_SYMBOL(zlib_deflateInit2);
 EXPORT_SYMBOL(zlib_deflateEnd);
 EXPORT_SYMBOL(zlib_deflateReset);
+MODULE_DESCRIPTION("Data compression using the deflation algorithm");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are


