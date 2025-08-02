Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BBB173
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754159852; cv=none; b=DPVwqOywcuVlY6VGA/ZdyTM58bApm25KoqAheQmWkIqzEAVULFcv0ubCbV49szraLUtSd1cCibAFyT+FvjaQuSviuqgoylArxRf38WSjlQTkkVrenn0YiVmFWPumoFRY0sDnf4gF147MVNRxEnVe5e/6J/8lhqv7rKFtcbkFiyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754159852; c=relaxed/simple;
	bh=KCs/uqHAOGezLuymhhtJ9s2IXsQKD6HuQ7SyeafgqbQ=;
	h=Date:To:From:Subject:Message-Id; b=ZymWLfU+PaApEaEZ7r2UigzPX8Kdoa4WgyxtHM6e4el/J5R22avob1QVVSCPYQSUskIWMjHZr7OnOQjjkirCZR8eejrPhn8eQ7SM6phkmeWgoywa3zt9HdkXHldxtUEa2w7IPZf8CVc3VonWpz8YcAhHtt6YA0UUxk8q7FAoYC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YBlaivGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YBlaivGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC34FC4CEEF;
	Sat,  2 Aug 2025 18:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754159851;
	bh=KCs/uqHAOGezLuymhhtJ9s2IXsQKD6HuQ7SyeafgqbQ=;
	h=Date:To:From:Subject:From;
	b=YBlaivGYDzhbXuBtnYDK8bzNS+ULecMiWecKKjPNGarZ/yzsBZHqMoPH/j1WcGSHo
	 C7zoCdo1ObY/pxu0J3yD+Vbt8LMlbokqf3LWSKYIIfXsdArPhdGmXwbHaqMLqaDXxD
	 qmpv91iMm9+u0sOOarVNfo4XBNqYMpwMshYgdbDo=
Date: Sat, 02 Aug 2025 11:37:31 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mseal-simplify-and-rename-vma-gap-check-fix.patch removed from -mm tree
Message-Id: <20250802183731.BC34FC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mseal: add comment explaining why we disallow gaps on mseal()
has been removed from the -mm tree.  Its filename was
     mm-mseal-simplify-and-rename-vma-gap-check-fix.patch

This patch was dropped because it was folded into mm-mseal-simplify-and-rename-vma-gap-check.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mseal: add comment explaining why we disallow gaps on mseal()
Date: Fri, 25 Jul 2025 19:23:50 +0100

This explains the semantics clearly, the 'why' of the situation.

Link: https://lkml.kernel.org/r/d85b3d55-09dc-43ba-8204-b48267a96751@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mseal.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/mseal.c~mm-mseal-simplify-and-rename-vma-gap-check-fix
+++ a/mm/mseal.c
@@ -38,6 +38,18 @@ out:
 }
 
 /*
+ * mseal() disallows an input range which contain unmapped ranges (VMA holes).
+ *
+ * It disallows unmapped regions from start to end whether they exist at the
+ * start, in the middle, or at the end of the range, or any combination thereof.
+ *
+ * This is because after sealng a range, there's nothing to stop memory mapping
+ * of ranges in the remaining gaps later, meaning that the user might then
+ * wrongly consider the entirety of the mseal()'d range to be sealed when it
+ * in fact isn't.
+ */
+
+/*
  * Does the [start, end) range contain any unmapped memory?
  *
  * We ensure that:
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch
mm-correct-type-for-vmalloc-vm_flags-fields.patch
mm-correct-type-for-vmalloc-vm_flags-fields-fix.patch

