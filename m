Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCA11448E0;
	Wed, 11 Jun 2025 01:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749606975; cv=none; b=Ks1hDRddNKhMGbbxbdbHF8F35tROc1qFfNoRlo+Y+MnKoEGXXnG86OsaAd0wrjPUhCGXUuJrZPFoxNZfoy7/QewDGDHPwASXHbEcQerf6whipoJvWQshtabBgzKE8K+BsGBh6GrO7p9U+2AkXET6ZYnxZ5H/on+/EfjZV8/4WrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749606975; c=relaxed/simple;
	bh=3/M5ybRke+cDLrxXQXgDGWoPQyrWByK2zcqqoSIUbiU=;
	h=Date:To:From:Subject:Message-Id; b=JJzWcq3veWhRbKNkyc8IUn8D/KKng+ij6tVr+SXSAipw/rzZr2f6EqgXjxb04uTHst9V6ASOPTjNJnEtqxkSw3SytX7eARil0UHfGNQHuR8JFEbR8mB/NusGWyvFBqTm+8XOdq2zDTaVgRpyJXeVeKy2TQXIIg+dxETg111cOwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X9mr6Oui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X9mr6Oui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3D3C4CEED;
	Wed, 11 Jun 2025 01:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749606974;
	bh=3/M5ybRke+cDLrxXQXgDGWoPQyrWByK2zcqqoSIUbiU=;
	h=Date:To:From:Subject:From;
	b=X9mr6OuiD/R0/UMsLtrmoadlrhZRpEI5KT22svyDcswoo1q92T/7WZNkS9Nl/KMSP
	 JTl0RgLGAhtZzUYv399161kaGoHv8ePHLar0ayZj1X+K5qvhjHHX5f4uVfAEyihoGf
	 fg7aKWsr5hG7CRNtALcWArDv4qmiex3ZqtFKnWok=
Date: Tue, 10 Jun 2025 18:56:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-restart-walk-on-correct-status.patch added to mm-new branch
Message-Id: <20250611015614.8C3D3C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: restart walk on correct status
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-restart-walk-on-correct-status.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-restart-walk-on-correct-status.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: restart walk on correct status
Date: Wed, 11 Jun 2025 01:12:52 +0000

Commit a8091f039c1e ("maple_tree: add MAS_UNDERFLOW and MAS_OVERFLOW
states") adds more status during maple tree walk.  But it introduce a typo
on the status check during walk.

It expects to mean neither active nor start, we would restart the walk,
while current code means we would always restart the walk.

Link: https://lkml.kernel.org/r/20250611011253.19515-3-richard.weiyang@gmail.com
Fixes: a8091f039c1e ("maple_tree: add MAS_UNDERFLOW and MAS_OVERFLOW states")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-restart-walk-on-correct-status
+++ a/lib/maple_tree.c
@@ -4930,7 +4930,7 @@ void *mas_walk(struct ma_state *mas)
 {
 	void *entry;
 
-	if (!mas_is_active(mas) || !mas_is_start(mas))
+	if (!mas_is_active(mas) && !mas_is_start(mas))
 		mas->status = ma_start;
 retry:
 	entry = mas_state_walk(mas);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-fix-mt_destroy_walk-on-root-leaf-node.patch
maple_tree-restart-walk-on-correct-status.patch
maple_tree-assert-retrieving-new-value-on-a-tree-containing-just-a-leaf-node.patch

