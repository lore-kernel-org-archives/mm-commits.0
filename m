Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853EE7F55D
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cc+fHY7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471A3C433C7;
	Tue, 12 Dec 2023 18:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407540;
	bh=lFrH2rU4+dm9QPaKcgz4waBtvJPqEkb8jf0TGco8exI=;
	h=Date:To:From:Subject:From;
	b=Cc+fHY7AgBDWasbtKbxcTydotLD1QOflsRbeq1QHZT6F+5IGp+6fGEHaPPszfd5JG
	 /PFD+fXHZYpRRsSmwcuUVCubonDH1f0WXhyDEOAQPt3mu8iXeiPrpraDR0mYhXifj6
	 wCeL8Wh3L1bFRxyACMqzuMsLkXR9ktEoNfzSFPuQ=
Date: Tue, 12 Dec 2023 10:58:59 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-make-mas_erase-more-robust.patch removed from -mm tree
Message-Id: <20231212185900.471A3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: make mas_erase() more robust
has been removed from the -mm tree.  Its filename was
     maple_tree-make-mas_erase-more-robust.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: make mas_erase() more robust
Date: Wed, 1 Nov 2023 13:16:19 -0400

mas_erase() may not deal correctly with all maple states.  Make the
function more robust by ensuring the state is in one of the two acceptable
states.

Link: https://lkml.kernel.org/r/20231101171629.3612299-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-make-mas_erase-more-robust
+++ a/lib/maple_tree.c
@@ -6173,7 +6173,7 @@ void *mas_erase(struct ma_state *mas)
 	void *entry;
 	MA_WR_STATE(wr_mas, mas, NULL);
 
-	if (mas_is_none(mas) || mas_is_paused(mas))
+	if (!mas_is_active(mas) || !mas_is_start(mas))
 		mas->node = MAS_START;
 
 	/* Retry unnecessary when holding the write lock. */
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


