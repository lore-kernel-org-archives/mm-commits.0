Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E549D13BAFD;
	Thu, 22 Feb 2024 23:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645220; cv=none; b=KRbpMXmetp6ITmaK6JOCgPKlyd6TR/2cIdBpY/kCyrjgF0UU4ymlKrfIDcCHfNuapw9p2ioAqcPVU/dV9dqLKN+AL6Vf6o3t/CgxDO9CnVaAMU1j4lJ07jZFwRuONMGhbDzhmVUT5YzmM6mkl1SDDPxyWg744xhulkq+ZnGv45o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645220; c=relaxed/simple;
	bh=npZGDo35/7mN8tFn53WkdHOnHt8Tyf/3fzVC4oTjv3Q=;
	h=Date:To:From:Subject:Message-Id; b=nNBpVwTymrtw7/Vqh+6PRijvW5QMum+uCTJag6Y/i05MlaFebVVcuwi8AiEwGFzmC0sYJEo92xBFNxqTMGYYdrLu9MCYJg+IqOUfD+EXvNMXW+B7Y1zFK1TwmHpTtQot5FE7kB8N0OBKAiP7LCtgkQmsyLPFUCn611msXBdwcg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sc1CtNuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sc1CtNuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79533C433C7;
	Thu, 22 Feb 2024 23:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645219;
	bh=npZGDo35/7mN8tFn53WkdHOnHt8Tyf/3fzVC4oTjv3Q=;
	h=Date:To:From:Subject:From;
	b=Sc1CtNuTXD38tjMP5kBU0nWqr5sky/c0CR9f6dP676MAqDleT0Jx1PKQWbi6VsU+o
	 eQm1/0j3Wq1OBK923MTTpYhothMhkKnlAe5lt8+oDNNams8GERp5w80C0wRxFvbipe
	 GTLJyUNG7LthziThpplUAy2alFWlgdcvyAN6o1Xw=
Date: Thu, 22 Feb 2024 15:40:18 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hirofumi@mail.parknet.co.jp,amir73il@gmail.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fat-fix-uninitialized-field-in-nostale-filehandles.patch removed from -mm tree
Message-Id: <20240222234019.79533C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fat: fix uninitialized field in nostale filehandles
has been removed from the -mm tree.  Its filename was
     fat-fix-uninitialized-field-in-nostale-filehandles.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fat: fix uninitialized field in nostale filehandles
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

shmem-properly-report-quota-mount-options.patch

