Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27341B6CE9
	for <mm-commits@vger.kernel.org>; Sat, 21 Mar 2026 17:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774115756; cv=none; b=c0cC/gZMqpeci6gnOlNP5091Hr1sv9Qna1RYrDBkfZxWPLZTwKjuW34YYSNh8tTi+2OP9qJQ4aDmv2uOxoHkQSuaduj4FIOA57PNQQ3Pe4enTJFngwqUvEAFZmcnQf9ennpBO9C5Vo4uOj5U1qselSsbzT78jPIKG2InMELmEGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774115756; c=relaxed/simple;
	bh=+aoSyoHwS4J1V7WUvukpvza+ZejMPlTpuJqKZLzMsd8=;
	h=Date:To:From:Subject:Message-Id; b=mKnpw5DZfGZvROl9Btt+Xn30eRw2YlIuzg3iYnMfFxzu+wCoR0H2Ol9ZQePclBOta8T/mnUdeTNGHSP9/VVhVFCAgtJYwGLR6EM0Ui7V1/r/1/F8qxBfykgcbTxN5B9eF0fuHg1vy3y4IFUjvGyU9bZrh/6mB8wbjhb8aZusJBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AamDvVOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AamDvVOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCEDC2BCAF;
	Sat, 21 Mar 2026 17:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774115756;
	bh=+aoSyoHwS4J1V7WUvukpvza+ZejMPlTpuJqKZLzMsd8=;
	h=Date:To:From:Subject:From;
	b=AamDvVOlhzjtsL6wwH3zfVE9lhDcIk61HeFatNtlm6CBqKtFhyioK6Z0rzsLshnMu
	 MJWRENIKTEus9Idyr6nx3FRahbh3b+M0rTIG2np1cGKQ3FSfY9qa02J8vDTRIGW4y9
	 81Awxz507XyZZnh735iGiLnPVMLM2XWx0q0Ej+Uw=
Date: Sat, 21 Mar 2026 10:55:55 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,tony.luck@intel.com,kees@kernel.org,julia.lawall@inria.fr,gpiccoli@igalia.com,kexinsun@smail.nju.edu.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-update-outdated-comment-for-renamed-vread.patch added to mm-new branch
Message-Id: <20260321175556.5BCEDC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: update outdated comment for renamed vread()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-update-outdated-comment-for-renamed-vread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-update-outdated-comment-for-renamed-vread.patch

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
+ * copy data from that area to a given iterator. If the given memory range
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

kasan-update-outdated-comment.patch
mm-vmalloc-update-outdated-comment-for-renamed-vread.patch

