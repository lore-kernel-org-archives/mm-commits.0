Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD0740861
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 18:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716576943; cv=none; b=l2s4DgNgmBSH3bECo5kNntMqJoxXTcPUnZQ/ifb0/EKRRIALJqQlB/regAf4d+vQdpWIC2SpmrXj0bV4Yk3Hq5/MfjzsboHhZdIFn7hrWpipvTOxD3IX7hVqjr3e/HVzSHkzGRqV6t+8FsomipRQwd1fjAdFsGOZb+hf0z1V+XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716576943; c=relaxed/simple;
	bh=XFBYwnCo+GkMHbQbmsmDfQqEl5xiJ0M9V9tqF6sZ3r8=;
	h=Date:To:From:Subject:Message-Id; b=HOaUq/fkh0lFIjJ4lb78R+4eIqpxhSR5bVhh3r46ro1kV5Em17r/F0TAFJwC1i/ZE7oTK1+vNnGj1Y+QNVXtLAm8VBwd+FxbLYAROE3q5RyKIFrhqavRV2vV7AWjQX8U1gU1dZv18d3YlHlLk2AsUCANeNpr+0EWeEfqRlDt014=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kLSxsGNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kLSxsGNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14925C2BBFC;
	Fri, 24 May 2024 18:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716576943;
	bh=XFBYwnCo+GkMHbQbmsmDfQqEl5xiJ0M9V9tqF6sZ3r8=;
	h=Date:To:From:Subject:From;
	b=kLSxsGNuJDxRM/EhVnEVGfp5Z39bNjRVG9gYEu/D4XRve7gyWzSAMdfk7O2jGDSno
	 ImoDbkBb4lPCtIWQ+ttFe4/Y2JihKyXYIZaWef+uE5Ol8UnkTpRqJnnpMZwrR//fo/
	 ViAtMu03a3uYhqGPw1N32D716p4EZb3zNoP/n+IU=
Date: Fri, 24 May 2024 11:55:42 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-add-version-into-proc-allocinfo-output.patch removed from -mm tree
Message-Id: <20240524185543.14925C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: add version into /proc/allocinfo output
has been removed from the -mm tree.  Its filename was
     lib-add-version-into-proc-allocinfo-output.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: remove stray newline from struct allocinfo_private]
Link: https://lkml.kernel.org/r/20240514163128.3662251-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    5 +-
 lib/alloc_tag.c                    |   47 ++++++++++++++++++---------
 2 files changed, 35 insertions(+), 17 deletions(-)

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
@@ -16,47 +16,60 @@ EXPORT_SYMBOL(_shared_alloc_tag);
 DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			mem_alloc_profiling_key);
 
+struct allocinfo_private {
+	struct codetag_iterator iter;
+	bool print_header;
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
@@ -71,13 +84,17 @@ static void alloc_tag_to_text(struct seq
 
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


