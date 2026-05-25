Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B168825392C
	for <mm-commits@vger.kernel.org>; Mon, 25 May 2026 20:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779739426; cv=none; b=Xlb+kXsVIjXMpLIasdoQSgwTR5w3EjxxZ7VBr8CSViGGO7Zoi2H4rS1qEg+mw4TPrmGyBQYa7meE/IcyM1pKbiDDj370WSQyftNy2PmfH32W6Ph/MwDtGmVpZmECfhM2cL0WF6CRS9htgsyzPWJIIN0nTkHr8EOpdy3aNY5ZCi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779739426; c=relaxed/simple;
	bh=PtEngYApauaJhogaYqoYt8wnb8wwYuhwUksqzxhSr24=;
	h=Date:To:From:Subject:Message-Id; b=gDExV6CL1kWc8Wz4tSVbvpT53phlklbuCT+rhbF4X/DeOE+RJOsYoh+YQugnuqUQlmY6D19DEuRjfoN6hOXv/KY0GSjNhTLy86Y+XaXQPcBw77OFprLNfrHBzFTZ+h9qEeVB12pWDL1tZXuIrKE5KOgYfCIqPzQW92QsY185U2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qnOe78r8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qnOe78r8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403E41F000E9;
	Mon, 25 May 2026 20:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779739425;
	bh=v+evdZSigPtM6OSxQmU3fTmcf7hQ/sM7Fk9dAUy2HZo=;
	h=Date:To:From:Subject;
	b=qnOe78r8gWTy5rRxS/kh0H2DCmnIdBGl38oMNjDxbh4UFgmEfoHDYKMhill7Y+ZJ6
	 zZb7JoUtWSNQ2wGEAppuID3Tt7+YYB6rVD2UQJx9mq2iAoAzLS0n9ddM/frjK0nGgK
	 OBondBxD7xTmMNA4KLoUr1Gwat76A4u6c7gLDzrY=
Date: Mon, 25 May 2026 13:03:44 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch added to mm-new branch
Message-Id: <20260525200345.403E41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: fix use-after-free in /proc/allocinfo after module unload
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch

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
From: Hao Ge <hao.ge@linux.dev>
Subject: alloc_tag: fix use-after-free in /proc/allocinfo after module unload
Date: Mon, 25 May 2026 15:21:17 +0800

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

Fix by always reinitializing the iterator in allocinfo_start().

Link: https://lore.kernel.org/20260525072117.112779-1-hao.ge@linux.dev
Fixes: 9f44df50fee4 ("alloc_tag: keep codetag iterator active between read()")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/lib/alloc_tag.c~alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload
+++ a/lib/alloc_tag.c
@@ -51,16 +51,19 @@ struct allocinfo_private {
 static void *allocinfo_start(struct seq_file *m, loff_t *pos)
 {
 	struct allocinfo_private *priv;
+	struct codetag *ct;
 	loff_t node = *pos;
 
 	priv = (struct allocinfo_private *)m->private;
 	codetag_lock_module_list(alloc_tag_cttype, true);
-	if (node == 0) {
+	if (node == 0)
 		priv->print_header = true;
-		priv->iter = codetag_get_ct_iter(alloc_tag_cttype);
-		codetag_next_ct(&priv->iter);
-	}
-	return priv->iter.ct ? priv : NULL;
+
+	priv->iter = codetag_get_ct_iter(alloc_tag_cttype);
+	while ((ct = codetag_next_ct(&priv->iter)) != NULL && node)
+		node--;
+
+	return ct ? priv : NULL;
 }
 
 static void *allocinfo_next(struct seq_file *m, void *arg, loff_t *pos)
_

Patches currently in -mm which might be from hao.ge@linux.dev are

mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list.patch
proc-meminfo-expose-per-node-balloon-pages-in-node-meminfo.patch
lib-test_hmm-use-kvfree-to-free-kvcalloc-allocations.patch
alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch

