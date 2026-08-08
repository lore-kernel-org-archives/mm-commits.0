Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1690175A88
	for <mm-commits@vger.kernel.org>; Sat,  8 Aug 2026 17:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786211446; cv=none; b=TTYq+gmdB002cTJDj6r9mjEgfxAagSPxy2bNAmB9WU4eYsEMxDOxzmzPLZ4Q6VaFle4DUSQ1I/JNeavmaLMgCWPh6yjGxyhyT3e/6XY1UpecuI1ppCXIJicFapdvhzPtQy2/oHepGuOSI3ILMFoqwmhHnEnK6/drGAT6XQfZt34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786211446; c=relaxed/simple;
	bh=U++4T22Gd/gMpapoGcFm/EzwoZ29/yix1al/YaMW6Bc=;
	h=Date:To:From:Subject:Message-Id; b=HNjUkHwo+LBbL/Mz9vX31KVV/Ye3c2iNRw9+q9mEzZha9lWh465nLrDck1I//XR88FWdxwdleUi660zH6OeCm9V7N4fqwCz8tOTWIXKIaUhKOGyhZXuyqdMGp8bEbCQzPyiLgMFx7gr80UF1Z5iDHkbq47g98lDnkHAAdSHUQFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sENuG+Xf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sENuG+Xf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5020C1F000E9;
	Sat,  8 Aug 2026 17:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786211445;
	bh=u49k/sO8KMvlQ7NxLY1zajMSExPkwtGS/AxhKsrBsaE=;
	h=Date:To:From:Subject;
	b=sENuG+XfXZ1l7jQkd70tEil2Mx+JMnOcky0zhGPsj+C595CSgPWNSbCq62cPbumh2
	 W3xK6oQePBd2MLotQkbtFZ86JIARiIpxzeSTofIkPRy+RozDKaugpvZ+8XctR/47R2
	 QoUmUQCBcP4oD85jZYwhOZEDsNmJ+Xjsev+IVV1Q=
Date: Sat, 08 Aug 2026 10:50:44 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-interval_tree-fix-allocation-warning-messages.patch added to mm-nonmm-unstable branch
Message-Id: <20260808175045.5020C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/interval_tree: fix allocation warning messages
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-interval_tree-fix-allocation-warning-messages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-interval_tree-fix-allocation-warning-messages.patch

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
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: lib/interval_tree: fix allocation warning messages
Date: Sat, 8 Aug 2026 14:36:08 +0200

WARN_ON_ONCE() takes a condition, not a message.  The string literals are
always true, so the warnings still trigger but the messages are never
printed.

Use WARN_ONCE(1, ...) instead to print the messages and keep the once-only
behavior.

Found with a Coccinelle script.  Clang's -Wstring-conversion also flags
such calls but is not enabled in kernel builds.

Link: https://lore.kernel.org/20260808123608.73613-1-kmehltretter@gmail.com
Fixes: 82114e45131f ("lib/interval_tree: add test case for interval_tree_iter_xxx() helpers")
Assisted-by: Claude:claude-fable-5 coccinelle
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/interval_tree_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/interval_tree_test.c~lib-interval_tree-fix-allocation-warning-messages
+++ a/lib/interval_tree_test.c
@@ -140,13 +140,13 @@ static int intersection_range_check(void
 
 	intxn1 = bitmap_alloc(nnodes, GFP_KERNEL);
 	if (!intxn1) {
-		WARN_ON_ONCE("Failed to allocate intxn1\n");
+		WARN_ONCE(1, "Failed to allocate intxn1\n");
 		return -ENOMEM;
 	}
 
 	intxn2 = bitmap_alloc(nnodes, GFP_KERNEL);
 	if (!intxn2) {
-		WARN_ON_ONCE("Failed to allocate intxn2\n");
+		WARN_ONCE(1, "Failed to allocate intxn2\n");
 		bitmap_free(intxn1);
 		return -ENOMEM;
 	}
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

lib-interval_tree-fix-allocation-warning-messages.patch

