Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4C540862F
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 20:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788035933; cv=none; b=kM5Tl3+aP0/73v6reomMIIdrgu1IDdMusth0zBv16kkEB2js/r3z59X+Iqcl2ZeKIIF0TUFeTCrPoD45XK81l9/Dl8/oRWNooEF5R3r651RajcUK/epdFJHbE+8XWsc6kouh16xjgF4/3KrOSPMki31BC4hlJeaTBiskjxZIews=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788035933; c=relaxed/simple;
	bh=sp2uwEQdp2XZ95D9KVZ2ot9usirOFcLO5p2aeWx4fxc=;
	h=Date:To:From:Subject:Message-Id; b=NANt6TfDkH1+DLeITEHtXoYlv6Jf4wc4fbxPYgmzxzI++0fOKUukWpgmUDK7ln/V6rOyL/+j2htYLExTRjy/t3esNL9xyu8Mq65WeEjtnrP5k/3xj1whk0CEXmWu6ycvMJ2LYqoKX6w1ovHs6h39JuM5MZ+CM/dEQBG8BSwMNzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RHASMeaj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RHASMeaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781DF1F000E9;
	Sat, 29 Aug 2026 20:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788035930;
	bh=fYUrUDvkUg9pf7TDQ554H3J05iQQSxeOFoH80hi8z7Q=;
	h=Date:To:From:Subject;
	b=RHASMeajmnlGS0Yc9Oq0EX1qgXDgoQSatlPVU2Dv+D9GU17jCS++uhadeu7s1Mf6M
	 e5JHSTy49hTI4Rzm0bOcYM5dyncRHHDgpfnpFaxTiECHhlcqlZNxLQroIVWBACwOAZ
	 OLwYwLHEWWnDZWcVVxsGLUZvA5JWgywkBJydsXTk=
Date: Sat, 29 Aug 2026 13:38:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ljs@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-rename-__swap_writepage-to-__swap_writeout.patch added to mm-new branch
Message-Id: <20260829203850.781DF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: rename __swap_writepage() to __swap_writeout()
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-rename-__swap_writepage-to-__swap_writeout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-rename-__swap_writepage-to-__swap_writeout.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/swap: rename __swap_writepage() to __swap_writeout()
Date: Sat, 29 Aug 2026 15:09:05 -0400

Commit 84798514db50 ("mm: Remove swap_writepage() and shmem_writepage()")
renamed swap_writepage() to swap_writeout().  Rename __swap_writepage(),
which operates on a folio, to match its caller.  Update a stale reference
to swap_writepage() in swapfile.c as well.

Link: https://lore.kernel.org/20260829-b4-page_io-folios-v2-6-649728091117@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c  |    4 ++--
 mm/swap.h     |    2 +-
 mm/swapfile.c |    2 +-
 mm/zswap.c    |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_io.c~mm-swap-rename-__swap_writepage-to-__swap_writeout
+++ a/mm/page_io.c
@@ -248,7 +248,7 @@ int swap_writeout(struct swap_io_ctx *ct
 	}
 	rcu_read_unlock();
 
-	__swap_writepage(ctx, folio);
+	__swap_writeout(ctx, folio);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -369,7 +369,7 @@ static void swap_add_folio(struct swap_i
 	}
 }
 
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
--- a/mm/swapfile.c~mm-swap-rename-__swap_writepage-to-__swap_writeout
+++ a/mm/swapfile.c
@@ -2928,7 +2928,7 @@ EXPORT_SYMBOL_GPL(add_swap_extent);
 /*
  * A `swap extent' is a simple thing which maps a contiguous range of pages
  * onto a contiguous range of disk blocks.  A rbtree of swap extents is
- * built at swapon time and is then used at swap_writepage/swap_read_folio
+ * built at swapon time and is then used at swap_writeout/swap_read_folio
  * time for locating where on disk a page belongs.
  *
  * If the swapfile is an S_ISBLK block device, a single extent is installed.
--- a/mm/swap.h~mm-swap-rename-__swap_writepage-to-__swap_writeout
+++ a/mm/swap.h
@@ -258,7 +258,7 @@ void swap_read_folio(struct swap_io_ctx
 void swap_read_submit(struct swap_io_ctx *ctx);
 void swap_write_submit(struct swap_io_ctx *ctx);
 int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio);
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
--- a/mm/zswap.c~mm-swap-rename-__swap_writepage-to-__swap_writeout
+++ a/mm/zswap.c
@@ -1037,7 +1037,7 @@ static int zswap_writeback_entry(struct
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(&ctx, folio);
+	__swap_writeout(&ctx, folio);
 	swap_write_submit(&ctx);
 
 out:
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-page_io-convert-write-completion-handlers-to-folios.patch
mm-remove-pagereclaim.patch
mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch
mm-page_io-rename-bio_associate_blkg_from_page.patch
mm-page_io-refer-to-folios-in-swap_writeout-comments.patch
mm-swap-rename-__swap_writepage-to-__swap_writeout.patch

