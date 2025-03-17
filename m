Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A1B215045
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188178; cv=none; b=UnFfi1ajUXrpJspRz0dNZWPZcJueB2P0pUJCZFzoju0ybNSH0R0S2UUs6KHPkdBlypYulAx/IIV8CQdhEOz9Udtp3M3ypvzdkPUHE3Ld446o/vWtcUAJm/zCgZCbM03zce83z+GoBLA/gJul4/XezEku3gDTd0fiDXfooXoSvzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188178; c=relaxed/simple;
	bh=mqcTU4CYBNccydhupu/AM9CX2/c/nUiboW8U/qLfl6c=;
	h=Date:To:From:Subject:Message-Id; b=rbvYMqLfCGaPuBwzSSWCgMcuQRIe3HdrkzGK1mtB2+Th1RXOAEnZ7Lb0godlDe66R95WqPLKzwOb8bMDewrKJaXQ3jRSxvjtQlodH3wxmaAoiQd3tgVEmvERY8c9m4X4s6dI1O1zZDKC1G9fjhFddCRxvDJnHlRSK/NEhMdOq4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x+XhXN7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x+XhXN7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE26C4CEEC;
	Mon, 17 Mar 2025 05:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188178;
	bh=mqcTU4CYBNccydhupu/AM9CX2/c/nUiboW8U/qLfl6c=;
	h=Date:To:From:Subject:From;
	b=x+XhXN7Ih4UpzW3l9xvX+ohvzASommSwDn9URpHBTlrJUj2LNMac92Oz0ZWWjPc3s
	 dVQNa4vg1a0051vgq5CUtC/7s8AWzAIXMlHWCH/gTIVs0maBWGgTHzJLgxs3dSTe6k
	 mIMAX+NPT523L0Q74HZ5ZWWZL4KHeke8+J448WBw=
Date: Sun, 16 Mar 2025 22:09:37 -0700
To: mm-commits@vger.kernel.org,cmllamas@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-oom_kill-fix-trivial-typo-in-comment.patch removed from -mm tree
Message-Id: <20250317050938.2AE26C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/oom_kill: fix trivial typo in comment
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-fix-trivial-typo-in-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Carlos Llamas <cmllamas@google.com>
Subject: mm/oom_kill: fix trivial typo in comment
Date: Thu, 23 Jan 2025 19:35:22 +0000

Update 'give' -> 'given' in the description of oom_reap_task_mm().

Link: https://lkml.kernel.org/r/20250123193523.1496909-1-cmllamas@google.com
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/oom_kill.c~mm-oom_kill-fix-trivial-typo-in-comment
+++ a/mm/oom_kill.c
@@ -563,7 +563,7 @@ static bool __oom_reap_task_mm(struct mm
 }
 
 /*
- * Reaps the address space of the give task.
+ * Reaps the address space of the given task.
  *
  * Returns true on success and false if none or part of the address space
  * has been reclaimed and the caller should retry later.
_

Patches currently in -mm which might be from cmllamas@google.com are


