Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D594C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011134; cv=none; b=lmfTlcXGuHCRlEudtlzEGcj9R6XRPvOAVaEfduDoICdIOI/dm4K+dmZcmpHnZQX8VmM9EucuCacLwldMjFASOD3fU6WrU7T/8xcnpSbqjZbND4a+FZUk6LuwZ+QukpgbCTlcBYMNmhEr6uIrQn0boAG6XahchCxfzFjN5+fEJ/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011134; c=relaxed/simple;
	bh=Q9FQaK0k1R5PXtt9CqhtfNcBmfIYT8Ofwo44u3im3nM=;
	h=Date:To:From:Subject:Message-Id; b=p8ZzTTxGud8dwPPIVIzwCg4VhtHRYJwhP9WyW8sNKolseg9Yjd5cmEiZW0Sp84SQBVy3TyZJZjVIN+QQCy9l9WRljV5kFLUhCklaqGCGiksCWAue0H28KenOUGH3k0m3GhYS5tinedOwVuxqjO7bYmQH+c7EsajjE8J115i2wd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qTVdTzas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qTVdTzas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E4BC4CEE4;
	Mon, 12 May 2025 00:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011134;
	bh=Q9FQaK0k1R5PXtt9CqhtfNcBmfIYT8Ofwo44u3im3nM=;
	h=Date:To:From:Subject:From;
	b=qTVdTzasB5Jw9V6adnBDkiA6eOr8QHpGpiX5WLsEhWAeDNewyVo59kXA/0QHnB4us
	 MzoGcJhCH56RxLV+G8f7fLaUsysI2tHCj91j3xfB0hkR9h25kOSQmqdG6bx3hMejV/
	 ERiBZGlrwb19+FQeUv8/I67jXidyucBYFVlnc3lo=
Date: Sun, 11 May 2025 17:52:13 -0700
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,osalvador@suse.de,david@redhat.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-clean-up-codes-in-fault_in_xxx-functions.patch removed from -mm tree
Message-Id: <20250512005214.03E4BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: clean up codes in fault_in_xxx() functions
has been removed from the -mm tree.  Its filename was
     mm-gup-clean-up-codes-in-fault_in_xxx-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[bhe@redhat.com: address minor concerns from David]
  Link: https://lkml.kernel.org/r/Z/sbv3EmLXWgEE7+@MiWiFi-R3L-srv
Link: https://lkml.kernel.org/r/20250410035717.473207-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yanjun.Zhu <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   62 ++++++++++++++++++++---------------------------------
 1 file changed, 24 insertions(+), 38 deletions(-)

--- a/mm/gup.c~mm-gup-clean-up-codes-in-fault_in_xxx-functions
+++ a/mm/gup.c
@@ -2113,28 +2113,22 @@ static long __get_user_pages_locked(stru
  */
 size_t fault_in_writeable(char __user *uaddr, size_t size)
 {
-	char __user *start = uaddr, *end;
+	const unsigned long start = (unsigned long)uaddr;
+	const unsigned long end = start + size;
+	unsigned long cur;
 
 	if (unlikely(size == 0))
 		return 0;
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
 
+	/* Stop once we overflow to 0. */
+	for (cur = start; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
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
@@ -2188,26 +2182,24 @@ EXPORT_SYMBOL(fault_in_subpage_writeable
  */
 size_t fault_in_safe_writeable(const char __user *uaddr, size_t size)
 {
-	unsigned long start = (unsigned long)uaddr, end;
+	const unsigned long start = (unsigned long)uaddr;
+	const unsigned long end = start + size;
+	unsigned long cur;
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
+	for (cur = start; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
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
@@ -2222,30 +2214,24 @@ EXPORT_SYMBOL(fault_in_safe_writeable);
  */
 size_t fault_in_readable(const char __user *uaddr, size_t size)
 {
-	const char __user *start = uaddr, *end;
+	const unsigned long start = (unsigned long)uaddr;
+	const unsigned long end = start + size;
+	unsigned long cur;
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
 
+	/* Stop once we overflow to 0. */
+	for (cur = start; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
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

mm-vmallocc-change-purge_ndoes-as-local-static-variable.patch
mm-vmallocc-find-the-vmap-of-vmap_nodes-in-reverse-order.patch
mm-vmallocc-optimize-code-in-decay_va_pool_node-a-little-bit.patch
mm-vmalloc-optimize-function-vm_unmap_aliases.patch
mm-vmallocc-return-explicit-error-value-in-alloc_vmap_area.patch

