Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5855818C03F
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 04:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744001057; cv=none; b=nH/L6IktYUKVNI5CBwqPPez4RPmhkfuCJyi8yNXlPKX8vkBvZEPWRceS0M3Od93G0TbexLzE/qkeZN644kd0GtjR4YhieMDXAP1bMrB+p/qH6rAv5qyIgR3BF11RfmQDXG6oum4mOtFmXlDsNyjEyL7gkr8psJdLFg/N4ypGeg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744001057; c=relaxed/simple;
	bh=0po5APxzKn1nWhH1wjdmEKjVB7w02hDsgJL7OS+R5zo=;
	h=Date:To:From:Subject:Message-Id; b=reon7qXUYeN6/GChqWeSU/p4mdJot+d0i61BSLqUkZ6pn/FSICl1X2HuQa8eaPyCExVUIKGDi832JFHtXFXaQ6TsS5PrDHv47e9uiMkYykIrSK1MAVgcl2XRqR+opBnAYdPEbB/yAmeF/PtKhfqL8fS7WrzPNlq9If8Tzg0/N2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u4kAUwYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u4kAUwYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5247C4CEDD;
	Mon,  7 Apr 2025 04:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744001055;
	bh=0po5APxzKn1nWhH1wjdmEKjVB7w02hDsgJL7OS+R5zo=;
	h=Date:To:From:Subject:From;
	b=u4kAUwYk4DHX/PHhyfTmX7xs+6DR2P0S1UGefhW+Km0n5mOZPZv6gC+oI/rIagb/2
	 Nu0lLE0pWo6MtPTrk6X5t+FpM+f9uC1+WvxSel6WoSAalc1/txwwahDEpp4xZKc/L0
	 4K/sDtDDmlnpvb3GmkSJvVX8VSzluqMbGNoeLZh8=
Date: Sun, 06 Apr 2025 21:44:14 -0700
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,osalvador@suse.de,mingo@kernel.org,david@redhat.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch added to mm-new branch
Message-Id: <20250407044415.A5247C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: fix wrongly calculated returned value in fault_in_safe_writeable()
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch

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
Subject: mm/gup: fix wrongly calculated returned value in fault_in_safe_writeable()
Date: Mon, 7 Apr 2025 11:03:04 +0800

Patch series "mm/gup: Minor fix, cleanup and improvements", v3.

These were made from code inspection in mm/gup.c.


This patch (of 3):

Not like fault_in_readable() or fault_in_writeable(), in
fault_in_safe_writeable() local variable 'start' is increased page by page
to loop till the whole address range is handled.  However, it mistakenly
calcalates the size of handled range with 'uaddr - start'.

Here fix the code bug in fault_in_safe_writeable(), and also adjusting the
codes in fault_in_readable() and fault_in_writeable() to use local
variable 'start' to loop so that codes in these three functions are
consistent.

Link: https://lkml.kernel.org/r/20250407030306.411977-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20250407030306.411977-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yanjun.Zhu <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/mm/gup.c~mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable
+++ a/mm/gup.c
@@ -2114,7 +2114,7 @@ static long __get_user_pages_locked(stru
  */
 size_t fault_in_writeable(char __user *uaddr, size_t size)
 {
-	char __user *start = uaddr, *end;
+	unsigned long start = (unsigned long)uaddr, end;
 
 	if (unlikely(size == 0))
 		return 0;
@@ -2122,20 +2122,20 @@ size_t fault_in_writeable(char __user *u
 		return size;
 	if (!PAGE_ALIGNED(uaddr)) {
 		unsafe_put_user(0, uaddr, out);
-		uaddr = (char __user *)PAGE_ALIGN((unsigned long)uaddr);
+		start = PAGE_ALIGN((unsigned long)uaddr);
 	}
-	end = (char __user *)PAGE_ALIGN((unsigned long)start + size);
+	end = PAGE_ALIGN(start + size);
 	if (unlikely(end < start))
-		end = NULL;
-	while (uaddr != end) {
-		unsafe_put_user(0, uaddr, out);
-		uaddr += PAGE_SIZE;
+		end = 0;
+	while (start != end) {
+		unsafe_put_user(0, (char __user *)start, out);
+		start += PAGE_SIZE;
 	}
 
 out:
 	user_write_access_end();
-	if (size > uaddr - start)
-		return size - (uaddr - start);
+	if (size > start - (unsigned long)uaddr)
+		return size - (start - (unsigned long)uaddr);
 	return 0;
 }
 EXPORT_SYMBOL(fault_in_writeable);
@@ -2207,8 +2207,8 @@ size_t fault_in_safe_writeable(const cha
 	} while (start != end);
 	mmap_read_unlock(mm);
 
-	if (size > (unsigned long)uaddr - start)
-		return size - ((unsigned long)uaddr - start);
+	if (size > start - (unsigned long)uaddr)
+		return size - (start - (unsigned long)uaddr);
 	return 0;
 }
 EXPORT_SYMBOL(fault_in_safe_writeable);
@@ -2223,7 +2223,7 @@ EXPORT_SYMBOL(fault_in_safe_writeable);
  */
 size_t fault_in_readable(const char __user *uaddr, size_t size)
 {
-	const char __user *start = uaddr, *end;
+	unsigned long start = (unsigned long)uaddr, end;
 	volatile char c;
 
 	if (unlikely(size == 0))
@@ -2232,21 +2232,21 @@ size_t fault_in_readable(const char __us
 		return size;
 	if (!PAGE_ALIGNED(uaddr)) {
 		unsafe_get_user(c, uaddr, out);
-		uaddr = (const char __user *)PAGE_ALIGN((unsigned long)uaddr);
+		start = PAGE_ALIGN((unsigned long)uaddr);
 	}
-	end = (const char __user *)PAGE_ALIGN((unsigned long)start + size);
+	end = PAGE_ALIGN(start + size);
 	if (unlikely(end < start))
-		end = NULL;
-	while (uaddr != end) {
-		unsafe_get_user(c, uaddr, out);
-		uaddr += PAGE_SIZE;
+		end = 0;
+	while (start != end) {
+		unsafe_get_user(c, (const char __user *)start, out);
+		start += PAGE_SIZE;
 	}
 
 out:
 	user_read_access_end();
 	(void)c;
-	if (size > uaddr - start)
-		return size - (uaddr - start);
+	if (size > start - (unsigned long)uaddr)
+		return size - (start - (unsigned long)uaddr);
 	return 0;
 }
 EXPORT_SYMBOL(fault_in_readable);
_

Patches currently in -mm which might be from bhe@redhat.com are

maintainers-add-andrew-and-myself-as-kexec-maintainer.patch
mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch
mm-gup-remove-unneeded-checking-in-follow_page_pte.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch

