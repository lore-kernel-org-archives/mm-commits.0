Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BEF80028
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FedLjRQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045ECC433CA;
	Tue, 12 Dec 2023 18:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407590;
	bh=g2ubnVrFG6KwjBI/ZbS4lBHmDn5ER83h17Zvfv6ru9c=;
	h=Date:To:From:Subject:From;
	b=FedLjRQoLxRURrbbN92t8Jjon+QW47Lcils12NQCoqKN3spqE+uUcvnsvICtbK3Le
	 2ZkPdC++dpDEYg3Bv/Y8n147G4E8zAv94onLhbIwn0z1RmNPxto6mk8LFDfz7beZ2g
	 2KYcpf31n1OAj0KlW0COoLVGYfvXExDS6lwyMwLU=
Date: Tue, 12 Dec 2023 10:59:49 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,zeming@nfschina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-remove-unnecessary-iitialization-of-ret.patch removed from -mm tree
Message-Id: <20231212185950.045ECC433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: filemap: remove unnecessary iitialization of ret
has been removed from the -mm tree.  Its filename was
     mm-filemap-remove-unnecessary-iitialization-of-ret.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li zeming <zeming@nfschina.com>
Subject: mm: filemap: remove unnecessary iitialization of ret
Date: Tue, 5 Dec 2023 10:29:54 +0800

The ret variable can be defined without assigning a value, as it is
assigned before use.

Link: https://lkml.kernel.org/r/20231205022954.101045-1-zeming@nfschina.com
Signed-off-by: Li zeming <zeming@nfschina.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-remove-unnecessary-iitialization-of-ret
+++ a/mm/filemap.c
@@ -1623,7 +1623,7 @@ EXPORT_SYMBOL_GPL(__folio_lock_killable)
 static int __folio_lock_async(struct folio *folio, struct wait_page_queue *wait)
 {
 	struct wait_queue_head *q = folio_waitqueue(folio);
-	int ret = 0;
+	int ret;
 
 	wait->folio = folio;
 	wait->bit_nr = PG_locked;
_

Patches currently in -mm which might be from zeming@nfschina.com are


