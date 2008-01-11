From: akpm@linux-foundation.org
Subject: + cris-v10-driver-for-ds1302-needs-to-include-cris-specific-i2ch.patch added to -mm tree
Date: Fri, 11 Jan 2008 15:45:23 -0800
Message-ID: <200801112345.m0BNjNpL003997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762955AbYAKXp2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 18:45:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, mikael.starvik@axis.com


The patch titled
     CRIS v10: driver for ds1302 needs to include cris-specific i2c.h
has been added to the -mm tree.  Its filename is
     cris-v10-driver-for-ds1302-needs-to-include-cris-specific-i2ch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CRIS v10: driver for ds1302 needs to include cris-specific i2c.h
From: Jesper Nilsson <jesper.nilsson@axis.com>

CRIS v10: Driver for ds1302 needs to include cris-specific i2c.h

This fixes compilation error where i2c_init wasn't defined.
Also, remove the CVS log and version tags, they are no longer useful.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/drivers/ds1302.c |  131 --------------------------
 1 file changed, 3 insertions(+), 128 deletions(-)

diff -puN arch/cris/arch-v10/drivers/ds1302.c~cris-v10-driver-for-ds1302-needs-to-include-cris-specific-i2ch arch/cris/arch-v10/drivers/ds1302.c
--- a/arch/cris/arch-v10/drivers/ds1302.c~cris-v10-driver-for-ds1302-needs-to-include-cris-specific-i2ch
+++ a/arch/cris/arch-v10/drivers/ds1302.c
@@ -6,136 +6,9 @@
 *!
 *! Functions exported: ds1302_readreg, ds1302_writereg, ds1302_init
 *!
