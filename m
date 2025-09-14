Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D1928E0F
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810105; cv=none; b=oLlim3Tq6qPzmc4GoA/bKZawYan8ZC3JgA5DJrbACRlvdZIoM/zRCGBw62PPqSOUNiEu40Ma4frMgvcqkXx7d2/dxAxyFGM7iBQKHSgGxeF9fOCvZU32kCQpGSZKrJi3Zq+498SpcGY9ydH5VPOcmmW0sv/u+UOVcKtdYUX9mGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810105; c=relaxed/simple;
	bh=n2CE0F2VtRQD2nCn5V1QCy0MXmvR9wjxI4YkvPnFbEc=;
	h=Date:To:From:Subject:Message-Id; b=jwuLSeLcBZr9Cwrns9qvNtXheHrI9vsZFQBirc3VL69f3puk+dz2pYs+bNpwajiOOU1jlKkG4FCHQZKEIyOg1gJXsmL5Htmsm+f8p4wtbqwhM48o9ryQ9GwBxbPztawPVspom2seGhI18g2fNCVoi+X822V6c+7XNkkqKOj04Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pt4vldQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pt4vldQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE5DC4CEEB;
	Sun, 14 Sep 2025 00:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810104;
	bh=n2CE0F2VtRQD2nCn5V1QCy0MXmvR9wjxI4YkvPnFbEc=;
	h=Date:To:From:Subject:From;
	b=pt4vldQSj4+5tLPU4AoaIryOBP7TWZh49L85Vj5FJYH/EFjoXxDEwWcVcpmKUwSQc
	 +9k6edR9UyaVz7oLx5vPx0Zyz9yU+hd7fybepyNxRiPhZRaEb7c18ujMOHMfEilj0h
	 AQELHB/wzSgLoO/BIBVmAnE1TwPL1J+2UfUQdFME=
Date: Sat, 13 Sep 2025 17:35:04 -0700
To: mm-commits@vger.kernel.org,liaoyuanhong@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-digsig-remove-unnecessary-memset.patch removed from -mm tree
Message-Id: <20250914003504.8BE5DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/digsig: remove unnecessary memset
has been removed from the -mm tree.  Its filename was
     lib-digsig-remove-unnecessary-memset.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: lib/digsig: remove unnecessary memset
Date: Mon, 11 Aug 2025 16:27:38 +0800

kzalloc() has already been initialized to full 0 space, there is no need
to use memset() to initialize again.

Link: https://lkml.kernel.org/r/20250811082739.378284-1-liaoyuanhong@vivo.com
Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/digsig.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/digsig.c~lib-digsig-remove-unnecessary-memset
+++ a/lib/digsig.c
@@ -159,7 +159,6 @@ static int digsig_verify_rsa(struct key
 
 	len = mlen;
 	head = len - l;
-	memset(out1, 0, head);
 	memcpy(out1 + head, p, l);
 
 	kfree(p);
_

Patches currently in -mm which might be from liaoyuanhong@vivo.com are


