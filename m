Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F974182B3
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 00:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724804391; cv=none; b=SxlU8nHo2mCoYwh7Grdfr95FWrtMYdB8ImnUPnRm5uFKfLzOFHgyFyorjwZxV0sa2CCsq4e8MlvMlH/udfJTFEfHNKUVowGCQPFyzHtuLJQOLojrNB36or8Q70CNNytW+Y8FuzVmOzSucDBmMOdHPqmhgInUVyWssknA6dCsEbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724804391; c=relaxed/simple;
	bh=PTxgu5Bu+f28vlk95h1rS1G/V676l9AJd82pXEuRWlc=;
	h=Date:To:From:Subject:Message-Id; b=YBiytXNJFDlSPsOVKdECEje8AJmL6zUb55mHrehk5Mvmy5WULlnDg5mOwX9Y/CagA/MuY60YrG9KtEUxFUNbmOck0/YJmtVkDF//eeJqDo9uMvz3wTzWF+dxZ6gjiQ/K5wq0lSRm5sfZUJx0bbXHwl7hE88AD5ZR2czbkB5Ar2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SLqwJPwE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SLqwJPwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965A0C4DE0B;
	Wed, 28 Aug 2024 00:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724804390;
	bh=PTxgu5Bu+f28vlk95h1rS1G/V676l9AJd82pXEuRWlc=;
	h=Date:To:From:Subject:From;
	b=SLqwJPwET/UmEnBvfB8etsEYn1MvjeWlOnTOD2eMpn6o4MberhJGBzo3rI4RtpZd9
	 3U4PhK+faZcU6yICVlsVX0CoFU+tUTAVYfr2itPaR7spbGEM7A9MA6uX0+pdg0jb1V
	 6sYI7aGmEcdmeOdX9IRfWQRcD4dns8umYWw7DcKk=
Date: Tue, 27 Aug 2024 17:19:50 -0700
To: mm-commits@vger.kernel.org,swaminathanalok@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-globc-added-null-check-for-character-class.patch added to mm-nonmm-unstable branch
Message-Id: <20240828001950.965A0C4DE0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: glob.c: added null check for character class
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-globc-added-null-check-for-character-class.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-globc-added-null-check-for-character-class.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

lib-globc-added-null-check-for-character-class.patch

