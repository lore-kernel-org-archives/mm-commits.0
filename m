Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6F234679C
	for <mm-commits@vger.kernel.org>; Fri, 30 Jan 2026 20:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769805789; cv=none; b=LFD0N64MgNg+XJ0KVgEqRgwaqH3Npqfv/DQLCeRgWXVntH3+covM5w3+bWIgUQM/BS/HC5NyHUf1wRVRajSH/At8/vuylvWFWPgjvyB1DzqVRRsZz4xEJIucbwMj9IP9RWntvr/lYl1t1ELXa4A4fdJ576nrd5C7jxVG8b+UiDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769805789; c=relaxed/simple;
	bh=5TUdVANuy5Pu1yohHm6CwfUVAb8CP55Zi3b5q8IqbsI=;
	h=Date:To:From:Subject:Message-Id; b=hnmkGXRV38XXCqWs+689WNzqusIZHim4h4rQsTHWAhnyU0isaopjBusC2/ZwKC63GyXUvnpS8+EwEkN1SPbp3j3TCwmYrmKqDCE7FT6P+qScsEtuV6/pentFCq8pemmWwxruiEhyRB6Rs5UHHTrR5hf4I/ktFVmRio5GOCoMjjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DpF8YW0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DpF8YW0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65377C4CEF7;
	Fri, 30 Jan 2026 20:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769805789;
	bh=5TUdVANuy5Pu1yohHm6CwfUVAb8CP55Zi3b5q8IqbsI=;
	h=Date:To:From:Subject:From;
	b=DpF8YW0u4GDiL88riJfnTP4NzNe+DWXTCFzP/rvAMwSSRS8L7ts4bPnJVRZQerlLW
	 Mk+os8lJoTZ9whah9xjDAYI8NwkHiMygbtgnCm21hN8MHV1EY/LIz3wmKWARLFF0aX
	 I48trtOooYzXgTE8XT0R9RnfQUabLSIVny9kEKag=
Date: Fri, 30 Jan 2026 12:43:08 -0800
To: mm-commits@vger.kernel.org,ast@kernel.org,andrii@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20260130204309.65377C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: procfs-avoid-fetching-build-id-while-holding-vma-lock-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch

