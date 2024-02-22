Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5231BFBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645187; cv=none; b=fdf/u8JeeKd1qDWNm6mOeXhnX7cUcbw4YU3uoOZexi4DNVIwZck9wPraovMi3Dhi37vzfUQvxVW/7lpntskOEdoDuT+uXxOLZZsg00U0kWz+n/2xV7vXaEugvpDXJjVaItUcxbuHm/fAdnWVICO1sNpD4pBq4DwdGplsa5+WYfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645187; c=relaxed/simple;
	bh=a8DVFZ81otuzVFIdi3C2mxOBaYVJxZPc+X+4VE4b6C4=;
	h=Date:To:From:Subject:Message-Id; b=LKt+vhYUlqNn1cy76uTCUMD78M7zkB2BksAiNz67zgOH2jni/UstenhEAkntUNvrB0e4ofU9n0KWpdkWf3DVeQ1TLNyOoszArS3EK8mQRyuTigcKRUwkubZW+wsWdqdQbKtbaM89RWNvZBr8M37Tk1FsX3zQ61QHfCjGkIGbrAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m67ua/2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m67ua/2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244C1C433F1;
	Thu, 22 Feb 2024 23:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645187;
	bh=a8DVFZ81otuzVFIdi3C2mxOBaYVJxZPc+X+4VE4b6C4=;
	h=Date:To:From:Subject:From;
	b=m67ua/2ftCnVDsblUkHOsDWjTQRaFbOMR+Rc+GSKmJMVXK8xO8XMeFIR/ibgzC6R9
	 hga7jTVJ0OPI7MZ5IK6LrqJ21PNYIgdTuqA6mgSoquMY0osoLvSQBZOiza0r3A8Enu
	 qyUEVEVzg9w6YjPiMxrBoxwodEAEcaCfkmvn6B4k=
Date: Thu, 22 Feb 2024 15:39:46 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-convert-recovery-logic-to-use-kmap_local.patch removed from -mm tree
Message-Id: <20240222233947.244C1C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert recovery logic to use kmap_local
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-recovery-logic-to-use-kmap_local.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: convert recovery logic to use kmap_local
Date: Mon, 22 Jan 2024 23:01:48 +0900

Patch series "nilfs2: eliminate kmap and kmap_atomic calls".

This series converts remaining kmap and kmap_atomic calls to use
kmap_local, mainly in metadata files, and eliminates calls to these
deprecated kmap functions from nilfs2.

This series does not include converting metadata files to use folios, but
it is a step in that direction.

Most conversions are straightforward, but some are not: the checkpoint
file, the inode file, and the persistent object allocator.  These have
been adjusted or rewritten to avoid multiple kmap_local calls or nest them
if necessary, and to eliminate long waits like block I/O within the
highmem mapping sections.

This series has been tested in both 32-bit and 64-bit environments with
varying block sizes.


This patch (of 15):

In the recovery function when mounting, nilfs_recovery_copy_block() uses
the deprecated kmap_atomic(), so convert it to use kmap_local.

Link: https://lkml.kernel.org/r/20240122140202.6950-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240122140202.6950-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/recovery.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/recovery.c~nilfs2-convert-recovery-logic-to-use-kmap_local
+++ a/fs/nilfs2/recovery.c
@@ -482,9 +482,9 @@ static int nilfs_recovery_copy_block(str
 	if (unlikely(!bh_org))
 		return -EIO;
 
-	kaddr = kmap_atomic(page);
+	kaddr = kmap_local_page(page);
 	memcpy(kaddr + from, bh_org->b_data, bh_org->b_size);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 	brelse(bh_org);
 	return 0;
 }
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


