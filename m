Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C7D2A1CA
	for <mm-commits@vger.kernel.org>; Tue,  6 Aug 2024 19:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722971305; cv=none; b=fjZDWs3BFcmu2BRu8hq0TKA5BDtpfnMyTO7JeH2K4ALN9ZA0NvL53j/ZCN7VIFeNNWrb95DyZYRsd5+8B1CCC4ZXV0SEJ53D+6wFo+mVsDxL160HVMghPgrkIB6EGQBkQxR+B/DEhBXDkEYwvIUE//NAOHnLUiYUNO/il2xApyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722971305; c=relaxed/simple;
	bh=FOTe2IyBLQWi/xQZ08nkX2fv2IQETPN2zz7iamtSaYY=;
	h=Date:To:From:Subject:Message-Id; b=FX091y70d1SeUgJ7FCl3R7yn2OqNHFQyQbFJ6jGVoUZv31K0J9xmciWzwCICbMJJNFtGDu6/woM0HWggC0NYudPPtgtkNj6bqXmz9QlGJUvfnrIwt8dsW8XUcGI9IsPVAxwuL4RtNtwltWm8tXz03++ISqWDOcVCkqnaP0Ru3Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q2iBxEUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q2iBxEUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C981DC32786;
	Tue,  6 Aug 2024 19:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722971304;
	bh=FOTe2IyBLQWi/xQZ08nkX2fv2IQETPN2zz7iamtSaYY=;
	h=Date:To:From:Subject:From;
	b=q2iBxEUjB2snOM1KaYCScrYik30gbagu06ccH2eJ1zf6gcoLdiA05NpUdzIfda/aW
	 zAbeXvFhrEMcMmSvROJZrBESSoO3zvN61jgjGcaC7MeWOvT8Un9i51uqJeq3KHJjGA
	 XPAlGigY9iDPHvS8+ffeQA30Aw1LQkPFk4XMOLuY=
Date: Tue, 06 Aug 2024 12:08:24 -0700
To: mm-commits@vger.kernel.org,mhocko@suse.com,herbert@gondor.apana.org.au,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-rhashtable-cleanup-fallback-check-in-bucket_table_alloc.patch added to mm-nonmm-unstable branch
Message-Id: <20240806190824.C981DC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/rhashtable: cleanup fallback check in bucket_table_alloc()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-rhashtable-cleanup-fallback-check-in-bucket_table_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-rhashtable-cleanup-fallback-check-in-bucket_table_alloc.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: lib/rhashtable: cleanup fallback check in bucket_table_alloc()
Date: Tue, 6 Aug 2024 08:39:27 -0700

Upon allocation failure, the current check with the nofail bits is
unnecessary, and further stands in the way of discouraging direct use of
__GFP_NOFAIL.  Remove this and replace with the proper way of determining
if doing a non-blocking allocation for the nested table case.

Link: https://lkml.kernel.org/r/20240806153927.184515-1-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rhashtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/rhashtable.c~lib-rhashtable-cleanup-fallback-check-in-bucket_table_alloc
+++ a/lib/rhashtable.c
@@ -189,7 +189,7 @@ static struct bucket_table *bucket_table
 
 	size = nbuckets;
 
-	if (tbl == NULL && (gfp & ~__GFP_NOFAIL) != GFP_KERNEL) {
+	if (tbl == NULL && !gfpflags_allow_blocking(gfp)) {
 		tbl = nested_bucket_table_alloc(ht, nbuckets, gfp);
 		nbuckets = 0;
 	}
_

Patches currently in -mm which might be from dave@stgolabs.net are

lib-rhashtable-cleanup-fallback-check-in-bucket_table_alloc.patch

