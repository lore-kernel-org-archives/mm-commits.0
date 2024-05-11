Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B219217BA8
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467943; cv=none; b=rUvgPKbvFMEoaYF+LI07FtOilbV5yDED6TJ8XJJO/BlGAb31/FzJLziEMOaxN9unpxqQqPzJ1yoQ9XkbRT7vgka7aS3PSvvW7b3stPkihvZVsNTBsbTXgx+iidJxwuUbZxUV09X5367pgS3jjjN3G8OeD7Ub4lQUYknT3vxDqog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467943; c=relaxed/simple;
	bh=IxjeKNFaaPdMbT1Yit1912woi/+e8D6eff/wKuEp4Pw=;
	h=Date:To:From:Subject:Message-Id; b=h227N1nMXuveZkzCQFyuhehmWKG9x7jIk8WPXjFSsu6O4Mfe4MYKfen8iQ9WWVyOgdyED1Az+m3JMGaYeebKIyl/L6pXA6Ihox5Pz+CSAfsSdbHeYK6N48CYuWrClDXd5tUV8ZHSogSuxnoz4T6OLNICppOeHMPJq690DrWZAqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cVOrVdey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cVOrVdey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CC7C2BBFC;
	Sat, 11 May 2024 22:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467943;
	bh=IxjeKNFaaPdMbT1Yit1912woi/+e8D6eff/wKuEp4Pw=;
	h=Date:To:From:Subject:From;
	b=cVOrVdeyQD0ex9B7w0dW8a0hiomszXpzo9Mb0LLhfHLn42RFqJ8WPIzwT0/qz8I/H
	 mOhxQGDmwNvAmTDzpIFAk7yGjpw6uxuKM4LkazZ9Pqpqu97sVluc3HM0/mSD7+XFoj
	 hzmgCscN9rlmsGRq+J8HsMiXjRmhrMWrhgw1NJpA=
Date: Sat, 11 May 2024 15:52:22 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-bug_on-in-nilfs_finish_roll_forward-to-warn_on.patch removed from -mm tree
Message-Id: <20240511225223.29CC7C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert BUG_ON() in nilfs_finish_roll_forward() to WARN_ON()
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-bug_on-in-nilfs_finish_roll_forward-to-warn_on.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: convert BUG_ON() in nilfs_finish_roll_forward() to WARN_ON()
Date: Thu, 9 May 2024 07:14:29 +0900

The BUG_ON check performed on the return value of __getblk() in
nilfs_finish_roll_forward() assumes that a buffer that has been
successfully read once is retrieved with the same parameters and does not
fail (__getblk() does not return an error due to memory allocation
failure).  Also, nilfs_finish_roll_forward() is called at most once during
mount.

Taking these into consideration, rewrite the check to use WARN_ON() to
avoid using BUG_ON().

Link: https://lkml.kernel.org/r/20240508221429.7559-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/recovery.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/recovery.c~nilfs2-convert-bug_on-in-nilfs_finish_roll_forward-to-warn_on
+++ a/fs/nilfs2/recovery.c
@@ -699,7 +699,9 @@ static void nilfs_finish_roll_forward(st
 		return;
 
 	bh = __getblk(nilfs->ns_bdev, ri->ri_lsegs_start, nilfs->ns_blocksize);
-	BUG_ON(!bh);
+	if (WARN_ON(!bh))
+		return;  /* should never happen */
+
 	memset(bh->b_data, 0, bh->b_size);
 	set_buffer_dirty(bh);
 	err = sync_dirty_buffer(bh);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


