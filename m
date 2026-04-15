Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BC83264D4
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 09:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244611; cv=none; b=j2dELOXDJ9uZ0IBpxAR40udIx2whpLDCU92aVK18raOQDTpbByGWdZpJWP6vwu8aLJCKJt5G6HeRP2LOSva+hTsN8cLgN3z2pODrE+lYwwNHkViC72q3ULeA9CVTg0rInBqPWQPORNqBuhIdDc3Tv0X4c5M6JzCJZ6+pxTD1/PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244611; c=relaxed/simple;
	bh=zskq5zQb6sH3yImlbZG8dn4vmr4SYYi4g4Yr7iP+hpM=;
	h=Date:To:From:Subject:Message-Id; b=dlUpAwoUOtmHE9n62EvT5b8hvqHTS1LUIUD9TrFnagKiAjZN78kI4JquT/3ifEG08HuOlcwl4Zo91qP+6Ly4CbIimbZVw/WM/BFzA8j05AShNldPQDUVHU4303Z/pW196TY1+822d35z3Gghe7g8X+9EvfUoUZb6cR0mdksfN/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CSmZOGSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CSmZOGSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78052C19424;
	Wed, 15 Apr 2026 09:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776244611;
	bh=zskq5zQb6sH3yImlbZG8dn4vmr4SYYi4g4Yr7iP+hpM=;
	h=Date:To:From:Subject:From;
	b=CSmZOGSWwMqXQq5p8LITSlVSKF8bboDFiTnoQ4ltdTA6Mm4Jdqb+6LWx5hy4aVXui
	 y9WVMM0XxPPFrdDE20fhbHaD1ccyGw7/hXvFAQovvf13/9bPX/Svit+NGjYJxtktPM
	 WCaxYQFudkr74lZOv219axGWQAMliZMe7XpV2Qic=
Date: Wed, 15 Apr 2026 02:16:47 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,corbet@lwn.net,Bjorn@xn--rombobjrn-67a.se,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] doc-watchdog-fix-typos-etc.patch removed from -mm tree
Message-Id: <20260415091650.78052C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: doc: watchdog: fix typos etc
has been removed from the -mm tree.  Its filename was
     doc-watchdog-fix-typos-etc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: doc: watchdog: fix typos etc
Date: Wed, 8 Apr 2026 14:35:21 -0700

Correct typos in lockup-watchdogs.rst.

Link: https://lkml.kernel.org/r/20260408213523.2707947-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Björn Persson <Bjorn@xn--rombobjrn-67a.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/lockup-watchdogs.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/lockup-watchdogs.rst~doc-watchdog-fix-typos-etc
+++ a/Documentation/admin-guide/lockup-watchdogs.rst
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
+The core of the detectors is an hrtimer. It serves multiple purposes:
 
 - schedules watchdog job for the softlockup detector
 - bumps the interrupt counter for hardlockup detectors (heartbeat)
_

Patches currently in -mm which might be from rdunlap@infradead.org are


