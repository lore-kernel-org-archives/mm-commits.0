Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB1141AAC
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 22:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708467325; cv=none; b=hyR44tIa36dS+Z/YcoLFXqnYcoNhBfAwFiJ7P0bVJ/vxnB4XH2OXxgkRitjEpwYEh/9zc6tyfOnxvrx1rD7mkW8/wX88sgu5hHHxFM7LUeSbyTWjOvozXCKPPy7XLymAe17OSyvpCiV/ao//sYfWGTzwcWtXbPMLflEWBVkz2Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708467325; c=relaxed/simple;
	bh=T7GaHk+QPxgm16rEAet6CIVY9TFqRh7yl5jSCxQzcvQ=;
	h=Date:To:From:Subject:Message-Id; b=KmGVzgqWzJ6hVfstbLjwNciD5T2MhhV+Ez1XszsveYpWYsnjuXuAmcnN0Dcp6+WeyK+TIdwwOQIpQL5r2rSNADDwIgj7NTpAVMiUL+UHlZyLlq+xfRqrvHeW/hzfPks+vOWoel07K7z+5U28CfXG5CEyloiwuzjSy9bRDHqy7kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HlJavvfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HlJavvfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1585EC433F1;
	Tue, 20 Feb 2024 22:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708467325;
	bh=T7GaHk+QPxgm16rEAet6CIVY9TFqRh7yl5jSCxQzcvQ=;
	h=Date:To:From:Subject:From;
	b=HlJavvfLfefK3zanNKcDb9On17OONvRi6LBYjPPuHrXGMqrgQMsu+f3QzoYCHGx2E
	 pfDsNgJSPYlpxxcnQGYFsTtDaT0kTNqQ60/GuAKmWXnSYFFhioOB/h3yIBRLhjlHpm
	 WWJUZDEFoJiI4G2Qj9iRfYsymkPNcpWFyMCNTPns=
Date: Tue, 20 Feb 2024 14:15:24 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-v2.patch removed from -mm tree
Message-Id: <20240220221525.1585EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap_state: update zswap LRU's protection range with the folio locked
has been removed from the -mm tree.  Its filename was
     mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-v2.patch

This patch was dropped because it was folded into mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked.patch

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm/swap_state: update zswap LRU's protection range with the folio locked
Date: Tue, 6 Feb 2024 10:08:55 -0800

add VM_WARN_ON_ONCE() to zswap_folio_swapin()

Link: https://lkml.kernel.org/r/20240206180855.3987204-1-nphamcs@gmail.com
Reported-by: syzbot+17a611d10af7d18a7092@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000ae47f90610803260@google.com/
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zswap.c~mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-v2
+++ a/mm/zswap.c
@@ -378,6 +378,7 @@ void zswap_folio_swapin(struct folio *fo
 	struct lruvec *lruvec;
 
 	if (folio) {
+		VM_WARN_ON_ONCE(!folio_test_locked(folio));
 		lruvec = folio_lruvec(folio);
 		atomic_long_inc(&lruvec->zswap_lruvec_state.nr_zswap_protected);
 	}
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked.patch
mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-fix.patch
mm-cachestat-fix-folio-read-after-free-in-cache-walk.patch
selftests-zswap-add-zswap-selftest-file-to-zswap-maintainer-entry.patch
selftests-fix-the-zswap-invasive-shrink-test.patch
selftests-add-zswapin-and-no-zswap-tests.patch

