Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD193B8BBF
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 12:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777292990; cv=none; b=DMs6KysZXThS+3KmAkvYOXj1D054sqKFCMbFnS9/Q3a/4S30+cwPEGLPTfknoJzl3PxJO5yJf2XyLwttCXJCsBAmRuPgTz+szOl8ZLwz1g051oOcMDG96cTh7X1AcTe9ZdvMgKjZTKiuedhz1owkkNAqtH485kC6SUMvKoEwq20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777292990; c=relaxed/simple;
	bh=KFGSi9s56zhp4Spee87HIwaHOhQ9ir9pLmav5vxeLG8=;
	h=Date:To:From:Subject:Message-Id; b=ErthyrNlsVzvefc2zGx7qOoZVBK6hJxQZAfhZgqOnSlkIdCR3WhXz9XtZW5qOWu+zKionttAfMAjNDACQY54s+Tnk33UUqKcZEUhbhd4pDEOQZiI0UtJqOrTMqWq1ikSBDINMBoZla2wL+sljMD2OmLuelUy78b8EEj77od8SSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RnvS3M32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RnvS3M32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F2CC19425;
	Mon, 27 Apr 2026 12:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777292990;
	bh=KFGSi9s56zhp4Spee87HIwaHOhQ9ir9pLmav5vxeLG8=;
	h=Date:To:From:Subject:From;
	b=RnvS3M32Sb/D5SKZWex3FLPDskROWCBKLG84rcewq+HsyhtjEyMBP8WtPD2mthUnF
	 EOazDD/XYUFw1rdShNrXl6JolSoBLEaKiNWRGLQB7Ro2l8CB/SaqVd3qvCsz/F3XAJ
	 tEb/pfa2VN8tsQwKJcyEmcPvR71qo36XITHENcTo=
Date: Mon, 27 Apr 2026 05:29:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,ljs@kernel.org,kaleshsingh@google.com,jack@suse.cz,david@kernel.org,fmayle@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-limit-filemap_fault-readahead-to-vma-boundaries.patch added to mm-new branch
Message-Id: <20260427122950.10F2CC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: limit filemap_fault readahead to VMA boundaries
has been added to the -mm mm-new branch.  Its filename is
     mm-limit-filemap_fault-readahead-to-vma-boundaries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-limit-filemap_fault-readahead-to-vma-boundaries.patch

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
From: Frederick Mayle <fmayle@google.com>
Subject: mm: limit filemap_fault readahead to VMA boundaries
Date: Sun, 26 Apr 2026 20:01:47 -0700

When a file mapping covers a strict subset of a file, an access to the
mapping can trigger readahead of file pages outside the mapped region. 
Readahead is meant to prefetch pages likely to be accessed soon, but these
pages aren't accessible via the same means, so it fair to say we don't
have a good indicator they'll be accessed soon.  Take an ELF file for
example: an access to the end of a program's read-only segment isn't a
sign that nearby file contents will be accessed next (they are likely to
be mapped discontiguously, or not at all).  The pressure from loading
these pages into the cache can evict more useful pages.

To improve the behavior, make three changes:

* Introduce a new readahead_control field, max_index, as a hard limit on
  the readahead. The existing file_ra_state->size can't be used as a
  limit, it is more of a hint and can be increased by various
  heuristics.
* Set readahead_control->max_index to the end of the VMA in all of the
  readahead paths that can be triggered from a fault on a file mapping
  (both "sync" and "async" readahead).
* Limit the read-around range start to the VMA's start.

Note that these changes only affect readahead triggered in the context of
a fault, they do not affect readahead triggered by read syscalls.  If a
user mixes the two types of accesses, the behavior is expected to be the
following: if a fault causes readahead and places a PG_readahead marker
and then a read(2) syscall hits the PG_readahead marker, the resulting
async readahead *will not* be limited to the VMA end.  Conversely, if a
read(2) syscall places a PG_readahead marker and then a fault hits the
marker, the async readahead *will* be limited to the VMA end.

There is an edge case that the above motivation glosses over: A single
file mapping might be backed by multiple VMAs.  For example, a whole file
could be mapped RW, then part of the mapping made RO using mprotect.  This
patch would hurt performance of a sequential faulted read of such a
mapping, the degree depending on how fragmented the VMAs are.  A usage
pattern like that is likely rare and already suffering from sub-optimal
performance because, e.g., the fragmented VMAs limit the fault-around, so
each VMA boundary in a sequential faulted read would cause a minor fault. 
Still, this patch would make it worse.  See a previous discussion of this
topic at [1].

Tested by mapping and reading a small subset of a large file, then using
the cachestat syscall to verify the number of cached pages didn't exceed
the mapping size.

In practical scenarios, the effect depends on the specific file and usage.
Sometimes there is no effect at all, but, for some ELF files in Android,
we see ~20% fewer pages pulled into the cache.

