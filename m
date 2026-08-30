Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684101A262D
	for <mm-commits@vger.kernel.org>; Sun, 30 Aug 2026 03:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788060789; cv=none; b=mmcyqR1oVLVp4dyzPJwwQiNyH+cuxQwT+5w0PhdeyKepuwxl2kWEwLbreJByLETgFBbVixMq6AbZfvdw/NLfiWcp+lSGBiVASIi2H7e5NMVko3jT2Hrc7EbQpyxEi9i2e9c9x/okwPOlzXWkc1q+tH9JI5/pJKagJ/YOS8yloOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788060789; c=relaxed/simple;
	bh=rQt7SqgMfpOpittCqH7rw5Xfe6xyDDJX0NMtTZO1SdU=;
	h=Date:To:From:Subject:Message-Id; b=Tj+HoEJir51vmqKXAI5BLgFnHr8N9wpH6KphHUhtekBkj4CQJliIFeZSRkKzvpQ6zxWOIrrJ2M6skH/EwKIK72E2Yc3MHut2c8+cAHEr83klGlt4a34RN3jTvmOFWVSM50y15XYisrQNHb79bXN994J4tNYiCZkcsqv0uyMMx5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dBBQubeU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dBBQubeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95951F000E9;
	Sun, 30 Aug 2026 03:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788060787;
	bh=bxcdTSGVTu0ArkB8Mr4fn68zrbLSkVGJHS3W3HV+7mU=;
	h=Date:To:From:Subject;
	b=dBBQubeUTV11wk6kWWOJ54Gutnhqf3KTAkeAPRIoLnSjAmlrfxaaS+wbBkxot2TiY
	 i/u9aj3ZZN3nnugtFqPVLMVPO6EhB2z4jghM0GBOca7X47oc/iyTDTSG3VUi6FMXix
	 5yk5RpPP9HS8TEU5ObfjUfInSBv2fk+ruBxp0NQo=
Date: Sat, 29 Aug 2026 20:33:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-custom-bad-page-map-ratelimiting-logic.patch added to mm-new branch
Message-Id: <20260830033307.B95951F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: replace custom bad page map ratelimiting logic
has been added to the -mm mm-new branch.  Its filename is
     mm-replace-custom-bad-page-map-ratelimiting-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-custom-bad-page-map-ratelimiting-logic.patch

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
From: Pedro Falcato <pfalcato@suse.de>
Subject: mm: replace custom bad page map ratelimiting logic
Date: Tue, 11 Aug 2026 18:21:55 +0100

Patch series "mm: replace custom ratelimiting logic".

The kernel has a perfectly cromulent and mostly-equivalent variant in
lib/ratelimit.c that can be used.


This patch (of 2):

The current logic (allow up to $BURST prints per minute) can be entirely
replaced by the generic version in lib/ratelimit.c, used around the
kernel.

Do so.  The only functional difference should be that the new logs will
read something like:

KERN_WARNING "print_bad_page_map: %d callbacks suppressed\n", ...

But that should be fine enough.

Link: https://lore.kernel.org/20260811172156.356053-1-pfalcato@suse.de
Link: https://lore.kernel.org/20260811172156.356053-2-pfalcato@suse.de
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

--- a/mm/memory.c~mm-replace-custom-bad-page-map-ratelimiting-logic
+++ a/mm/memory.c
@@ -492,32 +492,8 @@ static inline void add_mm_rss_vec(struct
 			add_mm_counter(mm, i, rss[i]);
 }
 
-static bool is_bad_page_map_ratelimited(void)
-{
-	static unsigned long resume;
-	static unsigned long nr_shown;
-	static unsigned long nr_unshown;
-
-	/*
-	 * Allow a burst of 60 reports, then keep quiet for that minute;
-	 * or allow a steady drip of one report per second.
-	 */
-	if (nr_shown == 60) {
-		if (time_before(jiffies, resume)) {
-			nr_unshown++;
-			return true;
-		}
-		if (nr_unshown) {
-			pr_alert("BUG: Bad page map: %lu messages suppressed\n",
-				 nr_unshown);
-			nr_unshown = 0;
-		}
-		nr_shown = 0;
-	}
-	if (nr_shown++ == 0)
-		resume = jiffies + 60 * HZ;
-	return false;
-}
+/* Allow a burst of 60 bad page map reports per minute. */
+static DEFINE_RATELIMIT_STATE(bad_page_map_ratelimit, 60 * HZ, 60);
 
 static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
 {
@@ -633,7 +609,7 @@ static void print_bad_page_map(struct vm
 	char entry_str[PTVAL_STR_MAX];
 	pgoff_t index, anon_index;
 
-	if (is_bad_page_map_ratelimited())
+	if (!__ratelimit(&bad_page_map_ratelimit))
 		return;
 
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
_

Patches currently in -mm which might be from pfalcato@suse.de are

x86-alternative-exclude-text-poking-against-change_page_attr.patch
mm-replace-custom-bad-page-map-ratelimiting-logic.patch
mm-page_alloc-replace-custom-bad-page-ratelimiting-logic.patch

