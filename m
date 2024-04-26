Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A688B76408
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103923; cv=none; b=m0hOh/E8PNR2VrJUlD6kkIXM5vFtNlHS1MbojylD0AiJHGt/1uf08HsF7E95aHarXQUC5pg2boxmo/l8AaKtAgVLLoKqQQK7wJmll/apRWMS9I4XD9idp/uTALBd9Ie4ypOTJL/+hSwSmeS3DhmDJARbNtPTbqciLO1p3jPiNQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103923; c=relaxed/simple;
	bh=s58vIUTf33C9zUPb414vskkS5ZZ5XrwmsQjWCUUxArA=;
	h=Date:To:From:Subject:Message-Id; b=G0JPR4nk8lPEEDXx4dsJK3LPnQgVr4WudeFPGVAY/TAkCtDco1FHjPxoD6PXtCdwTg5c1lRE87uzQUZQoyCIVffpjl3b5XFbA8FNrbBb7Zxfna9g8K/Yf5/VcTMI8KcDrn4vGoCcLLq8nmV0gDfZzAWX86NH0I4PVtfqa8+CCgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vWpsW/UR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vWpsW/UR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEBCC113CD;
	Fri, 26 Apr 2024 03:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103923;
	bh=s58vIUTf33C9zUPb414vskkS5ZZ5XrwmsQjWCUUxArA=;
	h=Date:To:From:Subject:From;
	b=vWpsW/URuMmM5l9s/yUaD9Ntbo+HrE2VNcQ3J+gIGxx+IZlz7i5NmHK+nlZQbCPu5
	 NZQBzaHShO/RdG2nQ4ASC/I6K/O0Cwxy7j2D+AS8ELJpIG4YdOumLMSS0A4QYjYL0e
	 /f0x+COepNKLOPB4QRwENX7IM1tegrETEGogCvM4=
Date: Thu, 25 Apr 2024 20:58:42 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-add-memory-allocations-report-in-show_mem.patch removed from -mm tree
Message-Id: <20240426035843.7AEBCC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: add memory allocations report in show_mem()
has been removed from the -mm tree.  Its filename was
     lib-add-memory-allocations-report-in-show_mem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: lib: add memory allocations report in show_mem()
Date: Thu, 21 Mar 2024 09:36:54 -0700

Include allocations in show_mem reports.

Link: https://lkml.kernel.org/r/20240321163705.3067592-33-surenb@google.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |    7 ++++++
 include/linux/codetag.h   |    1 
 lib/alloc_tag.c           |   38 ++++++++++++++++++++++++++++++++++++
 lib/codetag.c             |    5 ++++
 mm/show_mem.c             |   26 ++++++++++++++++++++++++
 5 files changed, 77 insertions(+)

--- a/include/linux/alloc_tag.h~lib-add-memory-allocations-report-in-show_mem
+++ a/include/linux/alloc_tag.h
@@ -31,6 +31,13 @@ struct alloc_tag {
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 
+struct codetag_bytes {
+	struct codetag *ct;
+	s64 bytes;
+};
+
+size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep);
+
 static inline struct alloc_tag *ct_to_alloc_tag(struct codetag *ct)
 {
 	return container_of(ct, struct alloc_tag, ct);
--- a/include/linux/codetag.h~lib-add-memory-allocations-report-in-show_mem
+++ a/include/linux/codetag.h
@@ -61,6 +61,7 @@ struct codetag_iterator {
 }
 
 void codetag_lock_module_list(struct codetag_type *cttype, bool lock);
+bool codetag_trylock_module_list(struct codetag_type *cttype);
 struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype);
 struct codetag *codetag_next_ct(struct codetag_iterator *iter);
 
--- a/lib/alloc_tag.c~lib-add-memory-allocations-report-in-show_mem
+++ a/lib/alloc_tag.c
@@ -89,6 +89,44 @@ static const struct seq_operations alloc
 	.show	= allocinfo_show,
 };
 
+size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep)
+{
+	struct codetag_iterator iter;
+	struct codetag *ct;
+	struct codetag_bytes n;
+	unsigned int i, nr = 0;
+
+	if (can_sleep)
+		codetag_lock_module_list(alloc_tag_cttype, true);
+	else if (!codetag_trylock_module_list(alloc_tag_cttype))
+		return 0;
+
+	iter = codetag_get_ct_iter(alloc_tag_cttype);
+	while ((ct = codetag_next_ct(&iter))) {
+		struct alloc_tag_counters counter = alloc_tag_read(ct_to_alloc_tag(ct));
+
+		n.ct	= ct;
+		n.bytes = counter.bytes;
+
+		for (i = 0; i < nr; i++)
+			if (n.bytes > tags[i].bytes)
+				break;
+
+		if (i < count) {
+			nr -= nr == count;
+			memmove(&tags[i + 1],
+				&tags[i],
+				sizeof(tags[0]) * (nr - i));
+			nr++;
+			tags[i] = n;
+		}
+	}
+
+	codetag_lock_module_list(alloc_tag_cttype, false);
+
+	return nr;
+}
+
 static void __init procfs_init(void)
 {
 	proc_create_seq("allocinfo", 0444, NULL, &allocinfo_seq_op);
--- a/lib/codetag.c~lib-add-memory-allocations-report-in-show_mem
+++ a/lib/codetag.c
@@ -36,6 +36,11 @@ void codetag_lock_module_list(struct cod
 		up_read(&cttype->mod_lock);
 }
 
+bool codetag_trylock_module_list(struct codetag_type *cttype)
+{
+	return down_read_trylock(&cttype->mod_lock) != 0;
+}
+
 struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype)
 {
 	struct codetag_iterator iter = {
--- a/mm/show_mem.c~lib-add-memory-allocations-report-in-show_mem
+++ a/mm/show_mem.c
@@ -423,4 +423,30 @@ void __show_mem(unsigned int filter, nod
 #ifdef CONFIG_MEMORY_FAILURE
 	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
 #endif
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+	{
+		struct codetag_bytes tags[10];
+		size_t i, nr;
+
+		nr = alloc_tag_top_users(tags, ARRAY_SIZE(tags), false);
+		if (nr) {
+			pr_notice("Memory allocations:\n");
+			for (i = 0; i < nr; i++) {
+				struct codetag *ct = tags[i].ct;
+				struct alloc_tag *tag = ct_to_alloc_tag(ct);
+				struct alloc_tag_counters counter = alloc_tag_read(tag);
+
+				/* Same as alloc_tag_to_text() but w/o intermediate buffer */
+				if (ct->modname)
+					pr_notice("%12lli %8llu %s:%u [%s] func:%s\n",
+						  counter.bytes, counter.calls, ct->filename,
+						  ct->lineno, ct->modname, ct->function);
+				else
+					pr_notice("%12lli %8llu %s:%u func:%s\n",
+						  counter.bytes, counter.calls, ct->filename,
+						  ct->lineno, ct->function);
+			}
+		}
+	}
+#endif
 }
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

