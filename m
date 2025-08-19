Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE6D3101D2
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 20:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755634775; cv=none; b=V8yNg9jHo3GxMFE223dW/Dq4FmTEECv3BZSbYJji/khf2EAak744BtEJrF1G/4vRQjvPTWyjo58+bHy7dAITVt4VR383LJtaXndXE4fYNWyuT3mVzn1ZCsTV/pHr4omkjv5WUVx9nA2Nrr9+PTvgaMwkLj7waspvWvsLGdT0ubA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755634775; c=relaxed/simple;
	bh=3A/i60jBeLo6QFSHT2E0IB+ldIj5HZ1hjjfEC9ngYb0=;
	h=Date:To:From:Subject:Message-Id; b=StHxOqNVyEgOxdr/jUcxeh1WNWi3w/CjBa8f5hNNDIzDL+66l+gSirpAO0BvEB3jXgkLHNRzrjL4rhSsrOP6rp7qXl5kXvV0Yvov01D8qMXA4jvjATIjsh2BBe/7PlbuXywpr5OMTvDW2WAPNf4cDVZr3TpeMQloG/8uHqWRhiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mRAy0o3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mRAy0o3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89765C4CEF1;
	Tue, 19 Aug 2025 20:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755634773;
	bh=3A/i60jBeLo6QFSHT2E0IB+ldIj5HZ1hjjfEC9ngYb0=;
	h=Date:To:From:Subject:From;
	b=mRAy0o3RszU5zWzCmcdLNshYuEbSQKpVBGBIC4fR5JZIaur28f+dQe9YzGocZYDCw
	 u7szGH/Ad+aM2GwB9wK/GV1YKKuFkPzU5ANYZx/exHMENkpgsgwRqXr9CHJC650du8
	 kIsFms2hY5tSMcDb8kZT9llx6WJ3q2TYQ1ZeRwfc=
Date: Tue, 19 Aug 2025 13:19:32 -0700
To: mm-commits@vger.kernel.org,safinaskar@zohomail.com,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,feng.tang@linux.alibaba.com,corbet@lwn.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-sys_info-handle-sys_info_mask==0-case-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250819201933.89765C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-sys_info-handle-sys_info_mask==0-case-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-sys_info-handle-sys_info_mask==0-case-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-sys_info-handle-sys_info_mask==0-case-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-sys_info-handle-sys_info_mask==0-case-fix
Date: Tue Aug 19 01:18:00 PM PDT 2025

remove comment, per Petr

Cc: Askar Safin <safinaskar@zohomail.com>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sys_info.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/sys_info.c~lib-sys_info-handle-sys_info_mask==0-case-fix
+++ a/lib/sys_info.c
@@ -81,7 +81,6 @@ int sysctl_sys_info_handler(const struct
 		char *delim = "";
 		int i, len = 0;
 
-		/* *si_bits_glabl could be 0 */
 		names[0] = '\0';
 
 		for (i = 0; i < ARRAY_SIZE(si_names); i++) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
lib-sys_info-handle-sys_info_mask==0-case-fix.patch

