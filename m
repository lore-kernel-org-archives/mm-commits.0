Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6542E1586FE
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742203; cv=none; b=eyFFikKphg4vJhpc7VUCCXLXsgO5TNwJwqkyAjq421jGd2w1E35bov1DeaIUDGPZ3U0fbz9QUrGhZerawmkdqdb+D2Z7UtIxXGH7kiAe6AAQ9CS85L2OtRTDysqM65d/IfDUDYxzkuywSyPHGbjg4mwyvrzRpjuDVZ04ksy0bZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742203; c=relaxed/simple;
	bh=K6eTOo6qMLS6NnzUBhaUM0SQ9mJJe9BIdD/fUwMWU+E=;
	h=Date:To:From:Subject:Message-Id; b=YV48Ya01d3mP8ofo6sSVe77+NcmSqi+fI2fpE+3j8kd1Gopl3zGRTynOHcBQqGYv9OOtafyjlttMLlVZq0p3hAFTd+tKH7yZ8f3UfG6ihw+oPhoC7ccTr3Wqngv/giVma2K4JtYi1Ui6lhJhzHHB8Mnkt8B//uY3NwKZAK1svAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZtHRhBU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZtHRhBU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EC6C4CED6;
	Mon, 13 Jan 2025 04:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742203;
	bh=K6eTOo6qMLS6NnzUBhaUM0SQ9mJJe9BIdD/fUwMWU+E=;
	h=Date:To:From:Subject:From;
	b=ZtHRhBU86oZRrTxvEy2jFckhCnqqATAzwA0VjmE2wAIYMlLghH2lzbiseiRQSFHe0
	 PQQW63k2PbzIbESY1AU6yV2g3X4cHeQwxFMSxuV5FroDvjyTR0kSWQ6FFqcwnCF3br
	 d9v3IC/HuljJ9wEc4APla0JAm/7+7D8Tg29ga3Ng=
Date: Sun, 12 Jan 2025 20:23:22 -0800
To: mm-commits@vger.kernel.org,wangfangpeng1@huawei.com,phillip@squashfs.org.uk,pangliyuan1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-dont-allocate-fragment-caches-more-than-fragments.patch removed from -mm tree
Message-Id: <20250113042323.39EC6C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Squashfs: don't allocate fragment caches more than fragments
has been removed from the -mm tree.  Its filename was
     squashfs-dont-allocate-fragment-caches-more-than-fragments.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: pangliyuan <pangliyuan1@huawei.com>
Subject: Squashfs: don't allocate fragment caches more than fragments
Date: Tue, 10 Dec 2024 17:08:42 +0800

Sometimes the actual number of fragments in image is between
0 and SQUASHFS_CACHED_FRAGMENTS, which cause additional
fragment caches to be allocated.

Sets the number of fragment caches to the minimum of fragments
and SQUASHFS_CACHED_FRAGMENTS.

Link: https://lkml.kernel.org/r/20241210090842.160853-1-pangliyuan1@huawei.com
Signed-off-by: pangliyuan <pangliyuan1@huawei.com>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: <wangfangpeng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/super.c~squashfs-dont-allocate-fragment-caches-more-than-fragments
+++ a/fs/squashfs/super.c
@@ -405,7 +405,7 @@ handle_fragments:
 		goto check_directory_table;
 
 	msblk->fragment_cache = squashfs_cache_init("fragment",
-		SQUASHFS_CACHED_FRAGMENTS, msblk->block_size);
+		min(SQUASHFS_CACHED_FRAGMENTS, fragments), msblk->block_size);
 	if (msblk->fragment_cache == NULL) {
 		err = -ENOMEM;
 		goto failed_mount;
_

Patches currently in -mm which might be from pangliyuan1@huawei.com are


