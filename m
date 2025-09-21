Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796161A9FB9
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 19:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758484334; cv=none; b=HEbkNXGb772foP5IfVlFBGzhS2ZUqN4uwa9zlZbZ4SRc4+UzJYnvHVtyxDdW3FfmvRgv+oFf4Mnt+OMqzyn47aO2cd3EOpEzGdEAyvtZmI89DMfU+SblL9KxSCFrD2ZvY1AgqbVccQMCNU9cScJOrVaRaoML3jX2f7mBlvFTkPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758484334; c=relaxed/simple;
	bh=MuWGHCj200yNXUf79MnPwLnOZ/i0rqOi2hDp/TDOdr8=;
	h=Date:To:From:Subject:Message-Id; b=fwale+y1mMjM1ySCpwGq0/FeHdvNKc7NsKBhW3+5uWtNpSWYxXmpaqU8FcACbILwtOkz3v9dC8ExSM2WbvANx38O7eUL5IAA9IIMRjTy2wdQGWjA2pPOoYeJunUnLpHaHsYQb9UkXhbsg/GSe7Sg3HIOpGp6svp65IS1iJYwIzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wEp7T2da; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wEp7T2da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DF3C4CEE7;
	Sun, 21 Sep 2025 19:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758484334;
	bh=MuWGHCj200yNXUf79MnPwLnOZ/i0rqOi2hDp/TDOdr8=;
	h=Date:To:From:Subject:From;
	b=wEp7T2dasDhrTlEv9hIyXOcZAXVsHx6PtmxNqpcJycoADJbiKPywqqD5k+UW9spGI
	 Lc+c/FwluhsavmgRo4sgSBAbzEoEhEYfnWFeublH/RzSVhtmiWvb5HJ4KEHaB8T6kN
	 35/UCt0sPwjioL02rCKltk4NP7HTbJm5bQgBjQMg=
Date: Sun, 21 Sep 2025 12:52:13 -0700
To: mm-commits@vger.kernel.org,kaushlendra.kumar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary-v4.patch removed from -mm tree
Message-Id: <20250921195213.F0DF3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary-v4
has been removed from the -mm tree.  Its filename was
     tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary-v4.patch

This patch was dropped because it was folded into tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary.patch

------------------------------------------------------
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary-v4
Date: Mon, 1 Sep 2025 10:19:55 +0530

remove unnecessary blank line

Link: https://lkml.kernel.org/r/20250901044955.3902815-1-kaushlendra.kumar@intel.com
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/slabinfo.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/mm/slabinfo.c~tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary-v4
+++ a/tools/mm/slabinfo.c
@@ -156,7 +156,6 @@ static void usage(void)
 static unsigned long read_obj(const char *name)
 {
 	size_t len;
-
 	FILE *f = fopen(name, "r");
 
 	if (!f) {
_

Patches currently in -mm which might be from kaushlendra.kumar@intel.com are

tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary.patch

