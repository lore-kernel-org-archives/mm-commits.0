Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF8F13A268
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248836; cv=none; b=J2PE1gd2rg5EsleGjhXGY62w4wRgMxLWGhtZZTm+9Zfd5WE/02cz7QgB5Ts14pwRuzztqLvFthxeKHgWAqPDD8G1iYCbDaweURD5S5SaeZW+OsQ6Jpa5E6ppzswurTZgw0a0gyLQlt7vjZun97dxXKnkNP1bELsXpPm0hkildZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248836; c=relaxed/simple;
	bh=QYPTDegijrktjXW1hSemkDs7D4a8jU4jkCgHXbhhO4I=;
	h=Date:To:From:Subject:Message-Id; b=Xtj0rP1TrfJGQ1/6yyFw0NI70I24ftPcHhM/yx9ZMlwDla6C6L1Vg+oeAuorVlUP4/6B9DhwSQ70C1LQefGT3qwQhdwbKa2ErLCVO4WYe5gfP3Q3v6i/OkGmx6p/0Ab899ke0OtozNnVd8BIDesaziRPMZHe6OH8rIcn9qFNyeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OKqPXn68; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OKqPXn68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D40C4CEC2;
	Mon,  2 Sep 2024 03:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248836;
	bh=QYPTDegijrktjXW1hSemkDs7D4a8jU4jkCgHXbhhO4I=;
	h=Date:To:From:Subject:From;
	b=OKqPXn68iFk8ScTh2ARNlG/tSYWsrLxORXhQtZ7OcA2qDoNmk3rSaXNMF9FTjb5Eb
	 LHn+5d4KHd0HpnT3kdyOJVoD/2uWddX355REOLOiTrAzM1+KJ1EXwBgq6gS63vAv9S
	 l0ZoZ4r48Aoxqla3VHOkyiqQhYunpe9AIfRPD+CQ=
Date: Sun, 01 Sep 2024 20:47:15 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-treat-missing-sufile-header-block-as-metadata-corruption.patch removed from -mm tree
Message-Id: <20240902034716.48D40C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: treat missing sufile header block as metadata corruption
has been removed from the -mm tree.  Its filename was
     nilfs2-treat-missing-sufile-header-block-as-metadata-corruption.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: treat missing sufile header block as metadata corruption
Date: Thu, 22 Aug 2024 00:46:23 +0900

Patch series "nilfs2: prevent unexpected ENOENT propagation".

This series fixes potential issues where the result code -ENOENT, which is
returned internally when a metadata file operation encouters a hole block,
is exposed to user space without being properly handled.

Several issues with the same cause leading to hangs or WARN_ON check
failures have been reported by syzbot and fixed each time in the past. 
This collectively fixes the missing -ENOENT conversions that do not cause
stability issues and are not covered by syzbot.


This patch (of 5):

The sufile, a metadata file that holds metadata for segment management,
has statistical information in its first block, but if reading this block
fails, it receives the internal code -ENOENT and returns it unchanged to
the callers.

To prevent this -ENOENT from being propagated to system calls, if reading
the header block fails, return -EIO (or -EINVAL depending on the context)
instead.

Link: https://lkml.kernel.org/r/20240821154627.11848-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240821154627.11848-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/fs/nilfs2/sufile.c~nilfs2-treat-missing-sufile-header-block-as-metadata-corruption
+++ a/fs/nilfs2/sufile.c
@@ -79,10 +79,17 @@ nilfs_sufile_block_get_segment_usage(con
 		NILFS_MDT(sufile)->mi_entry_size;
 }
 
-static inline int nilfs_sufile_get_header_block(struct inode *sufile,
-						struct buffer_head **bhp)
+static int nilfs_sufile_get_header_block(struct inode *sufile,
+					 struct buffer_head **bhp)
 {
-	return nilfs_mdt_get_block(sufile, 0, 0, NULL, bhp);
+	int err = nilfs_mdt_get_block(sufile, 0, 0, NULL, bhp);
+
+	if (unlikely(err == -ENOENT)) {
+		nilfs_error(sufile->i_sb,
+			    "missing header block in segment usage metadata");
+		err = -EIO;
+	}
+	return err;
 }
 
 static inline int
@@ -1237,9 +1244,15 @@ int nilfs_sufile_read(struct super_block
 	if (err)
 		goto failed;
 
-	err = nilfs_sufile_get_header_block(sufile, &header_bh);
-	if (err)
+	err = nilfs_mdt_get_block(sufile, 0, 0, NULL, &header_bh);
+	if (unlikely(err)) {
+		if (err == -ENOENT) {
+			nilfs_err(sb,
+				  "missing header block in segment usage metadata");
+			err = -EINVAL;
+		}
 		goto failed;
+	}
 
 	sui = NILFS_SUI(sufile);
 	kaddr = kmap_local_page(header_bh->b_page);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


