Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412373A16A0
	for <mm-commits@vger.kernel.org>; Wed,  8 Apr 2026 16:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775665024; cv=none; b=fJ32K2DB1bunfkc65eVENoAjRHqeTudg0pho9U9bI2ZzPZTmzHCJwHuW43SD/vNbNweiAYMqAt0GvMtaKSlLS4SeVFEQAfnX1PEbqLWa2CnKxNmDW9+KZr/cLrqt3Hb/cFLMlqOQ+9WYet5j1zHVmvNadkH9+TuxGVs8HdTYOJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775665024; c=relaxed/simple;
	bh=D0sajw95kBwVa6LfzyuJMtUqtWmTEo/vuwfJ8s83FhM=;
	h=Date:To:From:Subject:Message-Id; b=H6+oswISBnRT9duYK5k/YOjSVSvQvaH/UsCa5MvSgGeEEQVcFrAABq2WQTI3vwa2L82WmhkJNqmX0AePHQXtNAij8S9LqM9OxDCKAWm2oflWqgHiDpSpdEGBWiLXYE97Tj11HYXbeAMyMaF9zd7A/4UNmKRYkhBwO+wRPQl4qcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IqiL46Zl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IqiL46Zl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97191C19421;
	Wed,  8 Apr 2026 16:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775665023;
	bh=D0sajw95kBwVa6LfzyuJMtUqtWmTEo/vuwfJ8s83FhM=;
	h=Date:To:From:Subject:From;
	b=IqiL46ZlP8cz5O5Weo2BRipWnQnxtgT9DjFeyDBR9ut1HRaqInqfl7IhWrhjbLT/H
	 4O20YVSMD4wN8T01qYRS1SMyFvMrNEtRgk0CXHoB2c853KOQqaSyxMCdh6TD5B4Vct
	 Md1N29qq6SvaBh8X0ou7b7yPP6KqIVMcLm20CXpc=
Date: Wed, 08 Apr 2026 09:17:03 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + doc-watchdog-fix-typos-etc.patch added to mm-nonmm-unstable branch
Message-Id: <20260408161703.97191C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: doc: watchdog: fix typos etc.
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     doc-watchdog-fix-typos-etc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/doc-watchdog-fix-typos-etc.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: doc: watchdog: fix typos etc.
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

doc-watchdog-fix-typos-etc.patch

