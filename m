Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793338951;
	b=YiL/dfiNWlnJQggg5WBHsUfAaN3F/dYdBC2lO32WmK0/UsOE/EodPRzp/5x63UQ2joeD
	 N2fOqsieubIJi30ucRCzb6BXC75gfyq6GoZpB/jWTki56VitozQ2HuCIdI7x23VxsSZJY
	 76XsgpGqkbJKdIKbOXUNkq5WsBkdMAVN3SgGk8TgZp8YI/1r5+hJO0iE0bK7Jy970eMTv
	 MAcHxHlK5Lh5VEa7VkzkwPxx9egiII34ZKcZzw8sYLzEwQq9GovgjKeEqkVyr8RZYUc8k
	 x5sZI/gJ76Zkz/3yPYYMEJKBGu0vjIOFV95rw35ta+mmZdzj3H0V4FOxO1jbpLSOKVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793338951;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=90wUAcW14KjTvoBfT8HzFAkBUX7LfNNeIKej+xiI/y0=;
	b=gQNrnLTUvmKgcz9J2M9WCV2X0nAxCXfb22NeUUQlTn6U4k8NH1gDElyNSNytwsnpwcvD
	 /EXZX+nxyuJL52VfsATtO5cY9Nfq9nVFMXQEaSNwjAX1cytbRWLnOqHIfTnjDxcX0y3dW
	 Cxk5303X36gS76fKUzmyJiCNOXAkxZwP4nQ9YCpVTdhUyru6imnEm8JdOhFiUqTn+z0HG
	 DqhoB0x+EZbX/u5HFos+aDaKH0wUPQuxYFjjt/IEFiHR6Bf8GX7wOe1+JA9SRiToFx4/1
	 7FNvnxdLC8IbXg6Ib/P9uQXj7SIXivxI7bDCOcmQq8YoxYFCkEASUvXPSS6mfZHUfYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GpTZks1g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425EA606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 05:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GpTZks1g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21821F000C1;
	Fri, 30 Oct 2026 05:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793338950;
	bh=90wUAcW14KjTvoBfT8HzFAkBUX7LfNNeIKej+xiI/y0=;
	h=Date:To:From:Subject;
	b=GpTZks1gcPLZwqsreDY4LIrnL9nVt8+CxddXVTvfMzC/B9eE9F40xziVdhrcQYYmT
	 /kKpjidYsIJ1l8XtvWA8dJSgBPZ2Twrxdkx+9s+1V+/VWi/WF9bfAC/fFEdmzSidHp
	 4XdYzetvF2hcjPSVKhXK8yaXNgaqwGgj0zk+VcU4=
Date: Thu, 29 Oct 2026 22:42:30 -0700
To: mm-commits@vger.kernel.org,brauner@kernel.org,oleg@redhat.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-use-pid_has_task-in-proc_inode_is_dead.patch added to mm-nonmm-unstable branch
Message-Id: <20261030054230.A21821F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: proc: use pid_has_task() in proc_inode_is_dead()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-use-pid_has_task-in-proc_inode_is_dead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-use-pid_has_task-in-proc_inode_is_dead.patch

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
From: Oleg Nesterov <oleg@redhat.com>
Subject: proc: use pid_has_task() in proc_inode_is_dead()
Date: Sat, 17 Oct 2026 18:00:57 +0200

to make it more readable and consistent.

Link: https://lore.kernel.org/atObuVZXbl9n-zFq@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/base.c~proc-use-pid_has_task-in-proc_inode_is_dead
+++ a/fs/proc/base.c
@@ -2065,7 +2065,7 @@ out:
 
 static inline bool proc_inode_is_dead(struct inode *inode)
 {
-	return !proc_pid(inode)->tasks[PIDTYPE_PID].first;
+	return !pid_has_task(proc_pid(inode), PIDTYPE_PID);
 }
 
 int pid_delete_dentry(const struct dentry *dentry)
_

Patches currently in -mm which might be from oleg@redhat.com are

proc-use-pid_has_task-in-proc_inode_is_dead.patch

