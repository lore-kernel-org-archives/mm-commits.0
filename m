Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45B11BF37
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 01:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352786; cv=none; b=Tm/itZr5TIZRbXZK3rsgbBUAm75Qpif8fVDq3ToT1uIlX4G/rs1I3fSu8MLRxXD+VBA67OQdqgPhNsrTh2Fitwn2xetUVLMPJEyFeq49cpMrfdb5aVpYI54zsXHOUBwo7Wrzu0EbiZN8xqaTL+g2xFoIdj57XZ6lPZwQVQSLlJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352786; c=relaxed/simple;
	bh=vhKRKhygSNK1UoTSl4ugMM070t55qnwpmESggud5Aqw=;
	h=Date:To:From:Subject:Message-Id; b=Hg0k/wRb0Ov+ntfGuG0myTqs/BjBfaUqRdX80gxlJhFtq5yxXCxhfBAZZnhZVbn1XcB/+WxED73j9ND3ZOKKjGSLBzzV3EjNmON5+yNyX8CfgUQ71v3cYb4j1zUJ8NqDGrpDZGeJdOCj3u6oq5+655lFDKxMBiNiwrx9CvvMDe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zLQeSRCO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zLQeSRCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37604C4CEC6;
	Tue,  8 Oct 2024 01:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728352786;
	bh=vhKRKhygSNK1UoTSl4ugMM070t55qnwpmESggud5Aqw=;
	h=Date:To:From:Subject:From;
	b=zLQeSRCOOoWIDnvRUxUV6kd5HorzMrZb6FssAei5/uOMKoj4wuo3T27FZznhoOz2u
	 GwhTINchjpxY2CNusJStlVXpUw0Gi4gnlzRu7JY/h5b+5J+SJAAuDP7u/11LeKoiGj
	 RztPlFdQ+bRPPmJ1ws+FQ1lvMUydJxncH6GpBAcw=
Date: Mon, 07 Oct 2024 18:59:45 -0700
To: mm-commits@vger.kernel.org,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-instrument-copy_from-to_kernel_nofault-fix.patch removed from -mm tree
Message-Id: <20241008015946.37604C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, kasan: proper instrument _kernel_nofault
has been removed from the -mm tree.  Its filename was
     mm-instrument-copy_from-to_kernel_nofault-fix.patch

This patch was dropped because it was folded into mm-instrument-copy_from-to_kernel_nofault.patch

------------------------------------------------------
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: mm, kasan: proper instrument _kernel_nofault
Date: Mon, 30 Sep 2024 15:24:05 +0500

In commit 88ad9dc30bbf("mm, kasan: instrument
copy_from/to_kernel_nofault"), both src and dst were checked which might
lead to the false-positive reports.

Regular instrument_read() for copy_from and instrument_write() for copy_to
triggers KASAN reports in mm/kasan_test_c.c
copy_from_to_kernel_nofault_oob() kunit test.

Tested on x86_64, arm64 with CONFIG_KASAN_SW_TAGS using the latest
linux-next tree, where this commit has been merged today.

Link: https://lkml.kernel.org/r/20240930102405.2227124-1-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=210505
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/maccess.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/maccess.c~mm-instrument-copy_from-to_kernel_nofault-fix
+++ a/mm/maccess.c
@@ -32,7 +32,7 @@ long copy_from_kernel_nofault(void *dst,
 		return -ERANGE;
 
 	pagefault_disable();
-	instrument_memcpy_before(dst, src, size);
+	instrument_read(src, size);
 	if (!(align & 7))
 		copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
 	if (!(align & 3))
@@ -40,7 +40,6 @@ long copy_from_kernel_nofault(void *dst,
 	if (!(align & 1))
 		copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
 	copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
-	instrument_memcpy_after(dst, src, size, 0);
 	pagefault_enable();
 	return 0;
 Efault:
@@ -65,7 +64,7 @@ long copy_to_kernel_nofault(void *dst, c
 		align = (unsigned long)dst | (unsigned long)src;
 
 	pagefault_disable();
-	instrument_memcpy_before(dst, src, size);
+	instrument_write(dst, size);
 	if (!(align & 7))
 		copy_to_kernel_nofault_loop(dst, src, size, u64, Efault);
 	if (!(align & 3))
@@ -73,7 +72,6 @@ long copy_to_kernel_nofault(void *dst, c
 	if (!(align & 1))
 		copy_to_kernel_nofault_loop(dst, src, size, u16, Efault);
 	copy_to_kernel_nofault_loop(dst, src, size, u8, Efault);
-	instrument_memcpy_after(dst, src, size, 0);
 	pagefault_enable();
 	return 0;
 Efault:
_

Patches currently in -mm which might be from snovitoll@gmail.com are

mm-instrument-copy_from-to_kernel_nofault.patch

