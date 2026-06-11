Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB844A2E24
	for <mm-commits@vger.kernel.org>; Thu, 11 Jun 2026 18:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781203383; cv=none; b=p9Yt1ljHCEo31S9a6qwN7+PJCBMUr4HmMl61hj0GfS5WHsq+medeaRQuHTnyNdVCh/egvLBvmHHAbNRBqVGlJfQnI95kMbmWbjRvadwQ/qJ3+bTVGGbYrjK+Y5YS3oSWXy55wL7k36YBOea44u1ifuGHNdP15UvKLBQmC6Fgt1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781203383; c=relaxed/simple;
	bh=kR25GPXALxwllIg+iVz581UFNJHP/VPuq6RKzSxP5hM=;
	h=Date:To:From:Subject:Message-Id; b=NhNh16hsJUrUldhBuz/13miVkj3U8WwAO+FQi+/vQE6UktH5DiQLQE/JkTJCm1BDNkam7cSmOTyhgkL4rOmWT2p80e3aXTSh86iAtcP1gaJmp5FdwGehFPqTH0CEpFt34nhJ/ZNkkOowfd8Y9s1GSoim46zgMkGF2EzoGmN1KX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UQJH1CIn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UQJH1CIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BE51F00A3A;
	Thu, 11 Jun 2026 18:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781203382;
	bh=HaAipjkgxxHoxDS3uqFPFcMcB/DQi3jP+zH37L/oJlQ=;
	h=Date:To:From:Subject;
	b=UQJH1CIn809s6ZMgIG9xveZcT4ImX/dEAwEq3G7flBai2PfYgG4TF+5e7b3kaw5cw
	 +Tvk7qGGSohpbJFgGki+irGlvUZ3UkOgFzMvslnu2MF6+lO4VsNb6WaJILr7AjXpBT
	 2Vxn7JaVas7h3TSJAkG3jnbY9b6IA8p8nJYyp9QA=
Date: Thu, 11 Jun 2026 11:43:01 -0700
To: mm-commits@vger.kernel.org,pvorel@suse.cz,niecheng1@uniontech.com,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,cryolitia@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-suppress-warnings-when-reported-by-is-followed-by-link.patch removed from -mm tree
Message-Id: <20260611184302.23BE51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: cuppress warnings when Reported-by: is followed by Link:
has been removed from the -mm tree.  Its filename was
     checkpatch-suppress-warnings-when-reported-by-is-followed-by-link.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cryolitia PukNgae <cryolitia@uniontech.com>
Subject: checkpatch: cuppress warnings when Reported-by: is followed by Link:
Date: Fri, 05 Jun 2026 14:57:04 +0800

> The tag should be followed by a Closes: tag pointing to the report,
> unless the report is not available on the web. The Link: tag can be
> used instead of Closes: if the patch fixes a part of the issue(s)
> being reported.

According to Documentation/process/submitting-patches.rst, Link: is also
acceptable to follow a Reported-by:, if the patch fixes a part of the
issue(s) being reported.

Link: https://lore.kernel.org/20260605-checkpatch-v1-1-8c68ae618513@linux.dev
Signed-off-by: Cryolitia PukNgae <cryolitia@uniontech.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Cheng Nie <niecheng1@uniontech.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-suppress-warnings-when-reported-by-is-followed-by-link
+++ a/scripts/checkpatch.pl
@@ -3253,10 +3253,10 @@ sub process {
 			if ($sign_off =~ /^reported(?:|-and-tested)-by:$/i) {
 				if (!defined $lines[$linenr]) {
 					WARN("BAD_REPORTED_BY_LINK",
-					     "Reported-by: should be immediately followed by Closes: with a URL to the report\n" . $herecurr . "\n");
-				} elsif ($rawlines[$linenr] !~ /^closes:\s*/i) {
+					     "Reported-by: should be immediately followed by Closes: or Link: with a URL to the report\n" . $herecurr . "\n");
+				} elsif ($rawlines[$linenr] !~ /^(closes|link):\s*/i) {
 					WARN("BAD_REPORTED_BY_LINK",
-					     "Reported-by: should be immediately followed by Closes: with a URL to the report\n" . $herecurr . $rawlines[$linenr] . "\n");
+					     "Reported-by: should be immediately followed by Closes: or Link: with a URL to the report\n" . $herecurr . $rawlines[$linenr] . "\n");
 				}
 			}
 		}
_

Patches currently in -mm which might be from cryolitia@uniontech.com are


