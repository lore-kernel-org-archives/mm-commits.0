Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455EEDDD2
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337153; cv=none; b=CZSq20CBruejHum0Jpel+tKgeD9YVFXgtsvfwm9RZM4Ptp25MhjE1g3DdYNNUE3XlLNCV6sTFNktk0elvwbXCCB4oszfTo8osAl0MGeTBTy0mFPmZA/M5EKewJwqbn/1/sXyK5+kTVsfi4KSB2RkkckHt1aKxGbKkiEEJSUdn8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337153; c=relaxed/simple;
	bh=+aTonNAH+Iah6YNxLTLirCPu0siLLqSj04sgAXjfU6o=;
	h=Date:To:From:Subject:Message-Id; b=OophcKaPPFTls9fVilqgAnqyhRBdDWC3VdluPR3jdetJpR2fYgYPiRrw3waxfTRW4K0SXmPUla25SSmr6TY+mqA2XnVwN08c89UVV8KG0CCeXu19BgSTwACvRcmojn8BeHMhfpd63dgOycjBaf8Z8pCTkOOkjQtyvwjhKV8ytQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rtyA5X7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtyA5X7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9644C4CED6;
	Mon, 20 Jan 2025 01:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337152;
	bh=+aTonNAH+Iah6YNxLTLirCPu0siLLqSj04sgAXjfU6o=;
	h=Date:To:From:Subject:From;
	b=rtyA5X7TljJr79gdJN2G8pk8rPb0Aj90dyZgj2veoyLGgABIKwmlRNFTp17n03wWr
	 T9c2zHX+TBoU+4ssnX/HeIwGEuFggPkjrnh+XLtRMcjotbsv9iwK5TkkiaubHdBTjC
	 178wlJZVeaDL/yHw0IW0Dtk8hbvrQTVlW61dVr/U=
Date: Sun, 19 Jan 2025 17:39:12 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-call-filemap_fdatawrite_range_kick-after-iocb_dontcache-issue.patch removed from -mm tree
Message-Id: <20250120013912.A9644C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: call filemap_fdatawrite_range_kick() after IOCB_DONTCACHE issue
has been removed from the -mm tree.  Its filename was
     mm-call-filemap_fdatawrite_range_kick-after-iocb_dontcache-issue.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jens Axboe <axboe@kernel.dk>
Subject: mm: call filemap_fdatawrite_range_kick() after IOCB_DONTCACHE issue
Date: Fri, 20 Dec 2024 08:47:49 -0700

When a buffered write submitted with IOCB_DONTCACHE has been successfully
submitted, call filemap_fdatawrite_range_kick() to kick off the IO.  File
systems call generic_write_sync() for any successful buffered write
submission, hence add the logic here rather than needing to modify the
file system.

Link: https://lkml.kernel.org/r/20241220154831.1086649-12-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Chris Mason <clm@meta.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/fs.h~mm-call-filemap_fdatawrite_range_kick-after-iocb_dontcache-issue
+++ a/include/linux/fs.h
@@ -2912,6 +2912,11 @@ static inline ssize_t generic_write_sync
 				(iocb->ki_flags & IOCB_SYNC) ? 0 : 1);
 		if (ret)
 			return ret;
+	} else if (iocb->ki_flags & IOCB_DONTCACHE) {
+		struct address_space *mapping = iocb->ki_filp->f_mapping;
+
+		filemap_fdatawrite_range_kick(mapping, iocb->ki_pos,
+					      iocb->ki_pos + count);
 	}
 
 	return count;
_

Patches currently in -mm which might be from axboe@kernel.dk are


