Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF8A3BBF2
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 00:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756168875; cv=none; b=nLfU1itSzCidxn312DPTO54wBVCH/txALeeVoiQVIFbOq75pOqmrMGAE7vZp7+w8Naadomj/3TKw5iA4gmkeRvCtAkEZcuVULTxdL+J/X53e660etTD9vlWlRgRZa7P9VcpxQMxz3wCVthBFi0rPULxq8NJj9ovaUsj6rl0Cwww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756168875; c=relaxed/simple;
	bh=SqcRi6tQi9uXlXfAahs0ZmehnHleoV8vV3SaNGhDkB8=;
	h=Date:To:From:Subject:Message-Id; b=LswvZ5lC3+zyZ5NPbJb7ZL4TM8/rCiA5nA5c3ZRVA5pM+PYUT1RLwqs7dgWaITP34EA5fDTEwaQHx1bhv8AZ+LQIWR6ji2i9G3fqVwg5d1zF0KWfom9ROZPvce5DQBUU+CxChUS0eILxKxFvJTAKZmiekVj9/Oks4jJMVfaRUbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tLI9+EJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tLI9+EJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152BBC4CEED;
	Tue, 26 Aug 2025 00:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756168874;
	bh=SqcRi6tQi9uXlXfAahs0ZmehnHleoV8vV3SaNGhDkB8=;
	h=Date:To:From:Subject:From;
	b=tLI9+EJhlcM+WEwUGGpqGhZQoZucqfdB/ctS7ySoqUnS4Nd201Y4IgsCFDHPzFrn1
	 lgx0LxOIZzxGl3E8pxe61UCNSKO4nWIqj5N2yL6RLD0zViIf2xsErBPUOVtruaPQuD
	 Rbso6gT8j9Bu5sCeYEwBtj1+DFz2htHjWHbcysOk=
Date: Mon, 25 Aug 2025 17:41:13 -0700
To: mm-commits@vger.kernel.org,safinaskar@zohomail.com,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-refine-the-document-for-panic_print.patch added to mm-nonmm-unstable branch
Message-Id: <20250826004114.152BBC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: refine the document for 'panic_print'
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-refine-the-document-for-panic_print.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-refine-the-document-for-panic_print.patch

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
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: panic: refine the document for 'panic_print'
Date: Mon, 25 Aug 2025 10:56:59 +0800

User reported current document about SYS_INFO_PANIC_CONSOLE_REPLAY is
confusing, that people could expect all user space console messages to be
replayed.

Specify that only 'kernel' messages will be replayed to solve the confusion.

Link: https://lkml.kernel.org/r/20250825025701.81921-3-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Reported-by: Askar Safin <safinaskar@zohomail.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 +-
 Documentation/admin-guide/sysctl/kernel.rst     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~panic-refine-the-document-for-panic_print
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -4589,7 +4589,7 @@
 			bit 2: print timer info
 			bit 3: print locks info if CONFIG_LOCKDEP is on
 			bit 4: print ftrace buffer
-			bit 5: replay all messages on consoles at the end of panic
+			bit 5: replay all kernel messages on consoles at the end of panic
 			bit 6: print all CPUs backtrace (if available in the arch)
 			bit 7: print only tasks in uninterruptible (blocked) state
 			*Be aware* that this option may print a _lot_ of lines,
--- a/Documentation/admin-guide/sysctl/kernel.rst~panic-refine-the-document-for-panic_print
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -890,7 +890,7 @@ bit 1  print system memory info
 bit 2  print timer info
 bit 3  print locks info if ``CONFIG_LOCKDEP`` is on
 bit 4  print ftrace buffer
-bit 5  replay all messages on consoles at the end of panic
+bit 5  replay all kernel messages on consoles at the end of panic
 bit 6  print all CPUs backtrace (if available in the arch)
 bit 7  print only tasks in uninterruptible (blocked) state
 =====  ============================================
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

lib-sys_info-handle-sys_info_mask==0-case.patch
panic-refine-the-document-for-panic_print.patch
panic-add-note-that-panic_print-parameter-is-deprecated.patch

