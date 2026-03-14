Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA0A27AC31
	for <mm-commits@vger.kernel.org>; Sat, 14 Mar 2026 23:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773530949; cv=none; b=PM93UAR1PEp/Y3N4Lx0Il5D4ZV11yk1zwZFjDdmSmnS6NON+ogeL/OscIwpyRyoompTbNBdFKZ+HXWXsjzr4OWVU+uE8wTAMSG6jYiRFK95SK7VCc69+eK6j+bYow7ybxuj6c96YHE1LfxI+UBYWFgdxd65bYZatDRdAF9tz3AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773530949; c=relaxed/simple;
	bh=BqUGWOaYRCpdTGHtrjOSuLNlWvL1pwtkj9cgVR3dC0U=;
	h=Date:To:From:Subject:Message-Id; b=jpcq9joOjiKS+DebZH1nLnKpMbkiCm+pqZGvWnJ/QNBsP3Cs4qPgOo7ppASDLJVqBxo3P1a4WSIWvRi0c82z83aUZAjaKOB2OtnvB3AVvSq5uYNzaHRvtKNWMSgIDDuoCt3rSolx5hH+aVWwjJIAqWAchQN8Z92yNmc0k16H1t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ksLELIvi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ksLELIvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E42C116C6;
	Sat, 14 Mar 2026 23:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773530948;
	bh=BqUGWOaYRCpdTGHtrjOSuLNlWvL1pwtkj9cgVR3dC0U=;
	h=Date:To:From:Subject:From;
	b=ksLELIvildmpgI0za+ua/RRSVdu4Bzu6SMmquwt4yBnaztE8yen2nfctQu51rO4mU
	 7llMdQGsN8lE94OQyfK27ffUbzdO2eDvQhqDkxrax2urdIzFSztN3eBgZm2O2ktgFd
	 8KqTJoEp1hKB/XNfZJRGjFVt3pMb2RCqJW5OcvHQ=
Date: Sat, 14 Mar 2026 16:29:07 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,ljs@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-mmap_action_map_kernel_pages-fix-2.patch added to mm-new branch
Message-Id: <20260314232908.73E42C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-mmap_action_map_kernel_pages-fix-2
has been added to the -mm mm-new branch.  Its filename is
     mm-add-mmap_action_map_kernel_pages-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-mmap_action_map_kernel_pages-fix-2.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-mmap_action_map_kernel_pages-fix-2
Date: Sat Mar 14 04:27:41 PM PDT 2026

randyfy mmap_prepare.rst

Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/mmap_prepare.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/filesystems/mmap_prepare.rst~mm-add-mmap_action_map_kernel_pages-fix-2
+++ a/Documentation/filesystems/mmap_prepare.rst
@@ -130,10 +130,10 @@ pointer. These are:
 * mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
   physical address and over a specified length.
 
-* `mmap_action_map_kernel_pages()` - Maps a specified array of `struct page`
+* mmap_action_map_kernel_pages() - Maps a specified array of `struct page`
   pointers in the VMA from a specific offset.
 
-* `mmap_action_map_kernel_pages_full()` - Maps a specified array of `struct
+* mmap_action_map_kernel_pages_full() - Maps a specified array of `struct
   page` pointers over the entire VMA. The caller must ensure there are
   sufficient entries in the page array to cover the entire range of the
   described VMA.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
mm-various-small-mmap_prepare-cleanups-fix.patch
mm-add-mmap_action_simple_ioremap-fix.patch
mm-add-mmap_action_map_kernel_pages-fix.patch
mm-add-mmap_action_map_kernel_pages-fix-2.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch

