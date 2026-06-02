Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F853C4576
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439081; cv=none; b=DlcMHiwHVsaJDXWz8SjNKCtDi4JZ+UOtM3G78+hBVENr/o1dPKfX+tCUHZQgFNUoL3Yl94EESqzsquiS8fz/Ic449PGEINdJTAZ+37PxZb4l0AjSAOzLRb9rRFrFD1mgq4E9L9BNtQCFoX8RBjtzOcoNkFzogx/GltZTPiK0n6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439081; c=relaxed/simple;
	bh=G9SWGRZ08oWGz2ejuDd69KBlmYXdGrknPV585nlVA9E=;
	h=Date:To:From:Subject:Message-Id; b=FPqRqWpPt2zJ7SueeBE0mrf49uoisBMbiyj75D5z/vhSEcm+33OOgk2OCl1rRpbE0qdCJaupaNnRfopwfC1wmxwCJ6jBTMISaY1ZCMQCSqTGvfcAFLFTjxCgubxldojaLbHHzGe2qOth5a8v/5dH9p7CM7xlJBNt/GMuYBP/RDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oCmp/qhC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oCmp/qhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2933C1F0089A;
	Tue,  2 Jun 2026 22:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439080;
	bh=rWe3BmHyDaLP2NiNWcuj6lhBbMiqPdblTI2P2WoRYOk=;
	h=Date:To:From:Subject;
	b=oCmp/qhCYWP+WPP5ltk3X8zgaVYfKWFNZMELWxfjNNvyUutODodmf7e8TesBC+tJ0
	 r8+6ZopSoMkKfpAylbpzntcucQ+kQ8j1kkNYdc+7O2gj+Z37Aj2n7rm727pZ7YZhKq
	 Ouqe+JzT+0GJN0KwTtZte9K0cvEZizYvgx6haYCg=
Date: Tue, 02 Jun 2026 15:24:39 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,ssh1326@icloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-fix-typo-in-process_addrsrst.patch removed from -mm tree
Message-Id: <20260602222440.2933C1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/mm: fix typo in process_addrs.rst
has been removed from the -mm tree.  Its filename was
     docs-mm-fix-typo-in-process_addrsrst.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sakurai Shun <ssh1326@icloud.com>
Subject: docs/mm: fix typo in process_addrs.rst
Date: Sun, 17 May 2026 19:36:35 +0900

Replace "presense" with "presence"

Link: https://lore.kernel.org/20260517103640.45444-1-ssh1326@icloud.com
Signed-off-by: Sakurai Shun <ssh1326@icloud.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/process_addrs.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/process_addrs.rst~docs-mm-fix-typo-in-process_addrsrst
+++ a/Documentation/mm/process_addrs.rst
@@ -775,7 +775,7 @@ lock, releasing or downgrading the mmap
 lock so there is no :c:func:`!vma_end_write` function.
 
 Note that when write-locking a VMA lock, the :c:member:`!vma.vm_refcnt` is temporarily
-modified so that readers can detect the presense of a writer. The reference counter is
+modified so that readers can detect the presence of a writer. The reference counter is
 restored once the vma sequence number used for serialisation is updated.
 
 This ensures the semantics we require - VMA write locks provide exclusive write
_

Patches currently in -mm which might be from ssh1326@icloud.com are


