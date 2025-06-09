Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F6E21D3DF
	for <mm-commits@vger.kernel.org>; Mon,  9 Jun 2025 23:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749511952; cv=none; b=noDOcHwACYPo20gw341c11BB6F5Fu20pRT0X41hKEfOxm+ujc7OiXlMKMdrkEBIWPsX8R8T1I4iN/12d/5Za3vwxdcN3mm2khNaS+PnA4r9x4xnslR2ahgxzjvvKKYc4tsA6BvNbmS+rZUnhGQuIPUiyS9xW3Acqpzyl8tBuj10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749511952; c=relaxed/simple;
	bh=QLWfNsKjduHyJsNhQ0YPU7/E/DEGx6j02sPMhWdQyRQ=;
	h=Date:To:From:Subject:Message-Id; b=Aoqt/Dp3xKkj9/TmSlYsXfW2ZEldrM1+eOoZerTNsChSI6kcOSNhXf1q/dga30tqya9gSSH4yqWY4h08TlPO50pNwyTmvm3MA1P2cFhfy98eKBHnX6VIGvPPUOQ/Cry7CyLU9AZyWLVcrYjCm/I8saROxVHWIEaBjCCsWX1SxSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FBGbUV+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FBGbUV+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596C3C4CEEB;
	Mon,  9 Jun 2025 23:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749511952;
	bh=QLWfNsKjduHyJsNhQ0YPU7/E/DEGx6j02sPMhWdQyRQ=;
	h=Date:To:From:Subject:From;
	b=FBGbUV+mIPpVZXsAqVXJUF262X5XbrKGMfuicofVwhJ7WJNieT2ZJyR63hv9eFD1F
	 KGZJStAIihT4fF6pgNjfyXI7E1Vo3HT5kfED0mtjb0TXUjcPKQFDDl/62UqUB7xw3x
	 Qib2MgOsEA1aD9txMnD3QrZfQKY3tc+B/KKzi7MU=
Date: Mon, 09 Jun 2025 16:32:31 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,jack@suse.cz,david@redhat.com,chaitanyas.prakash@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-honour-new_order-in-page_cache_ra_order.patch added to mm-new branch
Message-Id: <20250609233232.596C3C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/readahead: honour new_order in page_cache_ra_order()
has been added to the -mm mm-new branch.  Its filename is
     mm-readahead-honour-new_order-in-page_cache_ra_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-honour-new_order-in-page_cache_ra_order.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm/readahead: honour new_order in page_cache_ra_order()
Date: Mon, 9 Jun 2025 10:27:23 +0100

Patch series "Readahead tweaks for larger folios", v5.

This series adds some tweaks to readahead so that it does a better job of
ramping up folio sizes as readahead extends further into the file.  And it
additionally special-cases executable mappings to allow the arch to
request a preferred folio size for text.


This patch (of 5):

page_cache_ra_order() takes a parameter called new_order, which is
intended to express the preferred order of the folios that will be
allocated for the readahead operation.  Most callers indeed call this with
their preferred new order.  But page_cache_async_ra() calls it with the
preferred order of the previous readahead request (actually the order of
the folio that had the readahead marker, which may be smaller when
alignment comes into play).

And despite the parameter name, page_cache_ra_order() always treats it at
the old order, adding 2 to it on entry.  As a result, a cold readahead
always starts with order-2 folios.

Let's fix this behaviour by always passing in the *new* order.

Worked example:

Prior to the change, mmaping an 8MB file and touching each page
sequentially, resulted in the following, where we start with order-2
folios for the first 128K then ramp up to order-4 for the next 128K, then
get clamped to order-5 for the rest of the file because pa_pages is
limited to 128K:

TYPE    STARTOFFS     ENDOFFS       SIZE  STARTPG    ENDPG   NRPG  ORDER
-----  ----------  ----------  ---------  -------  -------  -----  -----
FOLIO  0x00000000  0x00004000      16384        0        4      4      2
FOLIO  0x00004000  0x00008000      16384        4        8      4      2
FOLIO  0x00008000  0x0000c000      16384        8       12      4      2
FOLIO  0x0000c000  0x00010000      16384       12       16      4      2
FOLIO  0x00010000  0x00014000      16384       16       20      4      2
FOLIO  0x00014000  0x00018000      16384       20       24      4      2
FOLIO  0x00018000  0x0001c000      16384       24       28      4      2
FOLIO  0x0001c000  0x00020000      16384       28       32      4      2
FOLIO  0x00020000  0x00030000      65536       32       48     16      4
FOLIO  0x00030000  0x00040000      65536       48       64     16      4
FOLIO  0x00040000  0x00060000     131072       64       96     32      5
FOLIO  0x00060000  0x00080000     131072       96      128     32      5
FOLIO  0x00080000  0x000a0000     131072      128      160     32      5
FOLIO  0x000a0000  0x000c0000     131072      160      192     32      5
...

After the change, the same operation results in the first 128K being
order-0, then we start ramping up to order-2, -4, and finally get clamped
at order-5:

