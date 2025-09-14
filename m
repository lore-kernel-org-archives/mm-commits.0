Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C245F33987
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810131; cv=none; b=AmzwCpO5FAivCt/t0z6PzOYDyAN5KY0usRwo2d2P82b7G/cbCJ+djR6CAnyT2Bmk3LhWzfaGoNJTj+8SCcqiAp516D+iWLrCKqgJpTnunRI2gVj63vYhco7T03ZYA4c+xe9lWFQsJMHT7KJ3vFryo1dxjMROorbHLeHWcFruW1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810131; c=relaxed/simple;
	bh=ix+Fdm5LE7Vww6a+YsDIgvFW296wqcfwge0vbWmBUxY=;
	h=Date:To:From:Subject:Message-Id; b=uRyD01jBxnaIlgWRXrt7Tb84Z/wuCXdzpxEcA7AOHvEzfeXJafKFtzJ81yTL9zn+3+gLV+ugzHDtrns5yt4Lzl9bIwiT3PXegJBoc+Hap7PU4p2h+A+ELktq+adi93DEAqkBX7RDESoVap61xXOEf2XlZScWGSN6CUu0orpX7TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F/7V7uqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F/7V7uqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994DBC4CEEB;
	Sun, 14 Sep 2025 00:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810131;
	bh=ix+Fdm5LE7Vww6a+YsDIgvFW296wqcfwge0vbWmBUxY=;
	h=Date:To:From:Subject:From;
	b=F/7V7uqqUQ7IA38v5zZmeyKcgef0ErPryux287I6wRyWUtiLcemDso0RvpZnwyG3u
	 gDmZz15c7RCybxXNzQgkjwQpsaHaHK9ioUhKOsTIh/u+/LRKR62jhAVUpr3eQxlkmG
	 ooVlUbUlBC9ejI1DcZWn5d6LEnVLjmikNXI0F3Yw=
Date: Sat, 13 Sep 2025 17:35:31 -0700
To: mm-commits@vger.kernel.org,safinaskar@zohomail.com,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-refine-the-document-for-panic_print.patch removed from -mm tree
Message-Id: <20250914003531.994DBC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: refine the document for 'panic_print'
has been removed from the -mm tree.  Its filename was
     panic-refine-the-document-for-panic_print.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


