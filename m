Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795332626;
	b=37CKT57AG3m5frhfe5vQQ3Geva9IDwHJOo+vYse3JdZV3Y9IirwGF9YbAKIlxtz5yC8J
	 9cmeTLulWbx6Xsi9DN2rvqDmkli/Aa+A/9w0HSyEuH42rlnp4m0IWKYexKrVL/MXZofSI
	 E4lSrhqN9voKvLKdX4tZL505MWX41kWXNnJ6g8u38p71wWoh1Ore7aXGKeYkaJjOhkCf/
	 HxhLPiDQGk5glRk0lZ7AuxVqjUy6hC30r6G0O7/oWRsBk7wkRfeUrzoqNt1uqhPMcA6AF
	 kq4G3yzMacnsLE6XfJmPBX1qSMHRa/0yz7I+IY2szEchaoN8z6qA19qTF4UkVJTFT2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795332626;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=tUxS6oKIBstZhWA8RH6j0OdNl45Y404O7VFQCEZaxzY=;
	b=3LYQvbKaEa9UaEDBoLoe2/TVVRz/gqGVx1r/JZyfjF9cf1sfMH2iKAgq/59NOTqfU3LR
	 F79eKnXvLLGweML25Dt8knHvfBNSCU+lbVpp2DhpoeuT+TwZ8xtAtKIXtxYOX6jirX/Zz
	 qVdKpBnHrN3/sk/XKJqy3ktTjz+yHu/h32DnhTtFDVnKIKmNXP+9Xm6cdeSw8WUPWSM4G
	 qZe0nczcFMEt6qR7QPnvdDsO7GBWNY1C+lI5ZXd24uyjN2RqaYQk5gX7y5hdvt2R/Rcko
	 Gcz0dwhjcw2+n23R+VtUIB87QWg9LBKTu/Ob2pdVy93lMBlN+sL2YaJW4kGABDoYZvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eJb5ZqfV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA9C606A32A
	for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 07:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eJb5ZqfV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A441F000C0;
	Sun, 22 Nov 2026 07:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795332625;
	bh=tUxS6oKIBstZhWA8RH6j0OdNl45Y404O7VFQCEZaxzY=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=eJb5ZqfVw5kcCnufREAbwt3L3CvsWQWlaoFxj9rSyOpXkpemgLva8Jd0UY4l+/IT5
	 sJ0zrsb6UHD7Jyo14W7loFRmb3hhft+AmgAYXhEOfUk+XPzJ5XvX+foyBFceqmzXBk
	 rIecHxLIAGTQSR4Y5THlL/v4ITrbjy34oJRTjyA8=
Date: Sat, 21 Nov 2026 23:30:25 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,torvalds@linuxfoundation.org,
	tglx@kernel.org,tejavojjala@google.com,surenb@google.com,rppt@kernel.org,
	rientjes@google.com,pfalcato@suse.de,peterz@infradead.org,nhuhuan@google.com,
	mingo@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	hsalunke@amd.com,hpa@zytor.com,david.laight.linux@gmail.com,david@kernel.org,
	dave.hansen@linux.intel.com,bp@alien8.de,bharata@amd.com,
	ankur.a.arora@oracle.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261113-batpagecopy-v3-1-297f5b2fd28e@amd.com>
References: <20261113-batpagecopy-v3-1-297f5b2fd28e@amd.com>
Subject: + mm-introduce-copy_mc_highpages-and-batch-copy-in-folio_mc_copy.patch added to mm-unstable branch
Message-Id: <20261122073025.90A441F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: introduce copy_mc_highpages() and batch copy in folio_mc_copy()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-copy_mc_highpages-and-batch-copy-in-folio_mc_copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-copy_mc_highpages-and-batch-copy-in-folio_mc_copy.patch

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
From: Shivank Garg <shivankg@amd.com>
Subject: mm: introduce copy_mc_highpages() and batch copy in folio_mc_copy()
Date: Fri, 13 Nov 2026 17:09:21 +0000

folio_mc_copy() copies a folio one page at a time with copy_mc_highpage(),
so a 2MB folio makes 512 separate copy_mc_to_kernel() calls.  Each page
pays the startup cost of the string instruction ("REP; MOVSB" on x86 CPUs
with ERMS) plus a cond_resched().

Introduce copy_mc_highpages(), the page range variant of
copy_mc_highpage().  When copy_mc_to_kernel() is available and the pages
are in the linear map, copy the whole range with a single
copy_mc_to_kernel() call, so the CPU can optimize for the larger extent. 
Otherwise, fall back to copy_mc_highpage() one page at a time.

On a machine check, queue the poisoned source page for memory_failure(),
as copy_mc_highpage() does, and return -EHWPOISON, as folio_mc_copy() does
today.

