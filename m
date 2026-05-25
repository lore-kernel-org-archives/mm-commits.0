Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA893806BE
	for <mm-commits@vger.kernel.org>; Mon, 25 May 2026 18:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779734832; cv=none; b=e+DDFEBYriI7TAMaUU5ywqiSsSp/r6UScu378//TtUopJUFeBclberLJXIJnzmC9H4ErGxHv+F+UDDlsslCDLTdCcG8BSL7fjWggv38RtLt20w6bbPhXK0PJM79vYQFObw/iXT7XUwpfTsl+D/TdVesdbPTF9cpV2zoSeCEbSDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779734832; c=relaxed/simple;
	bh=MH5cM/579u4SouidbVpgJ6T9iIRPeFEs8XCryLKgIAg=;
	h=Date:To:From:Subject:Message-Id; b=amtyxWUq6ymnX+r0BpnJvn3GGbbeZgN4SFJxYpHeFECyKA7gT/sIUNrReUg/3ybjI6tk/MFwf+EZO8BUx1TfHHLNP3h9A5PJy1KMIbmyA6tmqZ0wvWRpE6EM8TZfcICsqDZSpbnn8y4Gfic4wD3gBgbFmXgUHNtdp5gFZAA23r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gAAMZdfs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gAAMZdfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F001F000E9;
	Mon, 25 May 2026 18:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779734829;
	bh=Cf1c7bKQi9riXwZH6PHLdFKo4QgCuxE+q7osT/AKgms=;
	h=Date:To:From:Subject;
	b=gAAMZdfsEi700Mg4d7SdQfkM2AVFLWZbetbfb+mswxbA/9zP28jZeyd0oNZcmYvxv
	 3os6pdzPtMxEhtI7nTHIidtM24ekn5vNoDdCVwKHgvCDUraZ0x0LVuWpzbD8rR28Zv
	 f9DkZVpMBwszQjFGVXCNjfkYQYjk4m/fZ6S/ii9g=
Date: Mon, 25 May 2026 11:47:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,jack@suse.cz,hannes@cmpxchg.org,david@kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-mmap_miss-accounting-symmetric-for-vm_seq_read.patch added to mm-new branch
Message-Id: <20260525184708.F0F001F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make mmap_miss accounting symmetric for VM_SEQ_READ
has been added to the -mm mm-new branch.  Its filename is
     mm-make-mmap_miss-accounting-symmetric-for-vm_seq_read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-mmap_miss-accounting-symmetric-for-vm_seq_read.patch

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
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: make mmap_miss accounting symmetric for VM_SEQ_READ
Date: Mon, 25 May 2026 07:57:51 -0700

do_sync_mmap_readahead() skips both the mmap_miss increment and the
MMAP_LOTSAMISS check for VM_SEQ_READ mappings, since sequential access is
non-speculative and should always read ahead.  The two decrement sites in
do_async_mmap_readahead() and filemap_map_pages() do not mirror this skip,
so concurrent faults on a VM_SEQ_READ mapping can still drive
ra->mmap_miss down to zero through the decrement paths even though nothing
in the sync path ever increments it.  The counter itself is per-file
(file->f_ra.mmap_miss), so it can be moved by any VMA mapping the file,
not just the one currently faulting.

Skip the decrement for VM_SEQ_READ in both decrement sites so the counter
only moves for mappings that also participate in the increment side.  No
functional change for VM_SEQ_READ users, since the increment-side gate
already prevents the counter from being consulted on their behalf, but it
stops a VM_SEQ_READ mapping from biasing the counter for other mappings of
the same file.

Link: https://lore.kernel.org/20260525145751.2671248-1-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Closes: https://lore.kernel.org/all/8edc8cd0-f65c-4456-9b3f-362e744c9a96@linux.dev/
Cc: David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-make-mmap_miss-accounting-symmetric-for-vm_seq_read
+++ a/mm/filemap.c
@@ -3433,8 +3433,13 @@ static struct file *do_async_mmap_readah
 	 * Don't touch the mmap_miss counter to avoid decreasing it multiple
 	 * times for a single folio and break the balance with mmap_miss
 	 * increase in do_sync_mmap_readahead().
+	 *
+	 * VM_SEQ_READ mappings skip the mmap_miss increment in
+	 * do_sync_mmap_readahead(), so skip the decrement here as well to
+	 * keep the counter symmetric.
 	 */
-	if (likely(!folio_test_locked(folio))) {
+	if (likely(!folio_test_locked(folio)) &&
+	    !(vmf->vma->vm_flags & VM_SEQ_READ)) {
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss)
 			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
@@ -3935,10 +3940,15 @@ vm_fault_t filemap_map_pages(struct vm_f
 		 * In such situation, read-ahead is only a waste of IO.
 		 * Don't decrease mmap_miss in this scenario to make sure
 		 * we can stop read-ahead.
+		 *
+		 * VM_SEQ_READ mappings skip the mmap_miss increment in
+		 * do_sync_mmap_readahead(), so skip the decrement here as
+		 * well to keep the counter symmetric.
 		 */
 		if ((map_ret & VM_FAULT_NOPAGE) &&
 		    !(vmf->flags & FAULT_FLAG_TRIED) &&
-		    !folio_test_workingset(folio)) {
+		    !folio_test_workingset(folio) &&
+		    !(vma->vm_flags & VM_SEQ_READ)) {
 			unsigned short mmap_miss;
 
 			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-make-mmap_miss-accounting-symmetric-for-vm_seq_read.patch

