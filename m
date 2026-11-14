Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794698268;
	b=1w1OMV1QGVe5JQAXSb3MPxTqwstyHZwCws/amv6nvQHTFPJ+LzRKvDax1wJhf3IxUbVo
	 7JXVFsz28mr2Zmobw5pAW39866u1IzLdUbLvVQ80IG+JtzbskfRG9zEU5WUeckN6Id7qf
	 cjiVA6c+NGPC3Qqg1fD/Lw3dlEwTRA61Fx/uuQk2zo5zZ8+tP2UZWm9JXNDcezV9Q9u5y
	 6fHSHiWZlm0Hwz2oHCYQ6BrW8zRS0S97wslLM3eU6F674zjTWGkeHHro76+ZoVCzd1jbj
	 OO+L9ksKYU3ecKY3qSfukVjYyKbnH0fFCMFNncYAts/IjS0BGr9uErbURyXLTVZ0ZyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794698268;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Vz3trdzEDxCKiM2itPZZ4WQxjAkhdwSm3QpaXQqSbMo=;
	b=2GBhf4h5qbqzFQB/4B6sWxZ8G4GvfBHshrW4cxb2YkSW52gM3as7NsRWtIdYDN4USOlO
	 8oNvTHGAxP8ySdeT3lRABud0th15ubqGvMucSAbH8DoCSiseC3xc2K/WY3C8kbECF2SVZ
	 RhzwtZa95RoY11NCPXBsOfm6iln3hbRXqh1s+Ekm1z6UzlXOig0W+7sN5Paz3J6BWnK3r
	 FGALsdDTy3I6PtXrAmp13rrFP158EaZPiNOLqxl3r7OJ734r8RX2gptY/16GlPxE1IqZD
	 R1rNNjsRZuSQh8NPhYqKkCFEqrjblW3+rY+seBQUHYeG535pYDjZZJI6i+gxzTY+w4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DcUHAG7g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C7F606A327
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 23:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DcUHAG7g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A601F000C4;
	Sat, 14 Nov 2026 23:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794698267;
	bh=Vz3trdzEDxCKiM2itPZZ4WQxjAkhdwSm3QpaXQqSbMo=;
	h=Date:To:From:Subject;
	b=DcUHAG7gCFtQSD3sV32//Wrtj2Wif3Es0iESM5SxoMoGHo8S4g5nZMKhX29vmDw1Y
	 50AEEtJFRJJyjwe7bw1YCnc8S6QiWpT/09z9Cruh8Dz7uLB056wdT/mMmiM2ZhqLuR
	 MNxPfbpKKJ7J0EBvZgB0Rr/5MhzEJLkh8LMmcZak=
Date: Sat, 14 Nov 2026 15:17:47 -0800
To: mm-commits@vger.kernel.org,wfelipe@google.com,ryan.roberts@arm.com,
	rppt@kernel.org,mhiramat@kernel.org,leitao@debian.org,ekffu200098@gmail.com,
	brauner@kernel.org,blum@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-use-strscpy-in-do_initcalls.patch added to mm-nonmm-unstable branch
Message-Id: <20261114231747.B2A601F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: init: use strscpy() in do_initcalls()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-use-strscpy-in-do_initcalls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-use-strscpy-in-do_initcalls.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Thorsten Blum <blum@kernel.org>
Subject: init: use strscpy() in do_initcalls()
Date: Sat, 14 Nov 2026 12:52:29 +0100

Replace the deprecated strcpy() [1] with strscpy() to bound the copy to
the allocated buffer size.

Link: https://lore.kernel.org/20261114115230.30345-3-blum@kernel.org
Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~init-use-strscpy-in-do_initcalls
+++ a/init/main.c
@@ -1493,7 +1493,7 @@ static void __init do_initcalls(void)
 
 	for (level = 0; level < ARRAY_SIZE(initcall_levels) - 1; level++) {
 		/* Parser modifies command_line, restore it each time */
-		strcpy(command_line, saved_command_line);
+		strscpy(command_line, saved_command_line, len);
 		do_initcall_level(level, command_line);
 	}
 
_

Patches currently in -mm which might be from blum@kernel.org are

init-reject-bare-rodata-parameter-before-architecture-parsing.patch
init-use-strscpy-in-do_initcalls.patch
init-use-kmalloc-in-do_initcalls.patch

