Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF16155312
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854719; cv=none; b=FgvKIstqy7RnYcG7/35+BlnykO6tkqb9FZuCbTVSCdtDizXEr4C5/HJ3s3ZXMx5jghNqrtf99SkmXukaRstMntfPYeJzzZesX62G7CTF3r54BwLq/ra1q95cOzDnsYcuDM+HjO3Tscx05m1SSgIsoq5mUwnm6FaZDur9c9qZc58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854719; c=relaxed/simple;
	bh=fiEI8hLjjlcpNHoiv0t3LI6I6YHIr9CLLfIJaKmwZPY=;
	h=Date:To:From:Subject:Message-Id; b=ILsfFr3PpUUMtVbeTW9suRRML84tfOM1l/MEFbPG6ypNJxzfX71UokJvpWWdJ+iVjbO1Ln0EtEyjOShnsJZyC/5zrUNdmxCeNaRA2KJrEb2zXbcBbuM3k7Hv9UkOgWNTY0OxykkFgO9YXXIG9j5rbEd1cRmTfXCdL/g3cWBhm0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mh96cex+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mh96cex+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F5AC4CECF;
	Wed,  6 Nov 2024 00:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854719;
	bh=fiEI8hLjjlcpNHoiv0t3LI6I6YHIr9CLLfIJaKmwZPY=;
	h=Date:To:From:Subject:From;
	b=Mh96cex+zIc2Gwlsu3juSTOEI/QLKDo2zVdQ2x1Acd/60+UThITEx8uHN+DllYgKy
	 WHqobwRrX12LLEy51HQKPhDryjEPyOsYt1kAVEKTjAzpNWYYSG6UsYUuztCEu4NbRb
	 m9HiN4i2rXTOLatA4OWfdKtHxWGvKDeQuRVbqh2U=
Date: Tue, 05 Nov 2024 16:58:37 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,anupnewsmail@gmail.com,tanyaagarwal25699@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-fix-comments-for-better-documentation.patch removed from -mm tree
Message-Id: <20241106005839.33F5AC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: fix comments for better documentation
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-comments-for-better-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tanya Agarwal <tanyaagarwal25699@gmail.com>
Subject: mm/mempolicy: fix comments for better documentation
Date: Fri, 27 Sep 2024 00:05:16 +0530

Fix typo in mempolicy.h and Correct the number of allowed memory policy

Link: https://lkml.kernel.org/r/20240926183516.4034-2-tanyaagarwal25699@gmail.com
Signed-off-by: Tanya Agarwal <tanyaagarwal25699@gmail.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Anup Sharma <anupnewsmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    2 +-
 mm/mempolicy.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mempolicy.h~mm-mempolicy-fix-comments-for-better-documentation
+++ a/include/linux/mempolicy.h
@@ -47,7 +47,7 @@ struct mempolicy {
 	atomic_t refcnt;
 	unsigned short mode; 	/* See MPOL_* above */
 	unsigned short flags;	/* See set_mempolicy() MPOL_F_* above */
-	nodemask_t nodes;	/* interleave/bind/perfer */
+	nodemask_t nodes;	/* interleave/bind/preferred/etc */
 	int home_node;		/* Home node to use for MPOL_BIND and MPOL_PREFERRED_MANY */
 
 	union {
--- a/mm/mempolicy.c~mm-mempolicy-fix-comments-for-better-documentation
+++ a/mm/mempolicy.c
@@ -8,7 +8,7 @@
  * NUMA policy allows the user to give hints in which node(s) memory should
  * be allocated.
  *
- * Support four policies per VMA and per process:
+ * Support six policies per VMA and per process:
  *
  * The VMA policy has priority over the process policy for a page fault.
  *
_

Patches currently in -mm which might be from tanyaagarwal25699@gmail.com are


