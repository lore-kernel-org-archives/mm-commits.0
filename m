Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1DE28DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489806; cv=none; b=WPpox4VrwRU+2/QqcGqSfxQ0DZYxeogzkWe98MO953fyeO/SIy9uk8U0l2FFKJu+arih5hO0M/i9qDRGVFhdxvS/LxfgIBSsRuePDTd/73re9pzzSGR0LKEwC1eJgGBejsT/UNw4Ep26fvPfhwV+CL58wJh+QKkSFx9MhFENwl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489806; c=relaxed/simple;
	bh=fYjlZJ++55kmb1Ed5C2IRdELVmmPYKkfUeN27Wzx0Js=;
	h=Date:To:From:Subject:Message-Id; b=m1W/ny80u2jXgDOaR0E3hMfF1ieuIvW8Np6EfZTK3t2fdE8ntOSanLfsvilXhn8cC4vdlXw+CJk2NHyvZSPXRmxw2RouvoGylcZ3UH7k2quzedNHUOHFvIWOr5m9jxB2yr9mdctPW3Nc6WIUktMaGpXQFHwVoG5Cg4AiDkqnMeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gUlLipvI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gUlLipvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FE1C4CEE7;
	Sun, 21 Sep 2025 21:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489805;
	bh=fYjlZJ++55kmb1Ed5C2IRdELVmmPYKkfUeN27Wzx0Js=;
	h=Date:To:From:Subject:From;
	b=gUlLipvIvg298Xclzwp850hyPI6mWEYVLc9Wb9bPGwFlMj9NBQCux8LFy96LR7754
	 vBPfX54EmF92RWZ0cFBwBtDlyhfCV2e/J/6ouFF/MJwsnwJNFxINdhOj54btAwAODe
	 ShdzbQ9955imtG2cHYopoJOserPznH7Rxy00j8Ss=
Date: Sun, 21 Sep 2025 14:23:25 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,kaushlendra.kumar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary.patch removed from -mm tree
Message-Id: <20250921212325.B0FE1C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/slabinfo: fix access to null terminator in string boundary
has been removed from the -mm tree.  Its filename was
     tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[kaushlendra.kumar@intel.com: remove unnecessary blank line]
  Link: https://lkml.kernel.org/r/20250901044955.3902815-1-kaushlendra.kumar@intel.com
Link: https://lkml.kernel.org/r/20250830172022.1927448-1-kaushlendra.kumar@intel.com
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Acked-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/slabinfo.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/tools/mm/slabinfo.c~tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary
+++ a/tools/mm/slabinfo.c
@@ -155,6 +155,7 @@ static void usage(void)
 
 static unsigned long read_obj(const char *name)
 {
+	size_t len;
 	FILE *f = fopen(name, "r");
 
 	if (!f) {
@@ -165,8 +166,10 @@ static unsigned long read_obj(const char
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


