Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE23481AA0
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865943; cv=none; b=pPspnVY890U+RI3Y6O1CfxcUVlqdc/ClzZdiB/cV+StoaqXMGmzvnPr0YhXNN2Y2CwCdYhhN2AythPokUbPJjCX/tbRkre+gVLgI98JF+lPVn1Qo55sgdhve5r+50/11BMnUDBTO+j/anwPcKdwEnT+RPeTZIrpnM0t/YYCHCqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865943; c=relaxed/simple;
	bh=yMCx5v7EiPKw2Bus+ss4yDx6LVx0/rjqZbKgVMow8dc=;
	h=Date:To:From:Subject:Message-Id; b=XPaI7ncMCVAGb0cqC0SL47xWxKACVXO5m9+cdklIFemzfRH3NQs9Blt2am3/9cgqT5BrT7VhsryQGgWC6fv2qhn6x3nwjCmH9nVRxEepYHT24tDJMWwK1nCTMyn9hmdo3kgNfj9PWs+kNL1oCg7ZlkCCyCZqllcdxgFkwq4jBFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lfY8rUdg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lfY8rUdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208F41F00898;
	Tue, 13 Oct 2026 04:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865942;
	bh=4xDwnQyJeLBIoQapR/k0F3gBDBDD2mob5vsNBPNtf+s=;
	h=Date:To:From:Subject;
	b=lfY8rUdgCYoOk50df5zUgjQfcsacmvRo3SP4GYEiBisBxhBH87GAv1+0PR7l21UpB
	 KXwyAZXFVznhJs07Cb4D6YfktQgMCZsW1evNcXgCLH4qBEQuAcvVAkEDsYMchxuOFw
	 jMzpw8i59/z/gdEfwF4xo7J22h87V908Ka3UYWts=
Date: Mon, 12 Oct 2026 21:32:21 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,zhenghui.hao@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-misspelled-parameter-names-in-comment.patch removed from -mm tree
Message-Id: <20261013043222.208F41F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix misspelled parameter names in comment
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-misspelled-parameter-names-in-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhenghui Hao <zhenghui.hao@qq.com>
Subject: mm/hugetlb: fix misspelled parameter names in comment
Date: Tue, 15 Sep 2026 16:20:29 +0800

The comment above hugepages_setup() refers to "hugepagsz" and
"default_hugepagsz", but the parameters parsed by this code are
"hugepagesz" and "default_hugepagesz".  Fix the spelling and also drop the
redundant spaces so the comment reads normally.

No functional change.

Link: https://lore.kernel.org/tencent_034C6FC23D4817C40657E5F17F64E260A009@qq.com
Signed-off-by: Zhenghui Hao <zhenghui.hao@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-misspelled-parameter-names-in-comment
+++ a/mm/hugetlb.c
@@ -4319,9 +4319,9 @@ static __init void hugetlb_parse_params(
 
 /*
  * hugepages command line processing
- * hugepages normally follows a valid hugepagsz or default_hugepagsz
- * specification.  If not, ignore the hugepages value.  hugepages can also
- * be the first huge page command line  option in which case it implicitly
+ * hugepages normally follows a valid hugepagesz or default_hugepagesz
+ * specification. If not, ignore the hugepages value. hugepages can also
+ * be the first huge page command line option in which case it implicitly
  * specifies the number of huge pages for the default size.
  */
 static int __init hugepages_setup(char *s)
_

Patches currently in -mm which might be from zhenghui.hao@qq.com are

hugetlbfs-fix-stale-comment-in-hugetlbfs_file_mmap.patch

