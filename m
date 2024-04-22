Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A8F804
	for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2024 20:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713817852; cv=none; b=eJ2zJ9In7OXkAPKuaIXhQuH7bl7crHhBnbHfaQMTotHPZY+/rh/6NIVxgNCnQuB7bJvjRRPOczV2pWxeDuf3f+MaGxb2EzpCmyvEz8cJXEFcjBQK1f77KeDeQ6Ri9kCCQO0J9asPuPT4ehmfCB3F8nAR+eEwK+f4ICkc8P3/4y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713817852; c=relaxed/simple;
	bh=HSMBJuH8jP6vO7JICDx0xbifEl3t6vO/5bXY8Rir38A=;
	h=Date:To:From:Subject:Message-Id; b=bVNbDMyYcGBd1g6hXsdC7Nx8N+pNhewzE7m6tfHO8dkuu16m2vMo9iYjBdCi7FXtpgKGu/5Hm1tLZWW0EwBlHf960VL0eQz0mwS/vvuKagGY65M+OT8n7ZdcCR0+t96A6nQOvW8sglnI12sgUXZT6riRnVa4HKmt11aMFTJavzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=moXdGUWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="moXdGUWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E1EC113CC;
	Mon, 22 Apr 2024 20:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713817851;
	bh=HSMBJuH8jP6vO7JICDx0xbifEl3t6vO/5bXY8Rir38A=;
	h=Date:To:From:Subject:From;
	b=moXdGUWkMBxkB42SmUZq3ZBZIQiJLcalfhzoQ+HNJDrtTeRwwhD+uLtRbYxDgYvp0
	 1RiB3U5P4PgngMT9LxynDzlxym7sUTpg5fyaLFpfpLrKPsDDnxO8b8xrsCWnB4+NyY
	 d/YiJM0LGvYPfQOh5nKvjkA9OkzajPF6+XlBPxOA=
Date: Mon, 22 Apr 2024 13:30:50 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jeffxu@google.com,javier.carrasco.cruz@gmail.com,amer.shanawany@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-mseal-read-only-elf-memory-segment-fix-2.patch added to mm-unstable branch
Message-Id: <20240422203051.D4E1EC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: fix linker error for inline function
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-mseal-read-only-elf-memory-segment-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-mseal-read-only-elf-memory-segment-fix-2.patch

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

selftest-mm-mseal-read-only-elf-memory-segment-fix-2.patch

