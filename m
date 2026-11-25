Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590768;
	b=3xbEbvFTPeXxeRgOea+y1z1w4b+Nsh9jrZhZN6ojbLOziNHM3jnePzR7TXYaOcm5m6Lm
	 eUyxMnVhF8s4O1sZTK0WKNkKN7rT1nSauO9/0ggA+oSLVfAiYJ1ss2uo1NCl9aVSWfDP3
	 poGFL/cZ80ltNbqNcuO3U0Rh7MBVj888x8k/fmG1wYsZMd0tlHpUIErn8r5vgn7XbqBbf
	 XjDID2ij+C3rDa3NPYKeWpEgOOMDNttfcD2PJrPPghVGfx5ttc9H41H0uItfhbMf9i7Pj
	 U+b+RjqQ2cOUZbV4azyu2JZlSqX/hcBki0abu7zicvIrUt+v8wwIlKtX6rPQyW9NSyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590768;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=SPb7DEvgjmVx1R/yqT8tjCcXP3nggcIKrFsvVcbVl88=;
	b=Gk97gBQbc4J33KtzCXAhjobAv4VOBqaUdMgQ5S8RYwAEoOeytRUXWTOdvtrUZOZ/k6oM
	 lGs8DMKJVIhjkfM4yLRdO+KMqFzMmK1M4fqEAHySGYjaJ5+SNE8/19kqRs6gLDLzM89sA
	 r8uYSG6vkagiu2mUBXrScZ7gqK7O+iiLA7u18fbQPdQFTv1KyR5Nfk2wKr9fVok+Mjit3
	 Goa8SksRLy2xuZDf7E+dvC7BRnBRU28fp5Ohyozhbrg29fLXPrvV3z0RFoLwhpuRFY0lC
	 pwVGv3bUm/hKxaRcmyQahC3jYopy247STt5zFCVUpTWHgQymMl0V0Wqo8KROnsJiKsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CCsp2MWJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A2B606A329
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 07:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CCsp2MWJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E591F000C0;
	Wed, 25 Nov 2026 07:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795590768;
	bh=SPb7DEvgjmVx1R/yqT8tjCcXP3nggcIKrFsvVcbVl88=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=CCsp2MWJGJ+UQhX16jf7HSsWka3y05485NoPwYIbvytypbloegBKEPR8rJTbWwnDs
	 Z7gfhdODF2cOpbG9+8Itk4UshVtOELppzntoucHt13ompbczo8qHPt1A9WP0hdIG9I
	 BR5ge2davu3iFW6rJgccOY+9caTBA4dtzhx44aBs=
Date: Tue, 24 Nov 2026 23:12:47 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ts930@dgu.ac.kr,
	surenb@google.com,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,
	mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,
	david@kernel.org,alx@kernel.org,azpijr@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261102074412.189554-3-azpijr@gmail.com>
References: <20261102074412.189554-3-azpijr@gmail.com>
Subject: + mm-mlock-reject-ranges-that-cannot-be-represented.patch added to mm-new branch
Message-Id: <20261125071248.31E591F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mlock: reject ranges that cannot be represented
has been added to the -mm mm-new branch.  Its filename is
     mm-mlock-reject-ranges-that-cannot-be-represented.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mlock-reject-ranges-that-cannot-be-represented.patch

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
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: mm/mlock: reject ranges that cannot be represented
Date: Mon, 02 Nov 2026 08:44:00 +0100

A length within a page of ULONG_MAX wraps when mlock() and munlock() round
the range to pages.  At an aligned address the length becomes 0 and the
call is a silent success; at an unaligned one it becomes a single page,
which is then locked or unlocked.  An overflowing start + len is only
caught in apply_vma_lock_flags(), after the RLIMIT_MEMLOCK check, so
mlock() returns -ENOMEM without CAP_IPC_LOCK and -EINVAL with it.

Return -EINVAL, as man 2 mlock documents, when start + len overflows or
the end overflows when rounded up to a page.  Doing this before
can_do_mlock() also avoids making the result depend on
RLIMIT_MEMLOCK/CAP_IPC_LOCK.  Requests that get a silent success today now
fail.

Link: https://patch.msgid.link/20261102074412.189554-3-azpijr@gmail.com
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Park Tae-sun <ts930@dgu.ac.kr>
Closes: https://lore.kernel.org/all/179066531783.50175.13377521828379196177@dgu.ac.kr/
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Alejandro Colomar <alx@kernel.org>

 mm/mlock.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/mm/mlock.c~mm-mlock-reject-ranges-that-cannot-be-represented
+++ a/mm/mlock.c
@@ -608,6 +608,7 @@ static __must_check int do_mlock(unsigne
 {
 	unsigned long locked;
 	unsigned long lock_limit;
+	unsigned long end;
 	int error = -ENOMEM;
 
 	start = untagged_addr(start);
@@ -615,12 +616,19 @@ static __must_check int do_mlock(unsigne
 	if (!len)
 		return 0;
 
+	/* Reject a wrapping range before can_do_mlock() and the rlimit check. */
+	end = start + len;
+	if (end < start)
+		return -EINVAL;
+	end = PAGE_ALIGN(end);
+	if (!end)
+		return -EINVAL;
+	start &= PAGE_MASK;
+	len = end - start;
+
 	if (!can_do_mlock())
 		return -EPERM;
 
-	len = PAGE_ALIGN(len + (offset_in_page(start)));
-	start &= PAGE_MASK;
-
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
 	locked = len >> PAGE_SHIFT;
@@ -676,6 +684,7 @@ SYSCALL_DEFINE3(mlock2, unsigned long, s
 
 SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 {
+	unsigned long end;
 	vma_flags_t flags = EMPTY_VMA_FLAGS;
 	int ret;
 
@@ -684,8 +693,14 @@ SYSCALL_DEFINE2(munlock, unsigned long,
 	if (!len)
 		return 0;
 
-	len = PAGE_ALIGN(len + (offset_in_page(start)));
+	end = start + len;
+	if (end < start)
+		return -EINVAL;
+	end = PAGE_ALIGN(end);
+	if (!end)
+		return -EINVAL;
 	start &= PAGE_MASK;
+	len = end - start;
 
 	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
_

Patches currently in -mm which might be from azpijr@gmail.com are

mm-userfaultfd-recheck-wp-registration-in-the-hugetlb-uffdio_copy-retry.patch
selftests-mm-add-a-uffd-test-for-re-registering-during-uffdio_copy.patch
documentation-userfaultfd-document-rwp-behavior-when-the-pte-is-dropped.patch
mm-mlock-make-a-zero-length-request-a-no-op-whatever-the-alignment.patch
mm-mlock-reject-ranges-that-cannot-be-represented.patch
selftests-mm-test-mlock-and-munlock-range-normalisation.patch

