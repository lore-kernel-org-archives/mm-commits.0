Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF183C14
	for <mm-commits@vger.kernel.org>; Wed, 30 Oct 2024 01:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730250411; cv=none; b=STd7IBXcArf2fK+bPKZ7lmmlciMIkxSLVHDO490PEr3yn3EAV08j/2O62pk+iPWZC8CyohdbURZ6bejWPqcy1kfko2RWFHDpniyc+XMZ7ICq0it2AWX3Q9nTpYWYzgoSgRD4T5+VQKFIwzwu1rYQHjcPc87f6NqDAuf6XGc2Gxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730250411; c=relaxed/simple;
	bh=2Ky84Yy0gbN3wncDOxj5pEPC9QY2Lna4A5+jtZ1cJHk=;
	h=Date:To:From:Subject:Message-Id; b=SgYVD+FDdBAJ5IMkpzBPgG7MtSzwvwgsuNfcw9w8s6pnp2DoKCpQdmlm3tkYF2NEJwwNjN3UzO1qwrlf5n5Cd6ypw+gZTH3g03yw+yAl/aKh3AREc5UU76xY/ju13/7oX2d443sySIR4N0xiA2Ao6VJr/olQqLZMghtX/hpFmg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GFbWlyMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GFbWlyMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D6AC4CECD;
	Wed, 30 Oct 2024 01:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730250411;
	bh=2Ky84Yy0gbN3wncDOxj5pEPC9QY2Lna4A5+jtZ1cJHk=;
	h=Date:To:From:Subject:From;
	b=GFbWlyMbxhmPDeLSM35NpqjE6b4CDSo6pBBUboGaCBJ5X2GHlICcl35PVAqrepsp1
	 qXtBYQgHuPvANoJLwShq6ZA7iDt3MDobftlz5Hxt5EDUYZ5bCNnp3nu2YY/S1PJ0tK
	 tSFVb0eG4CbKf7VUtuiGwtVqdYUAlY/b50jQALZ4=
Date: Tue, 29 Oct 2024 18:06:50 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,paul.walmsley@sifive.com,palmer@rivosinc.com,charlie@rivosinc.com,alex@ghiti.fr,zhangchunyan@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-fix-typo-in-virtual_address_range.patch added to mm-unstable branch
Message-Id: <20241030010651.13D6AC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest/mm: Fix typo in virtual_address_range
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-fix-typo-in-virtual_address_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-fix-typo-in-virtual_address_range.patch

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
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Subject: selftest/mm: Fix typo in virtual_address_range
Date: Tue, 8 Oct 2024 17:41:40 +0800

The function name should be *hint* address, so correct it.

Link: https://lkml.kernel.org/r/20241008094141.549248-4-zhangchunyan@iscas.ac.cn
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftest-mm-fix-typo-in-virtual_address_range
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -64,7 +64,7 @@
 #define NR_CHUNKS_HIGH  NR_CHUNKS_384TB
 #endif
 
-static char *hind_addr(void)
+static char *hint_addr(void)
 {
 	int bits = HIGH_ADDR_SHIFT + rand() % (63 - HIGH_ADDR_SHIFT);
 
@@ -185,7 +185,7 @@ int main(int argc, char *argv[])
 	}
 
 	for (i = 0; i < NR_CHUNKS_HIGH; i++) {
-		hint = hind_addr();
+		hint = hint_addr();
 		hptr[i] = mmap(hint, MAP_CHUNK_SIZE, PROT_READ | PROT_WRITE,
 			       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
_

Patches currently in -mm which might be from zhangchunyan@iscas.ac.cn are

selftest-mm-fix-typo-in-virtual_address_range.patch
selftests-mm-skip-virtual_address_range-tests-on-riscv.patch

