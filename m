Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28DD3FF1D5;
	Fri, 26 Jun 2026 16:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782492653; cv=none; b=ZElt/83/h95ACakIBnoNKsTld1o1dgXRgu09+TmSkFmaozog0wQf2nnsJH/UIivE56o6DuBl724W7r8b6MWQuOllMFo4I/mWJSyjx5byezZZVThNqVt+GiN/4ZnTyv3dlAIbK8pgWPSgXMLgVjNw5mNOd7lN7ZO3gRBsGeifksw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782492653; c=relaxed/simple;
	bh=Rdgi4XISxk2RbCfNkPVFbupZyaYg+7Tp5m7WiFvof6U=;
	h=Date:To:From:Subject:Message-Id; b=SCc/OLfkH39oqmxV++BAGjQ6V7yFueNtNplbxbWN8gV6qqMW2bVf/YS3afCdlqTG0AaR+3C1tvZQwG7RDC1WshTogK17zw0wRxN9tHlsojLECMOg4XXapDanR8hT//BmD30Ls1zgqQ3nJoj+eUfc3A28YnoybYxTG8taPyKq5s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y3SHf6US; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y3SHf6US"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038311F00A3E;
	Fri, 26 Jun 2026 16:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782492647;
	bh=L/uu47sRYUdCVB/fjvDNa6+lQH6AhBSXI7KIFWy3uVM=;
	h=Date:To:From:Subject;
	b=y3SHf6USIj5OVh9zWZ74XdBsyj2SRFapY3PNf1mf7DD5giUKUsOE3eYISRFIl1pbi
	 RJFs/UFuWlsrSLKCyZcj74fUxjzKv9X/uSWvPL1bPnmv7PuMC/jRkoOBlB6CCOkiGN
	 1J+2YCZS9McwxQpV0BG4+wJzHkzS1uXKd1Ilewis=
Date: Fri, 26 Jun 2026 09:50:46 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pmladek@suse.com,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,dianders@chromium.org,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] panic-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch removed from -mm tree
Message-Id: <20260626165047.038311F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: use sys_info_with_filter() to avoid duplicate backtraces
has been removed from the -mm tree.  Its filename was
     panic-use-sys_info_with_filter-to-avoid-duplicate-backtraces.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Bradley Morgan <include@grrlz.net>
Subject: panic: use sys_info_with_filter() to avoid duplicate backtraces
Date: Thu, 25 Jun 2026 15:25:58 +0000

panic_other_cpus_shutdown() handles SYS_INFO_ALL_BT before stopping the
other CPUs.  Do not ask sys_info() to handle that bit again later in the
panic path.

Use sys_info_with_filter() so panic_print=all_bt does not request more
output after the CPUs are stopped.

Link: https://lore.kernel.org/20260625152558.7450-5-include@grrlz.net
Fixes: a9af76a78760 ("watchdog: add sys_info sysctls to dump sys info on system lockup")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/panic.c~panic-use-sys_info_with_filter-to-avoid-duplicate-backtraces
+++ a/kernel/panic.c
@@ -680,7 +680,7 @@ void vpanic(const char *fmt, va_list arg
 	 */
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
-	sys_info(panic_print);
+	sys_info_with_filter(panic_print, SYS_INFO_ALL_BT);
 
 	kmsg_dump_desc(KMSG_DUMP_PANIC, buf);
 
_

Patches currently in -mm which might be from include@grrlz.net are

lib-string-fix-memchr_inv-for-large-ranges.patch