copy_mc_to_kernel() cannot reschedule, so only take the single-call path
when CONFIG_PREEMPTION is set and the copy can be preempted.  Since commit
7dadeaa6e851 ("sched: Further restrict the preemption modes"), x86 and
powerpc, the only architectures that select ARCH_HAS_COPY_MC, only offer
the full, lazy and RT preemption models, also with PREEMPT_DYNAMIC, so
they always take this path.  The per-page fallback calls cond_resched()
before each page, as clear_contig_highpages() does.  Other architectures
keep copying one page at a time.

Switch folio_mc_copy() to copy the whole folio with copy_mc_highpages().

On a Zen 6 system with CXL memory, move_pages() gets ~1.4x faster for 2MB
THPs and up to ~2.8x faster for 1GB hugetlb pages (numbers below).  When
demoting to CXL, kswapd uses ~31% less CPU per GB demoted.

Link: https://patch.msgid.link/20261113-batpagecopy-v3-1-297f5b2fd28e@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Salunke, Hrushikesh <hsalunke@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Teja Vojjala <tejavojjala@google.com>
Cc: Huan Nguyen <nhuhuan@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>

 include/linux/highmem.h |   51 ++++++++++++++++++++++++++++++++++++++
 mm/util.c               |   14 +---------
 2 files changed, 53 insertions(+), 12 deletions(-)

--- a/include/linux/highmem.h~mm-introduce-copy_mc_highpages-and-batch-copy-in-folio_mc_copy
+++ a/include/linux/highmem.h
@@ -484,6 +484,57 @@ static inline int copy_mc_highpage(struc
 }
 #endif
 
+/**
+ * copy_mc_highpages() - copy a page range with machine check handling
+ * @to: first destination page
+ * @from: first source page
+ * @nr_pages: number of pages
+ *
+ * Range variant of copy_mc_highpage(). On a machine check, the poisoned
+ * source page is queued for memory_failure().
+ *
+ * Context: Process context. May sleep.
+ * Return: 0 on success, -EHWPOISON if a machine check was handled.
+ */
+static inline int copy_mc_highpages(struct page *to, struct page *from,
+		unsigned long nr_pages)
+{
+	unsigned long len = nr_pages << PAGE_SHIFT;
+	unsigned long i, ret;
+
+	might_sleep();
+
+	/*
+	 * When copying we want to operate on the largest extent possible to
+	 * allow for architecture specific extent based optimizations.
+	 *
+	 * copy_mc_to_kernel() does not call cond_resched(). That is fine on
+	 * preemptible kernels, where the scheduler can preempt the copy at
+	 * any point, so copy the whole range at once if copy_mc_to_kernel() is
+	 * available and the pages are in the linear map. Otherwise, copy one
+	 * page at a time and reschedule in between.
+	 */
+	if (IS_ENABLED(CONFIG_ARCH_HAS_COPY_MC) && IS_ENABLED(CONFIG_PREEMPTION) &&
+	    !IS_ENABLED(CONFIG_HIGHMEM)) {
+		ret = copy_mc_to_kernel(page_address(to), page_address(from), len);
+		if (ret) {
+			memory_failure_queue(page_to_pfn(from) +
+					     ((len - ret) >> PAGE_SHIFT), 0);
+			return -EHWPOISON;
+		}
+		for (i = 0; i < nr_pages; i++)
+			kmsan_copy_page_meta(to + i, from + i);
+		return 0;
+	}
+
+	for (i = 0; i < nr_pages; i++) {
+		cond_resched();
+		if (copy_mc_highpage(to + i, from + i))
+			return -EHWPOISON;
+	}
+	return 0;
+}
+
 static inline void memcpy_page(struct page *dst_page, size_t dst_off,
 			       struct page *src_page, size_t src_off,
 			       size_t len)
--- a/mm/util.c~mm-introduce-copy_mc_highpages-and-batch-copy-in-folio_mc_copy
+++ a/mm/util.c
@@ -776,18 +776,8 @@ EXPORT_SYMBOL(folio_copy);
 
 int folio_mc_copy(struct folio *dst, struct folio *src)
 {
-	long nr = folio_nr_pages(src);
-	long i = 0;
-
-	for (;;) {
-		if (copy_mc_highpage(folio_page(dst, i), folio_page(src, i)))
-			return -EHWPOISON;
-		if (++i == nr)
-			break;
-		cond_resched();
-	}
-
-	return 0;
+	return copy_mc_highpages(folio_page(dst, 0), folio_page(src, 0),
+				 folio_nr_pages(src));
 }
 EXPORT_SYMBOL(folio_mc_copy);
 
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-introduce-copy_mc_highpages-and-batch-copy-in-folio_mc_copy.patch
mm-remove-unused-helpers-from-pagemaph.patch
mm-swapops-remove-unused-make_guard_swp_entry.patch
mm-swap-remove-unused-folio_to_swp_tb.patch
mm-zsmalloc-remove-unused-zpdesc_lock.patch
mm-nommu-remove-unused-heap_stack_gap.patch

