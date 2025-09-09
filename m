Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E687263E;
	Tue,  9 Sep 2025 06:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757400349; cv=none; b=AOmOOgMszFvaqTkReSeQlV+0QnM8zyK7hqIKlDkF2OFLXl39R0vvNWKGv9Tr2cfzXz56s2ngcYGfpsyCNKRO96kOWzPaSe1UqJlLpQE8eIuZeDuBcwu4asJTQNUwuBjkLct9P9MUpx1cSESuRuCeU6t9B5727U5jswHok6JyrcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757400349; c=relaxed/simple;
	bh=inKKkobQkSmznKowPvvVxEXuk41FTaQRmyH9+N6+Fbc=;
	h=Date:To:From:Subject:Message-Id; b=BnrXictXzMynyHJEX5PDNjrKP4hL6uNTvycud/hB+8etyR8+gcxsoFtkubmjXyCpiD3xj06P7UsaA7L4XKyhc18TgcAg7Kh50j1WIIJSn3f1XA+lboM+sDldZf3kfqlO2Cl5zbcAC2/yyi5zrzV4Pg7WQfOyY8np51eWcnRJrMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M9hs12hk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M9hs12hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4962CC113CF;
	Tue,  9 Sep 2025 06:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757400349;
	bh=inKKkobQkSmznKowPvvVxEXuk41FTaQRmyH9+N6+Fbc=;
	h=Date:To:From:Subject:From;
	b=M9hs12hkm4gsMHQ65/KJrsWiVKcyuZ1mhwoyypFh+zPFJMSTaJQtTI5YaI3yPadwP
	 A/D6VacUOL8Sj6FVMthWxRv+wqKI42Q/4DF0gt8I67hLirHU+SEkQzxsUvvB7Eb7mG
	 J0McwHSQVDbl54hhfSyjHv6U9dsrAQRvzp9S+mDo=
Date: Mon, 08 Sep 2025 23:45:48 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,spender@grsecurity.net,sbrivio@redhat.com,jirislaby@kernel.org,brauner@kernel.org,adobriyan@gmail.com,wangzijie1@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] proc-fix-type-confusion-in-pde_set_flags.patch removed from -mm tree
Message-Id: <20250909064549.4962CC113CF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: fix type confusion in pde_set_flags()
has been removed from the -mm tree.  Its filename was
     proc-fix-type-confusion-in-pde_set_flags.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Closes: https://lore.kernel.org/all/20250903065758.3678537-1-wangzijie1@honor.com/
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


