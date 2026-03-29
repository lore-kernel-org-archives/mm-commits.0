Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B3C277CB8
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744956; cv=none; b=m/QGR5Nzr3VlF7SxNhUVkELrDFPzgl6BEG4wSfY1G/cAn/ngzw8JQpbm62vtDk/sp+GBhP8QbwI13HS5Fz/5G4/PexLCouF17cYyvYVksTGLOXO3RNdVuC8T7SgFViomMJrt5QF5nU74lSoGLfCvnvQgS3bW7pUAN5aaZ8YjfcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744956; c=relaxed/simple;
	bh=jEQe5LkYnqav0S+qFYRAyVrzYrHt536oFlttJs7EuyU=;
	h=Date:To:From:Subject:Message-Id; b=mYQy3BCuOH26U8WzYwy83BhR9lCW4CiknnkkwNdT1k9cjJ5fsPAdCT1d5sRh4skDZpN+ipQ2MgCvn7eN/qNlY1w1COsEFH3ptEELgTI1tAf7rNW+QfQcj1Ao9/ucYjZqXi3GQ9MWA4UlahHM/phvcryoMDDI/PuKC9LRRsEiJ8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U+sLoSCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U+sLoSCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D381C4CEF7;
	Sun, 29 Mar 2026 00:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744956;
	bh=jEQe5LkYnqav0S+qFYRAyVrzYrHt536oFlttJs7EuyU=;
	h=Date:To:From:Subject:From;
	b=U+sLoSCYcW4+i1dxubGPD9yPoB4/sLTR8mOyKv+GwWSsVDSwXgegrkW3abeXYOLD6
	 clO8QmOrNR4GtU/WBP9lJKkbUb+nd05HMnj/Oi0Ale+i0dxeG9gUYOjTHcAi9N8Ux4
	 Rt8gqCQGykGTXxnHGdRMYv/MZjdO4CzVj10bZxSY=
Date: Sat, 28 Mar 2026 17:42:35 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,tony.luck@intel.com,kees@kernel.org,julia.lawall@inria.fr,gpiccoli@igalia.com,akpm@linux-foundation.org,kexinsun@smail.nju.edu.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-update-outdated-comment-for-renamed-vread.patch removed from -mm tree
Message-Id: <20260329004236.4D381C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: update outdated comment for renamed vread()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-update-outdated-comment-for-renamed-vread.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kexin Sun <kexinsun@smail.nju.edu.cn>
Subject: mm: vmalloc: update outdated comment for renamed vread()
Date: Sat, 21 Mar 2026 18:58:20 +0800

The function vread() was renamed to vread_iter() in commit 4c91c07c93bb
("mm: vmalloc: convert vread() to vread_iter()"), converting from a
buffer-based to an iterator-based interface.

Update the kdoc of vread_iter() to reflect the new interface: replace
references to @buf with @iter, drop the stale "kernel's buffer"
requirement, and update the self-reference from vread() to vread_iter().

Also update the stale vread() reference in pstore's ram_core.c.

Assisted-by: unnamed:deepseek-v3.2 coccinelle
Link: https://lkml.kernel.org/r/20260321105820.7134-1-kexinsun@smail.nju.edu.cn
Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Kees Cook <kees@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pstore/ram_core.c |    2 +-
 mm/vmalloc.c         |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/pstore/ram_core.c~mm-vmalloc-update-outdated-comment-for-renamed-vread
+++ a/fs/pstore/ram_core.c
@@ -450,7 +450,7 @@ static void *persistent_ram_vmap(phys_ad
 		pages[i] = pfn_to_page(addr >> PAGE_SHIFT);
 	}
 	/*
-	 * VM_IOREMAP used here to bypass this region during vread()
+	 * VM_IOREMAP used here to bypass this region during vread_iter()
 	 * and kmap_atomic() (i.e. kcore) to avoid __va() failures.
 	 */
 	vaddr = vmap(pages, page_count, VM_MAP | VM_IOREMAP, prot);
--- a/mm/vmalloc.c~mm-vmalloc-update-outdated-comment-for-renamed-vread
+++ a/mm/vmalloc.c
@@ -4575,20 +4575,20 @@ finished:
  * @count:        number of bytes to be read.
  *
  * This function checks that addr is a valid vmalloc'ed area, and
- * copy data from that area to a given buffer. If the given memory range
+ * copies data from that area to a given iterator. If the given memory range
  * of [addr...addr+count) includes some valid address, data is copied to
- * proper area of @buf. If there are memory holes, they'll be zero-filled.
+ * proper area of @iter. If there are memory holes, they'll be zero-filled.
  * IOREMAP area is treated as memory hole and no copy is done.
  *
  * If [addr...addr+count) doesn't includes any intersects with alive
- * vm_struct area, returns 0. @buf should be kernel's buffer.
+ * vm_struct area, returns 0.
  *
- * Note: In usual ops, vread() is never necessary because the caller
+ * Note: In usual ops, vread_iter() is never necessary because the caller
  * should know vmalloc() area is valid and can use memcpy().
  * This is for routines which have to access vmalloc area without
  * any information, as /proc/kcore.
  *
- * Return: number of bytes for which addr and buf should be increased
+ * Return: number of bytes for which addr and iter should be advanced
  * (same number as @count) or %0 if [addr...addr+count) doesn't
  * include any intersection with valid vmalloc area
  */
_

Patches currently in -mm which might be from kexinsun@smail.nju.edu.cn are


