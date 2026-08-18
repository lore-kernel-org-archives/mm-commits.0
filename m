Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A40358389;
	Tue, 18 Aug 2026 19:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787081355; cv=none; b=bNoBCXSL39QX5pmTtghUETvyvK9zrOyzo/41bWDpavqGUDJ0hqZAGnjOYJc9XH1hXXBvdUpkDvq5ya7O6zHCNoGMqrqdhbc5tNbE62JeeXXREIMOykL7jIHNOI/7Lcbm2+aXKOMr1YA5irqtIo0oo8dNq3JeNbSHLgYVflqzyFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787081355; c=relaxed/simple;
	bh=ECSi2dqL6Y7BW1VnpS2gzJXXwMRc+rzHk3d6ewIB+Nk=;
	h=Date:To:From:Subject:Message-Id; b=lwztBSmPT8xZy4se9JZYBOyv7s/xdWxVSng6TQJFvBfPuwRCoPmFDVDSKu2h91MWhwuSNL0Rw9t9jgr5cm4kFMDTDHg3UhVg2Q7JfrUXU+fIMGj3YtPMe/s/YCcYO/pxzTypPBlzRYoKn1hom3gMTu8cDnl0mD64Fo40DAeV7Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xPReECoD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xPReECoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1901F00A3D;
	Tue, 18 Aug 2026 19:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787081351;
	bh=EvDpBrFMwYkKtd2F1s98/J8aUzlp/dxkidKmfLTZD4Q=;
	h=Date:To:From:Subject;
	b=xPReECoDJ39IFGDs05WBFZe/SonP9QvHfeYnVswgi4m0gpSDe2DaWpnuAeRMd408L
	 BFb+/eDUPsVB6ffJ8qwQR7Is8SAHWtoJaD28ycvr2iJE1IYxdkNBHwfHYXm/Hk/W1m
	 E4RKcY31EUK119sZu/V8u7ESJ7wml+SOdtNqlH/k=
Date: Tue, 18 Aug 2026 12:29:11 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,osalvador@suse.de,nphamcs@gmail.com,linmiaohe@huawei.com,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-ratelimit-bad-swap-entry-reports.patch added to mm-unstable branch
Message-Id: <20260818192911.8E1901F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: ratelimit bad swap entry reports
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-ratelimit-bad-swap-entry-reports.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-ratelimit-bad-swap-entry-reports.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: mm, swap: ratelimit bad swap entry reports
Date: Tue, 18 Aug 2026 02:03:40 -0700

A corrupt page table hands the same bogus entry to get_swap_device() on
every access to the mapping, and every rejection is logged.  One machine
logged 6185620 copies of the same line in a few hours.

swap_dup_entry_direct() prints the same message from the fork path, once
per call: the WARN_ON_ONCE() guarding it warns once, the pr_err() inside
does not.

Rate limit all three prints.

Link: https://lore.kernel.org/20260818-swap_part_one-v1-1-a4fc58119fc0@debian.org
Fixes: 23b230ba8ac3 ("mm/swap: print bad swap offset entry in get_swap_device")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Kairui Song <kasong@tencent.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-ratelimit-bad-swap-entry-reports
+++ a/mm/swapfile.c
@@ -1899,11 +1899,11 @@ struct swap_info_struct *get_swap_device
 
 	return si;
 bad_nofile:
-	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
+	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);
 out:
 	return NULL;
 put_out:
-	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
+	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	percpu_ref_put(&si->users);
 	return NULL;
 }
@@ -3883,7 +3883,7 @@ int swap_dup_entry_direct(swp_entry_t en
 
 	si = swap_entry_to_info(entry);
 	if (WARN_ON_ONCE(!si)) {
-		pr_err("%s%08lx\n", Bad_file, entry.val);
+		pr_err_ratelimited("%s%08lx\n", Bad_file, entry.val);
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch
mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan.patch
documentation-kmemleak-document-the-conditional-min_unref_scans-default.patch
selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments.patch
mm-swap-ratelimit-bad-swap-entry-reports.patch

