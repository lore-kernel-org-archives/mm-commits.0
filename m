Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA037372675
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028767; cv=none; b=ECLu6qQzi+/05f0dSObDj0JgrgONxZFty7Z0H3NrZjDuI2byIVSWmt55UhhOa06yHBIJv8xMchaKfLoAl8Qus4f5OIp/AANRRlHfgKM401GzG7b/WXpcYY2U5YsVQPQpzoMUYxH7sbbIZOtQPZsumfHibuZj2j2cqsXOxxffvBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028767; c=relaxed/simple;
	bh=TsPw+ebqFY8tDN1PBhsPc2NfVtxJ4l8pTaHsH8cAYY4=;
	h=Date:To:From:Subject:Message-Id; b=FNBd/mtWGCLGMynFjWoTFgCwqcLBpB6Yoe1dGPzikmb7saxTKt2Mr47nARdguFOi5HcyVBpVZJtB++q2SQVPRGyGaGlQLtfSgTLbSPPkb3F6gzgblphmEkBy4lROEMJ+Eee3+Pj/CBuW1i+N+3CQu3SVgsk4D/u2xj6LeOlzMHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1jDkI7AR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1jDkI7AR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC0D1F00898;
	Fri, 29 May 2026 04:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028762;
	bh=derM3M/f4D2dnK2ckxMCp2bhuXWot7/MuyQuN9RcbKc=;
	h=Date:To:From:Subject;
	b=1jDkI7ARBxZbjIDa239il2uSha8eb4iZ6DdAqUPAVzX8cvMLfYPDENjE3bbFqBQGI
	 tWWu79aHsnlc8Kz5Y/PPKrGtPos3tFyQDFqjPUYUPIaMxbKNWs19HA1DxJcBqZ1dih
	 QxD/1N8Gr2Y+Uz+E95GdSq+l1RO9b/eXX5BuvZVw=
Date: Thu, 28 May 2026 21:26:02 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,dwaipayanray1@gmail.com,joe@perches.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-credits-remove-inactive-checkpatch-reviewers.patch removed from -mm tree
Message-Id: <20260529042602.7EC0D1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS/CREDITS: remove inactive checkpatch reviewers
has been removed from the -mm tree.  Its filename was
     maintainers-credits-remove-inactive-checkpatch-reviewers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS/CREDITS: remove inactive checkpatch reviewers
Date: Thu, 07 May 2026 10:41:46 -0700

Dwaipayan Ray and Lukas Bulwahn have not commented on checkpatch in
several years.

Lukas is still active on MAINTAINERS.
Create an entry in CREDITS for Dwaipayan.

Link: https://lore.kernel.org/64f057d1d7f247583eb616337b89b3ff7bcc627f.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/CREDITS~maintainers-credits-remove-inactive-checkpatch-reviewers
+++ a/CREDITS
@@ -3368,6 +3368,10 @@ N: Anil Ravindranath
 E: anil_ravindranath@pmc-sierra.com
 D: PMC-Sierra MaxRAID driver
 
+N: Dwaipayan Ray
+E: dwaipayanray1@gmail.com
+D: checkpatch improvements
+
 N: Eric S. Raymond
 E: esr@thyrsus.com
 W: http://www.tuxedo.org/~esr/
--- a/MAINTAINERS~maintainers-credits-remove-inactive-checkpatch-reviewers
+++ a/MAINTAINERS
@@ -5969,8 +5969,6 @@ F:	drivers/input/keyboard/charlieplex_ke
 CHECKPATCH
 M:	Andy Whitcroft <apw@canonical.com>
 M:	Joe Perches <joe@perches.com>
-R:	Dwaipayan Ray <dwaipayanray1@gmail.com>
-R:	Lukas Bulwahn <lukas.bulwahn@gmail.com>
 S:	Maintained
 F:	scripts/checkpatch.pl
 
_

Patches currently in -mm which might be from joe@perches.com are


