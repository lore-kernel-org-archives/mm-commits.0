Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D5E2517A8;
	Fri, 18 Apr 2025 03:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945879; cv=none; b=dwpuPHY5yjXaurk3JIct53fhYIZaXg4Hgcd4tg7G2pMt9mHP5qU4jHN12KPDHT0iDHQi4OZTbETOQO85mULg3qgt/O7cmonGndlmVXaLOuq8WdRkt97qh11wFK++DXDifztQxzW32zwMLwS45ciHj15bTOVoNnJyEmEZ/YPcW8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945879; c=relaxed/simple;
	bh=v2loZveF/3MQBud5Rd2Oe7sfvhfioh7CO6IJW5945ZU=;
	h=Date:To:From:Subject:Message-Id; b=OIT9kSlJkG0DkCKh1PY2rw5R/EcWFegHisSqY+G5PdgdwpEAQ68C/DO4HFq6JmupKWAGTF8CvyG0J6H9tpO04NJUFSWcoigQqzg/8n1rWltHnM7jAe8NTv7uOnQ16ymiPD8CPF4+rmCyzZ78eF3C+In+WyD4fCnmokJqIRi8n0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A8SPxx6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A8SPxx6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7F9C4AF0B;
	Fri, 18 Apr 2025 03:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744945877;
	bh=v2loZveF/3MQBud5Rd2Oe7sfvhfioh7CO6IJW5945ZU=;
	h=Date:To:From:Subject:From;
	b=A8SPxx6EhQ+NMQDwRHbxOHPc4OtxS/i2AyuKrT3cKHN+FJMbF9kwDp8pcjWVkQLbc
	 FeXbwbXwG0MbUGnJsakqMWMJmOA0Mkb3YQBYYTcb3OdG/LU+bV/xKpP9FZUx8gJwsH
	 L02L8Fqso8yKO7D5iNXSHPA41T+Kw2NXoPD3THYc=
Date: Thu, 17 Apr 2025 20:11:16 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jack@suse.cz,agruenba@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] writeback-fix-false-warning-in-inode_to_wb.patch removed from -mm tree
Message-Id: <20250418031117.7B7F9C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: fix false warning in inode_to_wb()
has been removed from the -mm tree.  Its filename was
     writeback-fix-false-warning-in-inode_to_wb.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: writeback: fix false warning in inode_to_wb()
Date: Sat, 12 Apr 2025 18:39:12 +0200

inode_to_wb() is used also for filesystems that don't support cgroup
writeback.  For these filesystems inode->i_wb is stable during the
lifetime of the inode (it points to bdi->wb) and there's no need to hold
locks protecting the inode->i_wb dereference.  Improve the warning in
inode_to_wb() to not trigger for these filesystems.

Link: https://lkml.kernel.org/r/20250412163914.3773459-3-agruenba@redhat.com
Fixes: aaa2cacf8184 ("writeback: add lockdep annotation to inode_to_wb()")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/backing-dev.h~writeback-fix-false-warning-in-inode_to_wb
+++ a/include/linux/backing-dev.h
@@ -249,6 +249,7 @@ static inline struct bdi_writeback *inod
 {
 #ifdef CONFIG_LOCKDEP
 	WARN_ON_ONCE(debug_locks &&
+		     (inode->i_sb->s_iflags & SB_I_CGROUPWB) &&
 		     (!lockdep_is_held(&inode->i_lock) &&
 		      !lockdep_is_held(&inode->i_mapping->i_pages.xa_lock) &&
 		      !lockdep_is_held(&inode->i_wb->list_lock)));
_

Patches currently in -mm which might be from agruenba@redhat.com are


