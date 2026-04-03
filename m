Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71FB34D91F
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 06:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198554; cv=none; b=guxUMu0NqRBgCpvLDt0OI2Jvne4tDddOi2fMWoLfatMGSLKRpbpiMm2mb2JlmqRQg/mQ4Gg3wwN64SnXAYV6eONeGHYg86qyVyYum8Bi5YveUoSYnpHFvpdUaEJeNmitF+MqoCw+NXqPzv+5IJRr8cLYPXPUQI2LBb7wWyLdO9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198554; c=relaxed/simple;
	bh=cP0hSOUvKZak8mQRDqLkcr7YVhZxxrB4YpGxLMBvo3U=;
	h=Date:To:From:Subject:Message-Id; b=Mx66wwjg9E7mGU1KGXciKsNxJR140V7AKbZNCXcs6ywVe8wUBd9yGeIT3nTHRBgWwUgdakKaHtt9lfihijGak5w1eHlyiGH0lRejJnaYEDDlEYsuol+aORLx4Vzwz7gOMxZHOPrLOF5n+iPdYjKwB+xvX3+7iBFSmUrpaoC3P2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VLNiBVzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VLNiBVzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6EFC4CEF7;
	Fri,  3 Apr 2026 06:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198554;
	bh=cP0hSOUvKZak8mQRDqLkcr7YVhZxxrB4YpGxLMBvo3U=;
	h=Date:To:From:Subject:From;
	b=VLNiBVzXfQPj8s2uO2hMWkiZkb10LYX1BzufsCvhGp1S2jULeEb4TwPrQWNlQvq6G
	 ata61pn0JyBWA45o9szQlrM82sSFoROe4P88jnnRsEajO3JsoB8ZLKFVTXlzg7AFK6
	 Gz3bbcb2rem3Otr1AFFSBWL9KkeYFU1uvtEE0DoQ=
Date: Thu, 02 Apr 2026 23:42:34 -0700
To: mm-commits@vger.kernel.org,objecting@objecting.org,joe@perches.com,jbaron@akamai.com,changbin.du@gmail.com,inseob@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-parser-fix-match_wildcard-to-correctly-handle-trailing-stars.patch removed from -mm tree
Message-Id: <20260403064234.9F6EFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: parser: fix match_wildcard to correctly handle trailing stars
has been removed from the -mm tree.  Its filename was
     lib-parser-fix-match_wildcard-to-correctly-handle-trailing-stars.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Inseob Kim <inseob@google.com>
Subject: lib: parser: fix match_wildcard to correctly handle trailing stars
Date: Thu, 26 Mar 2026 11:06:04 +0900

This fixes a bug in match_wildcard that incorrectly handles trailing
asterisks.  For example, `match_wildcard("abc**", "abc")` must return
true, but it returns false.

Link: https://lkml.kernel.org/r/20260326020630.4139520-1-inseob@google.com
Signed-off-by: Inseob Kim <inseob@google.com>
Cc: Changbin Du <changbin.du@gmail.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Joe Perches <joe@perches.com>
Cc: Josh Law <objecting@objecting.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/parser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/parser.c~lib-parser-fix-match_wildcard-to-correctly-handle-trailing-stars
+++ a/lib/parser.c
@@ -315,7 +315,7 @@ bool match_wildcard(const char *pattern,
 		}
 	}
 
-	if (*p == '*')
+	while (*p == '*')
 		++p;
 	return !*p;
 }
_

Patches currently in -mm which might be from inseob@google.com are


