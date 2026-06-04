Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E396A399899
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 17:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780592913; cv=none; b=rxm4Gd6af14JrWyuE+OmCfbiEPYKxN+mhGm3pqqS0LKZkPz+nBMAskVilNNY0KJAhTyZwEWUU/guJzff1eqG0afzoiHwq7hadcRMcxJ9aceuGdsAIJsGEdaO4IvCdbaC8mEkdBCl1P+OaDXpuMq3gx1KvFa5mxx5CAVWF+8Mitg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780592913; c=relaxed/simple;
	bh=AocdoxE/W81upPtEPp1LEm9UvKiGJBMw0jKbvotodzs=;
	h=Date:To:From:Subject:Message-Id; b=Q1NZQoWA54LAdrYI7oiXgebffKJqZt6UVbQlEDyCGO2HUcERNbog0PCC1TL8BFAJD1FHkyGGBNeRzxlrlUMyCNpGFtbwFUJ8pMMAyhcSn7u7LuE4Q+PrvVpqM13OHkszwbi5VWdzNmTLIeA37/D8qT9kzM90VvsKt7tA8KsGD7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yyg+chYs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yyg+chYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956B91F00893;
	Thu,  4 Jun 2026 17:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780592912;
	bh=mdWeHH2AWO/ToATF86aW/Ib1wTOOPfXhCA5fEQq4C10=;
	h=Date:To:From:Subject;
	b=yyg+chYsrptC58LSx2a1QZWdhz5MktE4UySzRkmJjVKOXQGRWXFuydW2M435UyAl+
	 hL2oPXji7Iy6mDkEDwBA6AvMaoQowsSm//ESOeCgDM6qgTAm7gzhPyuxzr6a4Gsogb
	 HK5qbuuQ0JB9ArAuz/A7UIFOLjx6n1k6TM0H8Ph8=
Date: Thu, 04 Jun 2026 10:08:32 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch added to mm-unstable branch
Message-Id: <20260604170832.956B91F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: fix use-after-free in /proc/allocinfo after module unload
has been added to the -mm mm-unstable branch.  Its filename is
     alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Hao Ge <hao.ge@linux.dev>
Subject: alloc_tag: fix use-after-free in /proc/allocinfo after module unload
Date: Thu, 4 Jun 2026 14:59:38 +0800

allocinfo_start() only reinitializes the codetag iterator at position 0. 
For subsequent reads (position > 0), it reuses cached iterator state from
the previous batch.  allocinfo_stop() drops mod_lock between read batches,
which allows module unload to complete and free the module memory that the
cached iterator still references:

  CPU0 (read)                        CPU1 (rmmod)
  ----                               ----
  allocinfo_start(pos=0)
    down_read(mod_lock)
    allocinfo_show()
    ...
  allocinfo_stop()
    up_read(mod_lock)
                                     codetag_unload_module()
                                       kfree(cmod)
                                       release_module_tags()
                                     ...
                                     free_mod_mem()
  allocinfo_start(pos=N)
    down_read(mod_lock)
    // reuses cached iter, skips re-init
  allocinfo_show()
    ct->filename   <-- UAF

After free_mod_mem() frees the module's .rodata, allocinfo_show()
dereferences ct->filename, ct->function which point there.

Save the iterator state in allocinfo_next() and resume from it in
allocinfo_start() with codetag_next_ct(), which detects module removal via
idr_find() returning NULL and skips to the next module.

Link: https://lore.kernel.org/20260604065938.105991-1-hao.ge@linux.dev
Fixes: 9f44df50fee4 ("alloc_tag: keep codetag iterator active between read()")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/lib/alloc_tag.c~alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload
+++ a/lib/alloc_tag.c
@@ -45,6 +45,7 @@ int alloc_tag_ref_offs;
 
 struct allocinfo_private {
 	struct codetag_iterator iter;
+	struct codetag_iterator reported_iter;
 	bool print_header;
 };
 
@@ -58,16 +59,20 @@ static void *allocinfo_start(struct seq_
 	if (node == 0) {
 		priv->print_header = true;
 		priv->iter = codetag_get_ct_iter(alloc_tag_cttype);
-		codetag_next_ct(&priv->iter);
+	} else {
+		priv->iter = priv->reported_iter;
 	}
+	codetag_next_ct(&priv->iter);
 	return priv->iter.ct ? priv : NULL;
 }
 
 static void *allocinfo_next(struct seq_file *m, void *arg, loff_t *pos)
 {
 	struct allocinfo_private *priv = (struct allocinfo_private *)arg;
-	struct codetag *ct = codetag_next_ct(&priv->iter);
+	struct codetag *ct;
 
+	priv->reported_iter = priv->iter;
+	ct = codetag_next_ct(&priv->iter);
 	(*pos)++;
 	if (!ct)
 		return NULL;
_

Patches currently in -mm which might be from hao.ge@linux.dev are

lib-test_hmm-fix-memory-leak-in-dmirror_migrate_to_system.patch
mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list.patch
alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch

