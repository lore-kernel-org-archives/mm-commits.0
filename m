Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A55223DF6
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 00:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756168872; cv=none; b=P7p51Qi+rwY0aXczTaha2xIhaRITrReCmJeep/+dhQAaYXc8ZXHrG5BFZuhSvBw1L3fDCO6hGoQgBuwD0T8GGjOCxM9GlYgvID4X7HzEyqd1ls+XBGg+5Izpl8kRiKHDmcoQ2jPN9c4/rqUCaiOzlaAi8EnsI3dU9dk9Q/6KnJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756168872; c=relaxed/simple;
	bh=JeaSBc2xuFcEfb1LyoIeJcFiQn1N/Nb9dV/GBf3sg7g=;
	h=Date:To:From:Subject:Message-Id; b=sZzY1Oodb5mW6ICsBqIuv3ItHE+LbybLJx8NTY76ZJgOxzQP/i734GH8ksyUrxOu2MeW+wEoc7JqMJhJTyOJUoXV8swKnft/oMCWjHr7mQA1wx9KDPx+X0ijQNjAlDspa4gAHECCzJS8N67c62K816AhPaPqbNsVQ7hixLdfS+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wozYJbKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wozYJbKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1151FC4CEED;
	Tue, 26 Aug 2025 00:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756168872;
	bh=JeaSBc2xuFcEfb1LyoIeJcFiQn1N/Nb9dV/GBf3sg7g=;
	h=Date:To:From:Subject:From;
	b=wozYJbKKSdj1pUFsNBFmx9ZLr0IaJiXBVSmItuF3qh/kyUzQhIPjYRdhPb2yUDInX
	 +2fb1gscdo+o448SBIqL9pTDPvtdt+Uayo1IRtbHBKjHprfOMjrXZkKLkxoxlE/Rl5
	 sqPTGgYL8COxQedCash7IhvbELgn7QWBu9XIYdnI=
Date: Mon, 25 Aug 2025 17:41:11 -0700
To: mm-commits@vger.kernel.org,safinaskar@zohomail.com,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-sys_info-handle-sys_info_mask==0-case.patch added to mm-nonmm-unstable branch
Message-Id: <20250826004112.1151FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/sys_info: handle sys_info_mask==0 case
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-sys_info-handle-sys_info_mask==0-case.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-sys_info-handle-sys_info_mask==0-case.patch

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
Subject: lib/sys_info: handle sys_info_mask==0 case
Date: Mon, 25 Aug 2025 10:56:58 +0800

Generalization of panic_print's dump function [1] has been merged, and
this patchset is to address some remaining issues, like adding note of the
obsoletion of 'panic_print' cmdline parameter, refining the kernel
document for panic_print, and hardening some string management.


This patch (of 4):

It is a normal case that bitmask parameter is 0, so pre-initialize the
names[] to null string to cover this case.

Also remove the superfluous "+1" in names[sizeof(sys_info_avail) + 1],
which is needed for 'strlen()', but not for 'sizeof()'.

Link: https://lkml.kernel.org/r/20250825025701.81921-1-feng.tang@linux.alibaba.com
Link: https://lkml.kernel.org/r/20250825025701.81921-2-feng.tang@linux.alibaba.com
Link: Link: https://lkml.kernel.org/r/20250703021004.42328-1-feng.tang@linux.alibaba.com [1]
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Askar Safin <safinaskar@zohomail.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sys_info.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/sys_info.c~lib-sys_info-handle-sys_info_mask==0-case
+++ a/lib/sys_info.c
@@ -55,7 +55,7 @@ int sysctl_sys_info_handler(const struct
 					  void *buffer, size_t *lenp,
 					  loff_t *ppos)
 {
-	char names[sizeof(sys_info_avail) + 1];
+	char names[sizeof(sys_info_avail)];
 	struct ctl_table table;
 	unsigned long *si_bits_global;
 
@@ -81,6 +81,7 @@ int sysctl_sys_info_handler(const struct
 		char *delim = "";
 		int i, len = 0;
 
+		names[0] = '\0';
 		for (i = 0; i < ARRAY_SIZE(si_names); i++) {
 			if (*si_bits_global & si_names[i].bit) {
 				len += scnprintf(names + len, sizeof(names) - len,
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

lib-sys_info-handle-sys_info_mask==0-case.patch
panic-refine-the-document-for-panic_print.patch
panic-add-note-that-panic_print-parameter-is-deprecated.patch

