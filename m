Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4939F156236
	for <mm-commits@vger.kernel.org>; Mon, 14 Apr 2025 23:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744671625; cv=none; b=g8ccA3Mt+WNgsFnZokJ08cmPJKIl/YdLvEyjIDGw55ZFeLq0QAyavanawnnnGHXkCKYGMNW5hW4uQewQ91+DUakgu4LVr3+7/oFmw5FAizVdL0Ztfd3n122jJfI6lYbx1WbY7xgTnfw0bWGaGddSqL/6ayxPbha80A6+e0LQSsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744671625; c=relaxed/simple;
	bh=gtAlc2Z2F/o6dUa9AOLv9hBzPntHF7/4auXz+dSc3Qs=;
	h=Date:To:From:Subject:Message-Id; b=H9o0prWyM5lPLQdHpvBcDm1/fDww5+4ClR92zAKL0Vgq+/twm9R2qH4Y8/uHOrjYBZNS/ZcK2PxX1HPNI+4OnsoTlFrJSM4vkcVG0uKpSNXsOJChr3njLlKRf+Wu+YpSuLq5O6SBsfCEN47C2OCuwc3YKhpEswcUK6WYN+3i/zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u2Or6vUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u2Or6vUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1606C4CEE2;
	Mon, 14 Apr 2025 23:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744671625;
	bh=gtAlc2Z2F/o6dUa9AOLv9hBzPntHF7/4auXz+dSc3Qs=;
	h=Date:To:From:Subject:From;
	b=u2Or6vUTIdJ5EIZvE5/GGfrWGtCh7OVmNkCwnNK/CecUruMHdPN1Bj3JwR3/q3tav
	 6UX+C82bdqhFvMn+1KA5UNimVcFHyx/Ix0WnnB0dOtU6TUahqAjYh126hknTMxquBE
	 O4u6rnaFslcgRCk1Qpcm5gjlvdYISfGktev+toNg=
Date: Mon, 14 Apr 2025 16:00:24 -0700
To: mm-commits@vger.kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-clean-up-codes-in-fault_in_xxx-functions-v5.patch added to mm-new branch
Message-Id: <20250414230024.E1606C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-gup-clean-up-codes-in-fault_in_xxx-functions-v5
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-clean-up-codes-in-fault_in_xxx-functions-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-clean-up-codes-in-fault_in_xxx-functions-v5.patch

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
Subject: mm-gup-clean-up-codes-in-fault_in_xxx-functions-v5
Date: Sun, 13 Apr 2025 10:04:47 +0800

address minor concerns from David

Link: https://lkml.kernel.org/r/Z/sbv3EmLXWgEE7+@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/gup.c~mm-gup-clean-up-codes-in-fault_in_xxx-functions-v5
+++ a/mm/gup.c
@@ -2115,18 +2115,16 @@ size_t fault_in_writeable(char __user *u
 {
 	const unsigned long start = (unsigned long)uaddr;
 	const unsigned long end = start + size;
-	unsigned long cur = start;
+	unsigned long cur;
 
 	if (unlikely(size == 0))
 		return 0;
-
 	if (!user_write_access_begin(uaddr, size))
 		return size;
 
 	/* Stop once we overflow to 0. */
-	for (; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
+	for (cur = start; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
 		unsafe_put_user(0, (char __user *)cur, out);
-
 out:
 	user_write_access_end();
 	if (size > cur - start)
@@ -2186,7 +2184,7 @@ size_t fault_in_safe_writeable(const cha
 {
 	const unsigned long start = (unsigned long)uaddr;
 	const unsigned long end = start + size;
-	unsigned long cur = start;
+	unsigned long cur;
 	struct mm_struct *mm = current->mm;
 	bool unlocked = false;
 
@@ -2195,7 +2193,7 @@ size_t fault_in_safe_writeable(const cha
 
 	mmap_read_lock(mm);
 	/* Stop once we overflow to 0. */
-	for (; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
+	for (cur = start; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
 		if (fixup_user_fault(mm, cur, FAULT_FLAG_WRITE, &unlocked))
 			break;
 	mmap_read_unlock(mm);
@@ -2218,15 +2216,16 @@ size_t fault_in_readable(const char __us
 {
 	const unsigned long start = (unsigned long)uaddr;
 	const unsigned long end = start + size;
-	unsigned long cur = start;
+	unsigned long cur;
 	volatile char c;
 
 	if (unlikely(size == 0))
 		return 0;
 	if (!user_read_access_begin(uaddr, size))
 		return size;
+
 	/* Stop once we overflow to 0. */
-	for (; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
+	for (cur = start; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
 		unsafe_get_user(c, (const char __user *)cur, out);
 out:
 	user_read_access_end();
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch
mm-gup-remove-unneeded-checking-in-follow_page_pte.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
mm-gup-clean-up-codes-in-fault_in_xxx-functions.patch
mm-gup-clean-up-codes-in-fault_in_xxx-functions-v5.patch

