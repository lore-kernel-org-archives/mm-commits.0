Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4173D1712
	for <mm-commits@vger.kernel.org>; Mon, 17 Aug 2026 21:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787003794; cv=none; b=CpZO2HFUAoIR7JpLWiNSYngYBm2fW1dVMgHpfsbjDcoZDFvwf0NtQaAvpTgw15H6vhtUrx9En61yCVnEY+68e7MCkDojtxc+GRsH3fA/n81UBUFG4gv9kO7TNNQ9IUCFf2Tmyw6AEoOlc+GLbO+JrqnkEnc4nYp2LIHbUI/l+vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787003794; c=relaxed/simple;
	bh=R60a6ulgz77l3ThrQyHbXKUzbSDwFmFyQEgmZoJAl48=;
	h=Date:To:From:Subject:Message-Id; b=Q8Wk2nU2F0dWX/aO7wtIO/9WDkMzLCrJUuMY6JYSynCDNITz9avHhlUmu5o/JBx0ZNFWo0gawaNkXJh1yQ76DSDlVJIPR65eF2vxbn52G74M76v3aUUhDddgCKIqw9Xt7fPQsIHggrr1AGAu+ZftWdnKz7adw45zc2x0ak230dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bqaxvazd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bqaxvazd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592C81F000E9;
	Mon, 17 Aug 2026 21:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787003788;
	bh=XPCUNZsuyDPzY5KEsDNuRbHmyFBbx3DcICq8S/l0IhE=;
	h=Date:To:From:Subject;
	b=BqaxvazdMfbTLuIJKaHXq5l+DGLsAWmwubEhSkCYS2jLtY0dIz4dd54rR5SGOxix3
	 aNpxFV7ZVtQ6Ylwyb3Qm89IedUb6n+/gdHqVWJyuHj8po4pYLtZ61FG6fQfRaz60GZ
	 P2Chx5b1zgL5WJxb0M4ZR8jzR2E6xDuIJF6bfn78=
Date: Mon, 17 Aug 2026 14:56:27 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-drop-redundant-open-in-mprotect_tests.patch added to mm-unstable branch
Message-Id: <20260817215628.592C81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: drop redundant open() in mprotect_tests()
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-drop-redundant-open-in-mprotect_tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-drop-redundant-open-in-mprotect_tests.patch

This patch will later appear in the mm-unstable branch at
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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: drop redundant open() in mprotect_tests()
Date: Mon, 17 Aug 2026 16:06:16 +0800

Remove duplicate open() for local pagemap_fd in mprotect_tests() that
shadows the global pagemap_fd already opened in main().  The local fd is
never used in the function.

Link: https://lore.kernel.org/20260817080616.52946-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-drop-redundant-open-in-mprotect_tests
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1332,12 +1332,6 @@ int mprotect_tests(void)
 	int ret;
 	char *mem, *mem2;
 	struct page_region vec;
-	int pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
-
-	if (pagemap_fd < 0) {
-		fprintf(stderr, "open() failed\n");
-		exit(1);
-	}
 
 	/* 1. Map two pages */
 	mem = mmap(0, 2 * page_size, PROT_READ|PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

ksm-update-comments-and-docs-to-reference-folio-mapping.patch
selftests-mm-drop-duplicate-test_seal_mprotect_two_vma_with_gap-call.patch
selftests-mm-fix-read_file-return-value-check.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch
mm-cma-remove-stray-newline-from-auto-generated-cma-area-name.patch
selftests-mm-drop-redundant-open-in-mprotect_tests.patch

