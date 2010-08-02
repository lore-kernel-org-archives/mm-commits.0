From: akpm@linux-foundation.org
Subject: + drivers-serial-68328serialc-check-return-value-of-copy__user-instead-of-access_ok.patch added to -mm tree
Date: Mon, 02 Aug 2010 16:44:24 -0700
Message-ID: <201008022344.o72NiORE018538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836Ab0HBXo1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Aug 2010 19:44:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com, greg@kroah.com


The patch titled
     drivers/serial/68328serial.c: check return value of copy_*_user() instead of access_ok()
has been added to the -mm tree.  Its filename is
     drivers-serial-68328serialc-check-return-value-of-copy__user-instead-of-access_ok.patch

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
Subject: drivers/serial/68328serial.c: check return value of copy_*_user() instead of access_ok()
From: Kulikov Vasiliy <segooon@gmail.com>

As copy_*_user() calls access_ok() it should not be called explicitly.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/68328serial.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff -puN drivers/serial/68328serial.c~drivers-serial-68328serialc-check-return-value-of-copy__user-instead-of-access_ok drivers/serial/68328serial.c
--- a/drivers/serial/68328serial.c~drivers-serial-68328serialc-check-return-value-of-copy__user-instead-of-access_ok
+++ a/drivers/serial/68328serial.c
@@ -869,7 +869,9 @@ static int get_serial_info(struct m68k_s
 	tmp.close_delay = info->close_delay;
 	tmp.closing_wait = info->closing_wait;
 	tmp.custom_divisor = info->custom_divisor;
-	copy_to_user(retinfo,&tmp,sizeof(*retinfo));
+	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
+		return -EFAULT;
+
 	return 0;
 }
 
@@ -882,7 +884,8 @@ static int set_serial_info(struct m68k_s
 
 	if (!new_info)
 		return -EFAULT;
-	copy_from_user(&new_serial,new_info,sizeof(new_serial));
+	if (copy_from_user(&new_serial, new_info, sizeof(new_serial)))
+		return -EFAULT;
 	old_info = *info;
 
 	if (!capable(CAP_SYS_ADMIN)) {
@@ -943,8 +946,7 @@ static int get_lsr_info(struct m68k_seri
 	status = 0;
 #endif
 	local_irq_restore(flags);
-	put_user(status,value);
-	return 0;
+	return put_user(status, value);
 }
 
 /*
@@ -999,27 +1001,18 @@ static int rs_ioctl(struct tty_struct *t
 			send_break(info, arg ? arg*(100) : 250);
 			return 0;
 		case TIOCGSERIAL:
-			if (access_ok(VERIFY_WRITE, (void *) arg,
-						sizeof(struct serial_struct)))
-				return get_serial_info(info,
-					       (struct serial_struct *) arg);
-			return -EFAULT;
+			return get_serial_info(info,
+				       (struct serial_struct *) arg);
 		case TIOCSSERIAL:
 			return set_serial_info(info,
 					       (struct serial_struct *) arg);
 		case TIOCSERGETLSR: /* Get line status register */
-			if (access_ok(VERIFY_WRITE, (void *) arg,
-						sizeof(unsigned int)))
-				return get_lsr_info(info, (unsigned int *) arg);
-			return -EFAULT;
+			return get_lsr_info(info, (unsigned int *) arg);
 		case TIOCSERGSTRUCT:
-			if (!access_ok(VERIFY_WRITE, (void *) arg,
-						sizeof(struct m68k_serial)))
+			if (copy_to_user((struct m68k_serial *) arg,
+				    info, sizeof(struct m68k_serial)))
 				return -EFAULT;
-			copy_to_user((struct m68k_serial *) arg,
-				    info, sizeof(struct m68k_serial));
 			return 0;
-			
 		default:
 			return -ENOIOCTLCMD;
 		}
_

Patches currently in -mm which might be from segooon@gmail.com are

linux-next.patch
drivers-serial-68328serialc-check-return-value-of-copy__user-instead-of-access_ok.patch
cpqarray-check-put_user-result.patch
mm-vmallocc-check-kmalloc-return-value.patch
i2o-fix-overflow-of-copy_to_user.patch
i2o-check-return-code-from-put_user.patch
drivers-video-igafbc-introduce-lost-return.patch
drivers-video-igafbc-make-igafb_setup-and-igafb_init-static.patch
edac-i5000-improve-handling-of-pci_enable_device-return-value.patch
edac-i5400-improve-handling-of-pci_enable_device-return-value.patch

