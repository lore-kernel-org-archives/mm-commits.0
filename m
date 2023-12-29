Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B191213FE1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uiUL22oK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7672FC433C7;
	Fri, 29 Dec 2023 20:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881395;
	bh=oeBvU5ju38xFljdajm3k6BI9IZVjLfClj3g8Qd6F8k8=;
	h=Date:To:From:Subject:From;
	b=uiUL22oKXaj0vTAcY5WmmtJZRQ8C+TCxtdxTyGvAPPdQTdeJEAtPP2auM1jcpvcm7
	 wz5c4S0a2PkbRKKruKN/hkTkkRknSBmnetC8YE9G615Wv7MUFux/JAbUDrW8ph5rCo
	 k5G+oBUY6nBLtWAY9+2ol72n+aDXlmC6WgNyWdOc=
Date: Fri, 29 Dec 2023 12:23:14 -0800
To: mm-commits@vger.kernel.org,zhaoyang.huang@unisoc.com,sboyd@kernel.org,rdunlap@infradead.org,pmladek@suse.com,paulmck@kernel.org,kernel@pengutronix.de,keescook@chromium.org,geert+renesas@glider.be,elver@google.com,dianders@chromium.org,u.kleine-koenig@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-add-note-about-process-exit-message-for-debug_stack_usage.patch removed from -mm tree
Message-Id: <20231229202315.7672FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: add note about process exit message for DEBUG_STACK_USAGE
has been removed from the -mm tree.  Its filename was
     lib-add-note-about-process-exit-message-for-debug_stack_usage.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


