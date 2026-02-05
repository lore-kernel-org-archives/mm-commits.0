Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B0D1482E8
	for <mm-commits@vger.kernel.org>; Thu,  5 Feb 2026 23:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770334325; cv=none; b=pVzyeBcIEsuk/cGKvwdVW+fARYMgcr3pYpdZYFW85slIAINLuDBoLKBvpbWAhNF5+B8/Sm3mxNKBEgMhoso4Y0ACft0rfSkebFbhZXIS+f88UTxzCiHgPfLq4hJCZOHzAh2dBj1H9BvpdO3ioZEhB28LjarbY3r/79uSGqviIgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770334325; c=relaxed/simple;
	bh=Cp9uopIZvIaVn2l4F7pxr+fmkT/wfTPR/fQcYVbUoEs=;
	h=Date:To:From:Subject:Message-Id; b=dB9Z+nTPH9OMH8PmwV3HevfVRFQ5BFhaeopzOJSqXX/TpCogbpnEDSmQ+0F3ONMp4LAgbf0WjB6yCRPHO1y5FQv8h3dV+y83FtJM3CoMMip92aGGhvbWi9jkLCE+n+E2bF3w58uZAmsYd31RY2E37XgxBT6fA+56nJ8Rdt0HpU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KXzKW1LU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KXzKW1LU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D4CC4CEF7;
	Thu,  5 Feb 2026 23:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770334325;
	bh=Cp9uopIZvIaVn2l4F7pxr+fmkT/wfTPR/fQcYVbUoEs=;
	h=Date:To:From:Subject:From;
	b=KXzKW1LU1mo/dxgwLhOFhrt/V26GSbVid15TaskGNyzVXZ38jipcxPAm+XGJ0u+1m
	 dyMKNFduaDvRtkX+75hEkv3VXNfLA0H2EZ+N55EZwKIObpSCyjj8Xaj39ngUwomxM2
	 TAGVnOfkEoReAoLIU7fRIEON2gL+1vNDrbNW4SSg=
Date: Thu, 05 Feb 2026 15:32:04 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] liveupdate-luo_file-remember-retrieve-status-fix.patch removed from -mm tree
Message-Id: <20260205233205.41D4CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate-luo_file-remember-retrieve-status-fix
has been removed from the -mm tree.  Its filename was
     liveupdate-luo_file-remember-retrieve-status-fix.patch

This patch was dropped because it was folded into liveupdate-luo_file-remember-retrieve-status.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: liveupdate-luo_file-remember-retrieve-status-fix
Date: Sat Jan 31 11:43:34 AM PST 2026

fix kerneldoc, per Pasha

Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/liveupdate.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/liveupdate.h~liveupdate-luo_file-remember-retrieve-status-fix
+++ a/include/linux/liveupdate.h
@@ -23,7 +23,7 @@ struct file;
 /**
  * struct liveupdate_file_op_args - Arguments for file operation callbacks.
  * @handler:          The file handler being called.
- * @retrieved:        The retrieve status for the 'can_finish / finish'
+ * @retrieve_sts:     The retrieve status for the 'can_finish / finish'
  *                    operation. A value of 0 means the retrieve has not been
  *                    attempted, a positive value means the retrieve was
  *                    successful, and a negative value means the retrieve failed,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
liveupdate-luo_file-remember-retrieve-status.patch

