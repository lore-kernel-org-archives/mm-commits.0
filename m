Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F8A78C80
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824281; cv=none; b=gWGtaBiYKKrJgjavTcq7nCe896vZbzpKlM/hPoik1MgUZCiD+mIl58tGf5B2HkB1EgqCtfEl0lAgSCh1nua74Ip9tnIGBLjBx1fzTwOPkinoA+oRc6PVYXxGToSJq1BglQnkTv9bc9aQJ+SbgGK7EkQiizIfLMWOqoWxS87QOqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824281; c=relaxed/simple;
	bh=PjZc9f0c9hywc6WPssKUTSNP610JaNCQsGvU05TBUI8=;
	h=Date:To:From:Subject:Message-Id; b=DBHDBE+7VKbP2hDVvZe5sF/EhRXsUpbvd8vDdqqtDKpGYMVjY/Wds9gjczS5WJ0alPQJBlUPgIuXHz+Cg4AKSatsnWH5jKGtiZidN93XbNBOKJOxgyo1FHlQGTM9RmZV3ClVVPusqcCJGx4hIGDp3yk7b6Ua1SUoLBrr7CYsb+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g63Gc4tJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g63Gc4tJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C373C32782;
	Fri, 12 Jul 2024 22:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824280;
	bh=PjZc9f0c9hywc6WPssKUTSNP610JaNCQsGvU05TBUI8=;
	h=Date:To:From:Subject:From;
	b=g63Gc4tJWjrFMn1MV08YG+0m1aot6c+HSYHC3dADsfvSCQMfEPaKZ30j4Apsajibo
	 2RJ7hbOLFcyNgeytipWBzuHcEOdmQj+1PFm46/R1s5qn40QaQptxprgJrUNEZStnHa
	 +89HR5u5xlPGeJST4x16iaj7vXX0eem9m3MUnmXY=
Date: Fri, 12 Jul 2024 15:44:40 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,surenb@google.com,sfr@canb.auug.org.au,rppt@kernel.org,Liam.Howlett@oracle.com,gregkh@linuxfoundation.org,brauner@kernel.org,arnd@arndb.de,ak@linux.intel.com,adobriyan@gmail.com,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-procfs-add-build-id-fetching-to-procmap_query-api-fix.patch removed from -mm tree
Message-Id: <20240712224440.9C373C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/procfs: fix integer to pointer cast warning in do_procmap_query()
has been removed from the -mm tree.  Its filename was
     fs-procfs-add-build-id-fetching-to-procmap_query-api-fix.patch

This patch was dropped because it was folded into fs-procfs-add-build-id-fetching-to-procmap_query-api.patch

------------------------------------------------------
From: Andrii Nakryiko <andrii@kernel.org>
Subject: fs/procfs: fix integer to pointer cast warning in do_procmap_query()
Date: Mon, 1 Jul 2024 10:48:04 -0700

On 32-bit architectures compiler will complain about casting __u64 to
void * pointer:

fs/proc/task_mmu.c: In function 'do_procmap_query':
fs/proc/task_mmu.c:598:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  598 |         if (karg.vma_name_size && copy_to_user((void __user *)karg.vma_name_addr,
      |                                                ^
fs/proc/task_mmu.c:605:48: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  605 |         if (karg.build_id_size && copy_to_user((void __user *)karg.build_id_addr,
      |                                                ^

Fix this by using u64_to_user_ptr() helper that's meant to handle this
properly.

Link: https://lkml.kernel.org/r/20240701174805.1897344-1-andrii@kernel.org
Fixes: df789ce1eb90 ("fs/procfs: add build ID fetching to PROCMAP_QUERY API")
Fixes: 3757be498749 ("fs/procfs: implement efficient VMA querying API for /proc/<pid>/maps")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~fs-procfs-add-build-id-fetching-to-procmap_query-api-fix
+++ a/fs/proc/task_mmu.c
@@ -595,14 +595,14 @@ static int do_procmap_query(struct proc_
 	query_vma_teardown(mm, vma);
 	mmput(mm);
 
-	if (karg.vma_name_size && copy_to_user((void __user *)karg.vma_name_addr,
+	if (karg.vma_name_size && copy_to_user(u64_to_user_ptr(karg.vma_name_addr),
 					       name, karg.vma_name_size)) {
 		kfree(name_buf);
 		return -EFAULT;
 	}
 	kfree(name_buf);
 
-	if (karg.build_id_size && copy_to_user((void __user *)karg.build_id_addr,
+	if (karg.build_id_size && copy_to_user(u64_to_user_ptr(karg.build_id_addr),
 					       build_id_buf, karg.build_id_size))
 		return -EFAULT;
 
_

Patches currently in -mm which might be from andrii@kernel.org are

fs-procfs-extract-logic-for-getting-vma-name-constituents.patch
fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps.patch
fs-procfs-add-build-id-fetching-to-procmap_query-api.patch
docs-procfs-call-out-ioctl-based-procmap_query-command-existence.patch
tools-sync-uapi-linux-fsh-header-into-tools-subdir.patch
selftests-proc-add-procmap_query-ioctl-tests.patch

