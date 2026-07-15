Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3B648124F
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 20:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784145849; cv=none; b=JgRVgIP8H67XJ/YZTzHVshPLdhSeAScCynQAIH780AEiXOUs3s/I5yJf/dXfiYRH5MR6zwCdJEuW6ivtkpbLYxNoTAwzNzzcVnwQgIx+bXHYH/6PcJt59OfwOgl6Wu0F0CLAdSzb0dvJLOzNpUmSiUsXZhoJETRjm0CiT94c+aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784145849; c=relaxed/simple;
	bh=Smfp0MFXoLetpL99AYoUV6epTJ2+Ma45PedungNTPvA=;
	h=Date:To:From:Subject:Message-Id; b=MUZsuRHyLukZIgwqY1h/eXncnFzVsgAJHtrepxu+c2z8ST+sOC2+HNZCLFV4Kxw62p9nKydA/UiQOP3q1bnetYs7ZyGqAYTtpTxAETsjaMmIS2A14E/FcgbODTTTaewSNSGkW+JqhsMVO3maZoMTBB18K3Kx6b8GldZ7BFf+1sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SSoqOg7T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SSoqOg7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441401F000E9;
	Wed, 15 Jul 2026 20:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784145845;
	bh=1TBLFkpfNjqdzXAVxIusI3j54QPs1QLYCbhIwcy1f0Q=;
	h=Date:To:From:Subject;
	b=SSoqOg7Tu8ewkBuU7NGD6pugBgCCbmqnPVqQhN7f9K+x11ZVkG791+OYbCGP3rhRP
	 RuezLkkFkfdI0Knlf0nncrzjHoNj8Fu3E8vk7SvRdckZBUKd5FTmXyc5TbyVyUXgp2
	 EyftPT5k7FAVD6xQYZC9DCu18kVQ9YeDjnGf4CJM=
Date: Wed, 15 Jul 2026 13:04:04 -0700
To: mm-commits@vger.kernel.org,ravi.n1@samsung.com,namjae.jeon@samsung.com,hirofumi@mail.parknet.co.jp,brauner@kernel.org,a.sahrawat@samsung.com,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-release-buffer-head-after-rebuilding-parent.patch added to mm-nonmm-unstable branch
Message-Id: <20260715200405.441401F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fat: release buffer head after rebuilding parent
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-release-buffer-head-after-rebuilding-parent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-release-buffer-head-after-rebuilding-parent.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Yichong Chen <chenyichong@uniontech.com>
Subject: fat: release buffer head after rebuilding parent
Date: Wed, 15 Jul 2026 10:09:57 +0800

fat_scan_logstart() leaves the matching directory entry's buffer head in
sinfo.bh for the caller to release, just like fat_scan().

fat_rebuild_parent() uses the directory entry to rebuild the parent inode
for the nostale_ro NFS export path, but does not release sinfo.bh after a
successful scan.  Release it once fat_build_inode() has consumed the
directory entry data.

Link: https://lore.kernel.org/20260715020957.1096309-1-chenyichong@uniontech.com
Fixes: f1e6fb0ab451 ("fat (exportfs): rebuild directory-inode if fat_dget()")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: chenyichong <chenyichong@uniontech.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/nfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/fat/nfs.c~fat-release-buffer-head-after-rebuilding-parent
+++ a/fs/fat/nfs.c
@@ -250,8 +250,10 @@ struct inode *fat_rebuild_parent(struct
 		MSDOS_I(dummy_grand_parent)->i_pos = -1;
 	}
 
-	if (!fat_scan_logstart(dummy_grand_parent, clus_to_match, &sinfo))
+	if (!fat_scan_logstart(dummy_grand_parent, clus_to_match, &sinfo)) {
 		parent = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
+		brelse(sinfo.bh);
+	}
 
 	brelse(parent_bh);
 	iput(dummy_grand_parent);
_

Patches currently in -mm which might be from chenyichong@uniontech.com are

tools-mm-page_owner_sort-return-explicit-filter-results.patch
tools-mm-page_owner_sort-free-per-record-allocations.patch
tools-mm-page_owner_sort-bound-pattern-output-copies.patch
fat-release-buffer-head-after-rebuilding-parent.patch

