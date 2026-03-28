Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A96733557B
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671923; cv=none; b=rSJhOhsNsiJUDBpEGZR0r5re8iliSJCrRwPnRn6Rd4aMvMIhHJEnklj4sDrdqL43o78IQ2hT4UJJty0nCmgKPGKoTF7AVL5lkg3Pjk+nlG4oZSusnb1bQiR8c66V2vCBtTkGkzDd/R03bhNUXBa+Foj0929OBaNYGn8xugUsriI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671923; c=relaxed/simple;
	bh=kcHr2aOhakyXAxk+RPwwy7pZYK+4bymRMW2uvImXSFI=;
	h=Date:To:From:Subject:Message-Id; b=oWPdtbJgA2+6qTJJT0NZQiKI4Z1ensV8kHxaYMrPhDwPVStYlru2F6iu5pBqC7TkRzc00S4xmU6eT/ZO3/mR8cIY6F/ge6RpgCIEqIN2uZoDnVWnOg2NDw2pB+rmFOE9A+84iB/MMACy0AwNsUcxxPQZKSWyL48MoXpMB7mDCEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RQqhG3b7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RQqhG3b7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4267CC4CEF7;
	Sat, 28 Mar 2026 04:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671923;
	bh=kcHr2aOhakyXAxk+RPwwy7pZYK+4bymRMW2uvImXSFI=;
	h=Date:To:From:Subject:From;
	b=RQqhG3b7ew7JJxADJw/SfjbPpSMSrRLbkavSqB7+lELd0ym09Owuj0nTu5iYjSGnE
	 GwVR3EVfzhAmI0HrvwufFeWXPwmgSQlVKhjG3341fPMn9+Mep5+qqX3L+3eWu8DYi/
	 qkv1xWwCiyzyYtDBz2cZhLN/hmcqODIxdshDH58Q=
Date: Fri, 27 Mar 2026 21:25:22 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-uuid-fix-typo-reversion-to-revision-in-comment.patch removed from -mm tree
Message-Id: <20260328042523.4267CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/uuid: fix typo "reversion" to "revision" in comment
has been removed from the -mm tree.  Its filename was
     lib-uuid-fix-typo-reversion-to-revision-in-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib/uuid: fix typo "reversion" to "revision" in comment
Date: Fri, 6 Mar 2026 16:12:50 +0000

Fix a typo in __uuid_gen_common() where "reversion" (meaning to revert)
was used instead of "revision" when describing the UUID variant field.

Link: https://lkml.kernel.org/r/20260306161250.2811500-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/uuid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/uuid.c~lib-uuid-fix-typo-reversion-to-revision-in-comment
+++ a/lib/uuid.c
@@ -54,7 +54,7 @@ EXPORT_SYMBOL(generate_random_guid);
 static void __uuid_gen_common(__u8 b[16])
 {
 	get_random_bytes(b, 16);
-	/* reversion 0b10 */
+	/* revision 0b10 */
 	b[8] = (b[8] & 0x3F) | 0x80;
 }
 
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

