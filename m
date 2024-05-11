Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4D81CD3B
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 21:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715464222; cv=none; b=eG+m+X6cIhPbfROeV9M4DGvX/rogkZrnLbM1xZ12OdPwKSbAdGj7qUzN/09Ugn1BWAwyoovSnboRv/ThDij7p8gqXWlSbDGwmossd+Ys2W7+BbnlFMOK57tNnwS004345KNn9wgNox8NgQEhLBJG8Vnv7ourgfnswanC6T2WpfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715464222; c=relaxed/simple;
	bh=cowbIVS/OKkQtjjZ1au0Mte86DhEHUGSnlqq9wK9Zto=;
	h=Date:To:From:Subject:Message-Id; b=LBx90cRzCKIQnry82J+MtmrNKIXFAEFBoOirufn2BlHnX4ppnaKGhMfJ+QTqfdzHeWT6H9zLKACVUpGo4epBdZ1DNX7KR18QLaMxBxWkLSL//BjL3rP/oe5Jf3HagKOFHD2AJt9QF00Ft7dSRFwYpTRSrlM8t+K+YtDvF47C41A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bSCfQ37M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bSCfQ37M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381F5C2BBFC;
	Sat, 11 May 2024 21:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715464222;
	bh=cowbIVS/OKkQtjjZ1au0Mte86DhEHUGSnlqq9wK9Zto=;
	h=Date:To:From:Subject:From;
	b=bSCfQ37MAbV6AAA6a0Lv+281+QA37OQQ9N9c3JQ0+KrOQ13AvcIs5U4kaZCxM4AwV
	 auEkZ5vnt22V6qANF0RMTKXrOvBpv8HW3BkqQ8UVON7fEpuqfVhX3m396Qg0YMfTvS
	 0FD+IxZwjsnWRkiZziQA7FyMRm7dA6jGlsJSvnms=
Date: Sat, 11 May 2024 14:50:21 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jeffxu@google.com,javier.carrasco.cruz@gmail.com,amer.shanawany@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftest-mm-mseal-read-only-elf-memory-segment-fix-2.patch removed from -mm tree
Message-Id: <20240511215022.381F5C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: fix linker error for inline function
has been removed from the -mm tree.  Its filename was
     selftest-mm-mseal-read-only-elf-memory-segment-fix-2.patch

This patch was dropped because it was folded into selftest-mm-mseal-read-only-elf-memory-segment.patch

------------------------------------------------------
From: Amer Al Shanawany <amer.shanawany@gmail.com>
Subject: selftests: mm: fix linker error for inline function
Date: Sat, 20 Apr 2024 22:23:46 +0200

add 'static' keyword to 'sys_mprotect()' to link properly, otherwise the
test won't build.

gcc (Ubuntu 12.3.0-1ubuntu1~22.04) 12.3.0

/usr/bin/ld: /tmp/cc7yeABp.o: in function `test_seal_elf':
seal_elf.c:(.text+0x7af): undefined reference to `sys_mprotect'
/usr/bin/ld: seal_elf.c:(.text+0x82c): undefined reference to
`sys_mprotect'
/usr/bin/ld: seal_elf.c:(.text+0xa4e): undefined reference to
`sys_mprotect'

Link: https://lkml.kernel.org/r/20240420202346.546444-1-amer.shanawany@gmail.com
Signed-off-by: Amer Al Shanawany <amer.shanawany@gmail.com>
Cc: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Jeff Xu <jeffxu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/seal_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/seal_elf.c~selftest-mm-mseal-read-only-elf-memory-segment-fix-2
+++ a/tools/testing/selftests/mm/seal_elf.c
@@ -72,7 +72,7 @@ static void *sys_mmap(void *addr, unsign
 	return sret;
 }
 
-inline int sys_mprotect(void *ptr, size_t size, unsigned long prot)
+static inline int sys_mprotect(void *ptr, size_t size, unsigned long prot)
 {
 	int sret;
 
_

Patches currently in -mm which might be from amer.shanawany@gmail.com are

selftest-mm-mseal-read-only-elf-memory-segment.patch

