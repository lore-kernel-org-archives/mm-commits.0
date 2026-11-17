Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794894522;
	b=BW8aVFi6HgnlARwYRVlHY9JJFEc6b5devNKPfTPNGJFrKJDkBZNQHo+9IgayN7Pcu7i7
	 ohGHxizYrnHQCkuNOlIKf4dOP6tgw17MQ9oxX1CBsEFYXTchodJnR5o1AG3m1G6DirCs5
	 VjI3cZcG9BtnkAcyI4+bOYMI+j9hDvuNhbO6VLpncmpkktV+ZgB1/s2BXQ6/YydqE6Uy6
	 lTonPRCKyQYA5BnOSK0d8Lza0JvCKby6n3KveIPLVCfLNLrm8yYwJYYtoUYDDFQQm08nk
	 ufApm94YTpA4dJhAaVRoEODhGjTW+6oqt/4xdNIL16b/y+sl+VITrxF0u6/EX4uKMQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794894522;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=QZ1n+kaA1qJyWEqvvkpOqA3dWfJbaeOsST8X0NjFVsw=;
	b=ULkl/lH48xYc6XUzMG4fGhRxfeKQo+Sykx+HW5mRKSIyPe/JapmshYltyB4bNrG87cbV
	 905iAzmJtjgTVErpCHB2wu4Z0sbheNC1YkC4aLbzrXNWkTt00eNzH+Yg7WSYoVqbmHwSO
	 7/aM0/cfspz4QG4UItknRGzaZsNGcdaXyyrXcEcwkpOkrpDZG+ylqDbginpZ0icFzy8Tz
	 gQmavUduhFv5/fkacMBWRbNYXmeWYicD4mL5D6H/uqUF/F2mqxGdOWgqI8cAgGycqO5V3
	 WKv2FvfKQRB/5YmIo1LVwGhdH9kvV95qZwT/s79KG4/ynpWTME42qGIxZAQAz25ebtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="PdKc52/Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BB7606A31C
	for <mm-commits@vger.kernel.org>; Tue, 17 Nov 2026 05:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PdKc52/Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2CB1F000C5;
	Tue, 17 Nov 2026 05:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794894522;
	bh=QZ1n+kaA1qJyWEqvvkpOqA3dWfJbaeOsST8X0NjFVsw=;
	h=Date:To:From:Subject;
	b=PdKc52/ZBp3cVNS42m6knK8KmKLpR95lExRLgdvXM3MHhcShbzaVmT/YpU5c/VoPm
	 CB0tgI+2V4CC+q8Qb3ANZl4cMZAJWYNRyRwiuXAi1jE6gNlh6Z36UjVsFKxaVvD3HA
	 dedVj+4NueahMyC8gjAe7ORK+DUI7B+qwH1HiXbg=
Date: Mon, 16 Nov 2026 21:48:41 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,david@kernel.org,lihongfu@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-protection_keys-use-_exit-in-aarch64-ptrace-tracee.patch added to mm-new branch
Message-Id: <20261117054842.5F2CB1F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: protection_keys: use _exit() in aarch64 ptrace tracee
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-protection_keys-use-_exit-in-aarch64-ptrace-tracee.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-protection_keys-use-_exit-in-aarch64-ptrace-tracee.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: selftests/mm: protection_keys: use _exit() in aarch64 ptrace tracee
Date: Mon, 16 Nov 2026 16:56:11 +0800

Commit 25356081894d ("selftests/mm: protection_keys: use library code
for HugeTLB setup") replaced the exit() calls in the x86 version of
test_ptrace_modifies_pkru() with _exit(), but missed the aarch64
version, which still calls exit() from the tracee.

When the test runs as root, hugepage_save_settings() registers
hugepage_restore_settings_atexit() with atexit(). The tracee inherits
the atexit list across fork(), so its exit() runs
hugepage_restore_settings_atexit() in the child. That handler calls
hugetlb_restore_settings(), which writes nr_hugepages back to the saved
original value while the test is still running. If the saved original
value is 0 (or otherwise leaves fewer than the two free huge pages
needed by the next allocation), subsequent iterations fail in
malloc_pkey_hugetlb() when mmap(MAP_HUGETLB) returns MAP_FAILED.

Use _exit() in the aarch64 tracee as well, matching x86.

This was found by code inspection with AI assistance. No POE-capable
arm64 hardware was available, so test_ptrace_modifies_pkru() was not
runtime-tested; the change has only been compile-tested with an arm64
cross-compiler.

Link: https://lore.kernel.org/20261116-for-pkey-exit-v1-1-ca4c76b32ff7@kylinos.cn
Fixes: 25356081894d ("selftests/mm: protection_keys: use library code for HugeTLB setup")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>

 tools/testing/selftests/mm/protection_keys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-protection_keys-use-_exit-in-aarch64-ptrace-tracee
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -1530,11 +1530,11 @@ static void test_ptrace_modifies_pkru(in
 		 * checking
 		 */
 		if (__read_pkey_reg() != new_pkey)
-			exit(1);
+			_exit(1);
 
 		raise(SIGSTOP);
 
-		exit(0);
+		_exit(0);
 	}
 
 	pkey_assert(child == waitpid(child, &status, 0));
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-hugetlb-charge-hugetlb-cgroup-and-memcg-in-alloc_hugetlb_folio_reserve.patch
selftests-mm-mlock2-tests-fix-fclosenull-in-is_vmflag_set.patch
selftests-mm-protection_keys-use-_exit-in-aarch64-ptrace-tracee.patch

