Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C82514386D
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 02:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743648968; cv=none; b=gwQu01Y/Ybvk+W/ftZ7mYuxcYMnrmdHk1MxDYjrhZUr3ZCAmcGW31DdE9fhf7C7TYbrrcpvyLGm2jD45l3AWVk5kz47ujnEfGmUH5bQzlK2K+ROUG2fu4qsCN46a9ARZGsyoHZliTjPpbla2tFKes0SypABvlgonTvdloopTpZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743648968; c=relaxed/simple;
	bh=4GiYzvODgABNJTtnUdM0lDcRrvLL0LuO4J/mWg3lqWM=;
	h=Date:To:From:Subject:Message-Id; b=FJw7YAcxEeHGy9RhO529TeoEzCIMiuAoCFwSu75B6WKn8fjnXvpJY6mS8HHuJxG89ueVN8Svym8/Al0bF/FcT+zGsbc+Uh488PDinHXZ7QUecT+iYe+pE2pdJtdeh1xFB8Sbegr3dMOJxdL54ucqCDrfv5ubHTgQmwAXPbK0SM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BCwyHiX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BCwyHiX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9F1C4CEE7;
	Thu,  3 Apr 2025 02:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743648967;
	bh=4GiYzvODgABNJTtnUdM0lDcRrvLL0LuO4J/mWg3lqWM=;
	h=Date:To:From:Subject:From;
	b=BCwyHiX6VuHQbKNabc5KucO3/BrOszcTRDD9WDedf6jRy9nXraz+gCLTmSDKHaquG
	 shPdk/apaqHy6XpYEs95bs+WtogWoLr3HT002dJlM45TepbgB66HNCSal0JNDGes6F
	 KQAmpitaQHRFRPc6/4P3PF6K9rQz0IH85NKArIdM=
Date: Wed, 02 Apr 2025 19:56:07 -0700
To: mm-commits@vger.kernel.org,tim.bird@sony.com,rostedt@goodmis.org,francesco@valla.it,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-mainc-log-initcall-level-when-initcall_debug-is-used-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250403025607.BF9F1C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init-mainc-log-initcall-level-when-initcall_debug-is-used-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-mainc-log-initcall-level-when-initcall_debug-is-used-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-mainc-log-initcall-level-when-initcall_debug-is-used-fix.patch

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
Subject: init-mainc-log-initcall-level-when-initcall_debug-is-used-fix
Date: Wed Apr  2 07:54:29 PM PDT 2025

use pr_debug()

Cc: Francesco Valla <francesco@valla.it>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tim Bird <tim.bird@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~init-mainc-log-initcall-level-when-initcall_debug-is-used-fix
+++ a/init/main.c
@@ -1217,7 +1217,7 @@ trace_initcall_finish_cb(void *data, ini
 static __init_or_module void
 trace_initcall_level_cb(void *data, const char *level)
 {
-	printk(KERN_DEBUG "entering initcall level: %s\n", level);
+	pr_debug("entering initcall level: %s\n", level);
 }
 
 static ktime_t initcall_calltime;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

radix-tree-add-missing-cleanuph-fix.patch
init-mainc-log-initcall-level-when-initcall_debug-is-used-fix.patch

