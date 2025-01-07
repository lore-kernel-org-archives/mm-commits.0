Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600D0259C;
	Tue,  7 Jan 2025 03:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736219087; cv=none; b=ZXxFdxttB1Sf+lundE5FGKXjtFQUvISS6BnEqVOeOLcZXVIyknAUyfuoYVvNlkR4qm0LUFhcJ2eXPggafJiSx9SL0ROxc5bGF2jXKoKLgZDr7/f5Xx4dHjPGvU9W2PUD1c9a6jQTVQN2jQt4A1qN1hSkvcUz0RKfTVLZt5HUMb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736219087; c=relaxed/simple;
	bh=pQ+aZMJfs0tLFC+8bz6GwbvVM52+W74yyIUaxiAl8ek=;
	h=Date:To:From:Subject:Message-Id; b=CVwwG0RriuhT/JGqcMTwR/emHvESG4Th9HUgCavzuLbIdGAYUtkn0ceB92DXsf/uJyOXqn2sjG4rQf0Ei/LTOh5MZJLwnAxohYTfhWLAa4V+fIfne0/BCfpBA1CHUU5dk7CWU0Z4F0pdAYJO15zY50TrTtzVQjDR/aAAgALUFlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XHF1KbK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XHF1KbK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C701FC4CED2;
	Tue,  7 Jan 2025 03:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736219086;
	bh=pQ+aZMJfs0tLFC+8bz6GwbvVM52+W74yyIUaxiAl8ek=;
	h=Date:To:From:Subject:From;
	b=XHF1KbK3/TbA2pTbdjgS1Fz/zX8yhIQ5Xr7rHd8zy4DZ0ssmj+A8nVPfsfpjUBJSk
	 TcGHqpfTmKBMFbMXHvg/ydc3uglrq73c7a00F8g2TnRCcsE/74XuuNpQExl3rXsVJg
	 4PK1VevxoiYQIUqRN/rFRz+j4wlW8lKwtA4dSl7o=
Date: Mon, 06 Jan 2025 19:04:46 -0800
To: mm-commits@vger.kernel.org,zzqq0103.hey@gmail.com,stable@vger.kernel.org,lihongbo22@huawei.com,brauner@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-fix-null-pointer-dereference-in-trace_hugetlbfs_alloc_inode.patch added to mm-hotfixes-unstable branch
Message-Id: <20250107030446.C701FC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: fix NULL pointer dereference in trace_hugetlbfs_alloc_inode
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlb-fix-null-pointer-dereference-in-trace_hugetlbfs_alloc_inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-fix-null-pointer-dereference-in-trace_hugetlbfs_alloc_inode.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Muchun Song <songmuchun@bytedance.com>
Subject: hugetlb: fix NULL pointer dereference in trace_hugetlbfs_alloc_inode
Date: Mon, 6 Jan 2025 11:31:17 +0800

hugetlb_file_setup() will pass a NULL @dir to hugetlbfs_get_inode(), so we
will access a NULL pointer for @dir.  Fix it and set __entry->dr to 0 if
@dir is NULL.  Because ->i_ino cannot be 0 (see get_next_ino()), there is
no confusing if user sees a 0 inode number.

Link: https://lkml.kernel.org/r/20250106033118.4640-1-songmuchun@bytedance.com
Fixes: 318580ad7f28 ("hugetlbfs: support tracepoint")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Cheung Wall <zzqq0103.hey@gmail.com>
Closes: https://lore.kernel.org/linux-mm/02858D60-43C1-4863-A84F-3C76A8AF1F15@linux.dev/T/#
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Cc: cheung wall <zzqq0103.hey@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/hugetlbfs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/hugetlbfs.h~hugetlb-fix-null-pointer-dereference-in-trace_hugetlbfs_alloc_inode
+++ a/include/trace/events/hugetlbfs.h
@@ -23,7 +23,7 @@ TRACE_EVENT(hugetlbfs_alloc_inode,
 	TP_fast_assign(
 		__entry->dev		= inode->i_sb->s_dev;
 		__entry->ino		= inode->i_ino;
-		__entry->dir		= dir->i_ino;
+		__entry->dir		= dir ? dir->i_ino : 0;
 		__entry->mode		= mode;
 	),
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

hugetlb-fix-null-pointer-dereference-in-trace_hugetlbfs_alloc_inode.patch

