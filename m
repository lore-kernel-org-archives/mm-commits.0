Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2255E2FD665;
	Fri,  3 Apr 2026 17:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775237543; cv=none; b=i+t5uPsSpMdJvAyYzVkKuA/DHwJ35sgJUSNk2Ygs/d39WTI1iEwVmHdTp5MBu+y6BAHsjX0x1cqY+/ObZvGKCxxY4x/hdBqlJhxIF9Ic9HnblAdH+hzG3m8XHCZyAVRhoCIaD+z5lzHhadf9OALfcgeFrdAg2+sZIfT5MUf4G7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775237543; c=relaxed/simple;
	bh=9hMsoNm0XbId952oZoxtn/0arLkFesFZm702d4Y3+bg=;
	h=Date:To:From:Subject:Message-Id; b=NZbQS9cerI8cCi4NcdkZNYQxIgC8rdx6bs8YbVovt46naI9VOtgYPI0E8d0fMWHEja3wj81RMkJOFNfn0KcMTQpQTRPCh97sKZ3OEozQ9JF3rm6awUaC7iUyaxG8utaPXU8SQXagWL7MucQ6v12+Jv/QXUQ5qrXVgzNW8yBoSa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LDlmnFuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LDlmnFuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEBFC4CEF7;
	Fri,  3 Apr 2026 17:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775237542;
	bh=9hMsoNm0XbId952oZoxtn/0arLkFesFZm702d4Y3+bg=;
	h=Date:To:From:Subject:From;
	b=LDlmnFuoiADF5WzD+3dTcHDzQ0tMj0V6sWtZnTHEInAVIN0XzPcCikDgEkqlHCwBb
	 Qn4M2y3nxHYHmQHfh2JokwmnZzXGoubNRvY9wrvqpqZffS/uFjaGyiC7JM0ABUcHDK
	 JxwydAkXcYlqY3m+MfPMMKDT+0SsGGmFR6bkywSM=
Date: Fri, 03 Apr 2026 10:32:22 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jason@zx2c4.com,jannh@google.com,david@kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-fix-mmap-errno-value-when-map_droppable-is-not-supported.patch removed from -mm tree
Message-Id: <20260403173222.8AEBFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix mmap errno value when MAP_DROPPABLE is not supported
has been removed from the -mm tree.  Its filename was
     mm-fix-mmap-errno-value-when-map_droppable-is-not-supported.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: mm: fix mmap errno value when MAP_DROPPABLE is not supported
Date: Wed, 1 Apr 2026 17:34:16 -0700

On configs where MAP_DROPPABLE is not supported (currently any 32-bit
config except for PPC32), mmap fails with errno set to ENOTSUPP.  However,
ENOTSUPP is not a standard error value that userspace knows about.  The
acceptable userspace-visible errno to use is EOPNOTSUPP.  checkpatch.pl
has a warning to this affect.

Link: https://lkml.kernel.org/r/20260402003417.438037-2-anthony.yznaga@oracle.com
Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-fix-mmap-errno-value-when-map_droppable-is-not-supported
+++ a/mm/mmap.c
@@ -504,7 +504,7 @@ unsigned long do_mmap(struct file *file,
 			break;
 		case MAP_DROPPABLE:
 			if (VM_DROPPABLE == VM_NONE)
-				return -ENOTSUPP;
+				return -EOPNOTSUPP;
 			/*
 			 * A locked or stack area makes no sense to be droppable.
 			 *
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are

selftests-mm-verify-droppable-mappings-cannot-be-locked.patch

