Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E221DA52
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 23:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707174372; cv=none; b=bL89qix1tVYYPlaLXk8U/5jXoDWSqLe3fDq8akU6uyVoVDZ5hVHNdPbwOw/USbPhNEZfV5mxOmZzAtYGOeOBwQ+wTcykP+PKvRPlZTJ+ARUopeTTLAcHB71x61BQse8lu4khN7PkRwZlLGi3ry+g4qpzc5NkXv8fGlDu6OSX/zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707174372; c=relaxed/simple;
	bh=jYw8YjOudsoxyp2KXxxzP/UuzWftXefW4E1KIMhqtwE=;
	h=Date:To:From:Subject:Message-Id; b=n0Iy7qqRtBwQNLUSJYMsjsXlYAChzu+knm5iQr+CS0l0MXbQDNtfVFqEabUyJwDxaxNLJ9N7Vbq7Eo6lWp0c5R4rI5gGroMPOXskcxmcN8fCMGeOA7It2HGJh6v7S0zPsfrA9Y6VmD3YC8+H94X+AoDqMaFoozY2s9IG/itW9+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VwloB9ZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VwloB9ZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBA7C433F1;
	Mon,  5 Feb 2024 23:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707174372;
	bh=jYw8YjOudsoxyp2KXxxzP/UuzWftXefW4E1KIMhqtwE=;
	h=Date:To:From:Subject:From;
	b=VwloB9ZZeOmvVuSU2qEP95ZAW1536wOdFOwSHLjYfZk+PD1EK3X1+sZdMiD4mJCW8
	 lkCHSSRplpvcMj741dCf6PwJN7t9/U5rdCkAi4VQzFPXTIrzFNNzoZMJYlteuzyEMy
	 5hwRzsUbp7ER7wocW+OrlzqLy5mXBGi8ZfBvqHqk=
Date: Mon, 05 Feb 2024 15:06:11 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + smp-make-__smp_processor_id-0-argument-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240205230612.6DBA7C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: smp: make __smp_processor_id() 0-argument macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     smp-make-__smp_processor_id-0-argument-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/smp-make-__smp_processor_id-0-argument-macro.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: smp: make __smp_processor_id() 0-argument macro
Date: Mon, 5 Feb 2024 12:39:30 +0300

smp_processor_id family of macros never accepted any arguments.

	#define __smp_processor_id(x)

works by accident (see C99 6.10.3 §4). __smp_processor_id() gets
1 (empty) argument and passes it down to raw_smp_processor_id()
which doesn't accept arguments.

Link: https://lkml.kernel.org/r/0037d1f2-8153-4b33-b43e-f4b6ecd710ac@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/smp.h~smp-make-__smp_processor_id-0-argument-macro
+++ a/include/linux/smp.h
@@ -261,7 +261,7 @@ static inline int get_boot_cpu_id(void)
  * regular asm read for the stable.
  */
 #ifndef __smp_processor_id
-#define __smp_processor_id(x) raw_smp_processor_id(x)
+#define __smp_processor_id() raw_smp_processor_id()
 #endif
 
 #ifdef CONFIG_DEBUG_PREEMPT
_

Patches currently in -mm which might be from adobriyan@gmail.com are

smp-make-__smp_processor_id-0-argument-macro.patch

