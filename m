Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116A8C13B
	for <mm-commits@vger.kernel.org>; Sun, 31 Aug 2025 19:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756669866; cv=none; b=o0vZuIm1z/YIsm/xDyNOEvScsll34ADuwErAJK1V+hMB7fXRGH3+FAx7VIjXTKMAko/Qj2aJVLwg+L1xj/HWYP1oEOW5eIM5w357cTR0ZosyyTcjqKixCpaYgSWUhgPq7CtGg+BfL68H5uWXiV7AUHFrqVvr4C7nFnYiwpAmK9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756669866; c=relaxed/simple;
	bh=ZDZqQRC7mIktxG4/GOcAYlVMOggN+Ei6aVRzRZucHjw=;
	h=Date:To:From:Subject:Message-Id; b=MXmWJYmy/TpNUv5yxx+s2Frtac6TUz+VfgRM7RFN//aYpnLrVlH6++lsHnPx1na5eILRdQwihne/KC3SU89s6luNdYRh6ZiygfeNGqQUNWA6vrybA7SpPp/LKIEoV3wXXr3sNFmO/z6bwfLbU26PdaKpkFDjDQJCo41uT89FR3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cWZswPPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cWZswPPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871BCC4CEED;
	Sun, 31 Aug 2025 19:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756669865;
	bh=ZDZqQRC7mIktxG4/GOcAYlVMOggN+Ei6aVRzRZucHjw=;
	h=Date:To:From:Subject:From;
	b=cWZswPPmraWd7p2z4F6ksWbP4oa1XK7y6RLz6U63v2y4Eca9/SD6FatVG4eE5If4r
	 MH61jgqeZPYR7egcKv93SGqHgtz8+wMvxm6PZE8WON9KL1kmd70aH+big/dOQV5ClC
	 dTzITx0qtcLkiLC7q0UZTYNuFnED/q+PpuFCkIOA=
Date: Sun, 31 Aug 2025 12:51:04 -0700
To: mm-commits@vger.kernel.org,kaushlendra.kumar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary.patch added to mm-new branch
Message-Id: <20250831195105.871BCC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm/slabinfo: fix access to null terminator in string boundary
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary.patch

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
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: tools/mm/slabinfo: fix access to null terminator in string boundary
Date: Sat, 30 Aug 2025 22:50:22 +0530

The current code incorrectly accesses buffer[strlen(buffer)], which points
to the null terminator ('\0') at the end of the string.  This is
technically out-of-bounds access since valid string content ends at index
strlen(buffer)-1.

Fix by:
1. Declaring strlen() result variable at function scope
2. Adding bounds check (len > 0) to handle empty strings
3. Using buffer[len-1] to correctly access the last character before
   the null terminator

Link: https://lkml.kernel.org/r/20250830172022.1927448-1-kaushlendra.kumar@intel.com
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/slabinfo.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/tools/mm/slabinfo.c~tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary
+++ a/tools/mm/slabinfo.c
@@ -155,6 +155,8 @@ static void usage(void)
 
 static unsigned long read_obj(const char *name)
 {
+	size_t len;
+
 	FILE *f = fopen(name, "r");
 
 	if (!f) {
@@ -165,8 +167,10 @@ static unsigned long read_obj(const char
 		if (!fgets(buffer, sizeof(buffer), f))
 			buffer[0] = 0;
 		fclose(f);
-		if (buffer[strlen(buffer)] == '\n')
-			buffer[strlen(buffer)] = 0;
+		len = strlen(buffer);
+
+		if (len > 0 && buffer[len - 1] == '\n')
+			buffer[len - 1] = 0;
 	}
 	return strlen(buffer);
 }
_

Patches currently in -mm which might be from kaushlendra.kumar@intel.com are

tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary.patch

