Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E252B674
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 03:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744343150; cv=none; b=E+DOf7nN8/x+ZxVLHxncotjPoWN9rq/AzpJtV4wTwtONDebu/3D+4ONx0vMWo5dKmIT+W2vTMEcKqfWqP/yU1LpLemPjW98edicVXlXG5eqQndNNWrPEtAXP9fieHEkxqCAVlhehNBIlo9B5/YJig8Y4oOggLtsPOXg7CT5lubE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744343150; c=relaxed/simple;
	bh=wEIk4J6e+NDLfMpLd4vL/V0KoGUwyVI0KKC60NWpCUo=;
	h=Date:To:From:Subject:Message-Id; b=kB1n4/4TDVuCBREOCGxQb8zSYNDxb5bu61dHJmYtl6QkvnaCunSLa+TubWdDiAxYXYTViTLJdqZc7Jrvf3R6U3L4KauFTxEEQnW2LgjGWlveCVHjZjKdMAsugYyMVhcQ/iCrhj7djGa2LQ6a0YqbE1mHvtLiqg43M9ylfc03pbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UV9PC2pF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UV9PC2pF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D5BC4CEE2;
	Fri, 11 Apr 2025 03:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744343150;
	bh=wEIk4J6e+NDLfMpLd4vL/V0KoGUwyVI0KKC60NWpCUo=;
	h=Date:To:From:Subject:From;
	b=UV9PC2pFEt/wH/0+FJ7ygw3hrAFuln8uo7qNqCrgZd1dsawDyHd4knxLLKAfqpNHn
	 kYscW5/YS0YO8j3LZPwEoN8IZ+GqFuEzYDGAVE63GCELzSm8pQMTDCQpQDzc2Py0Wc
	 eLsCQa/zTL+KMWQ7HwlMlHcyUXT7riI2yrZHeHG8=
Date: Thu, 10 Apr 2025 20:45:49 -0700
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,osalvador@suse.de,david@redhat.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-clean-up-codes-in-fault_in_xxx-functions.patch added to mm-new branch
Message-Id: <20250411034550.18D5BC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: clean up codes in fault_in_xxx() functions
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-clean-up-codes-in-fault_in_xxx-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-clean-up-codes-in-fault_in_xxx-functions.patch

This patch will later appear in the mm-new branch at
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
From: Baoquan He <bhe@redhat.com>
Subject: mm/gup: clean up codes in fault_in_xxx() functions
Date: Thu, 10 Apr 2025 11:57:17 +0800

The code style in fault_in_readable() and fault_in_writable() is a little
inconsistent with fault_in_safe_writeable().  In fault_in_readable() and
fault_in_writable(), it uses 'uaddr' passed in as loop cursor.  While in
fault_in_safe_writeable(), local variable 'start' is used as loop cursor. 
This may mislead people when reading code or making change in these codes.

Here define explicit loop cursor and use for loop to simplify codes in
these three functions.  These cleanup can make them be consistent in code
style and improve readability.

Link: https://lkml.kernel.org/r/20250410035717.473207-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yanjun.Zhu <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   65 +++++++++++++++++++++--------------------------------
 1 file changed, 26 insertions(+), 39 deletions(-)

