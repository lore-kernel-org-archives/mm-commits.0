Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF462153E0
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188248; cv=none; b=stSbjqGWIT9F3JaIo/iszVjHWUv1f5YT5xAG9NlBT5FOBjNCSFkc4Cmbjijl2+ve508QZpQ83ZxJtQbpd2RkbDpsP8Mrlvs0kEpw/I2khMF8kRZ/eJ5GlHT9GUtw+epZLTI9/Dixrq1l+Za+3HKKBMn9LXXdKOhTwpC1RvgM0G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188248; c=relaxed/simple;
	bh=nXQUDm4V71UKHQ1qK+X1P6SL8KK7E6UUyM2okLRJyWo=;
	h=Date:To:From:Subject:Message-Id; b=mQKug3iv7BPI6YmoMZLxhBHpito28d55GibelnxxSchOZ69ATPhJO3MN1333cLohd/zIcd4RIG0UpQuh4eyYyG+pi2tdzPpJfaWMpWV4qWp/vQd8smggClMdrhXq65A+NATqY6wUqUZ2+QT+VCh2hBLMD1Zjwj4y5iZuNCVZku0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=INP1fjwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="INP1fjwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B155CC4CEED;
	Mon, 17 Mar 2025 05:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188247;
	bh=nXQUDm4V71UKHQ1qK+X1P6SL8KK7E6UUyM2okLRJyWo=;
	h=Date:To:From:Subject:From;
	b=INP1fjwGt4YCJIVHRf65CBV74JhNOJn8PMWge2M73Z9Eh+n6wjhGv9vZbu9rY/zvj
	 NVDllTU1bweSXfcMm+9E43t7yTGDLVujNDE71ItCcgO6FbgSw3oeCiPZRnlaPTnEfM
	 dIzevZysODZw8rKtjzYYOmpTRhTXU5YvC0J82tDc=
Date: Sun, 16 Mar 2025 22:10:47 -0700
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfilec-remove-the-incorrect-code-comment.patch removed from -mm tree
Message-Id: <20250317051047.B155CC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swapfile.c: remove the incorrect code comment
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-remove-the-incorrect-code-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/swapfile.c: remove the incorrect code comment
Date: Wed, 5 Feb 2025 17:27:20 +0800

Since commit eb085574a752 ("mm, swap: fix race between swapoff and some
swap operations"), the non_swap_entry() checking has been taken off from
function __swap_duplicate().  Hence, in the kernel-doc comment, the line
'swp_entry is migration entry -> EINVAL' is obsolete.  Remove that line to
avoid misleading people.

Link: https://lkml.kernel.org/r/20250205092721.9395-12-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfilec-remove-the-incorrect-code-comment
+++ a/mm/swapfile.c
@@ -3529,7 +3529,6 @@ void si_swapinfo(struct sysinfo *val)
  * Returns error code in following case.
  * - success -> 0
  * - swp_entry is invalid -> EINVAL
- * - swp_entry is migration entry -> EINVAL
  * - swap-cache reference is requested but there is already one. -> EEXIST
  * - swap-cache reference is requested but the entry is not used. -> ENOENT
  * - swap-mapped reference requested but needs continued swap count. -> ENOMEM
_

Patches currently in -mm which might be from bhe@redhat.com are


