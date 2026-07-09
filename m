Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13892236E0
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 03:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783567879; cv=none; b=IF7Dr8hK1gy6tkKckSdT2KnwT2ujtma8lNzmFDOHv5CR6pfT2pTjybM9h0+A0yU66QJEPijYiQfxCc8VQonG5SojfK1cgoijwdIJn7XK7V6F+YqmezsZvjmNljCnR8HBXOutQLVJl7sYY6141PRiVKobuc3rlZFVwhvEVMLvsNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783567879; c=relaxed/simple;
	bh=5viZfecDYtYPNnbsOU8hCABp0mlA0xfvX731kEWrGx8=;
	h=Date:To:From:Subject:Message-Id; b=GZEPKL9Iaepx/21h/AdU8yt6uEV9VFuHMzA4L7g6zxPhlXAWGLi3Ow8SVipjwh0MBInUdbh+y7w/JgQEm6R4GTRmp9jJU46mAz3cTp0p1hzF3k0sCQFNExXAa8Sq+lCeJERujfZTKiRHFF0XkrPITwS3Mi02Cv6VTfYCXOg60To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S14hywIf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S14hywIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE6F1F000E9;
	Thu,  9 Jul 2026 03:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783567878;
	bh=A/O4sEqAJGzzgPvKzWHBCuwDUvRhBnUWPlyQ/ra3COk=;
	h=Date:To:From:Subject;
	b=S14hywIfdXLlZtrVcRhkT0xiKdhyOjCOB9VHZ+rEngFj+IYD453IkWSe1022bR1Zz
	 XKVsas2AM13ThW3755QA5/LGJrI3lSKVWNlMglf1wyrWe2GnuodV4Vew0KrPC/+QOM
	 icBwbn+sT59Kq2ZyVI3EukPxz6xbEjkhxQO0BbpU=
Date: Wed, 08 Jul 2026 20:31:17 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,wang.yaxin@zte.com.cn,fan.yu9@zte.com.cn,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + delaytop-sort-by-max-delay-to-highlight-top-latency-processes-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260709033118.4BE6F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: delaytop: fix a bunch of docs build problems
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     delaytop-sort-by-max-delay-to-highlight-top-latency-processes-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/delaytop-sort-by-max-delay-to-highlight-top-latency-processes-fix.patch

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
Subject: delaytop: fix a bunch of docs build problems
Date: Wed, 8 Jul 2026 17:51:04 -0700

Add one space before '('.  Use a literal block for the last output
example, thus repairing all of these warnings:

Documentation/accounting/delay-accounting.rst:236: ERROR: Unexpected indentation. [docutils]
Documentation/accounting/delay-accounting.rst:237: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
Documentation/accounting/delay-accounting.rst:237: ERROR: Unexpected section title or transition.
  ------------------------------------------------------------------------ [docutils]
Documentation/accounting/delay-accounting.rst:239: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
Documentation/accounting/delay-accounting.rst:243: ERROR: Unexpected indentation. [docutils]
Documentation/accounting/delay-accounting.rst:244: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
Documentation/accounting/delay-accounting.rst:246: ERROR: Unexpected indentation. [docutils]
Documentation/accounting/delay-accounting.rst:247: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
Documentation/accounting/delay-accounting.rst:249: WARNING: Definition list ends without a blank line; unexpected unindent. [docutils]
Documentation/accounting/delay-accounting.rst:246: ERROR: Unknown target name: "pool_workqueue". [docutils]

Link: https://lore.kernel.org/20260709005104.501556-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/delay-accounting.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/accounting/delay-accounting.rst~delaytop-sort-by-max-delay-to-highlight-top-latency-processes-fix
+++ a/Documentation/accounting/delay-accounting.rst
@@ -181,7 +181,7 @@ Interactive keyboard controls during run
 	M - Toggle display mode (Default/Memory Verbose)
 	q - Quit
 
-Available sort fields(use -s/--sort or interactive command)::
+Available sort fields (use -s/--sort or interactive command)::
 
 	cpu(c)       - CPU delay
 	blkio(i)     - I/O delay
@@ -219,8 +219,8 @@ Advanced usage examples::
 
 
 
-delaytop add delay_max fields to track the maximum delay value for each delay type
-(cpu, blkio, irq, swapin, freepages, thrashing, compact, wpcopy) per task.
+delaytop add delay_max fields to track the maximum delay value for each delay
+  type (cpu, blkio, irq, swapin, freepages, thrashing, compact, wpcopy) per task::
 
 	bash# ./delaytop -t cpu
 	System Pressure Information: (avg10/avg60/avg300/total)
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-page_owner-document-page_owner-filter-fix.patch
radix-tree-add-correct-some-kernel-doc.patch
delaytop-sort-by-max-delay-to-highlight-top-latency-processes-fix.patch

