Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FC928469F
	for <mm-commits@vger.kernel.org>; Fri, 20 Mar 2026 17:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774029201; cv=pass; b=k5EkzbiQ36+L4serDP5E9A5IFGhLVkTf8uu007lrN+yN4/w9iIvXgaSsIx5MtFiVqWMVd+vgY2BB+JJgQwWkFOAEwCc86D3wYQVKVWfJSxlsDDJ4+61NpIKnaW5+2wEIXLYvPkcDa6qJRScnRihXTRYX+9BQuVLPE2+I6j0qErI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774029201; c=relaxed/simple;
	bh=Bi5bqGG1mocqvW4yD/gALw1e2k+QYA95gFQduDTuuZQ=;
	h=Date:From:To:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=BKsMIloQqPj7iAalMa8Vi5zPw/8ZlbU69ym4nmYDZbJD8qkStrko2BolEHxaPQ/+5MeYrT/0BIiG9vdgqeFkAsZm5Oz1Z9vGXhClOJzj3hyUcIDvBSxBrkaOLYWc93V23ZrSa4rb6e6hXkG45Y5UyzF6ru8Ef4Q21uIZEMqxB54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=objecting.org; spf=pass smtp.mailfrom=objecting.org; dkim=pass (1024-bit key) header.d=objecting.org header.i=objecting@objecting.org header.b=ELhyagMN; arc=pass smtp.client-ip=136.143.169.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=objecting.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=objecting.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=objecting.org header.i=objecting@objecting.org header.b="ELhyagMN"
ARC-Seal: i=1; a=rsa-sha256; t=1774029185; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=hZpzRKbfGE7jpdGg2WQ7tiFK2nJXnVJ+E6Wl6FfPLBNCmMyywnnsEr4OQ7R2XKx5ppqjKa5mX7JJUoq8slRuFTeMmy3nLBRXSI7Oepn2vIbW3CMhOMlcbu1x4pYsO030f6ibDfTgz0qsowBBcGrOb0VSk/zhfi0Sx4kAjllmadU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774029185; h=Content-Type:Content-Transfer-Encoding:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=fUytztU1fMgElDyZOR/T1ocfkxlT+Ud2vknKS5cRr1E=; 
	b=DP40P/7lxTNWczRyzyM4Df+9WLWGhcO2m1Z4KXgnd6cBY/9bvZhR6VlstmMqihQtvB/Y+3GMy0GCh+sGc0vH6hj59wbDbg+rFHIZ6kHP74S1S/k1Bv14jvhbsW1/KkHgVYn/QxzVVWkzgpToEH9/vfHmIWju2dZTzuvbpnSjHHw=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774029185;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=fUytztU1fMgElDyZOR/T1ocfkxlT+Ud2vknKS5cRr1E=;
	b=ELhyagMN/z9wdMbe5I55f0L2Fa5l9VW5+s2gMxtkab2WekhJ+152DWKOxXwjWQyI
	4RkVVvpjqWAmwdKz7Q9rPxHSfrHurf4ICl4zwH6b3xq3yEe2Yr8YQs/MDZ4gBi5dme+
	Vkfzojr2bBmIdQRi6bKylMimncmrsF2gg2giLa1U=
Received: by mx.zoho.eu with SMTPS id 1774029182796491.7620112239116;
	Fri, 20 Mar 2026 18:53:02 +0100 (CET)
Date: Fri, 20 Mar 2026 17:53:01 +0000
From: Josh Law <objecting@objecting.org>
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 sj@kernel.org, akpm@linux-foundation.org
Subject: =?US-ASCII?Q?Re=3A_+_mm-damon-core-document-damos=5Fcommit=5Fdests?=
 =?US-ASCII?Q?-failure-semantics=2Epatch_added_to_mm-new_branch?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260320175026.1FF21C4CEF7@smtp.kernel.org>
References: <20260320175026.1FF21C4CEF7@smtp.kernel.org>
Message-ID: <9C933CBE-7643-4F87-B222-891ACE12C7E1@objecting.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External



On 20 March 2026 17:50:25 GMT, Andrew Morton <akpm@linux-foundation=2Eorg>=
 wrote:
