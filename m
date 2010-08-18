From: akpm@linux-foundation.org
Subject: + vmcore-it-is-not-experimental-any-more.patch added to -mm tree
Date: Wed, 18 Aug 2010 16:00:33 -0700
Message-ID: <201008182300.o7IN0X8f016947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006Ab0HRXAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 19:00:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com


The patch titled
     vmcore: it is not experimental any more
has been added to the -mm tree.  Its filename is
     vmcore-it-is-not-experimental-any-more.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmcore: it is not experimental any more
From: WANG Cong <xiyou.wangcong@gmail.com>

We use vmcore in our production kernel for a long time, it is pretty
stable now.  So I don't think we need to mark it as experimental any more.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/Kconfig~vmcore-it-is-not-experimental-any-more fs/proc/Kconfig
--- a/fs/proc/Kconfig~vmcore-it-is-not-experimental-any-more
+++ a/fs/proc/Kconfig
@@ -33,8 +33,8 @@ config PROC_KCORE
 	depends on PROC_FS && MMU
 
 config PROC_VMCORE
-        bool "/proc/vmcore support (EXPERIMENTAL)"
-        depends on PROC_FS && CRASH_DUMP
+	bool "/proc/vmcore support"
+	depends on PROC_FS && CRASH_DUMP
 	default y
         help
         Exports the dump image of crashed kernel in ELF format.
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

vmcore-it-is-not-experimental-any-more.patch

