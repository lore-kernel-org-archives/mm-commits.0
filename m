Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9353B1EDA1E
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119241; cv=none; b=IbY9URhhTW3svHWfXrEDGPucLXlfa6lwk72J8+H1BiWw1KT6czCUrsKw2VHgPNEqGytCIfJyC1er0xwQhpXO9W921yXk5d+pvNLy9D8e9P9ms77cVbh0XtwOjzfCXvxEUWg1Y4Kw3+X6qQ+atDJpj1blvbPRjjUq/li/c4uCHc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119241; c=relaxed/simple;
	bh=DOqfLy3AfJGnHpo2W/4Z3kawpdzPC+DipigB8PdhJR4=;
	h=Date:To:From:Subject:Message-Id; b=sTNsY8+snD1JNLG1Al5Q+gGTAGW5KLqzqbMA2yWIEYvp0zx85H2Txv4zp3UH22zL367hp+ghoBoib/GH9sH7ZFJu5QBKYEpEEHXiBrNuJfcdNQWlFLjjbvJSOnIvvmHnbI2NXlhSom1v0fSP15clILCmoocep2/dpDsu75PABYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jHVF5TO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jHVF5TO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B80C4CEE4;
	Tue, 13 May 2025 06:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119241;
	bh=DOqfLy3AfJGnHpo2W/4Z3kawpdzPC+DipigB8PdhJR4=;
	h=Date:To:From:Subject:From;
	b=jHVF5TO+MRAZ5yNiadWyUGTtrPHu5o91HwRlYBAizk+MwdhtfGVD+h2NcHBXkxScB
	 EVroniYkeBZA+DxxNKidBYq89KzTmiAbGUzcZFGjYjQoylJk80FpUGXV5Cw0rNroE5
	 lVcCfBKzAcvYVCGTLxGfYp/OvxVTs2xddZhFZPwM=
Date: Mon, 12 May 2025 23:54:00 -0700
To: mm-commits@vger.kernel.org,anshuman.khandual@arm.com,hank20010209@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unused-macro-init_pasid.patch removed from -mm tree
Message-Id: <20250513065401.61B80C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unused macro INIT_PASID
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-macro-init_pasid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cheng-Han Wu <hank20010209@gmail.com>
Subject: mm: remove unused macro INIT_PASID
Date: Sun, 27 Apr 2025 22:50:04 +0800

The macro INIT_PASID was originally used by mm_init_pasid.  However, since
commit a6cbd44093ef ("kernel/fork: Initialize mm's PASID"), mm_init_pasid
has been removed.  Therefore, INIT_PASID is no longer needed and is
removed.

Link: https://lkml.kernel.org/r/20250427145004.13049-1-hank20010209@gmail.com
Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/mm_types.h~mm-remove-unused-macro-init_pasid
+++ a/include/linux/mm_types.h
@@ -28,7 +28,6 @@
 #endif
 #define AT_VECTOR_SIZE (2*(AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1))
 
-#define INIT_PASID	0
 
 struct address_space;
 struct mem_cgroup;
_

Patches currently in -mm which might be from hank20010209@gmail.com are


