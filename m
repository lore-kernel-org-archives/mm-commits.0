Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6872F15687D
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977367; cv=none; b=Vo77BTg3bNP09T5KoiCCAdMb4c+WorOEkfFjqrWSz8VqF92gNgFxJ79YYIjvFXJMAlE82tL60Zh2K1ZrhkP47oQ7SUacT5B/hSX78nlWZOG1WCUeaaVWi/d2nuIa2hjNX03pkFjK3JIx/7yqTF1Y4W6keMC8CgfWjCommkAAqjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977367; c=relaxed/simple;
	bh=v9J+ktJxnXSYYk/R+1x93fSgTDqcKmt++ONxKEziNaw=;
	h=Date:To:From:Subject:Message-Id; b=OyPC2NVpAux4LeAS7VPwmJNn3PyzEwhkVTh85AH/fFbpc2k9lURf2Z93UxsIgqpJXtfTKXolgJwDxxywBDSNHcdb1JmVoCGH9yurKKYnqJNTVt0wovDITSXYJfd8hi1eSGrGMlyqe/O1IH8bxZAbd3ZFjxK6MduClNe6l7IDQ58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uh/hbpgy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uh/hbpgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B71DC4CEE3;
	Sun, 20 Jul 2025 02:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977367;
	bh=v9J+ktJxnXSYYk/R+1x93fSgTDqcKmt++ONxKEziNaw=;
	h=Date:To:From:Subject:From;
	b=uh/hbpgy9SuS5oyzx0K+O08FmzsxCvMJ6xhYMUOUjGkg92ZbpJ5lOHpvQz7x50E2F
	 FiHCYbdSpDdgP0aBf3muvm0AK0IzhEC3l8v60yDIrqB6ntVdsUo5pPNfi83Kj40jgC
	 Ks3e9v847hUBDfb/ajsAXnMjLbrle/60OJ//ATMY=
Date: Sat, 19 Jul 2025 19:09:26 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-replace-with-and-end-of-fi-declaration.patch removed from -mm tree
Message-Id: <20250720020927.3B71DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: replace ;; with ; and end of fi declaration
has been removed from the -mm tree.  Its filename was
     squashfs-replace-with-and-end-of-fi-declaration.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: squashfs: replace ;; with ; and end of fi declaration
Date: Tue, 8 Jul 2025 12:49:00 +0100

There is an extraneous ; after a declaration, remove it.

Link: https://lkml.kernel.org/r/20250708114900.1883130-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-replace-with-and-end-of-fi-declaration
+++ a/fs/squashfs/block.c
@@ -83,7 +83,7 @@ static int squashfs_bio_read_cached(stru
 	struct folio *head_to_cache = NULL, *tail_to_cache = NULL;
 	struct block_device *bdev = fullbio->bi_bdev;
 	int start_idx = 0, end_idx = 0;
-	struct folio_iter fi;;
+	struct folio_iter fi;
 	struct bio *bio = NULL;
 	int idx = 0;
 	int err = 0;
_

Patches currently in -mm which might be from colin.i.king@gmail.com are


