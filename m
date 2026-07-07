Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FFC34C140
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 18:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783450301; cv=none; b=U6hRKHACf/gEQzKBxI/l3ZAnYCiu0nUE/mrIo6rSJAuJhvmyT5vG18g7HyzkbjfwT2e1JEcSOBQuA3qolZiPRS3yQwHTBHQLFf8V0ZPXE4ShLqijB+jCU9tirUEbs6zw1jNIq2tH+uzLBqkXEa+3T5NvHIEd8kqOShSq8UiJy78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783450301; c=relaxed/simple;
	bh=89WrLOWLiQd2idnUut/F7Z+5CJIa2RmgXC39QKvEaSk=;
	h=Date:To:From:Subject:Message-Id; b=inRJGIshRDPQH+W9cix7kU8NDtDFoNASnkIKJU4IvCGww83MBXV2+rzHmOV19VXwb+IzyelIzR8qTGeYZYHJRsJZ+Jqw2t/d+p1uCyoI2/MyICYiH/4oruIC6C1WXxAiLhCe0AAbMGUMWWNq0bleDaEiYtn4SMnwUGpJJtwc5nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m3sFEYhP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m3sFEYhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB871F000E9;
	Tue,  7 Jul 2026 18:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783450300;
	bh=ma4zBJ7//4uxl4tuLDSXhuoEjV9p5m4g5D4K2FIWksQ=;
	h=Date:To:From:Subject;
	b=m3sFEYhPbADQ/9Tu+86ciMhWdRBBL4v4Leb6cKzUsWhTwiAqBjwGIaymUC/oiaYO1
	 ztVb2SgAEJl5zwgu44Ki1CxdlxfZurECrb7SX/7BIjJbYiE37m2SfimvXfj4xd5uks
	 VmgDXYfOxske1WqtBHDSyBuN1j7S09F3cAVE8Lys=
Date: Tue, 07 Jul 2026 11:51:39 -0700
To: mm-commits@vger.kernel.org,balbirs@nvidia.com,cyyzero16@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-remove-dead-taskstats_exit_mutex-declaration.patch added to mm-nonmm-unstable branch
Message-Id: <20260707185140.0BB871F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: taskstats: remove dead taskstats_exit_mutex declaration
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     taskstats-remove-dead-taskstats_exit_mutex-declaration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-remove-dead-taskstats_exit_mutex-declaration.patch

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
From: Yiyang Chen <cyyzero16@gmail.com>
Subject: taskstats: remove dead taskstats_exit_mutex declaration
Date: Tue, 7 Jul 2026 22:52:05 +0800

The extern declaration of taskstats_exit_mutex has never been defined nor
referenced anywhere now.  Just remove it.

Link: https://lore.kernel.org/98948e69094b73d6dfa63dcf0770067b57f3becf.1783435695.git.cyyzero16@gmail.com
Signed-off-by: Yiyang Chen <cyyzero16@gmail.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/taskstats_kern.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/taskstats_kern.h~taskstats-remove-dead-taskstats_exit_mutex-declaration
+++ a/include/linux/taskstats_kern.h
@@ -14,7 +14,6 @@
 
 #ifdef CONFIG_TASKSTATS
 extern struct kmem_cache *taskstats_cache;
-extern struct mutex taskstats_exit_mutex;
 
 static inline void taskstats_tgid_free(struct signal_struct *sig)
 {
_

Patches currently in -mm which might be from cyyzero16@gmail.com are

taskstats-remove-dead-taskstats_exit_mutex-declaration.patch

