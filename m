Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794698270;
	b=qitroSazEpx3RA2FIySJjtexkCLMQja0eJRfzsmoak+SRnvn8RDYtyUSuY5NxdsGCKDw
	 yGqn1SQ7quXyk4DR3Gc/EXQZIROv332ecQFlPsSbEiZ59BdpljswVIOzU+oM0/uIMn1LM
	 g2Jclc3/0wbGVQwiumKc8dYNE1BRC0Fgar56Qs4KhrjS+46Qppycpjh2wu7f8KqQ/MxAV
	 L/0NetCY4c+59Cjhtg1nO5Ej4zxYBxWjxZ2RW/MsbLgGECTiQoDG00xpjq5GVzOgg2bOQ
	 PQ7sTUQTYVLMS3aAVlYabr3QE5okwjjRqIM0FVNfd7fP4Y0fC0cDoYrxTERYsCBK2mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794698270;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=+lspRI58qLmXRfdvLho8cxzsVzNSiWphsR3IPSe9eGA=;
	b=ESOB2kRKZUO+etF44iWjcOjEpLg/1p2HsvSjrzLWLJx05cvdJFMHOpXD2FyfXhjv72/M
	 gXoFBlgH1ZZI3ujmLgDtpz2LGQYumU33L42mKBWAQnvPsEuQjfIwtBXx0jK42h7vsFX6J
	 1voPdQqso50bW8jPxeaE+JlTpjGPCTpiS/EK4AyxX3kWBxy6ox9FnTHCD/0SoGk8UF6zs
	 8qceaBRIjHFsH/+Tz2ue8MOXXrIjcS2paLYvv9zYXRHIqc4WSwZLHmx/3MMk3cgEAwnUU
	 Wc5lYPdOyaMu170MsiO7FMas51hBnzj/4u9zfUgwGbdcI2xUMHwP0z91slwzrRCtf3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dDxS6Zel;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FFB606A323
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 23:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dDxS6Zel
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15991F000C4;
	Sat, 14 Nov 2026 23:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794698269;
	bh=+lspRI58qLmXRfdvLho8cxzsVzNSiWphsR3IPSe9eGA=;
	h=Date:To:From:Subject;
	b=dDxS6ZelSHfbU+2RgpiCtoIQW7rM1mWef256gQV8kRS1eRyxLa8HPpLZ8ru+CNDLz
	 xdD8wrCLD6NvbaYHq0k1qxjqw0v+Ozb/9YDR4ravGl9CpriDSOapPVzSMrFdxnnAtG
	 QcU7e96pr80eQBYm+BwGre8KUA7BgHHFyIPcf/C8=
Date: Sat, 14 Nov 2026 15:17:49 -0800
To: mm-commits@vger.kernel.org,wfelipe@google.com,ryan.roberts@arm.com,
	mhiramat@kernel.org,leitao@debian.org,ekffu200098@gmail.com,
	brauner@kernel.org,blum@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-use-kmalloc-in-do_initcalls.patch added to mm-nonmm-unstable branch
Message-Id: <20261114231749.D15991F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: init: use kmalloc() in do_initcalls()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-use-kmalloc-in-do_initcalls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-use-kmalloc-in-do_initcalls.patch

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
Subject: init: use kmalloc() in do_initcalls()
Date: Sat, 14 Nov 2026 12:52:30 +0100

Use kmalloc() since strscpy() already NUL-terminates command_line.

Link: https://lore.kernel.org/20261114115230.30345-4-blum@kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~init-use-kmalloc-in-do_initcalls
+++ a/init/main.c
@@ -1487,7 +1487,7 @@ static void __init do_initcalls(void)
 	size_t len = saved_command_line_len + 1;
 	char *command_line;
 
-	command_line = kzalloc(len, GFP_KERNEL);
+	command_line = kmalloc(len, GFP_KERNEL);
 	if (!command_line)
 		panic("%s: Failed to allocate %zu bytes\n", __func__, len);
 
_

Patches currently in -mm which might be from blum@kernel.org are

init-reject-bare-rodata-parameter-before-architecture-parsing.patch
init-use-strscpy-in-do_initcalls.patch
init-use-kmalloc-in-do_initcalls.patch

