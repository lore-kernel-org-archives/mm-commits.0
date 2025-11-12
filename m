Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1949C14B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908560; cv=none; b=MFYfMTWIos+cBaKQvG3oIORb3xESxfsUvROrPl6Jrja/pSdZYqAwYAJBJ+GplE0O/FCl10FWzbXefq4j4ypL48/8LCW99Civ/c78/LjpG2GioTvyH3sAMVqigHpWBuo0CPlQE2Br/1AlIla1IqOqpiIXzFOCJSxVRUCWjiCCdqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908560; c=relaxed/simple;
	bh=1qVkOygYGd5BKrNv+DzmAgc9+jS5gKs5YPQ+BPwwcmk=;
	h=Date:To:From:Subject:Message-Id; b=iPBZ9YoGh7zqedLxDc0xxoDkE8N77OeaDYNx4V6U3Z0SfnuRsiNvtgDGSiNKHpGNyQsdQc1ByGoEBlSimAUJNKqJOlXSoK7EjO+eucXciKGVYxx3JMGpAAVjBZ1GyxHJsoVVuLp8PZoQ7NXy3Y0XdfTxKIS9Fx/Wd3C6oqEh9ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1K/K1Qt8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1K/K1Qt8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837C4C116B1;
	Wed, 12 Nov 2025 00:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908559;
	bh=1qVkOygYGd5BKrNv+DzmAgc9+jS5gKs5YPQ+BPwwcmk=;
	h=Date:To:From:Subject:From;
	b=1K/K1Qt8mVeJz5F7Bwh35vvzIikut5HPS6LP59zQAnGaGQW/vnuK/na+cEwyMEimy
	 OpUTvuCUk1MUgHJjwi+AEXW6vLUBOnwQAFt8SHPzyffWRfnQye3jPQCNcNfM+bMb52
	 dXqy8eQ/yMJNoFZolOV/2AJOtAb3t5VWDlRxUv1s=
Date: Tue, 11 Nov 2025 16:49:19 -0800
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,corbet@lwn.net,apw@canonical.com,work@onurozkan.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-detect-unhandled-placeholders-in-cover-letters.patch removed from -mm tree
Message-Id: <20251112004919.837C4C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: detect unhandled placeholders in cover letters
has been removed from the -mm tree.  Its filename was
     checkpatch-detect-unhandled-placeholders-in-cover-letters.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Onur Özkan <work@onurozkan.dev>
Subject: checkpatch: detect unhandled placeholders in cover letters
Date: Wed, 17 Sep 2025 20:37:24 +0300

Add a new check PLACEHOLDER_USE to detect unhandled placeholders.  This
prevents sending patch series with incomplete patches (mostly in cover
letters) containing auto generated subject or blurb lines.

These placeholders can be seen on mailing lists.  With this change,
checkpatch will emit an error when such text is found.

Link: https://lkml.kernel.org/r/20250917173725.22547-2-work@onurozkan.dev
Signed-off-by: Onur Özkan <work@onurozkan.dev>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-detect-unhandled-placeholders-in-cover-letters
+++ a/scripts/checkpatch.pl
@@ -3345,6 +3345,13 @@ sub process {
 			}
 		}
 
+# Check for auto-generated unhandled placeholder text (mostly for cover letters)
+		if (($in_commit_log || $in_header_lines) &&
+		    $rawline =~ /(?:SUBJECT|BLURB) HERE/) {
+			ERROR("PLACEHOLDER_USE",
+			      "Placeholder text detected\n" . $herecurr);
+		}
+
 # Check for git id commit length and improperly formed commit descriptions
 # A correctly formed commit description is:
 #    commit <SHA-1 hash length 12+ chars> ("Complete commit subject")
_

Patches currently in -mm which might be from work@onurozkan.dev are


