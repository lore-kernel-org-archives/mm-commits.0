Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F363D0A2
	for <mm-commits@vger.kernel.org>; Tue, 19 Dec 2023 20:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t3XYfDYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576BAC433C8;
	Tue, 19 Dec 2023 20:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703018883;
	bh=pJWiRH5YTOBpxpBmA8oQYKRGCFkGnuYnOdRkY/09ErU=;
	h=Date:To:From:Subject:From;
	b=t3XYfDYf1C6ZYWoJN1mcOOdXaRFzhGcsa0bo52rwR5SreGewLhDwevQ5hUWS4sWOs
	 MDQaY+d2oGunTwTWh/qGglycTscFnX+HCKzTYqEXjX94uPM6Q3sscTc4UnZ5uMOEoW
	 6xV1havK+Bl9x7Mb8FwW4mVhfkkngwUX3yxQTSII=
Date: Tue, 19 Dec 2023 12:48:02 -0800
To: mm-commits@vger.kernel.org,zhaoyang.huang@unisoc.com,sboyd@kernel.org,rdunlap@infradead.org,pmladek@suse.com,paulmck@kernel.org,kernel@pengutronix.de,keescook@chromium.org,geert+renesas@glider.be,elver@google.com,dianders@chromium.org,u.kleine-koenig@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-note-about-process-exit-message-for-debug_stack_usage.patch added to mm-nonmm-unstable branch
Message-Id: <20231219204803.576BAC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: add note about process exit message for DEBUG_STACK_USAGE
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-add-note-about-process-exit-message-for-debug_stack_usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-note-about-process-exit-message-for-debug_stack_usage.patch

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
From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Subject: lib: add note about process exit message for DEBUG_STACK_USAGE
Date: Tue, 19 Dec 2023 19:28:09 +0100

DEBUG_STACK_USAGE doesn't only have an influence on the output of sysrq-T
and sysrq-P, it also enables a message at process exit.  See
check_stack_usage() in kernel/exit.c where this is implemented.

Link: https://lkml.kernel.org/r/20231219182808.210284-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/Kconfig.debug~lib-add-note-about-process-exit-message-for-debug_stack_usage
+++ a/lib/Kconfig.debug
@@ -763,6 +763,8 @@ config DEBUG_STACK_USAGE
 	help
 	  Enables the display of the minimum amount of free stack which each
 	  task has ever had available in the sysrq-T and sysrq-P debug output.
+	  Also emits a message to dmesg when a process exits if that process
+	  used more stack space than previously exiting processes.
 
 	  This option will slow down process creation somewhat.
 
_

Patches currently in -mm which might be from u.kleine-koenig@pengutronix.de are

lib-add-note-about-process-exit-message-for-debug_stack_usage.patch

