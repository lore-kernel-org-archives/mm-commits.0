Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D791DA316
	for <mm-commits@vger.kernel.org>; Wed,  3 Jul 2024 19:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720035151; cv=none; b=eC6wcNHPZ+xchQbMpJlt/2lkd9o/pC2q4XQFUu59JnNiJIseS8egqihgg10zRPLpZHplr97uJfQ98+M0eW+0VJT5M6p4+D0gVUb7TzAKC31pWGeh1FqExLb9EcKsjrgBghZx5g+CVNa3lWkpemlXtJMLEylbWheJ00Nn1w2rpL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720035151; c=relaxed/simple;
	bh=s90/tboHyOhCql16DlkYuUnyKVgxKfoB+5iiBveFerU=;
	h=Date:To:From:Subject:Message-Id; b=Z0Ym5CJcXPsT3rEkUKT1flcsoT0YnNHw2nbwgDsKAert4bZChlQCwPrJRnYUUKeSs64prKkkxaonQOinKYFRXY3KX05L3xkoJfl1yPHx3cyhOsz/0qjoWRP8FsGXKFbAFX/6ACsXG2CAJWYL8E6ll+oJ2mWz/oI1kAhp6KYtNwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1AXpLnAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1AXpLnAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7648C4AF0B;
	Wed,  3 Jul 2024 19:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720035150;
	bh=s90/tboHyOhCql16DlkYuUnyKVgxKfoB+5iiBveFerU=;
	h=Date:To:From:Subject:From;
	b=1AXpLnAMPIVcE0TtDNIykoWPyEK7H6U2kFZK45rboAzav9sD1hSD7ZwQEI4hdUxL7
	 CTUi75erJQBigrk5zcmUUxiroDnmpXOMYA9GQSVd4GVBnMC0H63NIvg3WM/TwRujLb
	 uiBFPCXa9X8VKC8Zq08VeSf5cQIq7X3/YUyKxbRI=
Date: Wed, 03 Jul 2024 12:32:30 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,arnd@arndb.de,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-procfs-add-build-id-fetching-to-procmap_query-api-fix.patch added to mm-unstable branch
Message-Id: <20240703193230.C7648C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/procfs: fix integer to pointer cast warning in do_procmap_query()
has been added to the -mm mm-unstable branch.  Its filename is
     fs-procfs-add-build-id-fetching-to-procmap_query-api-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-procfs-add-build-id-fetching-to-procmap_query-api-fix.patch

This patch will later appear in the mm-unstable branch at
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
fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps-fix.patch
fs-procfs-add-build-id-fetching-to-procmap_query-api.patch
fs-procfs-add-build-id-fetching-to-procmap_query-api-fix.patch
docs-procfs-call-out-ioctl-based-procmap_query-command-existence.patch
tools-sync-uapi-linux-fsh-header-into-tools-subdir.patch
selftests-proc-add-procmap_query-ioctl-tests.patch

