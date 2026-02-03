Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8632FBDF2
	for <mm-commits@vger.kernel.org>; Tue,  3 Feb 2026 02:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770086492; cv=none; b=HP/7jt7NSX8ndSs8deryq1anloSJFbvcwVZ6NFXwfj5VeJynmpDeW+amt60aH+bu90B2awYEkEyaMURYygPqgOyZlSuADnlTTNFrivRaV3uts/b1Alki/1zwXCrzJ4gO2ysbz4aKq3w1PQf88SH8MdUC/nAfT6ahQ95hxeah+u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770086492; c=relaxed/simple;
	bh=oR6r+wdJJKCqPJLPLOz4La4rXrIzVXoP9773N4dTX3E=;
	h=Date:To:From:Subject:Message-Id; b=rrO4v7dWo/6TJeaAhIHqh5hkd2SqrPOrzGPG72j4Mt2KJCxWmoCaNUsR+jjueIZCZMV83Xww8QFkn2esOfu6p9Z+yVM9Lgk5q8GQYCXq209jXkMbvw0wcJ3IS5FfpwrtsX5QyJXZ+tqeLwBlHv2eyNW2V78VlDeC08APzzoJTFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s0TLkotV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s0TLkotV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C45AC116C6;
	Tue,  3 Feb 2026 02:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770086491;
	bh=oR6r+wdJJKCqPJLPLOz4La4rXrIzVXoP9773N4dTX3E=;
	h=Date:To:From:Subject:From;
	b=s0TLkotV5NcJerTojSO8oWsqgyYl6RxkZChkdiCR/yK6q3kYeVfC68bOEzUA4GK69
	 8yXcomhBx0cTKi0+NoIi9f7lH3VN+K2m1Z0QtLW+ZsdWh6JutJnFMVMb4dhctuGsAl
	 9SxRRooia7ynwWV6rmm3H+Ak8k+l1/af+JyB3Rno=
Date: Mon, 02 Feb 2026 18:41:30 -0800
To: mm-commits@vger.kernel.org,ast@kernel.org,andrii@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch removed from -mm tree
Message-Id: <20260203024131.8C45AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: procfs-avoid-fetching-build-id-while-holding-vma-lock-fix
has been removed from the -mm tree.  Its filename was
     procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch

This patch was dropped because it was folded into procfs-avoid-fetching-build-id-while-holding-vma-lock.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-avoid-fetching-build-id-while-holding-vma-lock-fix
Date: Fri Jan 30 12:39:13 PM PST 2026

fix up kerneldoc

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/buildid.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/lib/buildid.c~procfs-avoid-fetching-build-id-while-holding-vma-lock-fix
+++ a/lib/buildid.c
@@ -315,8 +315,8 @@ out:
 	return ret;
 }
 
-/*
- * Parse build ID of ELF file mapped to vma
+/**
+ * build_id_parse_nofault() - Parse build ID of ELF file mapped to vma
  * @vma:      vma object
  * @build_id: buffer to store build id, at least BUILD_ID_SIZE long
  * @size:     returns actual build id size in case of success
@@ -334,8 +334,8 @@ int build_id_parse_nofault(struct vm_are
 	return __build_id_parse(vma->vm_file, build_id, size, false /* !may_fault */);
 }
 
-/*
- * Parse build ID of ELF file mapped to VMA
+/**
+ * build_id_parse() - Parse build ID of ELF file mapped to VMA
  * @vma:      vma object
  * @build_id: buffer to store build id, at least BUILD_ID_SIZE long
  * @size:     returns actual build id size in case of success
@@ -354,7 +354,7 @@ int build_id_parse(struct vm_area_struct
 }
 
 /**
- * Parse build ID of ELF file
+ * build_id_parse_file() - Parse build ID of ELF file
  * @file:      file object
  * @build_id: buffer to store build id, at least BUILD_ID_SIZE long
  * @size:     returns actual build id size in case of success
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-avoid-fetching-build-id-while-holding-vma-lock.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
liveupdate-luo_file-remember-retrieve-status-fix.patch

