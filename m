From: akpm@linux-foundation.org
Subject: - gdth-build-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:17:37 -0700
Message-ID: <200710150917.l9F9HbIh027293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58293 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756130AbXJOJVk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:21:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhaval@linux.vnet.ibm.com, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     gdth build fix
has been removed from the -mm tree.  Its filename was
     gdth-build-fix.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: gdth build fix
=46rom: Dhaval Giani <dhaval@linux.vnet.ibm.com>

drivers/scsi/gdth.c: In function =E2=80=98gdth_search_dev=E2=80=99:
drivers/scsi/gdth.c:646: warning: =E2=80=98pci_find_device=E2=80=99 is =
deprecated
(declared at include/linux/pci.h:482)
drivers/scsi/gdth.c: In function =E2=80=98gdth_init_isa=E2=80=99:
drivers/scsi/gdth.c:857: error: =E2=80=98gdth_irq_tab=E2=80=99 undeclar=
ed (first use in
this function)
drivers/scsi/gdth.c:857: error: (Each undeclared identifier is reported
only once
drivers/scsi/gdth.c:857: error: for each function it appears in.)
drivers/scsi/gdth.c: In function =E2=80=98gdth_copy_internal_data=E2=80=
=99:
drivers/scsi/gdth.c:2362: warning: unused variable =E2=80=98sg=E2=80=99
make[2]: *** [drivers/scsi/gdth.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2
[dhaval@gondor linux-2.6.23]$

Looking into the code I notice that gdth_irq_tab is not declared with
CONFIG_ISA=3Dy and !CONFIG_EISA.

The values seem to be same in 2.6.23 (I am not sure why it has been put
with #ifdefs in -mm) so I have just modified the #ifdef to take care of
CONFIG_ISA as well.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/gdth.c~gdth-build-fix drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~gdth-build-fix
+++ a/drivers/scsi/gdth.c
@@ -288,7 +288,7 @@ static struct timer_list gdth_timer;
 #ifdef CONFIG_ISA
 static unchar   gdth_drq_tab[4] =3D {5,6,7,7};            /* DRQ table=
 */
 #endif
-#ifdef CONFIG_EISA
+#if defined(CONFIG_EISA) || defined(CONFIG_ISA)
 static unchar   gdth_irq_tab[6] =3D {0,10,11,12,14,0};    /* IRQ table=
 */
 #endif
 static unchar   gdth_polling;                           /* polling if =
TRUE */
_

Patches currently in -mm which might be from dhaval@linux.vnet.ibm.com =
are

origin.patch
git-sched.patch
git-scsi-misc.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
