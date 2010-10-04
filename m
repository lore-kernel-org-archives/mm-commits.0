From: akpm@linux-foundation.org
Subject: + hpet-factor-timer-allocate-from-open-fix.patch added to -mm tree
Date: Mon, 04 Oct 2010 13:15:36 -0700
Message-ID: <201010042015.o94KFaiV011907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756005Ab0JDUQK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 16:16:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, clemens@ladisch.de, johnstul@us.ibm.com, maglyx@gmail.com, tglx@linutronix.de


The patch titled
     hpet-factor-timer-allocate-from-open-fix
has been added to the -mm tree.  Its filename is
     hpet-factor-timer-allocate-from-open-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: hpet-factor-timer-allocate-from-open-fix
=46rom: Arnd Bergmann <arnd@arndb.de>

On Wednesday 29 September 2010, Andrew Morton wrote:
> 2010/9/29  <akpm@linux-foundation.org>:
> > The mm-of-the-moment snapshot 2010-09-28-16-13 has been uploaded to
>
> drivers/char/hpet.c: In function 'hpet_alloc_timer':
> drivers/char/hpet.c:278: error: implicit declaration of function 'unl=
ock_kernel'
> make[2]: *** [drivers/char/hpet.o] B=C5=82=C4=85d 1
> make[1]: *** [drivers/char] B=C5=82=C4=85d 2
> make: *** [drivers] B=C5=82=C4=85d 2

It comes from this patch:

http://userweb.kernel.org/~akpm/mmotm/broken-out/hpet-factor-timer-allo=
cate-from-open.patch

Please fold the hunk below into that patch.

It should also be possible to get rid of the hpet_mutex entirely by
using hpet_lock consistently in the ioctl functions. Two global locks
for one driver is a bit too much.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Magnus Lynch <maglyx@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/hpet.c~hpet-factor-timer-allocate-from-open-fix =
drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-factor-timer-allocate-from-open-fix
+++ a/drivers/char/hpet.c
@@ -275,7 +275,7 @@ static int hpet_alloc_timer(struct file=20
 	devp =3D file->private_data;
 	if (devp->hd_timer) {
 		spin_unlock_irq(&hpet_lock);
-		unlock_kernel();
+		mutex_unlock(&hpet_mutex);
 		return 0;
 	}
=20
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
linux-next.patch
hpet-factor-timer-allocate-from-open-fix.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
autofs-only-declare-function-when-config_compat-is-defined.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
