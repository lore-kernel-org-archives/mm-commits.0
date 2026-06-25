Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374371D555
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 00:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782346323; cv=none; b=HA1lobiRWCTk6kbVMAIzOAF208tzm9HiZGnfVjl7syQlvD3JgwX4NsrS6MjIKSdXbUzvLC2LN02qh/s963jo1b7+OKVJnyroceWe7oANrhmJbp3Ymw4pREZaZkGXqaQ6WR7dWLFOc+JZw2+HEhcmVsiZuZhrmcVoVc/OxF4uJX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782346323; c=relaxed/simple;
	bh=ZBb8HiVpum7vCCEKgbS4A6tgWFPyVHciKAqXEce7HGI=;
	h=Date:To:From:Subject:Message-Id; b=QoKmhtehjlNHOpIC+cPH6ncQnSrVkpMZhgWABTo2LtroE1Y9mCzvlhvW1f2M0RG5TlXGo3gNJF/4nlEoo3wx9HTEV84Bf9P1Pb9sDVSNi0efIyQ/nt8YYIHd5pbJFgpV6UHOxEwkQBuo+epgv7GNscoDaYckcXETMhM4xjoAGFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wb4lhqB2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wb4lhqB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCC71F000E9;
	Thu, 25 Jun 2026 00:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782346321;
	bh=xesNNJZO21fWtnSqVWa+c27uEZ6I6STNoGciub7Rh9A=;
	h=Date:To:From:Subject;
	b=wb4lhqB28AaHI7iESW40fgxpSnN2WfODXBuxhCt3A/UQHjSR70jUi4oo8QtlNLrKC
	 JGyTn5XqzQ2Y3VUrQsoEdsXVc31YwsurOPuYW819G7B5xjeRFGYlC8czHsy/HStt4J
	 zHL3nZze9KoTElYE++xIw4IyMxC1mbWcthUCEM0s=
Date: Wed, 24 Jun 2026 17:12:01 -0700
To: mm-commits@vger.kernel.org,harry@kernel.org,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-remove-stray-text-from-obj_stock_pcp-comment.patch added to mm-new branch
Message-Id: <20260625001201.9DCC71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: remove stray text from obj_stock_pcp comment
has been added to the -mm mm-new branch.  Its filename is
     mm-memcg-remove-stray-text-from-obj_stock_pcp-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-remove-stray-text-from-obj_stock_pcp-comment.patch

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
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: mm: memcg: remove stray text from obj_stock_pcp comment
Date: Tue, 23 Jun 2026 16:26:14 +0800

A patch filename was accidentally inserted into the comment describing
the nr_bytes field of struct obj_stock_pcp. Remove it.

No functional change.

Link: https://lore.kernel.org/20260623082614.81621-1-guopeng.zhang@linux.dev
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-remove-stray-text-from-obj_stock_pcp-comment
+++ a/mm/memcontrol.c
@@ -2039,7 +2039,7 @@ struct obj_stock_pcp {
 	/*
 	 * On rare archs with 256KiB base page size (hexagon and powerpc 44x)
 	 * keep nr_bytes to unsigned int as uint16_t cannot represent the full
-e patches/memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch	 * sub-page remainder. Such archs are not cacheline optimization target.
+	 * sub-page remainder. Such archs are not cacheline optimization targets.
 	 */
 	unsigned int nr_bytes[NR_OBJ_STOCK];
 #else
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are

mm-memcg-remove-stray-text-from-obj_stock_pcp-comment.patch

