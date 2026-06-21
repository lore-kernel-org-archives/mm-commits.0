Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1FC217704
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782066740; cv=none; b=uIiVA9XN+LYMkAPAmj5WjXpuhDYHeDnmTly48H4+8HtMOq5qTcAPG2WdVVf6+vj9TjS2Dq7N/FsyeI4PpA4iDCzh36wiDlfE9Bv2FOPFosDZLjJnVFq4IV9pxA03TraZcnl0YEcjqnHKRbPlTPUzqX8tzeomgymnJsCtZO/RwLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782066740; c=relaxed/simple;
	bh=MNbBCG72OMnES5nbc/u5LONgkK0qJOc1CN8uDN2UNms=;
	h=Date:To:From:Subject:Message-Id; b=SgTvinUCS4qk4a5lCGvBGDeFqvu3bnlLFeytc4akg25q+4vHzrBfF3Eolz6OtDsM7evxbp2GKe0Tf8MUXEC3GPsMq7u9PrQVxua1WyDH0NXHrMObx9hLzbAQGQhK65twQkwyFzDy/3W4pNrvY8VhQ/T86fFztf/OKfZPq9gl6jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HLWQtkb2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HLWQtkb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C6E1F00A3A;
	Sun, 21 Jun 2026 18:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782066739;
	bh=rcxq5nJcN1yqGn3DqX2lQT30mHufgRyRffGzjy0Qh8M=;
	h=Date:To:From:Subject;
	b=HLWQtkb2eeL8pW4cldCsl7ZmapnbFUk4LPpBGXLU2mfhCqFhCBABRo9307ZDBADOx
	 RVsSR9O4vHUMGpYNPz7yJrLPledQmw4Bk264pl9lfdGAwSnEAwQr+vsS3tlCbIQlXZ
	 0/p0nj801qVxcX6NChAhEHOVvxxEEEUmIFU0Ne9I=
Date: Sun, 21 Jun 2026 11:32:18 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch removed from -mm tree
Message-Id: <20260621183219.35C6E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: fix use-after-free in /proc/allocinfo after module unload
has been removed from the -mm tree.  Its filename was
     alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Suren Baghdasaryan <surenb@google.com>
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

maintainers-add-hao-ge-as-reviewer-for-codetag-and-alloc_tag.patch

