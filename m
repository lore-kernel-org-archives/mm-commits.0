Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DC23CCA19
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 23:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778715905; cv=none; b=hV1bBPeKU0rHsOGuIoaQDC/7qRA3EdAQMZhsVEPHQMEiFI16kME65vBQTyqTj1G3hlVwd92UpvDcmK5DanbrRWRne3QAO+ssPfPVLC7DXHScIdtcaEgwzLXbRZ06hjTslKqr1hTxUYkdMRauDNPS0xTiRggY+rKc0VZvkCgIw+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778715905; c=relaxed/simple;
	bh=H/OI68jVv58Pv4nRrRDE3oJJ5o8XlXibg3xjq9D9rXM=;
	h=Date:To:From:Subject:Message-Id; b=QOhnVl5GQ45k3VpKKDee+//yyZdXCesJ4iSFmXPOgvnTJioJfQoFaqZ7WvO7eC3cXe/+FF9quyFMp5Zz6Zd4P+whQTdMrmSSvpYcPev10ux1mMMm/DUQI9QpHDnvyncKTKDQ42T4eLJ6ywHOeVV5j8Z6qL0N2jMzxpZDa86SzWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=snhPAbk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="snhPAbk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B010EC19425;
	Wed, 13 May 2026 23:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778715904;
	bh=H/OI68jVv58Pv4nRrRDE3oJJ5o8XlXibg3xjq9D9rXM=;
	h=Date:To:From:Subject:From;
	b=snhPAbk4yzgUWa085KKFo3P8Nm0C3zhRXXGSPlazgGd7pmfBNulSeTnVcF08cwHku
	 Bnk0w8krRwI/RFU2vAsET/QqUuQbg4ekuMiiAemUZ3Squ/Ct+vvzW+jseIo9OE0dhT
	 zja9k83MqRGhQHAibGEcqAU5JgJdRchWUF2ONsHc=
Date: Wed, 13 May 2026 16:45:04 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-page-types-fix-kpageflags-option-argument-in-getopt_long.patch added to mm-new branch
Message-Id: <20260513234504.B010EC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/page-types: fix kpageflags option argument in getopt_long
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-page-types-fix-kpageflags-option-argument-in-getopt_long.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-page-types-fix-kpageflags-option-argument-in-getopt_long.patch

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
From: Ye Liu <liuye@kylinos.cn>
Subject: tools/mm/page-types: fix kpageflags option argument in getopt_long
Date: Wed, 13 May 2026 10:21:18 +0800

The --kpageflags option requires an argument to specify the kpageflags
file path, but has_arg was set to 0 (no_argument) in the long options
table.  Change it to 1 (required_argument) so getopt_long correctly parses
the argument.

Link: https://lore.kernel.org/20260513022120.58033-4-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page-types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/page-types.c~tools-mm-page-types-fix-kpageflags-option-argument-in-getopt_long
+++ a/tools/mm/page-types.c
@@ -1261,7 +1261,7 @@ static const struct option opts[] = {
 	{ "no-summary", 0, NULL, 'N' },
 	{ "hwpoison"  , 0, NULL, 'X' },
 	{ "unpoison"  , 0, NULL, 'x' },
-	{ "kpageflags", 0, NULL, 'F' },
+	{ "kpageflags", 1, NULL, 'F' },
 	{ "help"      , 0, NULL, 'h' },
 	{ NULL        , 0, NULL, 0 }
 };
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-memory-failure-use-bool-for-forcekill-state.patch
mm-khugepaged-use-align-helpers-for-pmd-alignment.patch
mm-khugepaged-fix-inconsistent-mmf_vm_hugepage-flag-due-to-allocation-failure-order.patch
tools-mm-page-types-fix-typo-in-madvise-error-message.patch
tools-mm-page-types-fix-ternary-operator-precedence-in-sigbus-handler.patch
tools-mm-page-types-fix-kpageflags-option-argument-in-getopt_long.patch

