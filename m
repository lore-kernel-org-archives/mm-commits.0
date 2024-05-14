Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE23180A9C
	for <mm-commits@vger.kernel.org>; Tue, 14 May 2024 20:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715718009; cv=none; b=XjUG1IR/rt7BcRZpNlD3bnI1koqt0Wf5t7PaFOsSq84SgWwYuGAvlwKBt9Q25nUQ3VfePVAe1e3YK8R5OK8efxcWeliTRW+n89e2Om3ulMvYSQ49I9rjDXwjGa4RbKn716zmpJqzNyyG4w9fLjbrGlrdF5Ym7/5EGaZJqeXitSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715718009; c=relaxed/simple;
	bh=D0WhXz/Y825BNUqh8gpX35TsDKdRWczbdBX26Z/FyUg=;
	h=Date:To:From:Subject:Message-Id; b=NB57hhgaPi3HV8ntEFS+TrtEvCq42jq9cgol/clZQHcTBSJcuNTwZYXn8t6ibWM567fSorhmxJ41r8YfdOTPlH2/KcLTGhV7df7jNF1BD7dsD5Z1br1UfRJJKStoVnj/7GhZO1EN5ZfU0yHumHwF4SxXRcs/hRvL13zeLaNE8+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KDJ8vwTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KDJ8vwTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA52C2BD10;
	Tue, 14 May 2024 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715718009;
	bh=D0WhXz/Y825BNUqh8gpX35TsDKdRWczbdBX26Z/FyUg=;
	h=Date:To:From:Subject:From;
	b=KDJ8vwTLzQCx7eakAJpUfZCRDnM/13MFtrWmf3XH0PpdS4Lr6WZo9j21Iq0PqJMPg
	 owt2o8Pd31DNf3Q2DgmmrifvJEEfRkec3Ge77XwBk2bigJXUdO6U6KCadpVdzWZMrA
	 T/ocuuCa00p1GMhq81te3tkt3BAwDc23V3NQzaaY=
Date: Tue, 14 May 2024 13:20:03 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-version-into-proc-allocinfo-output.patch added to mm-unstable branch
Message-Id: <20240514202009.2FA52C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: add version into /proc/allocinfo output
has been added to the -mm mm-unstable branch.  Its filename is
     lib-add-version-into-proc-allocinfo-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-version-into-proc-allocinfo-output.patch

This patch will later appear in the mm-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: lib: add version into /proc/allocinfo output
Date: Tue, 14 May 2024 09:31:28 -0700

Add version string and a header at the beginning of /proc/allocinfo to
allow later format changes.  Example output:

> head /proc/allocinfo
allocinfo - version: 1.0
#     <size>  <calls> <tag info>
           0        0 init/main.c:1314 func:do_initcalls
           0        0 init/do_mounts.c:353 func:mount_nodev_root
           0        0 init/do_mounts.c:187 func:mount_root_generic
           0        0 init/do_mounts.c:158 func:do_mount_root
           0        0 init/initramfs.c:493 func:unpack_to_rootfs
           0        0 init/initramfs.c:492 func:unpack_to_rootfs
           0        0 init/initramfs.c:491 func:unpack_to_rootfs
         512        1 arch/x86/events/rapl.c:681 func:init_rapl_pmus
         128        1 arch/x86/events/rapl.c:571 func:rapl_cpu_online

Link: https://lkml.kernel.org/r/20240514163128.3662251-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    5 +-
 lib/alloc_tag.c                    |   48 ++++++++++++++++++---------
 2 files changed, 36 insertions(+), 17 deletions(-)

--- a/Documentation/filesystems/proc.rst~lib-add-version-into-proc-allocinfo-output
+++ a/Documentation/filesystems/proc.rst
@@ -961,13 +961,14 @@ Provides information about memory alloca
 base. Each allocation in the code is identified by its source file, line
 number, module (if originates from a loadable module) and the function calling
 the allocation. The number of bytes allocated and number of calls at each
