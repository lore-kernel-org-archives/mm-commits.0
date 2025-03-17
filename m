Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95543140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189536; cv=none; b=jcTKrvdizYWCkklnA+OA420Lj2AK4DRFgDdReYNKNh0IE23jpvsK2w669pWmU9CkYSDK//p/GipTryMefjkYHHWGqqYWHZ6XchXu3UvQfTxgjWomATNrC+U9C34iKDKSTMfPyFMG2ydQ7T5nM+FIR6q30lrlXlo89vk8vEu4dPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189536; c=relaxed/simple;
	bh=6Siea8L54+nOPiTukVYT/BoJJoIg6MrGjjiISdHPZwE=;
	h=Date:To:From:Subject:Message-Id; b=ZVC84Ld2ajYim3K0sPWLm4n/QeQGDe8Rm1FzjvW1VjOWFt4F+gcPAIMc1IVH7GHOqRGhX3qSrsm0uwlk+r/CbRa/YCjnmpLg5HbtbK1R5ntlK3JJTqArfCi/9IUMLJnMKE7iPZ3NBoGiZdkna9Nhs6CUVEOF5sihn2Yigdx045k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hj0AYarA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hj0AYarA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE18C4CEEC;
	Mon, 17 Mar 2025 05:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189536;
	bh=6Siea8L54+nOPiTukVYT/BoJJoIg6MrGjjiISdHPZwE=;
	h=Date:To:From:Subject:From;
	b=Hj0AYarA07UA90+wRvsjarzAavYWXyf7Q6RKlOPiGMOA6tqgnZdjGtxcF5wdydaTd
	 IRy+W/6cRv9bfoiC5TTkAuXQNkW4mZwOZlX1bFQu3gEEynkznE98jCKi++whZfliWV
	 s3RFmy7Ji4ZnQ1uhbcjOI9ZEz8euMl0mHA/l9aKU=
Date: Sun, 16 Mar 2025 22:32:15 -0700
To: mm-commits@vger.kernel.org,quic_zijuhu@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rhashtable-remove-needless-return-in-three-void-apis.patch removed from -mm tree
Message-Id: <20250317053216.6BE18C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rhashtable: remove needless return in three void APIs
has been removed from the -mm tree.  Its filename was
     rhashtable-remove-needless-return-in-three-void-apis.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zijun Hu <quic_zijuhu@quicinc.com>
Subject: rhashtable: remove needless return in three void APIs
Date: Fri, 21 Feb 2025 05:02:21 -0800

Remove needless 'return' in the following void APIs:

 rhltable_walk_enter()
 rhltable_free_and_destroy()
 rhltable_destroy()

Since both the API and callee involved are void functions.

Link: https://lkml.kernel.org/r/20250221-rmv_return-v1-16-cc8dff275827@quicinc.com
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rhashtable.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/rhashtable.h~rhashtable-remove-needless-return-in-three-void-apis
+++ a/include/linux/rhashtable.h
@@ -1259,7 +1259,7 @@ static inline int rhashtable_replace_fas
 static inline void rhltable_walk_enter(struct rhltable *hlt,
 				       struct rhashtable_iter *iter)
 {
-	return rhashtable_walk_enter(&hlt->ht, iter);
+	rhashtable_walk_enter(&hlt->ht, iter);
 }
 
 /**
@@ -1275,12 +1275,12 @@ static inline void rhltable_free_and_des
 							     void *arg),
 					     void *arg)
 {
-	return rhashtable_free_and_destroy(&hlt->ht, free_fn, arg);
+	rhashtable_free_and_destroy(&hlt->ht, free_fn, arg);
 }
 
 static inline void rhltable_destroy(struct rhltable *hlt)
 {
-	return rhltable_free_and_destroy(hlt, NULL, NULL);
+	rhltable_free_and_destroy(hlt, NULL, NULL);
 }
 
 #endif /* _LINUX_RHASHTABLE_H */
_

Patches currently in -mm which might be from quic_zijuhu@quicinc.com are