TYPE    STARTOFFS     ENDOFFS       SIZE  STARTPG    ENDPG   NRPG  ORDER
-----  ----------  ----------  ---------  -------  -------  -----  -----
FOLIO  0x00000000  0x00001000       4096        0        1      1      0
FOLIO  0x00001000  0x00002000       4096        1        2      1      0
FOLIO  0x00002000  0x00003000       4096        2        3      1      0
FOLIO  0x00003000  0x00004000       4096        3        4      1      0
FOLIO  0x00004000  0x00005000       4096        4        5      1      0
FOLIO  0x00005000  0x00006000       4096        5        6      1      0
FOLIO  0x00006000  0x00007000       4096        6        7      1      0
FOLIO  0x00007000  0x00008000       4096        7        8      1      0
FOLIO  0x00008000  0x00009000       4096        8        9      1      0
FOLIO  0x00009000  0x0000a000       4096        9       10      1      0
FOLIO  0x0000a000  0x0000b000       4096       10       11      1      0
FOLIO  0x0000b000  0x0000c000       4096       11       12      1      0
FOLIO  0x0000c000  0x0000d000       4096       12       13      1      0
FOLIO  0x0000d000  0x0000e000       4096       13       14      1      0
FOLIO  0x0000e000  0x0000f000       4096       14       15      1      0
FOLIO  0x0000f000  0x00010000       4096       15       16      1      0
FOLIO  0x00010000  0x00011000       4096       16       17      1      0
FOLIO  0x00011000  0x00012000       4096       17       18      1      0
FOLIO  0x00012000  0x00013000       4096       18       19      1      0
FOLIO  0x00013000  0x00014000       4096       19       20      1      0
FOLIO  0x00014000  0x00015000       4096       20       21      1      0
FOLIO  0x00015000  0x00016000       4096       21       22      1      0
FOLIO  0x00016000  0x00017000       4096       22       23      1      0
FOLIO  0x00017000  0x00018000       4096       23       24      1      0
FOLIO  0x00018000  0x00019000       4096       24       25      1      0
FOLIO  0x00019000  0x0001a000       4096       25       26      1      0
FOLIO  0x0001a000  0x0001b000       4096       26       27      1      0
FOLIO  0x0001b000  0x0001c000       4096       27       28      1      0
FOLIO  0x0001c000  0x0001d000       4096       28       29      1      0
FOLIO  0x0001d000  0x0001e000       4096       29       30      1      0
FOLIO  0x0001e000  0x0001f000       4096       30       31      1      0
FOLIO  0x0001f000  0x00020000       4096       31       32      1      0
FOLIO  0x00020000  0x00024000      16384       32       36      4      2
FOLIO  0x00024000  0x00028000      16384       36       40      4      2
FOLIO  0x00028000  0x0002c000      16384       40       44      4      2
FOLIO  0x0002c000  0x00030000      16384       44       48      4      2
FOLIO  0x00030000  0x00034000      16384       48       52      4      2
FOLIO  0x00034000  0x00038000      16384       52       56      4      2
FOLIO  0x00038000  0x0003c000      16384       56       60      4      2
FOLIO  0x0003c000  0x00040000      16384       60       64      4      2
FOLIO  0x00040000  0x00050000      65536       64       80     16      4
FOLIO  0x00050000  0x00060000      65536       80       96     16      4
FOLIO  0x00060000  0x00080000     131072       96      128     32      5
FOLIO  0x00080000  0x000a0000     131072      128      160     32      5
FOLIO  0x000a0000  0x000c0000     131072      160      192     32      5
FOLIO  0x000c0000  0x000e0000     131072      192      224     32      5
...

Link: https://lkml.kernel.org/r/20250609092729.274960-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20250609092729.274960-2-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Tested-by: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/mm/readahead.c~mm-readahead-honour-new_order-in-page_cache_ra_order
+++ a/mm/readahead.c
@@ -468,20 +468,12 @@ void page_cache_ra_order(struct readahea
 	unsigned int nofs;
 	int err = 0;
 	gfp_t gfp = readahead_gfp_mask(mapping);
-	unsigned int min_ra_size = max(4, mapping_min_folio_nrpages(mapping));
 
-	/*
-	 * Fallback when size < min_nrpages as each folio should be
-	 * at least min_nrpages anyway.
-	 */
-	if (!mapping_large_folio_support(mapping) || ra->size < min_ra_size)
+	if (!mapping_large_folio_support(mapping))
 		goto fallback;
 
 	limit = min(limit, index + ra->size - 1);
 
-	if (new_order < mapping_max_folio_order(mapping))
-		new_order += 2;
-
 	new_order = min(mapping_max_folio_order(mapping), new_order);
 	new_order = min_t(unsigned int, new_order, ilog2(ra->size));
 	new_order = max(new_order, min_order);
@@ -683,6 +675,7 @@ void page_cache_async_ra(struct readahea
 	ra->size = get_next_ra_size(ra, max_pages);
 	ra->async_size = ra->size;
 readit:
+	order += 2;
 	ractl->_index = ra->start;
 	page_cache_ra_order(ractl, ra, order);
 }
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-close-theoretical-race-where-stale-tlb-entries-could-linger.patch
mm-readahead-honour-new_order-in-page_cache_ra_order.patch
mm-readahead-terminate-async-readahead-on-natural-boundary.patch
mm-readahead-make-space-in-struct-file_ra_state.patch
mm-readahead-store-folio-order-in-struct-file_ra_state.patch
mm-filemap-allow-arch-to-request-folio-size-for-exec-memory.patch
mm-remove-arch_flush_tlb_batched_pending-arch-helper.patch

