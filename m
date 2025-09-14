Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BEC33987
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810130; cv=none; b=QbMShInWCmO+HfkA9qQhgGBRosZiwpHFPJ53pB6cY7JrirCFn3d3c7aHK4zaXPw2pnKC0WW1/4LTrIOVwK5IzyhSWElynn2KEJXHgbwBJJPNDdRdmZp5d405CMY9/vcU2BYw5sWBH6hVFFxjH4gNugiavy7nnbzEQ/VU3/thyLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810130; c=relaxed/simple;
	bh=jGij5WL47hnID8OaVBDE1IgCoMCWnXG+TUz4IH/c1go=;
	h=Date:To:From:Subject:Message-Id; b=NkeM76Wsiji48YvWS00x7vQ95NYVW/I96cO1RL0MmkYcZgk0/TQWkyupYof4gvfSPxyrKSDH7xiTXbV6UuAHatsTChx4zxSOaR2nyTeSQe5vLKnspj5IOEec9f6L00nBjt7/+l5fHvUrTRzmZY3gdECDCcd3kyF2ngqBLmeG/KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T5y5Z+JW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T5y5Z+JW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282C8C4CEEB;
	Sun, 14 Sep 2025 00:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810130;
	bh=jGij5WL47hnID8OaVBDE1IgCoMCWnXG+TUz4IH/c1go=;
	h=Date:To:From:Subject:From;
	b=T5y5Z+JWP5HwHWSct5d1YVbMtQKfuuYNad81B+OAHjJFcUBJueYLxao04R8tmQtQX
	 kAvK2lmgOwgk/l7YroB2Vibl7qTSRHfxBRdwciV4tqIGCyZOAGYFMWUz9Q1owr3ke7
	 nSK7wdijaVq4l1QKu1xNwWeZKWdLjniKxvVKSc7A=
Date: Sat, 13 Sep 2025 17:35:29 -0700
To: mm-commits@vger.kernel.org,safinaskar@zohomail.com,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-sys_info-handle-sys_info_mask==0-case.patch removed from -mm tree
Message-Id: <20250914003530.282C8C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/sys_info: handle sys_info_mask==0 case
has been removed from the -mm tree.  Its filename was
     lib-sys_info-handle-sys_info_mask==0-case.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


