Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876E015A2
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ipKC0U44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9D3C433C8;
	Mon, 11 Dec 2023 00:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702255425;
	bh=To+t+HCCQBZi5WTk7rCV8PVqTaOWqct9o5KFSkgxYDk=;
	h=Date:To:From:Subject:From;
	b=ipKC0U44NLfuVyRJUrLDjOpeTjC1DmzaKwITyPbuUeljCqTN+N6ie576JvA8iaNJX
	 gaOhTDPdpgRPjBmX1ULA1RRyxZJzbSPbvYPsJDnrz6yjkq3Fbr7cKPfjNU2gnsjMZs
	 aEebt0MF1YNBHWtiPx8AmhynuXHEuLRpKTVZLV8o=
Date: Sun, 10 Dec 2023 16:43:44 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tytso@mit.edu,djwong@kernel.org,agruenba@redhat.com,adilger.kernel@dilger.ca,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-folio_fill_tail-and-use-it-in-iomap-fix.patch removed from -mm tree
Message-Id: <20231211004344.EC9D3C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-folio_fill_tail-and-use-it-in-iomap-fix
has been removed from the -mm tree.  Its filename was
     mm-add-folio_fill_tail-and-use-it-in-iomap-fix.patch

This patch was dropped because it was folded into mm-add-folio_fill_tail-and-use-it-in-iomap.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-folio_fill_tail-and-use-it-in-iomap-fix
Date: Thu Nov  9 02:42:04 PM PST 2023

fix folio_fill_tail(), per Andreas Gruenbacher

Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/highmem.h~mm-add-folio_fill_tail-and-use-it-in-iomap-fix
+++ a/include/linux/highmem.h
@@ -555,7 +555,7 @@ static inline void folio_fill_tail(struc
 	}
 
 	memcpy(to, from, len);
-	to = folio_zero_tail(folio, offset, to);
+	to = folio_zero_tail(folio, offset + len, to + len);
 	kunmap_local(to);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-add-folio_fill_tail-and-use-it-in-iomap.patch
mm-memcg-restore-subtree-stats-flushing-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch

