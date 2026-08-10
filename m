Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07610282F0C;
	Mon, 10 Aug 2026 22:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786400256; cv=none; b=krlutMA9Bpk8pZw/r+h1t+hRblfm19L0CRlgHcCsMGFGjun9PtibfCQlPXFBtztLhccUFq3YrA+X2yBIxcpRDA0vM1J7Y8cty6rrMYKi2UdJrYSepT6+KI1N7h/XrPMhEOMXlv6pJcwB8KLZIc06K2VbiuGiNAIC3Ibdn2W+VqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786400256; c=relaxed/simple;
	bh=7pCAdkiLecLq7sw2aSbaDcqDOAcBjPaF/pTvW+66T3k=;
	h=Date:To:From:Subject:Message-Id; b=OgwtYTrCcREoGRLbl/zeOk8IJCPvD13MuKuAORMJvtrDsq0H7giwqdJr1+ovN+hv5ZoCzonIWwovUEeug3KBcdwpuqisfh1wG7ByTzFG6DJxXHB4qY3IfpybQJV+6fqknyX2TXDYipCZuCahOAEHZ6Cgdl8zDfbqJEo3fUHUafM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LTE/PZAp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LTE/PZAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510251F000E9;
	Mon, 10 Aug 2026 22:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786400254;
	bh=70vdFw/jEnA3endoRmKaVBYiqPeVl0yiNYThZY2eRpI=;
	h=Date:To:From:Subject;
	b=LTE/PZAps5uzznga5RsPDBgKsukgFeyWosWMacKj4A7UuIzifKB1vUT/2O1ohMj+B
	 3nv06/uFE+OxdFIFb+tMS44eaTCQwrHQXZunsu/iZH93zCrU+9wkFNZ4FjaKYuTRq/
	 IOshq+xTBiax6o+biUu38Y3LFNxX0HbdheUfcHtE=
Date: Mon, 10 Aug 2026 15:17:33 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,jianhuizzzzz@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-userfaultfd-clear-uffd-wp-pte-state-when-re-registering-without-wp.patch removed from -mm tree
Message-Id: <20260810221734.510251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/userfaultfd: clear uffd-wp PTE state when re-registering without WP
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-clear-uffd-wp-pte-state-when-re-registering-without-wp.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Jianhui Zhou <jianhuizzzzz@gmail.com>
Subject: mm/userfaultfd: clear uffd-wp PTE state when re-registering without WP
Date: Mon, 1 Jun 2026 16:26:09 +0800

UFFDIO_REGISTER can be issued on a range that is already registered in the
same userfaultfd context, replacing the VMA's userfaultfd tracking mode. 
For example, a range can be registered with UFFDIO_REGISTER_MODE_WP and
later re-registered with UFFDIO_REGISTER_MODE_MISSING.

When the second registration removes VM_UFFD_WP, the VMA flags are updated
but existing uffd-wp state in page-table entries is left behind.  That
stale state can survive in swap PTEs.  On swapin, do_swap_page() restores
_PAGE_UFFD_WP from the swap PTE and can then install a writable PTE,
triggering page_table_check:

  pte_uffd_wp(pte) && pte_write(pte)

Handle removal of WP mode through UFFDIO_REGISTER the same way as
UFFDIO_UNREGISTER: resolve the per-PTE uffd-wp state before dropping
VM_UFFD_WP from the VMA.

Also make the same-context fast path require an exact UFFD mode match. 
The old subset check treats MISSING|WP -> MISSING as a no-op, even though
WP mode is being removed.

Link: https://lore.kernel.org/20260601082609.170076-1-jianhuizzzzz@gmail.com
Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
Reported-by: syzbot+18d274a59b87cf80e86d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=18d274a59b87cf80e86d
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-clear-uffd-wp-pte-state-when-re-registering-without-wp
+++ a/mm/userfaultfd.c
@@ -2337,7 +2337,7 @@ static int userfaultfd_register_range(st
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    vma_test_all_mask(vma, vma_flags))
+		    (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags)
 			goto skip;
 
 		/*
@@ -2352,6 +2352,14 @@ static int userfaultfd_register_range(st
 			start = vma->vm_start;
 		vma_end = min(end, vma->vm_end);
 
+		/*
+		 * Re-registering into the same userfaultfd can remove WP mode.
+		 * Clear any per-PTE uffd-wp state before dropping VM_UFFD_WP,
+		 * matching the UFFDIO_UNREGISTER cleanup semantics.
+		 */
+		if (userfaultfd_wp(vma) && !(vm_flags & VM_UFFD_WP))
+			uffd_wp_range(vma, start, vma_end - start, false);
+
 		new_vma_flags = vma->flags;
 		vma_flags_clear_mask(&new_vma_flags, __VMA_UFFD_FLAGS);
 		vma_flags_set_mask(&new_vma_flags, vma_flags);
_

Patches currently in -mm which might be from jianhuizzzzz@gmail.com are


