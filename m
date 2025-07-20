Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833193C463;
	Sun, 20 Jul 2025 00:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752971704; cv=none; b=CZwQgQY26e4juosrIdjorng043RsLvMh9NDZjkwrzM7XVklXvpx3Kn6gPIqeSytgodwM1DqF8GOcP7tP+P0tnu7V6Z/GYkRcvm00RWYxWjDC1cIrc4xkJN1xO5JU/RAZts0fxtIuyX9duoMPmYm0aowxu262WZ2s4Qebm/aqNpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752971704; c=relaxed/simple;
	bh=MqOds7hJME7C7SPLSM/qwETiVGHBcTbsr/R/f4eZFso=;
	h=Date:To:From:Subject:Message-Id; b=rXbxrcW0xTp5mVp7WWTNdZPIOsbs1k9YlPX7RE6u8tuJ6qTlIeP8BX7QTZWIDreRz1mt4P8vtelV+kRTRZM1vZh207nk6wPw9DH+ejsTUu4u1Bqs0KO25Fz0Ijd9ca0fIIgK8WvvKQS8iRpzPTZqLT5lvmZEpo4NzfgDfRVWQJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r2D3NrEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r2D3NrEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF97C4CEE3;
	Sun, 20 Jul 2025 00:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752971704;
	bh=MqOds7hJME7C7SPLSM/qwETiVGHBcTbsr/R/f4eZFso=;
	h=Date:To:From:Subject:From;
	b=r2D3NrEy/K7vsOASMS3QyUbpCcgpLyGpMp6u/ls/edKBBTNdSLpQkyj5t/MVEWbfW
	 TBx6+S0xJkrrpSmrRKBFjpgAGb/Nv8WWMOW0qkBUC5x6C9mOh8k2QXtfp03fVQh4V0
	 MoNtJRNS6RfMpozYp8f8dzy0GYGCmpjSupquv7vo=
Date: Sat, 19 Jul 2025 17:35:03 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kasong@tencent.com,hannes@cmpxchg.org,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop-fix.patch added to mm-new branch
Message-Id: <20250720003503.DFF97C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: correctly use maxpages in swapon syscall to avoid potential deadloop
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop-fix.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: correctly use maxpages in swapon syscall to avoid potential deadloop
Date: Fri, 18 Jul 2025 14:51:39 +0800

ensure si->pages == si->max - 1 after setup_swap_extents()

Link: https://lkml.kernel.org/r/20250522122554.12209-3-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20250718065139.61989-1-shikemeng@huaweicloud.com
Fixes: 661383c6111a ("mm: swap: relaim the cached parts that got scanned")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/swapfile.c~mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop-fix
+++ a/mm/swapfile.c
@@ -3357,6 +3357,12 @@ SYSCALL_DEFINE2(swapon, const char __use
 		error = nr_extents;
 		goto bad_swap_unlock_inode;
 	}
+	if (si->pages != si->max - 1) {
+		pr_err("swap:%u != (max:%u - 1)\n", si->pages, si->max);
+		error = -EINVAL;
+		goto bad_swap_unlock_inode;
+	}
+
 	maxpages = si->max;
 
 	/* OK, set up the swap map and apply the bad block list */
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc.patch
mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch
mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop-fix.patch
mm-swap-fix-potensial-buffer-overflow-in-setup_clusters.patch
mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry.patch

