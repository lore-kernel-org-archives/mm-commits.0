Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269603358CA
	for <mm-commits@vger.kernel.org>; Wed,  8 Apr 2026 21:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775684688; cv=none; b=PsgLnvJ5WvJgRRyd81qIOdTaHdrbyaM+LK0+8oO58llSwfSukiCb8JvXfLSig1hrDwfcx8HXEu1+DBGtQa0lUDqBai1uyJcoqWpV8sCTalV/5fvgXO8Kj5kYJ3JZ3cAnuzKcEuI5KUo6QW0yQ/zDVN4jH/VxmbO5H8C/k91DHo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775684688; c=relaxed/simple;
	bh=wJp1vnO5uSx53yquxGPjNNcG4IHJN1AQ9dJ/mK8BCxs=;
	h=Date:To:From:Subject:Message-Id; b=I3cE6Gm7LvoZPrwx849lyc2lgQDCG0Gy8eFvC9LHvcqmFrdIwJXWrKKzsnB5RRo560qJJ1Saq34jV/XoVbhtRZgBkOkzhsHsKuo3lG1iODymJQzJ3FQKXJkq4KZvoPMuX2NQhHLqwwRY8Id/qTnP2jKXLJ5jXBa1kXvetY6MI9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nWZ0S58D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nWZ0S58D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04BCC19421;
	Wed,  8 Apr 2026 21:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775684687;
	bh=wJp1vnO5uSx53yquxGPjNNcG4IHJN1AQ9dJ/mK8BCxs=;
	h=Date:To:From:Subject:From;
	b=nWZ0S58DRZ3zysBqRiDlbnCVcb2LqNbC+olX5/wZa0lJcpAyn+hVk2mKw6K6vRExA
	 eLWnQCqb/73YiZLYPAW1t8WW6WgZLeHqANfL2ovMmzTekb5Tc87uzoJCNJWTm13idw
	 JlRP4jEuT+dntlqwgTu3uK7ZYpsARzwjtVd94ZD8=
Date: Wed, 08 Apr 2026 14:44:47 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] doc-watchdog-fix-typos-etc.patch removed from -mm tree
Message-Id: <20260408214447.A04BCC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: doc: watchdog: fix typos etc
has been removed from the -mm tree.  Its filename was
     doc-watchdog-fix-typos-etc.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: doc: watchdog: fix typos etc
Date: Tue, 7 Apr 2026 20:12:12 -0700

Correct grammar, plurality, and typos in lockup-watchdogs.rst.

Link: https://lkml.kernel.org/r/20260408031212.2510235-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/lockup-watchdogs.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/lockup-watchdogs.rst~doc-watchdog-fix-typos-etc
+++ a/Documentation/admin-guide/lockup-watchdogs.rst
@@ -18,7 +18,7 @@ provided for this.
 A 'hardlockup' is defined as a bug that causes the CPU to loop in
 kernel mode for several seconds (see "Implementation" below for
 details), without letting other interrupts have a chance to run.
-Similarly to the softlockup case, the current stack trace is displayed
+Similar to the softlockup case, the current stack trace is displayed
 upon detection and the system will stay locked up unless the default
 behavior is changed, which can be done through a sysctl,
 'hardlockup_panic', a compile time knob, "BOOTPARAM_HARDLOCKUP_PANIC",
@@ -41,7 +41,7 @@ is a trade-off between fast response to
 Implementation
 ==============
 
-The soft and hard lockup detectors are built around a hrtimer.
+The soft and hard lockup detectors are built around an hrtimer.
 In addition, the softlockup detector regularly schedules a job, and
 the hard lockup detector might use Perf/NMI events on architectures
 that support it.
@@ -49,7 +49,7 @@ that support it.
 Frequency and Heartbeats
 ------------------------
 
-The core of the detectors in a hrtimer. It servers multiple purpose:
+The core of the detectors is an hrtimer. It servers multiple purposes:
 
 - schedules watchdog job for the softlockup detector
 - bumps the interrupt counter for hardlockup detectors (heartbeat)
_

Patches currently in -mm which might be from rdunlap@infradead.org are


