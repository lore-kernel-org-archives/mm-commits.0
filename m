Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3BB3172D;
	Mon,  5 Feb 2024 22:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171333; cv=none; b=fHtGvYJI5cfuIdj/TPHSRK6VE71HlgWYTndXYHwo6gr4kiNJ8IfhL3RTYLIjWML3k+421JA+1e8uFYK8KatFmqG7eF3vfxyKky6gvzJ1Lq7o9BN1fFgPpSNrBGS4bDb/X14R68r0368YIBK+YLo8Nd1z0CLRoVm7Ao0UtxqXPMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171333; c=relaxed/simple;
	bh=pdoPaqUDLrCKkYkbIvgHrBVe7I2Gk8VPTo8favYYvfU=;
	h=Date:To:From:Subject:Message-Id; b=IZzFC4gfFwedJVs/WzKC3/pl3n7DePlvKTO24vLTjujEBj7+jgfN3TMpYz1PiTrgm4O2le9YcyqzqEug33xNZsg3H+5mCAMOixt5Xml6oaXzYtII7lerhkLvTtI7qF4yN5b4cvQ4RVGJ0qN76dNCrhzTQq1HmKcf1kwosKJQ95Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZAYg+A8z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZAYg+A8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8C2C433F1;
	Mon,  5 Feb 2024 22:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707171332;
	bh=pdoPaqUDLrCKkYkbIvgHrBVe7I2Gk8VPTo8favYYvfU=;
	h=Date:To:From:Subject:From;
	b=ZAYg+A8zkJxlN6U6YtMFZcWUyo89VLrAkS+2d4inwpJdfb57OIqGesRnLECrnIIt4
	 bS/sseO+SY7u4+CBTlvei5LzOxTugMkJdSeYLSeSXjy3mcS/n1AVFWgitZx67OvHpR
	 USMw9W5x8uhwVdLS74zpRPevoH3QC7U0GkzWiNjA=
Date: Mon, 05 Feb 2024 14:15:31 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hirofumi@mail.parknet.co.jp,amir73il@gmail.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-fix-uninitialized-field-in-nostale-filehandles.patch added to mm-nonmm-unstable branch
Message-Id: <20240205221532.7E8C2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fat: Fix uninitialized field in nostale filehandles
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-fix-uninitialized-field-in-nostale-filehandles.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-fix-uninitialized-field-in-nostale-filehandles.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fat: Fix uninitialized field in nostale filehandles
Date: Mon, 5 Feb 2024 13:26:26 +0100

When fat_encode_fh_nostale() encodes file handle without a parent it
stores only first 10 bytes of the file handle. However the length of the
file handle must be a multiple of 4 so the file handle is actually 12
bytes long and the last two bytes remain uninitialized. This is not
great at we potentially leak uninitialized information with the handle
to userspace. Properly initialize the full handle length.

Link: https://lkml.kernel.org/r/20240205122626.13701-1-jack@suse.cz
Reported-by: syzbot+3ce5dea5b1539ff36769@syzkaller.appspotmail.com
Fixes: ea3983ace6b7 ("fat: restructure export_operations")
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/nfs.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/fat/nfs.c~fat-fix-uninitialized-field-in-nostale-filehandles
+++ a/fs/fat/nfs.c
@@ -130,6 +130,12 @@ fat_encode_fh_nostale(struct inode *inod
 		fid->parent_i_gen = parent->i_generation;
 		type = FILEID_FAT_WITH_PARENT;
 		*lenp = FAT_FID_SIZE_WITH_PARENT;
+	} else {
+		/*
+		 * We need to initialize this field because the fh is actually
+		 * 12 bytes long
+		 */
+		fid->parent_i_pos_hi = 0;
 	}
 
 	return type;
_

Patches currently in -mm which might be from jack@suse.cz are

fat-fix-uninitialized-field-in-nostale-filehandles.patch

