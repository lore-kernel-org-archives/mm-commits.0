Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FD1293458
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 17:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780592830; cv=none; b=e9QHjezaotBabjQhOXaTR0nTZ/UG83GtJmvK1rOm1yjuLpEKFd4ib+VW125cpgtweLEy7DrF0AAvKxJ70WI6//XBAGYGFJgnXIpQTJb4+Dl1/2ZlGgIrTUqNR9m476n+VNThCBr1UA5wZTBvmmofqxulUW2d9e30e1ZiGMd3n80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780592830; c=relaxed/simple;
	bh=u2v+8w9aCUgOzjf8/KcOC9vYb8PLqBPhoIxeURUZetk=;
	h=Date:To:From:Subject:Message-Id; b=dCHbtWn3wAqjkiUWkWdipC9RT2GVsGAo0q2DPLH7ynPlaiWX+oPlSG9qVZbJcYoMkCtOBbjQyr/k8V0B19j20cXtr5o0dmHvyXjCnCh422M1PZGaS8LSUsZaaWWCZa3HlusUaxZGuUvhAptjK4QL3pucOgSFFrD8phkWw9eVu0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dlkHKAYl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dlkHKAYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7F11F00893;
	Thu,  4 Jun 2026 17:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780592828;
	bh=ShqIrUhw8nn/eg8WWMU0jyZCILQ/5JgHrakw0zesOHo=;
	h=Date:To:From:Subject;
	b=dlkHKAYlRda5cKsCb3nUYOBZ4AgKnQBz9qis5Ts5meDC/V7V7RmSxpvF/4Q8nTHSC
	 vSFFhUVez6/5643D9BKITZcTkY2SDa9OhahyNJrawM8crXBSKVA1e0Xe2dmm2Ucwwc
	 hrIVQfAUk+QXKMaoAQ8F14w4vQkvxqzTFkO8D5os=
Date: Thu, 04 Jun 2026 10:07:08 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch removed from -mm tree
Message-Id: <20260604170708.CA7F11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: fix use-after-free in /proc/allocinfo after module unload
has been removed from the -mm tree.  Its filename was
     alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch

This patch was dropped because an updated version will be issued

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

lib-test_hmm-fix-memory-leak-in-dmirror_migrate_to_system.patch
mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list.patch

