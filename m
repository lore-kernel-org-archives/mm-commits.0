Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0932418DF76
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925692; cv=none; b=fiuuJXnfOk53KoDEehLL3h4C82wshX8Fa0Rdr5dTmIAHn3i9WvNPgN/JT9IaTIJFAf1hSXvyeh9SL+UlkOCc7Ms5b5CrBXQZfC4baVcki8w2GZhPCKwbuAHdD9zs3xiwuapLn3kFiy2vqZ3MUQpsJ8qD2why13BxDp37jbp1bTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925692; c=relaxed/simple;
	bh=hzvho3dI40wOTuzYObC1OZ0OpqOzF6cTMpCql0C2r2g=;
	h=Date:To:From:Subject:Message-Id; b=pUcuNi0BOFlmN69/FWOsyGINf72LDSJ0rgLOyUShsPYsqnTor1cYPtU9dIEpBZJtXiZZRIDwQCwJgo64Xp+Wmn6KRHOMr4SSW0yhsJC4mh++TDrKPOpRPDo2KXN7KzAPZvOpD4GxbFTY48WKVR/KvPpYhSkRE2aqXQMRXVRW/aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x+fQxMAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x+fQxMAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D58C4CEC5;
	Mon,  9 Sep 2024 23:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925691;
	bh=hzvho3dI40wOTuzYObC1OZ0OpqOzF6cTMpCql0C2r2g=;
	h=Date:To:From:Subject:From;
	b=x+fQxMAJFkqwWcgflrg8UdWb1+51D+Ys0Tyv6GyWUTePpNJlRTBok2xtaeZ2eJreb
	 iRRFACh5El2OEXECoAqsaP6kHCDD84DxHdniUEbY2H9CXlOkxzbgpBXqGKPlROqgQi
	 8zFpx7cOhpPwk2I3KLIEQ8KGvKyp12xrlCykvKa4=
Date: Mon, 09 Sep 2024 16:48:10 -0700
To: mm-commits@vger.kernel.org,swaminathanalok@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-globc-added-null-check-for-character-class.patch removed from -mm tree
Message-Id: <20240909234811.66D58C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: glob.c: added null check for character class
has been removed from the -mm tree.  Its filename was
     lib-globc-added-null-check-for-character-class.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alok Swaminathan <swaminathanalok@gmail.com>
Subject: lib: glob.c: added null check for character class
Date: Mon, 26 Aug 2024 11:57:09 -0400

Add null check for character class.  Previously, an inverted character
class could result in a nul byte being matched and lead to the function
reading past the end of the inputted string.

Link: https://lkml.kernel.org/r/20240826155709.12383-1-swaminathanalok@gmail.com
Signed-off-by: Alok Swaminathan <swaminathanalok@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/glob.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/glob.c~lib-globc-added-null-check-for-character-class
+++ a/lib/glob.c
@@ -68,6 +68,8 @@ bool __pure glob_match(char const *pat,
 			back_str = --str;	/* Allow zero-length match */
 			break;
 		case '[': {	/* Character class */
+			if (c == '\0')	/* No possible match */
+				return false;
 			bool match = false, inverted = (*pat == '!');
 			char const *class = pat + inverted;
 			unsigned char a = *class++;
_

Patches currently in -mm which might be from swaminathanalok@gmail.com are


