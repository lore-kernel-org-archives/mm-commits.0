Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8C13B3BF7
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 23:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784589023; cv=none; b=foorY6ChcVS9+wImxQswLUxUW1AjRb7woVhPBxGlP2XkoFSvv2DjmQcDu+nCGJ2w4WfbToK2wnmxV7dUe5d/XmJoOYty/gCIePBFkvvF+76eahLQ+YFSwKe+DMLf0m2CBVSGxkkQMi4hWXY5K0u6Y1KvqDB1Ptu+oO6u8W0TbX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784589023; c=relaxed/simple;
	bh=NDtW5evrxIvOsCVJaR9u02DQwLYUy2ut9WyHqOLcTf0=;
	h=Date:To:From:Subject:Message-Id; b=gM5UYMN+cAtRTPieSqny7NhUSTv39+7UtIn9f9XY609qbaUanPKtUuaCy1zBFGtwT5FnDN9PXdECE1c78JHWmZ3SBWxi0Vduh5xsF6KCRgBMCIMKEBZojyVI3UR0d37xd00X8Ux+8kvUtKF+Gcz41IyPNa94Z+j07SFMkmSHEKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b8iZXgqe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b8iZXgqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476601F000E9;
	Mon, 20 Jul 2026 23:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784589022;
	bh=M3MtWJZSklhPlTtzTHopqYLm04kPzETdPRQm8KebIBU=;
	h=Date:To:From:Subject;
	b=b8iZXgqeGVBONvKsAbbj+A1PVNfCEFqjnKL19iHbBtB/X9P5vnOd3XbniZDCDXCnw
	 C37AIp99kB1FeYXBfi/ElyeKMh39TOemM5prb4QGlf1r7M2662liurSNEXlE5vBN0V
	 eek8F3x2zNxHlctRJD98Z1VnLSN6Rd6OGcBHHHtI=
Date: Mon, 20 Jul 2026 16:10:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,willy@infradead.org,wangkefeng.wang@huawei.com,svetly.todorov@memverge.com,sunnanyong@huawei.com,luizcap@redhat.com,linmiaohe@huawei.com,david@kernel.org,chengming.zhou@linux.dev,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-stable_page_flags-simplify-kpf_idle-handling.patch added to mm-new branch
Message-Id: <20260720231022.476601F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: stable_page_flags(): simplify KPF_IDLE handling
has been added to the -mm mm-new branch.  Its filename is
     fs-stable_page_flags-simplify-kpf_idle-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-stable_page_flags-simplify-kpf_idle-handling.patch

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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: fs: stable_page_flags(): simplify KPF_IDLE handling
Date: Mon, 20 Jul 2026 11:30:21 +0800

For KPF_IDLE, folio_test_idle() check in set_ps_flags() already handles
all config cases, so remove the duplicate code in stable_page_flags() that
deals with CONFIG_PAGE_IDLE_FLAG for the 64‑bit case.

No functional change is intended.

Link: https://lore.kernel.org/20260720033021.4091944-4-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Svetly Todorov <svetly.todorov@memverge.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/fs/proc/page.c~fs-stable_page_flags-simplify-kpf_idle-handling
+++ a/fs/proc/page.c
@@ -196,6 +196,9 @@ u64 stable_page_flags(const struct page
 	if (ps.flags & PAGE_SNAPSHOT_PG_BUDDY)
 		u |= BIT_ULL(KPF_BUDDY);
 
+	if (ps.flags & PAGE_SNAPSHOT_PG_IDLE)
+		u |= BIT_ULL(KPF_IDLE);
+
 	if (folio_test_offline(folio))
 		u |= BIT_ULL(KPF_OFFLINE);
 	if (folio_test_pgtable(folio))
@@ -203,13 +206,6 @@ u64 stable_page_flags(const struct page
 	if (folio_test_slab(folio))
 		u |= BIT_ULL(KPF_SLAB);
 
-#if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
-	u |= kpf_copy_bit(k, KPF_IDLE,          PG_idle);
-#else
-	if (ps.flags & PAGE_SNAPSHOT_PG_IDLE)
-		u |= BIT_ULL(KPF_IDLE);
-#endif
-
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
 	u |= kpf_copy_bit(k, KPF_DIRTY,		PG_dirty);
 	u |= kpf_copy_bit(k, KPF_UPTODATE,	PG_uptodate);
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

fs-stable_page_flags-use-bit_ull-for-kpf-flags.patch
fs-stable_page_flags-use-folio_test_-helpers.patch
fs-stable_page_flags-simplify-kpf_idle-handling.patch

