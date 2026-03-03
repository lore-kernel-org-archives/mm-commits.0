Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DEDA932
	for <mm-commits@vger.kernel.org>; Tue,  3 Mar 2026 00:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496868; cv=none; b=CeQKLRDWkhhBmbJcKkGsoaJYQ+QL70NXovklPwbo0wdHrKN70CZs3XbJR5OGP/uZnhsUIriGBXUWWTNRJnMko7Ns7qMONLqfEnh+GQ0QZxIvoWiek97XqyEihjq5m3hdldXa3h7jmPyFjSnrs9wn92DDStpO6USlnneUZzISQFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496868; c=relaxed/simple;
	bh=cZTfTopLRdVORjU7HE7y5upsgTmwBhU1QW/q0z61Om8=;
	h=Date:To:From:Subject:Message-Id; b=sOp+aqGKUQpGWSWbfZ/nlinX2R8Pjyf4k5qzdQUU0IOtQ2O42NcH6KgPQxBR3uEVdQDHLpfRcWVHHoRMRJYw/Baf8KFLqJpBLA9vPpYYoc2s5zdZs4vJYqYMSPT+fGiIdEjIF1QFkprbiDdCMfHzutYrK8gtCobfuACZAtHZvNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eZ5H65r1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eZ5H65r1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A76C19423;
	Tue,  3 Mar 2026 00:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772496868;
	bh=cZTfTopLRdVORjU7HE7y5upsgTmwBhU1QW/q0z61Om8=;
	h=Date:To:From:Subject:From;
	b=eZ5H65r1B4MRd5mINY62OAgUNfBrdj/RnuBEKmnyPuYj8/x/EfH1Epehw7xmcvnkn
	 anWQ12Ntzhp/gupc9RipFO2tlyOjzrspKzNs6nFO/osxyLHpqharQVQMIMTyaMBsWK
	 lInAecThzFB+C1NWvASZjkRkI4ELW6F2DYkg3Lig=
Date: Mon, 02 Mar 2026 16:14:27 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,peterx@redhat.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,dywoq.contact@gmail.com,david@kernel.org,aleks.koyf@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning.patch removed from -mm tree
Message-Id: <20260303001428.80A76C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: initialize 'seq' in gup_fast to remove -Wmaybe-uninitialized warning
has been removed from the -mm tree.  Its filename was
     mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Alexey Suchkov <aleks.koyf@gmail.com>
Subject: mm: initialize 'seq' in gup_fast to remove -Wmaybe-uninitialized warning
Date: Mon, 2 Mar 2026 22:34:05 +0300

The local variable 'seq' in gup_fast (mm/gup.c) was declared
without initialization which, with gcc-15.2.1 can trigger:

mm/gup.c:3165:20: warning: `seq' may be used uninitialized [-Wmaybe-uninitialized]

Work around this by initializing 'seq' to 0.  This does not change
behavior, since read_seqcount_retry() always writes to it before use.

Link: https://lkml.kernel.org/r/20260302193405.37961-1-dywoq.contact@gmail.com
Signed-off-by: Alexey Suchkov <dywoq.contact@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning
+++ a/mm/gup.c
@@ -3131,7 +3131,7 @@ static unsigned long gup_fast(unsigned l
 {
 	unsigned long flags;
 	int nr_pinned = 0;
-	unsigned seq;
+	unsigned int seq = 0;
 
 	if (!IS_ENABLED(CONFIG_HAVE_GUP_FAST) ||
 	    !gup_fast_permitted(start, end))
_

Patches currently in -mm which might be from aleks.koyf@gmail.com are


