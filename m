Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD97B2F60CC;
	Thu,  4 Sep 2025 22:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757026521; cv=none; b=LcTHf4cP8+LfBxO5wiBhEkMaFxK13Wp5f7HyOuLGxlbbiRHWx/bt8nmmOmQhqiio2U3cFzZ3ehTs1Uxew4LTDFB5TegRt/G7CfJEhfJP0BRon+OlYnZByYw4Twz2fU1UXbyv4iRWs6895xfY2FP6ep93VSeyWAM0jOfMaXhJ7qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757026521; c=relaxed/simple;
	bh=pbwL9Jb5cUDHT+JoiDDO8OJ4KwgU8acMhfnRJGUKSyk=;
	h=Date:To:From:Subject:Message-Id; b=S/DnZwUMwHandpRl8Y/ufB7Fh67a9NUE2CcvYJqydWkqRdMqwz/m0f72nACLQc27pvxHOyStNuqZ/akTmtm5iludDiyPMEDXl1JrDYahIpEx3NOKgbjhxU8AumDDezwNHjT1Uh/Is+vTQIDnVaHhsovsFyqxXjFVnfR/UGKNQ0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VNa3SXn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VNa3SXn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A18C4CEF0;
	Thu,  4 Sep 2025 22:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757026521;
	bh=pbwL9Jb5cUDHT+JoiDDO8OJ4KwgU8acMhfnRJGUKSyk=;
	h=Date:To:From:Subject:From;
	b=VNa3SXn3pn84toWftKyte6qf9qvH+4TX91lxPOnRLCFcLSRd9o4SP5pmjG6uig4MR
	 5gSHcKywQO0ZS4XqIPo4bNQld1WA9tzFjJo4Y6x6dbRR5EYrjDzbPLRkzkkM0ykwYM
	 p+uTU2caucyxJnVJV7on4b1+C8Fi5MEGs+C8p32Q=
Date: Thu, 04 Sep 2025 15:55:20 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,spender@grsecurity.net,sbrivio@redhat.com,jirislaby@kernel.org,brauner@kernel.org,adobriyan@gmail.com,wangzijie1@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-fix-type-confusion-in-pde_set_flags.patch added to mm-hotfixes-unstable branch
Message-Id: <20250904225521.76A18C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: fix type confusion in pde_set_flags()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     proc-fix-type-confusion-in-pde_set_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-fix-type-confusion-in-pde_set_flags.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: wangzijie <wangzijie1@honor.com>
Subject: proc: fix type confusion in pde_set_flags()
Date: Thu, 4 Sep 2025 21:57:15 +0800

Commit 2ce3d282bd50 ("proc: fix missing pde_set_flags() for net proc
files") missed a key part in the definition of proc_dir_entry:

union {
	const struct proc_ops *proc_ops;
	const struct file_operations *proc_dir_ops;
};

So dereference of ->proc_ops assumes it is a proc_ops structure results in
type confusion and make NULL check for 'proc_ops' not work for proc dir.

Add !S_ISDIR(dp->mode) test before calling pde_set_flags() to fix it.

Link: https://lkml.kernel.org/r/20250904135715.3972782-1-wangzijie1@honor.com
Fixes: 2ce3d282bd50 ("proc: fix missing pde_set_flags() for net proc files")
Signed-off-by: wangzijie <wangzijie1@honor.com>
Reported-by: Brad Spengler <spender@grsecurity.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Stefano Brivio <sbrivio@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/proc/generic.c~proc-fix-type-confusion-in-pde_set_flags
+++ a/fs/proc/generic.c
@@ -393,7 +393,8 @@ struct proc_dir_entry *proc_register(str
 	if (proc_alloc_inum(&dp->low_ino))
 		goto out_free_entry;
 
-	pde_set_flags(dp);
+	if (!S_ISDIR(dp->mode))
+		pde_set_flags(dp);
 
 	write_lock(&proc_subdir_lock);
 	dp->parent = dir;
_

Patches currently in -mm which might be from wangzijie1@honor.com are

proc-fix-type-confusion-in-pde_set_flags.patch

