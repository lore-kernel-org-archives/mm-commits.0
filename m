Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99BA393DE6
	for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2025 22:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755813711; cv=none; b=oLyP4eOXWKef3Ah2BFkje4TUIY1fiCNewkl8q7TqWOgm1BnGHRsL7DK/4gOCrsCNNKLr5YJwqxguOd9P6/BXKdeufsOP6Docv8G9XvnoBmdgNUrA+Lyf1VcZB0odg7wqd08RfaOpckjqbnxco8GG3vMod5RXDjPisOgK1cs6Y0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755813711; c=relaxed/simple;
	bh=+hkRA0kLIihY4KSyCelhlASWaKuV7HLtJtyX4d74n1c=;
	h=Date:To:From:Subject:Message-Id; b=jfCJLufZ/OyAKTPQSIdVwGzNp1N5rohPzW6hpeYNNVKxImpo6kiVb+ST8yPlAC63QMd4zUUfG1Lqqma0o6BVib3/kZSrCPQbxB5J/0K1l9vkKjf16eU4syGfmlxTplUDcgGbc+/tEOfZlmRzkIF5onPHo9L+a5FXa04lpEEXyFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OiEKi0jc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OiEKi0jc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8D8C4CEEB;
	Thu, 21 Aug 2025 22:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755813711;
	bh=+hkRA0kLIihY4KSyCelhlASWaKuV7HLtJtyX4d74n1c=;
	h=Date:To:From:Subject:From;
	b=OiEKi0jczD48AGsl1TUHIh/Q06P/OWPv8Rg0VOrVNt8tlex34U72ZfFLKnIJsVzPi
	 LA+c7s+q/vsnSy+5jBXX03dlYDfByEHHb9Oq1BiyS1qKQh3Sin309rMB1cHwrhJl5W
	 hpv6H2VVI3Tdt3XdA/D9cfrvUAdk8HqwRbMunN3o=
Date: Thu, 21 Aug 2025 15:01:50 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,rick.p.edgecombe@intel.com,polynomial-c@gmx.de,k.shutemov@gmail.com,jirislaby@kernel.org,gregkh@linuxfoundation.org,ast@kernel.org,adobriyan@gmail.com,wangzijie1@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-fix-missing-pde_set_flags-for-net-proc-files-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20250821220151.0A8D8C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc-fix-missing-pde_set_flags-for-net-proc-files-v3
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     proc-fix-missing-pde_set_flags-for-net-proc-files-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-fix-missing-pde_set_flags-for-net-proc-files-v3.patch

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
Subject: proc-fix-missing-pde_set_flags-for-net-proc-files-v3
Date: Thu, 21 Aug 2025 18:58:06 +0800

stash pde->proc_ops in a local const variable, per Christian

Link: https://lkml.kernel.org/r/20250821105806.1453833-1-wangzijie1@honor.com
Fixes: ff7ec8dc1b64 ("proc: use the same treatment to check proc_lseek as ones for proc_read_iter et.al")
Signed-off-by: wangzijie <wangzijie1@honor.com>
Reported-by: Lars Wendler <polynomial-c@gmx.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/proc/generic.c~proc-fix-missing-pde_set_flags-for-net-proc-files-v3
+++ a/fs/proc/generic.c
@@ -369,18 +369,20 @@ static const struct inode_operations pro
 
 static void pde_set_flags(struct proc_dir_entry *pde)
 {
-	if (!pde->proc_ops)
+	const struct proc_ops *proc_ops = pde->proc_ops;
+
+	if (!proc_ops)
 		return;
 
-	if (pde->proc_ops->proc_flags & PROC_ENTRY_PERMANENT)
+	if (proc_ops->proc_flags & PROC_ENTRY_PERMANENT)
 		pde->flags |= PROC_ENTRY_PERMANENT;
-	if (pde->proc_ops->proc_read_iter)
+	if (proc_ops->proc_read_iter)
 		pde->flags |= PROC_ENTRY_proc_read_iter;
 #ifdef CONFIG_COMPAT
-	if (pde->proc_ops->proc_compat_ioctl)
+	if (proc_ops->proc_compat_ioctl)
 		pde->flags |= PROC_ENTRY_proc_compat_ioctl;
 #endif
-	if (pde->proc_ops->proc_lseek)
+	if (proc_ops->proc_lseek)
 		pde->flags |= PROC_ENTRY_proc_lseek;
 }
 
_

Patches currently in -mm which might be from wangzijie1@honor.com are

proc-fix-missing-pde_set_flags-for-net-proc-files.patch
proc-fix-missing-pde_set_flags-for-net-proc-files-v3.patch

