Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF39728E5
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810109; cv=none; b=qsNaMev6X8KYWi4t76E9ZG6t8POck/nkgXKaZIHhyDvx9k0ipnDAGxp8xa+K7mL4Qg9l784T4BGEH/hayvPADuGgNUoFw7Y0uR91UjI02ykhk3Nl4FloRVQvNmS28zQmcMUrs+NS3pvwTNZ5W2wFXWPBt3ddl1Xt+gXB0uJYdJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810109; c=relaxed/simple;
	bh=A9NVRadkqKLZ0eH/M/EyQ/m1omhjYuA6cHvHbsbmku0=;
	h=Date:To:From:Subject:Message-Id; b=B3UBaWbN5Fnu3me2HgqyeVZ8DvFdjsbdxo7CLRTYlHF9lUHX5Mzvl3RdVluU0+004uRfH3vjlLo5ExWttRkheysxJwQEPzSQ02VJt45WNKLUCzxELjc9gaxXO0PoIvG93Hi5S9b38QgSrKmtDpAkfvtfHIknYAr4NoMjhWjmsUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q6kEMGVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q6kEMGVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3172C4CEEB;
	Sun, 14 Sep 2025 00:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810108;
	bh=A9NVRadkqKLZ0eH/M/EyQ/m1omhjYuA6cHvHbsbmku0=;
	h=Date:To:From:Subject:From;
	b=q6kEMGVqRFtz2NeDIGS0caQuQKI7qh8i2AeYBqPu7G8353h6K36JaQXLQ00tuHoIx
	 crtqR0Bw2M+V7EA031fVD5GfoQDf0Gu/fT5piJJyRjXV+tCPHSHJk/93oiLZoZ1x07
	 NGzCPUvNg2Ist/GR9ityc703p7+FCY3zU3rNOhnE=
Date: Sat, 13 Sep 2025 17:35:08 -0700
To: mm-commits@vger.kernel.org,linux@treblig.org,joe@perches.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-allow-http-links-of-any-length-in-commit-logs.patch removed from -mm tree
Message-Id: <20250914003508.C3172C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: allow http links of any length in commit logs
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-http-links-of-any-length-in-commit-logs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: allow http links of any length in commit logs
Date: Sat, 09 Aug 2025 21:31:10 -0700

Dave Gilbert noticed that checkpatch warns about URL links over 75 chars
in length in commit logs.

Fix that.

Link: https://lkml.kernel.org/r/3529faaf84a5a9a96c5c0ec4183ae0ba6e97673c.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dave Gilbert <linux@treblig.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-allow-http-links-of-any-length-in-commit-logs
+++ a/scripts/checkpatch.pl
@@ -3294,7 +3294,7 @@ sub process {
 					# file delta changes
 		      $line =~ /^\s*(?:[\w\.\-\+]*\/)++[\w\.\-\+]+:/ ||
 					# filename then :
-		      $line =~ /^\s*(?:Fixes:|$link_tags_search|$signature_tags)/i ||
+		      $line =~ /^\s*(?:Fixes:|https?:|$link_tags_search|$signature_tags)/i ||
 					# A Fixes:, link or signature tag line
 		      $commit_log_possible_stack_dump)) {
 			WARN("COMMIT_LOG_LONG_LINE",
_

Patches currently in -mm which might be from joe@perches.com are