A comprehensive performance evaluation hasn't been done, but, in addition
to the anecdontal memory savings mentioned above, a benchmark was run with
fio 3.38, showing neutral looking results:

    /data/local/tmp/fio --version

    fio --name=mmap_test --ioengine=mmap --rw=read --bs=4k \
        --offset=1G --size=1G --filesize=3G --numjobs=1 \
        --filename=testfile.bin

        Before: 4366.6 MiB/s (avg of 3459, 4592, 4613, 4697, 4472)
        After:  4444.0 MiB/s (avg of 4633, 4655, 4511, 4571, 3850)
                +1.7%

    Same, with --ioengine=mmap --rw=randread

        Before: 445.6 MiB/s  (avg of 446, 447, 442, 452, 441)
        After:  447.0 MiB/s  (avg of 447, 446, 446, 451, 445)
                +0.3%

    Same, with --ioengine=psync --rw=read

        Before: 3086.6 MiB/s (avg of 3122, 3094, 3066, 3094, 3057)
        After:  3084.6 MiB/s (avg of 3039, 3103, 3103, 3084, 3094)
                -0.06%

    Same, with --ioengine=psync --rw=randread

        Before: 2226.4 MiB/s (avg of 2256, 2183, 2207, 2265, 2221)
        After:  2231.4 MiB/s (avg of 2236, 2241, 2236, 2193, 2251)
                +0.2%


Link: https://lore.kernel.org/20260427030148.653228-1-fmayle@google.com
Link: https://lore.kernel.org/all/ivnv2crd3et76p2nx7oszuqhzzah756oecn5yuykzqfkqzoygw@yvnlkhjjssoz/ [1]
Signed-off-by: Frederick Mayle <fmayle@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 ++
 mm/filemap.c            |    4 ++++
 mm/readahead.c          |    6 +++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

--- a/include/linux/pagemap.h~mm-limit-filemap_fault-readahead-to-vma-boundaries
+++ a/include/linux/pagemap.h
@@ -1350,6 +1350,7 @@ struct readahead_control {
 	struct file_ra_state *ra;
 /* private: use the readahead_* accessors instead */
 	pgoff_t _index;
+	pgoff_t _max_index; /* limit readahead to _max_index, inclusive */
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
 	bool dropbehind;
@@ -1363,6 +1364,7 @@ struct readahead_control {
 		.mapping = m,						\
 		.ra = r,						\
 		._index = i,						\
+		._max_index = ULONG_MAX,				\
 	}
 
 #define VM_READAHEAD_PAGES	(SZ_128K / PAGE_SIZE)
--- a/mm/filemap.c~mm-limit-filemap_fault-readahead-to-vma-boundaries
+++ a/mm/filemap.c
@@ -3314,6 +3314,8 @@ static struct file *do_sync_mmap_readahe
 	bool force_thp_readahead = false;
 	unsigned short mmap_miss;
 
+	ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
+
 	/* Use the readahead code, even if readahead is disabled */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
@@ -3396,6 +3398,7 @@ static struct file *do_sync_mmap_readahe
 		 * mmap read-around
 		 */
 		ra->start = max_t(long, 0, vmf->pgoff - ra->ra_pages / 2);
+		ra->start = max(ra->start, vmf->vma->vm_pgoff);
 		ra->size = ra->ra_pages;
 		ra->async_size = ra->ra_pages / 4;
 		ra->order = 0;
@@ -3438,6 +3441,7 @@ static struct file *do_async_mmap_readah
 	}
 
 	if (folio_test_readahead(folio)) {
+		ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		page_cache_async_ra(&ractl, folio, ra->ra_pages);
 	}
--- a/mm/readahead.c~mm-limit-filemap_fault-readahead-to-vma-boundaries
+++ a/mm/readahead.c
@@ -324,6 +324,8 @@ static void do_page_cache_ra(struct read
 		return;
 
 	end_index = (isize - 1) >> PAGE_SHIFT;
+	if (end_index > ractl->_max_index)
+		end_index = ractl->_max_index;
 	if (index > end_index)
 		return;
 	/* Don't read past the page containing the last byte of the file */
@@ -471,7 +473,7 @@ void page_cache_ra_order(struct readahea
 	pgoff_t start = readahead_index(ractl);
 	pgoff_t index = start;
 	unsigned int min_order = mapping_min_folio_order(mapping);
-	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
+	pgoff_t limit;
 	pgoff_t mark = index + ra->size - ra->async_size;
 	unsigned int nofs;
 	int err = 0;
@@ -484,6 +486,8 @@ void page_cache_ra_order(struct readahea
 		goto fallback;
 	}
 
+	limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
+	limit = min(limit, ractl->_max_index);
 	limit = min(limit, index + ra->size - 1);
 
 	new_order = min(mapping_max_folio_order(mapping), new_order);
_

Patches currently in -mm which might be from fmayle@google.com are

mm-limit-filemap_fault-readahead-to-vma-boundaries.patch

