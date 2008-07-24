From: akpm@linux-foundation.org
Subject: - mdacon-messing-up-default-vcs-set-default-to-vc13-16-again.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:39 -0700
Message-ID: <200807242331.m6ONVdiC011656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756067AbYGXXb7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: devzero@web.de, adaplas@pol.net, jengelh@gmx.de, jsimmons@infradead.org, tim@physik3.uni-rostock.de, mm-commits@vger.kernel.org


The patch titled
     mdacon messing up default vc's - set default to vc13-16 again
has been removed from the -mm tree.  Its filename was
     mdacon-messing-up-default-vcs-set-default-to-vc13-16-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mdacon messing up default vc's - set default to vc13-16 again
From: Roland Kletzing <devzero@web.de>

mdacon incorrectly detects MDA hardware on systems without such graphics card.

One may load this module by chance, for example when doing some systematical
module-testing, and if there is no Monochrome Display Adapter attached ,
module init renders vc1-16 completely unusable.

I and others have run into this more than once.  see [Bug 224522 - modprobe
mdacon freezes machine -> https://bugzilla.novell.com/show_bug.cgi?id=224522 ]
for example

Apparently  proper MDA detection seems to be broken for a long time - seems to
be related to those #ifdef TEST_MDA_B statements added by Edward Betts.

this commit back in 2002 made things even worse :
http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commit;h=c72757b49c88914433244757fb4967fc63546685

It changed default vc allocation from 13-16 to 1-16 for no apparent reason
(!?) , and with that (and without X), mdacon grabs the vc you`re currently
sitting on and locks you out.

this is from Kconfig :
>config MDA_CONSOLE
>        depends on !M68K && !PARISC && ISA
>        tristate "MDA text console (dual-headed) (EXPERIMENTAL)"
>        ---help---
>          Say Y here if you have an old MDA or monochrome Hercules graphics
>          adapter in your system acting as a second head ( = video card). You
>          will then be able to use two monitors with your Linux system. Do not
>          say Y here if your MDA card is the primary card in your system; the
>          normal VGA driver will handle it.

As we can see mdacon is just meant as an additional driver for dual-head
setup, and since kernel 2.4.36 still defaults to vc13-16 , setting the default
back to that value again shouldn`t do any harm.

Hereby i'm reverting that change, setting default back to to vc13-16 again.

Besides the fact that mdacon may be rarely or never be used these days and
could perhaps put to trash anyway (pre-dinosaur hardware!), indeed this is not
a real solution, but at least it removes the unfortunate side-effect of
messing up the vc you`re working on.

Signed-off-by: Roland Kletzing <devzero@web.de>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Tim Schmielau <tim@physik3.uni-rostock.de>
Cc: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/mdacon.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/console/mdacon.c~mdacon-messing-up-default-vcs-set-default-to-vc13-16-again drivers/video/console/mdacon.c
--- a/drivers/video/console/mdacon.c~mdacon-messing-up-default-vcs-set-default-to-vc13-16-again
+++ a/drivers/video/console/mdacon.c
@@ -71,13 +71,15 @@ static char *mda_type_name;
 
 /* console information */
 
-static int	mda_first_vc = 1;
+static int	mda_first_vc = 13;
 static int	mda_last_vc  = 16;
 
 static struct vc_data	*mda_display_fg = NULL;
 
 module_param(mda_first_vc, int, 0);
+MODULE_PARM_DESC(mda_first_vc, "First virtual console. Default: 13");
 module_param(mda_last_vc, int, 0);
+MODULE_PARM_DESC(mda_last_vc, "Last virtual console. Default: 16");
 
 /* MDA register values
  */
_

Patches currently in -mm which might be from devzero@web.de are

origin.patch

