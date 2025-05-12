Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699E62EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011349; cv=none; b=TIBvzxePc0e5RctWwzUSdgtIcK7Mj/MVRFoM7BMG5sdsqo/sEN6hmexzhugwAA+keVP6CmuvkvQXNfS+k9iJO9Ru9dDczpuKPm2Exmc+nZZF8oDkXb1qJmxnt7D/6nu8Pr/2MOufs5qxlOLax9ExdPc6EBHRN5LL31qY35jADL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011349; c=relaxed/simple;
	bh=qThhJVYeZhIXOxwtiyfdniESItgAy7aHWM4bP1S41Dg=;
	h=Date:To:From:Subject:Message-Id; b=sECUlox4R34vtkFPcYP6mNGz1OU3xwNvs+XPuceAQ/lVTgRpcjZ/jvp9fyCqV5CIVFwgYbfssvjjgVzZnLxYn6+LqdwjJ1+QC/vFmELHTrgfOxiN5jPs89wOlEN+sbavlTpC9y5P4blkdpOaFJzCWYZauO825tEpiSHIJjQdMYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zLiDHRNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zLiDHRNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3DAC4CEE4;
	Mon, 12 May 2025 00:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011349;
	bh=qThhJVYeZhIXOxwtiyfdniESItgAy7aHWM4bP1S41Dg=;
	h=Date:To:From:Subject:From;
	b=zLiDHRNwIJqwOxUpfTqk9Qv5SbQSgwfnjXuQ547t+V36Qy+Izu40lEi8u+hthEe7d
	 W2RKX388+VW7r90Krsk2OmHb7rSM5vnNFWT4ykjvkivPB18zsy9ZLpM+RNhrvDZ5Ps
	 WQvHV6QDTGWnZn3eBBthL0r/S+4CuvtyZOq8S3so=
Date: Sun, 11 May 2025 17:55:48 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,aardelean@baylibre.com,mingo@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernelh-move-read-write-definitions-to-linux-typesh.patch removed from -mm tree
Message-Id: <20250512005549.3D3DAC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel.h: move READ/WRITE definitions to <linux/types.h>
has been removed from the -mm tree.  Its filename was
     kernelh-move-read-write-definitions-to-linux-typesh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ingo Molnar <mingo@kernel.org>
Subject: kernel.h: move READ/WRITE definitions to <linux/types.h>
Date: Mon, 24 Mar 2025 12:50:24 +0200

Patch series "kernel.h: Move out a couple of macros and constants".

kernel.h hosts a couple of macros and constants that may be better placed.
Do that.  Also add missing documentation.  No functional changes
intended.


This patch (of 2):

Headers shouldn't be forced to include <linux/kernel.h> just to
gain these simple constants.

Link: https://lkml.kernel.org/r/20250324105228.775784-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20250324105228.775784-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexandru Ardelean <aardelean@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 ----
 include/linux/types.h  |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/kernel.h~kernelh-move-read-write-definitions-to-linux-typesh
+++ a/include/linux/kernel.h
@@ -41,10 +41,6 @@
 
 #define STACK_MAGIC	0xdeadbeef
 
-/* generic data direction definitions */
-#define READ			0
-#define WRITE			1
-
 #define PTR_IF(cond, ptr)	((cond) ? (ptr) : NULL)
 
 #define u64_to_user_ptr(x) (		\
--- a/include/linux/types.h~kernelh-move-read-write-definitions-to-linux-typesh
+++ a/include/linux/types.h
@@ -136,6 +136,10 @@ typedef s64	ktime_t;
 typedef u64 sector_t;
 typedef u64 blkcnt_t;
 
+/* generic data direction definitions */
+#define READ			0
+#define WRITE			1
+
 /*
  * The type of an index into the pagecache.
  */
_

Patches currently in -mm which might be from mingo@kernel.org are


