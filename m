Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253C135CBB3
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966064; cv=none; b=TkxGRT6sFaNsIG/M7izjldnBhj1itwCg591AYGpBognDun6iP1ly18W7JP+f/+DSvZ9gdpmpl2MG5fZFvOyn7uh0nL/f9gY/yMWnNjKDcetEtYiswEYyceyoIc5gFOEJPs3ddOQb6GfK8X24JjYxY8NBa5+AMcNJMUk9b+bHnYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966064; c=relaxed/simple;
	bh=uvsrEzV7DGE29hu3GhuTNr8ijLcI84RS9mNmdtT9YK0=;
	h=Date:To:From:Subject:Message-Id; b=HMc2pblNf1aaSsbwDfz97Mn3TR9nYorlXnY6JBtethApjLvfhCTJbXlqtkcqqCO6DYhX1l9AGQzsswttk5QRa1VivkHE+9le2QK/y190NelFdxe3jesOLp+0fc85Pynp7cgiRXc0uy9dcA74Dbt58i78fKg+e3djveu/cgFmS/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ByPm2uIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ByPm2uIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0ACEC16AAE;
	Wed, 21 Jan 2026 03:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966064;
	bh=uvsrEzV7DGE29hu3GhuTNr8ijLcI84RS9mNmdtT9YK0=;
	h=Date:To:From:Subject:From;
	b=ByPm2uIklAl4kFPi1dhvyO7f7TF9hcGusXzuCQqnUaRr0ty3WYgn8igchLF8HxnK6
	 wn/1Otmu9kl9tgwoidB7+xrUD0SfbLPDPrjMBOkzSaA7dhjF4OPprSmKdxrYxWYJzr
	 7VP4yhXn/RoGB5ZdmwJBhIW3mpCd1F8o3H/Pz4ok=
Date: Tue, 20 Jan 2026 19:27:43 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,kaushlendra.kumar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-slabinfo-fix-partial-long-option-mapping.patch removed from -mm tree
Message-Id: <20260121032743.E0ACEC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/slabinfo: fix --partial long option mapping
has been removed from the -mm tree.  Its filename was
     tools-mm-slabinfo-fix-partial-long-option-mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: tools/mm/slabinfo: fix --partial long option mapping
Date: Mon, 8 Dec 2025 16:22:40 +0530

The long option "--partial" was incorrectly mapped to lowercase 'p' in the
opts[] array, but the getopt string and switch case handle uppercase 'P'. 
This mismatch caused --partial to be rejected.

Fix the long_options mapping to use 'P' so --partial works correctly
alongside the existing -P short option.

Link: https://lkml.kernel.org/r/20251208105240.2719773-1-kaushlendra.kumar@intel.com
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Tested-by: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/slabinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/slabinfo.c~tools-mm-slabinfo-fix-partial-long-option-mapping
+++ a/tools/mm/slabinfo.c
@@ -1405,7 +1405,7 @@ struct option opts[] = {
 	{ "numa", no_argument, NULL, 'n' },
 	{ "lines", required_argument, NULL, 'N'},
 	{ "ops", no_argument, NULL, 'o' },
-	{ "partial", no_argument, NULL, 'p'},
+	{ "partial", no_argument, NULL, 'P'},
 	{ "report", no_argument, NULL, 'r' },
 	{ "shrink", no_argument, NULL, 's' },
 	{ "Size", no_argument, NULL, 'S'},
_

Patches currently in -mm which might be from kaushlendra.kumar@intel.com are


