Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D83C2EC0BF
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 22:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937569; cv=none; b=jz5MGmO7/e45RYqFMVg1RhmOYiqvZQJs/z4He0i0Ho+/HQpTGYfqV8y3bG6X4b7XFH9vqhptQiMkBZBOehF1to1LkrH/YeDAdo8whIkbLCAaXH4JURgPMS261WNx555+xl5MUy2te35UVtiwQ/3kTiQfjnu7sGr/pacU3Dj1VAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937569; c=relaxed/simple;
	bh=+y4htkk91zsayaVRVuqAR6SKhfCGoH+tiKmFVPWstEA=;
	h=Date:To:From:Subject:Message-Id; b=mEIoONf3mtl7WDdWFi5hzk0zs//P7LG1hJEPeNB6NqYwd8Ta4AmalbRCAVY7NgCiM9hmI4X48Hw9mu9CraUVsuuvbJrr3BzZhIHJxNwl2wiBV3rPdtUge4TorYkXIVZN0F0FM5CEi3OTFB7krI0Zwo/eI85oyqggTT+egMfhIG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dg+4nC32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dg+4nC32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55ACC4CEE7;
	Wed,  3 Sep 2025 22:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756937568;
	bh=+y4htkk91zsayaVRVuqAR6SKhfCGoH+tiKmFVPWstEA=;
	h=Date:To:From:Subject:From;
	b=Dg+4nC32GMcnn120u1+UTXySJWOiWjhsJsV4QvfdIemwG/BKlrku9M/Gr63F/Ff+U
	 i6YNEb3rIIKJ4wmIO5ICchr6x+RJxdFEpQaYilcIa6iM1h0r9GfJvE/sHFHWktNdxf
	 AuLj+hJ+kojTtGqk0EOqOYsDqNIQaHAAgLRM70yI=
Date: Wed, 03 Sep 2025 15:12:48 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,viro@zeniv.linux.org.uk,tglx@linutronix.de,mingo@kernel.org,lorenzo.stoakes@oracle.com,frederic@kernel.org,brauner@kernel.org,zhangjiao2@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-basec-fix-the-wrong-format-specifier.patch added to mm-nonmm-unstable branch
Message-Id: <20250903221248.B55ACC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/base.c: fix the wrong format specifier
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-proc-basec-fix-the-wrong-format-specifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-basec-fix-the-wrong-format-specifier.patch

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
From: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Subject: fs/proc/base.c: fix the wrong format specifier
Date: Wed, 3 Sep 2025 16:39:47 +0800

Use '%d' instead of '%u' for int.

Link: https://lkml.kernel.org/r/20250903083948.2536-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/base.c~fs-proc-basec-fix-the-wrong-format-specifier
+++ a/fs/proc/base.c
@@ -3947,7 +3947,7 @@ static int proc_task_readdir(struct file
 		tid = task_pid_nr_ns(task, ns);
 		if (!tid)
 			continue;	/* The task has just exited. */
-		len = snprintf(name, sizeof(name), "%u", tid);
+		len = snprintf(name, sizeof(name), "%d", tid);
 		if (!proc_fill_cache(file, ctx, name, len,
 				proc_task_instantiate, task, NULL)) {
 			/* returning this tgid failed, save it as the first
_

Patches currently in -mm which might be from zhangjiao2@cmss.chinamobile.com are

fs-proc-basec-fix-the-wrong-format-specifier.patch

