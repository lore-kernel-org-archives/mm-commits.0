Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E5B156C6A
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810157; cv=none; b=Apn+gONBfLseOTlXqaNYadaksq4gQPE+DrLlurLiYaiWQovxORnX9Svil7YxJlZbj+GdjhrU3QNV0o3J2j0kVxOITs5jCc3Dnz8cfh+iMkdROa2J27mLXJtLg67CB2myoHs8Ka4XavYMlj5t02uoWYCSnOf3OyAdBEnwTx7oUmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810157; c=relaxed/simple;
	bh=+rMyt5rPxPuY/IHUPDxKIb64vpw5W/0WtoZW+GlPkU0=;
	h=Date:To:From:Subject:Message-Id; b=MTr+bFQdlL+J5zI7i9/3b72tR5uFEFMW354RokhPEkwFIvia7Atk+Ff8F3QXxw9LvPCFjM4+cROUgmHr+f5VTWpg6xeStKT65he3E0SWiCEbBs9Fuw7tBjl1wz5RYiDu+ECZ8MmzGAzci6FycM94tQhqlmJ3eTVNZDI27pkvzBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NiWNJXwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NiWNJXwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B68C4CEEB;
	Sun, 14 Sep 2025 00:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810156;
	bh=+rMyt5rPxPuY/IHUPDxKIb64vpw5W/0WtoZW+GlPkU0=;
	h=Date:To:From:Subject:From;
	b=NiWNJXwBoiiB3dZW5vZHEc38/N7jLkxcOx1B6oFoToJRvtuH7xMzALPuMzowuOR8a
	 H+BJknPCih92sF+oiwc/VEATOkkFgsGtjoZ/RrMIJSgnBziEk/AXSyGdlFA1f4WQiu
	 r0Ya7ITrkePCyCakq/aFIFfcSNKI7jqRf0ZH7FJ0=
Date: Sat, 13 Sep 2025 17:35:56 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,viro@zeniv.linux.org.uk,tglx@linutronix.de,mingo@kernel.org,lorenzo.stoakes@oracle.com,frederic@kernel.org,brauner@kernel.org,zhangjiao2@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-proc-basec-fix-the-wrong-format-specifier.patch removed from -mm tree
Message-Id: <20250914003556.B2B68C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/base.c: fix the wrong format specifier
has been removed from the -mm tree.  Its filename was
     fs-proc-basec-fix-the-wrong-format-specifier.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3945,7 +3945,7 @@ static int proc_task_readdir(struct file
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

samples-cgroup-rm-unused-memcg_events-macro.patch

