Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FE82153CE
	for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2025 21:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752789306; cv=none; b=V7Ru0muO7G6LDZU3Xpf58TZ/2ykg7qHrYGbWwXJIBFuHxP5pMaViRPFH/pZzRMkI6N+aDQ7pa5o25i0SMVOSkFE0HvFX4rUgDafcFOejn88vhxgU7fKl5REtDJ80Qz8wPPDA4qHg6E7xvYJESPTLBRp400gHdNxT8uDd18HiIPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752789306; c=relaxed/simple;
	bh=gdoMqBlBHjZ/YOnodEsXm0r0GAB7Uz2T2PtUVnI8Xzs=;
	h=Date:To:From:Subject:Message-Id; b=I8Hsv+d/cJOXupjJwmhpmQ3U6uzf8Z9U7l29vIo7ouPPZDGfFkLoIlgbLpp0PfBpbssTAvjfNJREtSPEeXcsZKtWJLBcu0znontj3VIxh9xOXARA8nBxzG2It5ljIXuxIDJjOHTzPCQzcy2KJhVx5oq5kWac2cgMJGDL88JXavk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o7d+GWe/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o7d+GWe/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFCDC4CEE3;
	Thu, 17 Jul 2025 21:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752789305;
	bh=gdoMqBlBHjZ/YOnodEsXm0r0GAB7Uz2T2PtUVnI8Xzs=;
	h=Date:To:From:Subject:From;
	b=o7d+GWe/LCdgb3SwXO78owsH+INfSWj6ml6KXEY7o8aP3xxxS/K/N4rG8bu9SOI3c
	 VOEg6l8Ix2oL89t+Yq08FEqlCBLB1RBWr4wCsOWmff5XykpaGbxx3ebZiUFF/Sc4w5
	 vjyuZ/vVCOiPymB6qv1ZKaO7VJjg/p0KmGDJQdss=
Date: Thu, 17 Jul 2025 14:55:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sj@kernel.org,shivankg@amd.com,osalvador@suse.de,harry.yoo@oracle.com,david@redhat.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-util-introduce-snapshot_page-fix.patch added to mm-new branch
Message-Id: <20250717215505.AAFCDC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-util-introduce-snapshot_page-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-util-introduce-snapshot_page-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-util-introduce-snapshot_page-fix.patch

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
From: Luiz Capitulino <luizcap@redhat.com>
Subject: mm-util-introduce-snapshot_page-fix
Date: Thu, 17 Jul 2025 11:54:07 -0400

fix set_ps_flags() commentary

Link: https://lkml.kernel.org/r/d5c75701-b353-4536-a306-187fab0655b3@redhat.com
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/util.c~mm-util-introduce-snapshot_page-fix
+++ a/mm/util.c
@@ -1198,10 +1198,12 @@ static void set_ps_flags(struct page_sna
  * Create a snapshot of the page and store both its struct page and struct
  * folio representations in @ps.
  *
- * Note that creating a faithful snapshot may fail if the compound
- * state of the page keeps changing (e.g., due to a folio split). In
- * this case, ps->faithful is set to false, and the snapshot assumes
- * that @page refers to a single page.
+ * A snapshot is marked as "faithful" if the compound state of @page was
+ * stable and allowed safe reconstruction of the folio representation. In
+ * rare cases where this is not possible (e.g. due to folio splitting),
+ * snapshot_page() falls back to treating @page as a single page and the
+ * snapshot is marked as "unfaithful". The snapshot_page_is_faithful()
+ * helper can be used to check for this condition.
  */
 void snapshot_page(struct page_snapshot *ps, const struct page *page)
 {
_

Patches currently in -mm which might be from luizcap@redhat.com are

mm-util-introduce-snapshot_page.patch
mm-util-introduce-snapshot_page-fix.patch
proc-kpagecount-use-snapshot_page.patch
fs-stable_page_flags-use-snapshot_page.patch