>
>The patch titled
>     Subject: mm/damon/core: document damos_commit_dests() failure semant=
ics
>has been added to the -mm mm-new branch=2E  Its filename is
>     mm-damon-core-document-damos_commit_dests-failure-semantics=2Epatch
>
>This patch will shortly appear at
>     https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/akpm/25-new=2Egi=
t/tree/patches/mm-damon-core-document-damos_commit_dests-failure-semantics=
=2Epatch
>
>This patch will later appear in the mm-new branch at
>    git://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/akpm/mm
>
>Note, mm-new is a provisional staging ground for work-in-progress
>patches, and acceptance into mm-new is a notification for others take
>notice and to finish up reviews=2E  Please do not hesitate to respond to
>review feedback and post updated versions to replace or incrementally
>fixup patches in mm-new=2E
>
>The mm-new branch of mm=2Egit is not included in linux-next
>
>If a few days of testing in mm-new is successful, the patch will me moved
>into mm=2Egit's mm-unstable branch, which is included in linux-next
>
>Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>
>*** Remember to use Documentation/process/submit-checklist=2Erst when tes=
ting your code ***
>
>The -mm tree is included into linux-next via various
>branches at git://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/akpm/mm
>and is updated there most days
>
>------------------------------------------------------
>From: Josh Law <objecting@objecting=2Eorg>
>Subject: mm/damon/core: document damos_commit_dests() failure semantics
>Date: Fri, 20 Mar 2026 07:36:45 -0700
>
>Add a kernel-doc-like comment to damos_commit_dests() documenting its
>allocation failure contract: on -ENOMEM, the destination structure is lef=
t
>in a partially torn-down state that is safe to deallocate via
>damon_destroy_scheme(), but must not be reused for further commits=2E
>
>This was unclear from the code alone and led to a separate patch [1]
>attempting to reset nr_dests on failure=2E  Make the intended usage expli=
cit
>so future readers do not repeat the confusion=2E
>
>Link: https://lkml=2Ekernel=2Eorg/r/20260320143648=2E91673-1-sj@kernel=2E=
org
>Link: https://lore=2Ekernel=2Eorg/20260318214939=2E36100-1-objecting@obje=
cting=2Eorg [1]
>Signed-off-by: Josh Law <objecting@objecting=2Eorg>
>Cc: Andrew Morton <akpm@linux-foundation=2Eorg>
>Reviewed-by: SeongJae Park <sj@kernel=2Eorg>
>Signed-off-by: SeongJae Park <sj@kernel=2Eorg>
>Signed-off-by: Andrew Morton <akpm@linux-foundation=2Eorg>
>---
>
> mm/damon/core=2Ec |   17 +++++++++++++++++
> 1 file changed, 17 insertions(+)
>
>--- a/mm/damon/core=2Ec~mm-damon-core-document-damos_commit_dests-failure=
-semantics
>+++ a/mm/damon/core=2Ec
>@@ -1060,6 +1060,23 @@ static void damos_set_filters_default_re
> 		damos_filters_default_reject(&s->ops_filters);
> }
>=20
>+/*
>+ * damos_commit_dests() - Copy migration destinations from @src to @dst=
=2E
>+ * @dst:	Destination structure to update=2E
>+ * @src:	Source structure to copy from=2E
>+ *
>+ * If the number of destinations has changed, the old arrays in @dst are=
 freed
>+ * and new ones are allocated=2E  On success, @dst contains a full copy =
of
>+ * @src's arrays and count=2E
>+ *
>+ * On allocation failure, @dst is left in a partially torn-down state: i=
ts
>+ * arrays may be NULL and @nr_dests may not reflect the actual allocatio=
n
>+ * sizes=2E  The structure remains safe to deallocate via damon_destroy_=
scheme(),
>+ * but callers must not reuse @dst for further commits =EF=BF=BD=EF=BF=
=BD=EF=BF=BD it should be
>+ * discarded=2E
>+ *
>+ * Return: 0 on success, -ENOMEM on allocation failure=2E
>+ */
> static int damos_commit_dests(struct damos_migrate_dests *dst,
> 		struct damos_migrate_dests *src)
> {
>_
>
>Patches currently in -mm which might be from objecting@objecting=2Eorg ar=
e
>
>lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call=2Epatch
>mm-damon-core-document-damos_commit_dests-failure-semantics=2Epatch
>lib-glob-fix-grammar-and-replace-non-inclusive-terminology=2Epatch
>lib-glob-add-explicit-include-for-exporth=2Epatch
>lib-glob-replace-bitwise-or-with-logical-operation-on-boolean=2Epatch
>lib-glob-clean-up-bool-abuse-in-pointer-arithmetic=2Epatch
>lib-uuid-fix-typo-reversion-to-revision-in-comment=2Epatch
>lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure=2Ep=
atch
>lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure=
=2Epatch
>lib-inflate-fix-grammar-in-comment-variable-to-variables=2Epatch
>lib-inflate-fix-typo-this-results-to-the-results-in-comment=2Epatch
>lib-bug-fix-inconsistent-capitalization-in-bug-message=2Epatch
>lib-bug-remove-unnecessary-variable-initializations=2Epatch
>lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries=2Epa=
tch
>lib-decompress_bunzip2-fix-32-bit-shift-undefined-behavior=2Epatch
>lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation=2Epatch
>lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation=2Epatch
>lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning=2E=
patch
>lib-bch-fix-signed-left-shift-undefined-behavior=2Epatch
>lib-bch-fix-signed-shift-overflow-in-build_mod8_tables=2Epatch
>



Thanks Andrew for the merge!

V/R


Josh Law
