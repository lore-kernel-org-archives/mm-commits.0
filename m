From: akpm@linux-foundation.org
Subject: + uml-kill-a-kconfig-warning.patch added to -mm tree
Date: Fri, 17 Apr 2009 11:46:06 -0700
Message-ID: <200904171846.n3HIk6ax002296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760859AbZDQSt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 14:49:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@addtoit.com, sam@ravnborg.org


The patch titled
     uml: kill a kconfig warning
has been added to the -mm tree.  Its filename is
     uml-kill-a-kconfig-warning.patch

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
Subject: uml: kill a kconfig warning
From: WANG Cong <xiyou.wangcong@gmail.com>

Got this warning from Kconfig:

   boolean symbol INPUT tested for 'm'? test forced to 'n'

because INPUT is tristate, not bool.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.rest |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/Kconfig.rest~uml-kill-a-kconfig-warning arch/um/Kconfig.rest
--- a/arch/um/Kconfig.rest~uml-kill-a-kconfig-warning
+++ a/arch/um/Kconfig.rest
@@ -36,7 +36,7 @@ source "drivers/leds/Kconfig"
 
 #This is just to shut up some Kconfig warnings, so no prompt.
 config INPUT
-	bool
+	tristate
 	default n
 
 source "arch/um/Kconfig.debug"
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

uml-kill-a-kconfig-warning.patch
mm-consolidate-init_mm-definition.patch
mm-consolidate-init_mm-definition-fix.patch

