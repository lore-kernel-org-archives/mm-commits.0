Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43E28C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600559; cv=none; b=b8o4xOc0KnfIYXQRsb2TpVUxh/Pb9OCJzKrBIDiOvBpDZic6yH14CS9X6rPbDGUxxNguD5fAQeb1UzC7X9bEX2/OFviFS8oWJCy+Q4efeIhbEtS9fg58SqYGTV0p/3aPumEh8HK2DWIrvRzOfA4PTH9nAPESNsPoln5qrnla44I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600559; c=relaxed/simple;
	bh=opdE7087/Yt5SutXJChgSuzK7+WVSMeyRXhlXAJ+Abk=;
	h=Date:To:From:Subject:Message-Id; b=fYDor1R1PZ2U0lKbrIFk1C4mdBt0DqTZr9WJ++IApNWhQ5pz7xGNVF3IHpM/oEYNhju8odBLz2EHczhvmfGJZFCvoV1xUbMCRxmA3XbVrC95sIg/XgHBe9xje/ZSnQwqfpT+PL01jyIolYSOe7iTrmasXfeC0VX2m0hf72Cxvlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vtqc5cIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vtqc5cIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60BCC433C7;
	Tue,  5 Mar 2024 01:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600558;
	bh=opdE7087/Yt5SutXJChgSuzK7+WVSMeyRXhlXAJ+Abk=;
	h=Date:To:From:Subject:From;
	b=Vtqc5cIo/eMWJKZjQ3tLLNI+g5sPjWkxbchHrut0PY8CS6swjU0rf74lV4MoYniKG
	 PxDu7QcvmILY/a4RH2gPzjYQL9nR9IdFiIKSNHTzYZRUN0LPe2FLKyC7jf5XCmoDOP
	 A6UbRXyq6qfzN4A4j+LDV4L76Ze/qEGuwel74oqY=
Date: Mon, 04 Mar 2024 17:02:38 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,martin@kaiser.cx,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_vmallocc-drop-empty-exit-function.patch removed from -mm tree
Message-Id: <20240305010238.B60BCC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_vmalloc.c: drop empty exit function
has been removed from the -mm tree.  Its filename was
     lib-test_vmallocc-drop-empty-exit-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Martin Kaiser <martin@kaiser.cx>
Subject: lib/test_vmalloc.c: drop empty exit function
Date: Mon, 26 Feb 2024 20:11:58 +0100

The module is never loaded successfully.  Therefore, it'll never be
unloaded and we can remove the exit function.

Link: https://lkml.kernel.org/r/20240226191159.39509-3-martin@kaiser.cx
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-drop-empty-exit-function
+++ a/lib/test_vmalloc.c
@@ -600,12 +600,7 @@ static int vmalloc_test_init(void)
 	return -EAGAIN; /* Fail will directly unload the module */
 }
 
-static void vmalloc_test_exit(void)
-{
-}
-
 module_init(vmalloc_test_init)
-module_exit(vmalloc_test_exit)
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Uladzislau Rezki");
_

Patches currently in -mm which might be from martin@kaiser.cx are


