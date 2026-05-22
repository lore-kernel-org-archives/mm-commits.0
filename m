Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C5F26B742
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 00:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779411505; cv=none; b=mgi/Q35m6L/S/m6T3MaQUAGKQidNqREvbdMivsAR9swx4w9ElUS5QRaY75UJ4Zn12I6BlYJyjvOitjrpEJwdB9AJNp3Ns+yVjDDXqo8GZwiit+w6VFz2VegvCQ981NNm1CmkOnk3BREgYshyXdkIG1hJGWarHaFLxa0IY0LkChE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779411505; c=relaxed/simple;
	bh=7opPWiZNN2lyraWKQRGtiw0pd7+1CCcxuL0pPPiWetQ=;
	h=Date:To:From:Subject:Message-Id; b=jKMfjNaGR/sfzbljQ/0AzCjJodyUTdTkCUpRQv29TlpwP62US8oQgJRTLlimkLRK/GFLkF57Xbxg3epexky1m076NcPY53CQWA60Y7ZmY170qm98sbfUf2BRAuhE1taBEvilnBvmyWnSJP43HECdYBmIRCEETuupM9KODneQFzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jPm5/a1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jPm5/a1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06C51F000E9;
	Fri, 22 May 2026 00:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779411504;
	bh=PHtLDuPF08s9gMGspIFdXomxe+toVUlOR0/gcFA2dF8=;
	h=Date:To:From:Subject;
	b=jPm5/a1tNvg0qdL+NURGiIuH+63qHSPkk+Hx2xWRIqzpo9SUi+XdVo3+fRhbw1RBo
	 G8deTwLiyExgDEVjBpBnHgj1YfG4SSI2OyzqmTnHLQeSkhHN65SONsqAJZnHJOtt9g
	 3w5ayt/Pug17R8daM9+MDxlF2km6J8s3xyMLnx9U=
Date: Thu, 21 May 2026 17:58:23 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,vbabka@kernel.org,surenb@google.com,ssh1326@icloud.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,niecheng1@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-clarify-next_intervals_tune_sis-update-path.patch added to mm-unstable branch
Message-Id: <20260522005823.E06C51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: clarify next_intervals_tune_sis update path
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-clarify-next_intervals_tune_sis-update-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-clarify-next_intervals_tune_sis-update-path.patch

This patch will later appear in the mm-unstable branch at
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
From: niecheng <niecheng1@uniontech.com>
Subject: mm/damon/core: clarify next_intervals_tune_sis update path
Date: Tue, 19 May 2026 18:20:59 -0700

Patch series "mm/damon: documentation and comment fixes".


This patch (of 3):

damon_set_attrs() updates next_aggregation_sis and next_ops_update_sis for
online attrs updates, but it does not update next_intervals_tune_sis
there.

This can look like a missing update when reading damon_set_attrs() alone,
while next_intervals_tune_sis is actually updated in kdamond_fn().

Add a short comment to make this explicit.

Link: https://lore.kernel.org/20260520012104.93602-1-sj@kernel.org
Link: https://lore.kernel.org/20260520012104.93602-2-sj@kernel.org
Suggested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: niecheng <niecheng1@uniontech.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Sakurai Shun <ssh1326@icloud.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-clarify-next_intervals_tune_sis-update-path
+++ a/mm/damon/core.c
@@ -909,6 +909,9 @@ int damon_set_attrs(struct damon_ctx *ct
 		attrs->aggr_interval / sample_interval;
 	ctx->next_ops_update_sis = ctx->passed_sample_intervals +
 		attrs->ops_update_interval / sample_interval;
+	/*
+	 * next_intervals_tune_sis will be updated inside kdamond_fn().
+	 */
 
 	damon_update_monitoring_results(ctx, attrs, aggregating);
 	ctx->attrs = *attrs;
_

Patches currently in -mm which might be from niecheng1@uniontech.com are

mm-damon-core-clarify-next_intervals_tune_sis-update-path.patch

