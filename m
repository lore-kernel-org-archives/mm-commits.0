From: akpm@linux-foundation.org
Subject: [merged] tile-fix-personality-bits-handling-upon-exec.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:13:56 -0700
Message-ID: <20121005201356.B02E0100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42422 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2JEUN5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:13:57 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so93671qae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:13:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, cmetcalf@tilera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tile: fix personality bits handling upon exec()
has been removed from the -mm tree.  Its filename was
     tile-fix-personality-bits-handling-upon-exec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: tile: fix personality bits handling upon exec()

Historically, the top three bytes of personality have been used for things
such as ADDR_NO_RANDOMIZE, which made sense only for specific
architectures.

We now however have a flag there that is general no matter the
architecture (UNAME26); generally we have to be careful to preserve the
personality flags across exec().

This patch fixes tile architecture not to forcefully overwrite personality
flags during exec().

In addition to that, we fix two other things along the way:

- exec_domain switching is fixed -- set_personality() should always
  be used instead of directly assigning to current->personality.
- as pointed out by Arnd Bergmann, PER_LINUX_32BIT is not used anywhere
  by tile, so let's just drop that in favor of PER_LINUX

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/asm/elf.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/tile/include/asm/elf.h~tile-fix-personality-bits-handling-upon-exec arch/tile/include/asm/elf.h
--- a/arch/tile/include/asm/elf.h~tile-fix-personality-bits-handling-upon-exec
+++ a/arch/tile/include/asm/elf.h
@@ -156,12 +156,12 @@ extern int arch_setup_additional_pages(s
 #undef SET_PERSONALITY
 #define SET_PERSONALITY(ex) \
 do { \
-	current->personality = PER_LINUX; \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK))); \
 	current_thread_info()->status &= ~TS_COMPAT; \
 } while (0)
 #define COMPAT_SET_PERSONALITY(ex) \
 do { \
-	current->personality = PER_LINUX_32BIT; \
+	set_personality(PER_LINUX | (current->personality & (~PER_MASK))); \
 	current_thread_info()->status |= TS_COMPAT; \
 } while (0)
 
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch
memorytxt-remove-stray-information.patch
cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus.patch
cpu-hotplug-debug-detect-imbalance-between-get_online_cpus-and-put_online_cpus-fix.patch