-*! $Log: ds1302.c,v $
-*! Revision 1.18  2005/01/24 09:11:26  mikaelam
-*! Minor changes to get DS1302 RTC chip driver to work
-*!
-*! Revision 1.17  2005/01/05 06:11:22  starvik
-*! No need to do local_irq_disable after local_irq_save.
-*!
-*! Revision 1.16  2004/12/13 12:21:52  starvik
-*! Added I/O and DMA allocators from Linux 2.4
-*!
-*! Revision 1.14  2004/08/24 06:48:43  starvik
-*! Whitespace cleanup
-*!
-*! Revision 1.13  2004/05/28 09:26:59  starvik
-*! Modified I2C initialization to work in 2.6.
-*!
-*! Revision 1.12  2004/05/14 07:58:03  starvik
-*! Merge of changes from 2.4
-*!
-*! Revision 1.10  2004/02/04 09:25:12  starvik
-*! Merge of Linux 2.6.2
-*!
-*! Revision 1.9  2003/07/04 08:27:37  starvik
-*! Merge of Linux 2.5.74
-*!
-*! Revision 1.8  2003/04/09 05:20:47  starvik
-*! Merge of Linux 2.5.67
-*!
-*! Revision 1.6  2003/01/09 14:42:51  starvik
-*! Merge of Linux 2.5.55
-*!
-*! Revision 1.4  2002/12/11 13:13:57  starvik
-*! Added arch/ to v10 specific includes
-*! Added fix from Linux 2.4 in serial.c (flush_to_flip_buffer)
-*!
-*! Revision 1.3  2002/11/20 11:56:10  starvik
-*! Merge of Linux 2.5.48
-*!
-*! Revision 1.2  2002/11/18 13:16:06  starvik
-*! Linux 2.5 port of latest 2.4 drivers
-*!
-*! Revision 1.15  2002/10/11 16:14:33  johana
-*! Added CONFIG_ETRAX_DS1302_TRICKLE_CHARGE and initial setting of the
-*! trcklecharge register.
-*!
-*! Revision 1.14  2002/10/10 12:15:38  magnusmn
-*! Added support for having the RST signal on bit g0
-*!
-*! Revision 1.13  2002/05/29 15:16:08  johana
-*! Removed unused variables.
-*!
-*! Revision 1.12  2002/04/10 15:35:25  johana
-*! Moved probe function closer to init function and marked it __init.
-*!
-*! Revision 1.11  2001/06/14 12:35:52  jonashg
-*! The ATA hack is back. It is unfortunately the only way to set g27 to output.
-*!
-*! Revision 1.9  2001/06/14 10:00:14  jonashg
-*! No need for tempudelay to be inline anymore (had to adjust the usec to
-*! loops conversion because of this to make it slow enough to be a udelay).
-*!
-*! Revision 1.8  2001/06/14 08:06:32  jonashg
-*! Made tempudelay delay usecs (well, just a tad more).
-*!
-*! Revision 1.7  2001/06/13 14:18:11  jonashg
-*! Only allow processes with SYS_TIME capability to set time and charge.
-*!
-*! Revision 1.6  2001/06/12 15:22:07  jonashg
-*! * Made init function __init.
-*! * Parameter to out_byte() is unsigned char.
-*! * The magic number 42 has got a name.
-*! * Removed comment about /proc (nothing is exported there).
-*!
-*! Revision 1.5  2001/06/12 14:35:13  jonashg
-*! Gave the module a name and added it to printk's.
-*!
-*! Revision 1.4  2001/05/31 14:53:40  jonashg
-*! Made tempudelay() inline so that the watchdog doesn't reset (see
-*! function comment).
-*!
-*! Revision 1.3  2001/03/26 16:03:06  bjornw
-*! Needs linux/config.h
-*!
-*! Revision 1.2  2001/03/20 19:42:00  bjornw
-*! Use the ETRAX prefix on the DS1302 options
-*!
-*! Revision 1.1  2001/03/20 09:13:50  magnusmn
-*! Linux 2.4 port
-*!
-*! Revision 1.10  2000/07/05 15:38:23  bjornw
-*! Dont update kernel time when a RTC_SET_TIME is done
-*!
-*! Revision 1.9  2000/03/02 15:42:59  macce
-*! * Hack to make RTC work on all 2100/2400
-*!
-*! Revision 1.8  2000/02/23 16:59:18  torbjore
-*! added setup of R_GEN_CONFIG when RTC is connected to the generic port.
-*!
-*! Revision 1.7  2000/01/17 15:51:43  johana
-*! Added RTC_SET_CHARGE ioctl to enable trickle charger.
-*!
-*! Revision 1.6  1999/10/27 13:19:47  bjornw
-*! Added update_xtime_from_cmos which reads back the updated RTC into the kernel.
-*! /dev/rtc calls it now.
-*!
-*! Revision 1.5  1999/10/27 12:39:37  bjornw
-*! Disabled superuser check. Anyone can now set the time.
-*!
-*! Revision 1.4  1999/09/02 13:27:46  pkj
-*! Added shadow for R_PORT_PB_CONFIG.
-*! Renamed port_g_shadow to port_g_data_shadow.
-*!
-*! Revision 1.3  1999/09/02 08:28:06  pkj
-*! Made it possible to select either port PB or the generic port for the RST
-*! signal line to the DS1302 RTC.
-*! Also make sure the RST bit is configured as output on Port PB (if used).
-*!
-*! Revision 1.2  1999/09/01 14:47:20  bjornw
-*! Added support for /dev/rtc operations with ioctl RD_TIME and SET_TIME to read
-*! and set the date. Register as major 121.
-*!
-*! Revision 1.1  1999/09/01 09:45:29  bjornw
-*! Implemented a DS1302 RTC driver.
-*!
-*!
 *! ---------------------------------------------------------------------------
 *!
-*! (C) Copyright 1999, 2000, 2001, 2002, 2003, 2004  Axis Communications AB, LUND, SWEDEN
-*!
-*! $Id: ds1302.c,v 1.18 2005/01/24 09:11:26 mikaelam Exp $
+*! (C) Copyright 1999-2007 Axis Communications AB, LUND, SWEDEN
 *!
 *!***************************************************************************/
 
@@ -156,6 +29,8 @@
 #include <asm/rtc.h>
 #include <asm/arch/io_interface_mux.h>
 
+#include "i2c.h"
+
 #define RTC_MAJOR_NR 121 /* local major, change later */
 
 static const char ds1302_name[] = "ds1302";
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

cris-v10-correct-do_signal-to-fix-oops-and-clean-up-signal-handling-in-general.patch
cris-v10-kernel-timec-needs-to-include-linux-vmstath-to-compile.patch
cris-v10-driver-for-ds1302-needs-to-include-cris-specific-i2ch.patch
git-kbuild.patch
git-mtd.patch
cris-avoid-using-arch-links-in-kconfig.patch
arch-cris-arch-v10-vmlinuxldss-fix-boot-problem.patch
cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh.patch
cris-define-__arch_want_sys_rt_sigsuspend-in-unistdh-for-cris.patch
avoid-overflows-in-kernel-timec.patch
