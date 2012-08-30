From: akpm@linux-foundation.org
Subject: + tile-fix-personality-bits-handling-upon-exec.patch added to -mm tree
Date: Thu, 30 Aug 2012 15:14:24 -0700
Message-ID: <20120830221424.A1AAA1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36603 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab2H3WOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Aug 2012 18:14:25 -0400
Received: by ggnu1 with SMTP id u1so274700ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 30 Aug 2012 15:14:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, cmetcalf@tilera.com


The patch titled
     Subject: tile: fix personality bits handling upon exec()
has been added to the -mm tree.  Its filename is
     tile-fix-personality-bits-handling-upon-exec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
cross-arch-dont-corrupt-personality-flags-upon-exec.patch
tile-fix-personality-bits-handling-upon-exec.patch

