Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92205206962
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 17:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728409270; cv=none; b=FFFWIpZmEbjLzl+te4JuxTsQSLFfKLZvatVevfxRzEu94hxRvp4icgiqN3hoCKriS5CNy5cTjGA9iIOJT5XSH2ToVQt8FKFkr30uUiLHpluTmqZC2cWtlnK5z6fZcvDdILQbxHTvddNg/qchck1hmdTPN2IqHZIZRnsyG33TWO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728409270; c=relaxed/simple;
	bh=/6ok86Kmhi5ifn45W9izsl08aT425h8Kfc5mRS32wB8=;
	h=Date:To:From:Subject:Message-Id; b=OIBjZby+wDyZN+1UzRAIs6tLCbmX3yIPMjxeRFise/ECg7eQltGG8mI1RY5XCO54f2orVHvhjUIwuXdIqhYLE75nbckjvAJ/mFrHYYrKJjB65rn2QxZbv9khNvg7VtDJ2/0qrcxouZ4b+04axvxv9yja3fTvc7pq1kLUyKwPu7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kZGOayrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kZGOayrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BB7C4CEC7;
	Tue,  8 Oct 2024 17:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728409270;
	bh=/6ok86Kmhi5ifn45W9izsl08aT425h8Kfc5mRS32wB8=;
	h=Date:To:From:Subject:From;
	b=kZGOayrDk82nw22b8dwiv6jdL7PnbBgIW8tUzzPQ7la+Do2Ru6+i8xnVayxpxqTUJ
	 93OqpKw0WqxQxKNalRlLrO9lz9SJCnXWDqfJ27TqkRf4RYeWb4qOr5QbtANspxQcj0
	 2OU6G3Bq+xjATsTPb+uUNts74Hgc1bpu2lcH/ea4=
Date: Tue, 08 Oct 2024 10:41:09 -0700
To: mm-commits@vger.kernel.org,lasse.collin@tukaani.org,t.v.s10123@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] fix-possible-memory-leak-in-unxz.patch removed from -mm tree
Message-Id: <20241008174110.22BB7C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/decompress_unxz.c: fix: possible memory leak in unxz()
has been removed from the -mm tree.  Its filename was
     fix-possible-memory-leak-in-unxz.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Vishnu Sanal T <t.v.s10123@gmail.com>
Subject: lib/decompress_unxz.c: fix: possible memory leak in unxz()
Date: Sun, 6 Oct 2024 12:55:43 +0530

Fix possible memory leak in the function unxz() in lib/decompress_unxz.c
forgets to free the pointer 'in', when the statement if (fill == NULL &&
flush == NULL) is true.

Link: https://lkml.kernel.org/r/20241006072542.66442-2-t.v.s10123@gmail.com
Signed-off-by: Vishnu Sanal T <t.v.s10123@gmail.com>
Cc: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unxz.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/decompress_unxz.c~fix-possible-memory-leak-in-unxz
+++ a/lib/decompress_unxz.c
@@ -343,13 +343,13 @@ STATIC int INIT unxz(unsigned char *in,
 			}
 		} while (ret == XZ_OK);
 
-		if (must_free_in)
-			free(in);
-
 		if (flush != NULL)
 			free(b.out);
 	}
 
+	if (must_free_in)
+		free(in);
+
 	if (in_used != NULL)
 		*in_used += b.in_pos;
 
_

Patches currently in -mm which might be from t.v.s10123@gmail.com are


