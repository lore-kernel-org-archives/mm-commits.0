Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F33E2F4A
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 00:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753145158; cv=none; b=A2mSXv/lIpa71/7hiCaX1KukvTIinlcefy06g5UYUTl7XUV4HtLtQdyA0mNfYJkqxveHd93ZxZh+DLkWHsZu/hBk9Wbqd1bqeof3i8kIkfP0ptbI3otianONcbcuBF1zzDBvgHQaqKIdJmZo1isGgKyrg5xPqa78BaEObgjZWus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753145158; c=relaxed/simple;
	bh=OXQqRvq6OyKgBd8jVoYcY2+NcsU2vZWnuKYJI3VWxDE=;
	h=Date:To:From:Subject:Message-Id; b=BcPZocqoBXJ4ZTHSwLcOqih/d6lGmT2DGdGg6vUyhGomhL3fMP9eA3v/M7nxq+oeWTSW+Gqbt9BEnrhnS4zxX0vTikDZvQ+QXC/FoJtU7HG67icLWQutK6eC9Fz8DVDDm7VqKwWRgwArYJ40PKW4/VaqRIOvNsVdSQz24HvwSJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ugibQ4gs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ugibQ4gs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE50C4CEED;
	Tue, 22 Jul 2025 00:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753145158;
	bh=OXQqRvq6OyKgBd8jVoYcY2+NcsU2vZWnuKYJI3VWxDE=;
	h=Date:To:From:Subject:From;
	b=ugibQ4gsvD3b4jHtlEdwpOZDAjejqejC1TpPIW33rqjKNv0Uu+0o/87Z5mq3P7YlA
	 pVIRen7sBCFJK1aQp3WjnF7lCHLpt1XrXSz47Ad5eb/ViMHattUG7nzswLbJySeOiH
	 lcDL1xLz+Yw//QfSUTPECckB6198D68mnNwbXizw=
Date: Mon, 21 Jul 2025 17:45:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin-fix.patch added to mm-unstable branch
Message-Id: <20250722004557.DEE50C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin-fix
Date: Mon Jul 21 05:44:19 PM PDT 2025

fix fix to patch conflict

Link: https://lkml.kernel.org/r/CAMgjq7BDQ=o=g52HteVYcVzBhSOUjnC6WADeitqRDnGw_77D2Q@mail.gmail.com
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin-fix
+++ a/mm/shmem.c
@@ -2328,7 +2328,8 @@ static int shmem_swapin_folio(struct ino
 
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			/* Direct swapin skipping swap cache & readahead */
-			folio = shmem_swap_alloc_folio(inode, vma, index, swap, order, gfp);
+			folio = shmem_swap_alloc_folio(inode, vma, index,
+						       index_entry, order, gfp);
 			if (IS_ERR(folio)) {
 				error = PTR_ERR(folio);
 				folio = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix.patch
mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin-fix.patch
init-kconfig-restore-config_broken-help-text.patch