--- a/mm/gup.c~mm-gup-clean-up-codes-in-fault_in_xxx-functions
+++ a/mm/gup.c
@@ -2113,28 +2113,24 @@ static long __get_user_pages_locked(stru
  */
 size_t fault_in_writeable(char __user *uaddr, size_t size)
 {
-	char __user *start = uaddr, *end;
+	const unsigned long start = (unsigned long)uaddr;
+	const unsigned long end = start + size;
+	unsigned long cur = start;
 
 	if (unlikely(size == 0))
 		return 0;
+
 	if (!user_write_access_begin(uaddr, size))
 		return size;
-	if (!PAGE_ALIGNED(uaddr)) {
-		unsafe_put_user(0, uaddr, out);
-		uaddr = (char __user *)PAGE_ALIGN((unsigned long)uaddr);
-	}
-	end = (char __user *)PAGE_ALIGN((unsigned long)start + size);
-	if (unlikely(end < start))
-		end = NULL;
-	while (uaddr != end) {
-		unsafe_put_user(0, uaddr, out);
-		uaddr += PAGE_SIZE;
-	}
+
+	/* Stop once we overflow to 0. */
+	for (; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
+		unsafe_put_user(0, (char __user *)cur, out);
 
 out:
 	user_write_access_end();
-	if (size > uaddr - start)
-		return size - (uaddr - start);
+	if (size > cur - start)
+		return size - (cur - start);
 	return 0;
 }
 EXPORT_SYMBOL(fault_in_writeable);
@@ -2188,26 +2184,24 @@ EXPORT_SYMBOL(fault_in_subpage_writeable
  */
 size_t fault_in_safe_writeable(const char __user *uaddr, size_t size)
 {
-	unsigned long start = (unsigned long)uaddr, end;
+	const unsigned long start = (unsigned long)uaddr;
+	const unsigned long end = start + size;
+	unsigned long cur = start;
 	struct mm_struct *mm = current->mm;
 	bool unlocked = false;
 
 	if (unlikely(size == 0))
 		return 0;
-	end = PAGE_ALIGN(start + size);
-	if (end < start)
-		end = 0;
 
 	mmap_read_lock(mm);
-	do {
-		if (fixup_user_fault(mm, start, FAULT_FLAG_WRITE, &unlocked))
+	/* Stop once we overflow to 0. */
+	for (; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
+		if (fixup_user_fault(mm, cur, FAULT_FLAG_WRITE, &unlocked))
 			break;
-		start = (start + PAGE_SIZE) & PAGE_MASK;
-	} while (start != end);
 	mmap_read_unlock(mm);
 
-	if (size > start - (unsigned long)uaddr)
-		return size - (start - (unsigned long)uaddr);
+	if (size > cur - start)
+		return size - (cur - start);
 	return 0;
 }
 EXPORT_SYMBOL(fault_in_safe_writeable);
@@ -2222,30 +2216,23 @@ EXPORT_SYMBOL(fault_in_safe_writeable);
  */
 size_t fault_in_readable(const char __user *uaddr, size_t size)
 {
-	const char __user *start = uaddr, *end;
+	const unsigned long start = (unsigned long)uaddr;
+	const unsigned long end = start + size;
+	unsigned long cur = start;
 	volatile char c;
 
 	if (unlikely(size == 0))
 		return 0;
 	if (!user_read_access_begin(uaddr, size))
 		return size;
-	if (!PAGE_ALIGNED(uaddr)) {
-		unsafe_get_user(c, uaddr, out);
-		uaddr = (const char __user *)PAGE_ALIGN((unsigned long)uaddr);
-	}
-	end = (const char __user *)PAGE_ALIGN((unsigned long)start + size);
-	if (unlikely(end < start))
-		end = NULL;
-	while (uaddr != end) {
-		unsafe_get_user(c, uaddr, out);
-		uaddr += PAGE_SIZE;
-	}
-
+	/* Stop once we overflow to 0. */
+	for (; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
+		unsafe_get_user(c, (const char __user *)cur, out);
 out:
 	user_read_access_end();
 	(void)c;
-	if (size > uaddr - start)
-		return size - (uaddr - start);
+	if (size > cur - start)
+		return size - (cur - start);
 	return 0;
 }
 EXPORT_SYMBOL(fault_in_readable);
_

Patches currently in -mm which might be from bhe@redhat.com are

maintainers-add-andrew-and-myself-as-kexec-maintainer.patch
mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch
mm-gup-remove-unneeded-checking-in-follow_page_pte.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
mm-gup-clean-up-codes-in-fault_in_xxx-functions.patch

