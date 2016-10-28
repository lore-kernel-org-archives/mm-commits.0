From: akpm@linux-foundation.org
Subject: [merged] latent_entropy-raise-config_frame_warn-by-default.patch
 removed from -mm tree
Date: Fri, 28 Oct 2016 11:30:33 -0700
Message-ID: <58139949.7QqtS6INEGHKnKCP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45734 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966112AbcJ1Sae (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2016 14:30:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, aryabinin@virtuozzo.com, dan.j.williams@intel.com, dvyukov@google.com, fengguang.wu@intel.com, jpoimboe@redhat.com, mingo@kernel.org, mmarek@suse.com, nikolay@cumulusnetworks.com, paulmck@linux.vnet.ibm.com, re.emese@gmail.com, shuah@kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: latent_entropy: raise CONFIG_FRAME_WARN by default
has been removed from the -mm tree.  Its filename was
     latent_entropy-raise-config_frame_warn-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: latent_entropy: raise CONFIG_FRAME_WARN by default

When building with the latent_entropy plugin, set the default
CONFIG_FRAME_WARN to 2048, since some __init functions have many basic
blocks that, when instrumented by the latent_entropy plugin, grow beyond
1024 byte stack size on 32-bit builds.

Link: http://lkml.kernel.org/r/20161018211216.GA39687@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Emese Revfy <re.emese@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Marek <mmarek@suse.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/Kconfig.debug~latent_entropy-raise-config_frame_warn-by-default lib/Kconfig.debug
--- a/lib/Kconfig.debug~latent_entropy-raise-config_frame_warn-by-default
+++ a/lib/Kconfig.debug
@@ -198,6 +198,7 @@ config FRAME_WARN
 	int "Warn for stack frames larger than (needs gcc 4.4)"
 	range 0 8192
 	default 0 if KASAN
+	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
 	default 1024 if !64BIT
 	default 2048 if 64BIT
 	help
_

Patches currently in -mm which might be from keescook@chromium.org are


