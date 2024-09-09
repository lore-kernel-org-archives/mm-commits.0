Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80F773440
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925699; cv=none; b=Zc80anfll94Em58w7NBT2NDatIvdxt2Mis03LGfF6GnwV24LcSgtI4zrHDYjf1eu5RrVkbfHmSTTbjEvK+rP26f9N4OWfCRTiuhNFle3cC29WAzZUpk1NP4c9NLTkXHoJ6iU5sU/w7s0Dliz7l03aq06BDKLErUtEVD8DY4PPBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925699; c=relaxed/simple;
	bh=1uGbFx789XP2FY53Y2FM772Gc6NyMUq4oecvsF90Rvk=;
	h=Date:To:From:Subject:Message-Id; b=HD+xesZEZFtXJPK17cL2mivoDH4YmOmVVcv+Q4giBy5B98nOOGNym6PNIVEjU87H7z8CgOwEIVVY9aqAq2iJCBiVHNFJb1AijGI0wwe/byrNh+NgKi5t0cBFU2md5M/Jpn4xDo+9y++l/L0S+If5++TkLZOZhTUPSGsetD6m4fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xuVUAp8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xuVUAp8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4392BC4CEC5;
	Mon,  9 Sep 2024 23:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925699;
	bh=1uGbFx789XP2FY53Y2FM772Gc6NyMUq4oecvsF90Rvk=;
	h=Date:To:From:Subject:From;
	b=xuVUAp8Jj6kBLz3CxuWmoDUzRiZyTlS+YrLC37gTtu16YVw1pCohCd8Q33tvWyVSD
	 y3xxOGYp5BlPdv1f5orgdbNAuaI2pKglrH4BOXPcs2YRRUQn8u3eXDji9SAGcVlrtP
	 p0Dm7CyytMiyz4CiMeV+OhHqM8mUOc7JbUaf4eJg=
Date: Mon, 09 Sep 2024 16:48:18 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,chentao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-remove-duplicate-unlikely-usage.patch removed from -mm tree
Message-Id: <20240909234819.4392BC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: remove duplicate 'unlikely()' usage
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-duplicate-unlikely-usage.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kunwu Chan <chentao@kylinos.cn>
Subject: nilfs2: remove duplicate 'unlikely()' usage
Date: Wed, 4 Sep 2024 19:16:03 +0900

Nested unlikely() calls, IS_ERR already uses unlikely() internally

Link: https://lkml.kernel.org/r/20240904101618.17716-1-konishi.ryusuke@gmail.com
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/page.c~nilfs2-remove-duplicate-unlikely-usage
+++ a/fs/nilfs2/page.c
@@ -262,7 +262,7 @@ repeat:
 			NILFS_FOLIO_BUG(folio, "inconsistent dirty state");
 
 		dfolio = filemap_grab_folio(dmap, folio->index);
-		if (unlikely(IS_ERR(dfolio))) {
+		if (IS_ERR(dfolio)) {
 			/* No empty page is added to the page cache */
 			folio_unlock(folio);
 			err = PTR_ERR(dfolio);
_

Patches currently in -mm which might be from chentao@kylinos.cn are