-location are reported.
+location are reported. The first line indicates the version of the file, the
+second line is the header listing fields in the file.
 
 Example output.
 
 ::
 
-    > sort -rn /proc/allocinfo
+    > tail -n +3 /proc/allocinfo | sort -rn
    127664128    31168 mm/page_ext.c:270 func:alloc_page_ext
     56373248     4737 mm/slub.c:2259 func:alloc_slab_page
     14880768     3633 mm/readahead.c:247 func:page_cache_ra_unbounded
--- a/lib/alloc_tag.c~lib-add-version-into-proc-allocinfo-output
+++ a/lib/alloc_tag.c
@@ -16,47 +16,61 @@ EXPORT_SYMBOL(_shared_alloc_tag);
 DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			mem_alloc_profiling_key);
 
+struct allocinfo_private {
+	struct codetag_iterator iter;
+	bool print_header;
+
+};
+
 static void *allocinfo_start(struct seq_file *m, loff_t *pos)
 {
-	struct codetag_iterator *iter;
+	struct allocinfo_private *priv;
 	struct codetag *ct;
 	loff_t node = *pos;
 
-	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
-	m->private = iter;
-	if (!iter)
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	m->private = priv;
+	if (!priv)
 		return NULL;
 
+	priv->print_header = (node == 0);
 	codetag_lock_module_list(alloc_tag_cttype, true);
-	*iter = codetag_get_ct_iter(alloc_tag_cttype);
-	while ((ct = codetag_next_ct(iter)) != NULL && node)
+	priv->iter = codetag_get_ct_iter(alloc_tag_cttype);
+	while ((ct = codetag_next_ct(&priv->iter)) != NULL && node)
 		node--;
 
-	return ct ? iter : NULL;
+	return ct ? priv : NULL;
 }
 
 static void *allocinfo_next(struct seq_file *m, void *arg, loff_t *pos)
 {
-	struct codetag_iterator *iter = (struct codetag_iterator *)arg;
-	struct codetag *ct = codetag_next_ct(iter);
+	struct allocinfo_private *priv = (struct allocinfo_private *)arg;
+	struct codetag *ct = codetag_next_ct(&priv->iter);
 
 	(*pos)++;
 	if (!ct)
 		return NULL;
 
-	return iter;
+	return priv;
 }
 
 static void allocinfo_stop(struct seq_file *m, void *arg)
 {
-	struct codetag_iterator *iter = (struct codetag_iterator *)m->private;
+	struct allocinfo_private *priv = (struct allocinfo_private *)m->private;
 
-	if (iter) {
+	if (priv) {
 		codetag_lock_module_list(alloc_tag_cttype, false);
-		kfree(iter);
+		kfree(priv);
 	}
 }
 
+static void print_allocinfo_header(struct seq_buf *buf)
+{
+	/* Output format version, so we can change it. */
+	seq_buf_printf(buf, "allocinfo - version: 1.0\n");
+	seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
+}
+
 static void alloc_tag_to_text(struct seq_buf *out, struct codetag *ct)
 {
 	struct alloc_tag *tag = ct_to_alloc_tag(ct);
@@ -71,13 +85,17 @@ static void alloc_tag_to_text(struct seq
 
 static int allocinfo_show(struct seq_file *m, void *arg)
 {
-	struct codetag_iterator *iter = (struct codetag_iterator *)arg;
+	struct allocinfo_private *priv = (struct allocinfo_private *)arg;
 	char *bufp;
 	size_t n = seq_get_buf(m, &bufp);
 	struct seq_buf buf;
 
 	seq_buf_init(&buf, bufp, n);
-	alloc_tag_to_text(&buf, iter->ct);
+	if (priv->print_header) {
+		print_allocinfo_header(&buf);
+		priv->print_header = false;
+	}
+	alloc_tag_to_text(&buf, priv->iter.ct);
 	seq_commit(m, seq_buf_used(&buf));
 	return 0;
 }
_

Patches currently in -mm which might be from surenb@google.com are

lib-add-version-into-proc-allocinfo-output.patch

