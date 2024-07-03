Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB6C184E
	for <mm-commits@vger.kernel.org>; Wed,  3 Jul 2024 02:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972002; cv=none; b=Ulv8J7JbXnM117ae6cMhNtafES1nxuJrISDXhY2Z9Go1mn+D3rbG3Y58IGzrAY/xZ5AX6kzuew2A928r0wLRoXzxPHVVHGvSle1cHf7dJYv5iFuApWDMvDjcueKbIorhqmSvGr9IKN5JeTsr2kVWZu7gUpP77fk/+ihA6mO0Rf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972002; c=relaxed/simple;
	bh=oa46lgr8drNBeXhTKWzeiV5CCRVroMdJBYzvvNxZskc=;
	h=Date:To:From:Subject:Message-Id; b=jURgg0+QO4dZ0jnZgTqMa411KhYd5ZxOv42pvYzQuHsUIH3rEIijIAv4PHwJOXx7VWBxpKPLa0ylpHKzJjzj3/gulGk0ZLzgWK2lvmW5Er887s3RZXO7gVCyzCjj/fHNkSsCBztZdDiaHJaIzT2qlq0QHo43n+QVfuq3+yxl4Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cikQCUuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cikQCUuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B89CC116B1;
	Wed,  3 Jul 2024 02:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719972001;
	bh=oa46lgr8drNBeXhTKWzeiV5CCRVroMdJBYzvvNxZskc=;
	h=Date:To:From:Subject:From;
	b=cikQCUuZGIz/IdxQQzYI6Dd3Gtvjh1LDzdnrPmyyGLeE5itHDDCJ/MZgvavrt+a7E
	 AVYbW+OvJQYkSomk7Rn34/g6vAVZrpyQXei4t9MS3aWm3IO9YKo1/xhM5zWWCktuPt
	 37QiCzrGb7RprhW+UpmROaUvLw/SHEGfBlwAuEA8=
Date: Tue, 02 Jul 2024 19:00:00 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,muchun.song@linux.dev,catalin.marinas@arm.com,yang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] hugetlbfs-add-mte-support.patch removed from -mm tree
Message-Id: <20240703020001.7B89CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlbfs: add MTE support
has been removed from the -mm tree.  Its filename was
     hugetlbfs-add-mte-support.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yang Shi <yang@os.amperecomputing.com>
Subject: hugetlbfs: add MTE support
Date: Tue, 25 Jun 2024 16:37:17 -0700

MTE can be supported on ram based filesystem.  It is supported on tmpfs. 
There is use case to use MTE on hugetlbfs as well, adding MTE support.

Exercising this capability requires special arrangements.  This needs
hardware support and custom-patched QEMU.  We did in-house testing on
AmpereOne platform with patched QEMU 8.1.

Custom-patched QEMU is not required for a minimum test.  But a special
test program is definitely needed.  We used custom-patched QEMU to test
VM backed by hugetlbfs with MTE enabled.

Link: https://lkml.kernel.org/r/20240625233717.2769975-1-yang@os.amperecomputing.com
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-add-mte-support
+++ a/fs/hugetlbfs/inode.c
@@ -110,7 +110,7 @@ static int hugetlbfs_file_mmap(struct fi
 	 * way when do_mmap unwinds (may be important on powerpc
 	 * and ia64).
 	 */
-	vm_flags_set(vma, VM_HUGETLB | VM_DONTEXPAND);
+	vm_flags_set(vma, VM_HUGETLB | VM_DONTEXPAND | VM_MTE_ALLOWED);
 	vma->vm_ops = &hugetlb_vm_ops;
 
 	ret = seal_check_write(info->seals, vma);
_

Patches currently in -mm which might be from yang@os.amperecomputing.com are

mm-page_ref-remove-folio_try_get_rcu.patch
mm-gup-stop-abusing-try_grab_folio.patch

