From: akpm@linux-foundation.org
Subject: + basic-braille-screen-reader-support-makefile-fix.patch added to -mm tree
Date: Fri, 21 Mar 2008 14:52:34 -0700
Message-ID: <200803212152.m2LLqZUt012175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756146AbYCUVyd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 17:54:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org, randy.dunlap@oracle.com


The patch titled
     Basic braille screen reader support makefile fix
has been added to the -mm tree.  Its filename is
     basic-braille-screen-reader-support-makefile-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: Basic braille screen reader support makefile fix
=46rom: Samuel Thibault <samuel.thibault@ens-lyon.org>

Randy Dunlap, le Wed 19 Mar 2008 11:57:26 -0700, a =E9crit :
> when O=3Ddir is used in make:
>
>   CC      drivers/accessibility/braille/braille_console.o
> Assembler messages:
> Fatal error: can't create drivers/accessibility/braille/braille_conso=
le.o: No such file or directory
>   CC      crypto/aes_generic.o
> make[3]: *** [drivers/accessibility/braille/braille_console.o] Error =
2
> make[2]: *** [drivers/accessibility] Error 2
> make[1]: *** [drivers] Error 2

Oh, right, the patch below should fix it

Properly recurse Makefiles into accessibility and accessibility/braille=
/

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/accessibility/Makefile         |    2 +-
 drivers/accessibility/braille/Makefile |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/accessibility/Makefile~basic-braille-screen-reader-su=
pport-makefile-fix drivers/accessibility/Makefile
--- a/drivers/accessibility/Makefile~basic-braille-screen-reader-suppor=
t-makefile-fix
+++ a/drivers/accessibility/Makefile
@@ -1 +1 @@
-obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)		+=3D braille/braille_console.o
+obj-y				+=3D braille/
diff -puN /dev/null drivers/accessibility/braille/Makefile
--- /dev/null
+++ a/drivers/accessibility/braille/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)		+=3D braille_console.o
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.o=
rg are

origin.patch
input-put-ledstate-in-the-keyboard-notifier.patch
vt-notifier-extension-for-accessibility.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
basic-braille-screen-reader-support.patch
basic-braille-screen-reader-support-fixes.patch
basic-braille-screen-reader-support-ppc-fix.patch
basic-braille-screen-reader-support-doc.patch
basic-braille-screen-reader-support-makefile-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
