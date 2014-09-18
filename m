From: akpm@linux-foundation.org
Subject: + video-fbdev-replace-strnicmp-with-strncasecmp.patch added to
 -mm tree
Date: Thu, 18 Sep 2014 14:36:09 -0700
Message-ID: <541b5049.s0rzkmK36G0Euigz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041AbaIRVgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 17:36:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: video: fbdev: replace strnicmp with strncasecmp
has been added to the -mm tree.  Its filename is
     video-fbdev-replace-strnicmp-with-strncasecmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/video-fbdev-replace-strnicmp-with-strncasecmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/video-fbdev-replace-strnicmp-with-strncasecmp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: video: fbdev: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/pvr2fb.c       |    2 
 drivers/video/fbdev/s3c2410fb.c    |    8 +--
 drivers/video/fbdev/sis/sis_main.c |   66 +++++++++++++--------------
 drivers/video/fbdev/sm501fb.c      |    4 -
 4 files changed, 40 insertions(+), 40 deletions(-)

diff -puN drivers/video/fbdev/pvr2fb.c~video-fbdev-replace-strnicmp-with-strncasecmp drivers/video/fbdev/pvr2fb.c
--- a/drivers/video/fbdev/pvr2fb.c~video-fbdev-replace-strnicmp-with-strncasecmp
+++ a/drivers/video/fbdev/pvr2fb.c
@@ -1001,7 +1001,7 @@ static int pvr2_get_param(const struct p
 
 	for (i = 0 ; i < size ; i++ ) {
 		if (s != NULL) {
-			if (!strnicmp(p[i].name, s, strlen(s)))
+			if (!strncasecmp(p[i].name, s, strlen(s)))
 				return p[i].val;
 		} else {
 			if (p[i].val == val)
diff -puN drivers/video/fbdev/s3c2410fb.c~video-fbdev-replace-strnicmp-with-strncasecmp drivers/video/fbdev/s3c2410fb.c
--- a/drivers/video/fbdev/s3c2410fb.c~video-fbdev-replace-strnicmp-with-strncasecmp
+++ a/drivers/video/fbdev/s3c2410fb.c
@@ -601,12 +601,12 @@ static int s3c2410fb_debug_store(struct
 	if (len < 1)
 		return -EINVAL;
 
-	if (strnicmp(buf, "on", 2) == 0 ||
-	    strnicmp(buf, "1", 1) == 0) {
+	if (strncasecmp(buf, "on", 2) == 0 ||
+	    strncasecmp(buf, "1", 1) == 0) {
 		debug = 1;
 		dev_dbg(dev, "s3c2410fb: Debug On");
-	} else if (strnicmp(buf, "off", 3) == 0 ||
-		   strnicmp(buf, "0", 1) == 0) {
+	} else if (strncasecmp(buf, "off", 3) == 0 ||
+		   strncasecmp(buf, "0", 1) == 0) {
 		debug = 0;
 		dev_dbg(dev, "s3c2410fb: Debug Off");
 	} else {
diff -puN drivers/video/fbdev/sis/sis_main.c~video-fbdev-replace-strnicmp-with-strncasecmp drivers/video/fbdev/sis/sis_main.c
--- a/drivers/video/fbdev/sis/sis_main.c~video-fbdev-replace-strnicmp-with-strncasecmp
+++ a/drivers/video/fbdev/sis/sis_main.c
@@ -162,7 +162,7 @@ static void sisfb_search_mode(char *name
 		return;
 	}
 
-	if(!strnicmp(name, sisbios_mode[MODE_INDEX_NONE].name, strlen(name))) {
+	if(!strncasecmp(name, sisbios_mode[MODE_INDEX_NONE].name, strlen(name))) {
 		if(!quiet)
 			printk(KERN_ERR "sisfb: Mode 'none' not supported anymore. Using default.\n");
 
@@ -201,7 +201,7 @@ static void sisfb_search_mode(char *name
 
 	i = 0; j = 0;
 	while(sisbios_mode[i].mode_no[0] != 0) {
-		if(!strnicmp(nameptr, sisbios_mode[i++].name, strlen(nameptr))) {
+		if(!strncasecmp(nameptr, sisbios_mode[i++].name, strlen(nameptr))) {
 			if(sisfb_fstn) {
 				if(sisbios_mode[i-1].mode_no[1] == 0x50 ||
 				   sisbios_mode[i-1].mode_no[1] == 0x56 ||
@@ -262,7 +262,7 @@ sisfb_search_crt2type(const char *name)
 	if(name == NULL) return;
 
 	while(sis_crt2type[i].type_no != -1) {
-		if(!strnicmp(name, sis_crt2type[i].name, strlen(sis_crt2type[i].name))) {
+		if(!strncasecmp(name, sis_crt2type[i].name, strlen(sis_crt2type[i].name))) {
 			sisfb_crt2type = sis_crt2type[i].type_no;
 			sisfb_tvplug = sis_crt2type[i].tvplug_no;
 			sisfb_crt2flags = sis_crt2type[i].flags;
@@ -289,7 +289,7 @@ sisfb_search_tvstd(const char *name)
 		return;
 
 	while(sis_tvtype[i].type_no != -1) {
-		if(!strnicmp(name, sis_tvtype[i].name, strlen(sis_tvtype[i].name))) {
+		if(!strncasecmp(name, sis_tvtype[i].name, strlen(sis_tvtype[i].name))) {
 			sisfb_tvstd = sis_tvtype[i].type_no;
 			break;
 		}
@@ -308,12 +308,12 @@ sisfb_search_specialtiming(const char *n
 	if(name == NULL)
 		return;
 
-	if(!strnicmp(name, "none", 4)) {
+	if(!strncasecmp(name, "none", 4)) {
 		sisfb_specialtiming = CUT_FORCENONE;
 		printk(KERN_DEBUG "sisfb: Special timing disabled\n");
 	} else {
 		while(mycustomttable[i].chipID != 0) {
-			if(!strnicmp(name,mycustomttable[i].optionName,
+			if(!strncasecmp(name,mycustomttable[i].optionName,
 			   strlen(mycustomttable[i].optionName))) {
 				sisfb_specialtiming = mycustomttable[i].SpecialID;
 				found = true;
@@ -3952,68 +3952,68 @@ static int __init sisfb_setup(char *opti
 
 		if(!(*this_opt)) continue;
 
-		if(!strnicmp(this_opt, "off", 3)) {
+		if(!strncasecmp(this_opt, "off", 3)) {
 			sisfb_off = 1;
-		} else if(!strnicmp(this_opt, "forcecrt2type:", 14)) {
+		} else if(!strncasecmp(this_opt, "forcecrt2type:", 14)) {
 			/* Need to check crt2 type first for fstn/dstn */
 			sisfb_search_crt2type(this_opt + 14);
-		} else if(!strnicmp(this_opt, "tvmode:",7)) {
+		} else if(!strncasecmp(this_opt, "tvmode:",7)) {
 			sisfb_search_tvstd(this_opt + 7);
-		} else if(!strnicmp(this_opt, "tvstandard:",11)) {
+		} else if(!strncasecmp(this_opt, "tvstandard:",11)) {
 			sisfb_search_tvstd(this_opt + 11);
-		} else if(!strnicmp(this_opt, "mode:", 5)) {
+		} else if(!strncasecmp(this_opt, "mode:", 5)) {
 			sisfb_search_mode(this_opt + 5, false);
-		} else if(!strnicmp(this_opt, "vesa:", 5)) {
+		} else if(!strncasecmp(this_opt, "vesa:", 5)) {
 			sisfb_search_vesamode(simple_strtoul(this_opt + 5, NULL, 0), false);
-		} else if(!strnicmp(this_opt, "rate:", 5)) {
+		} else if(!strncasecmp(this_opt, "rate:", 5)) {
 			sisfb_parm_rate = simple_strtoul(this_opt + 5, NULL, 0);
-		} else if(!strnicmp(this_opt, "forcecrt1:", 10)) {
+		} else if(!strncasecmp(this_opt, "forcecrt1:", 10)) {
 			sisfb_forcecrt1 = (int)simple_strtoul(this_opt + 10, NULL, 0);
-		} else if(!strnicmp(this_opt, "mem:",4)) {
+		} else if(!strncasecmp(this_opt, "mem:",4)) {
 			sisfb_parm_mem = simple_strtoul(this_opt + 4, NULL, 0);
-		} else if(!strnicmp(this_opt, "pdc:", 4)) {
+		} else if(!strncasecmp(this_opt, "pdc:", 4)) {
 			sisfb_pdc = simple_strtoul(this_opt + 4, NULL, 0);
-		} else if(!strnicmp(this_opt, "pdc1:", 5)) {
+		} else if(!strncasecmp(this_opt, "pdc1:", 5)) {
 			sisfb_pdca = simple_strtoul(this_opt + 5, NULL, 0);
-		} else if(!strnicmp(this_opt, "noaccel", 7)) {
+		} else if(!strncasecmp(this_opt, "noaccel", 7)) {
 			sisfb_accel = 0;
-		} else if(!strnicmp(this_opt, "accel", 5)) {
+		} else if(!strncasecmp(this_opt, "accel", 5)) {
 			sisfb_accel = -1;
-		} else if(!strnicmp(this_opt, "noypan", 6)) {
+		} else if(!strncasecmp(this_opt, "noypan", 6)) {
 			sisfb_ypan = 0;
-		} else if(!strnicmp(this_opt, "ypan", 4)) {
+		} else if(!strncasecmp(this_opt, "ypan", 4)) {
 			sisfb_ypan = -1;
-		} else if(!strnicmp(this_opt, "nomax", 5)) {
+		} else if(!strncasecmp(this_opt, "nomax", 5)) {
 			sisfb_max = 0;
-		} else if(!strnicmp(this_opt, "max", 3)) {
+		} else if(!strncasecmp(this_opt, "max", 3)) {
 			sisfb_max = -1;
-		} else if(!strnicmp(this_opt, "userom:", 7)) {
+		} else if(!strncasecmp(this_opt, "userom:", 7)) {
 			sisfb_userom = (int)simple_strtoul(this_opt + 7, NULL, 0);
-		} else if(!strnicmp(this_opt, "useoem:", 7)) {
+		} else if(!strncasecmp(this_opt, "useoem:", 7)) {
 			sisfb_useoem = (int)simple_strtoul(this_opt + 7, NULL, 0);
-		} else if(!strnicmp(this_opt, "nocrt2rate", 10)) {
+		} else if(!strncasecmp(this_opt, "nocrt2rate", 10)) {
 			sisfb_nocrt2rate = 1;
-		} else if(!strnicmp(this_opt, "scalelcd:", 9)) {
+		} else if(!strncasecmp(this_opt, "scalelcd:", 9)) {
 			unsigned long temp = 2;
 			temp = simple_strtoul(this_opt + 9, NULL, 0);
 			if((temp == 0) || (temp == 1)) {
 			   sisfb_scalelcd = temp ^ 1;
 			}
-		} else if(!strnicmp(this_opt, "tvxposoffset:", 13)) {
+		} else if(!strncasecmp(this_opt, "tvxposoffset:", 13)) {
 			int temp = 0;
 			temp = (int)simple_strtol(this_opt + 13, NULL, 0);
 			if((temp >= -32) && (temp <= 32)) {
 			   sisfb_tvxposoffset = temp;
 			}
-		} else if(!strnicmp(this_opt, "tvyposoffset:", 13)) {
+		} else if(!strncasecmp(this_opt, "tvyposoffset:", 13)) {
 			int temp = 0;
 			temp = (int)simple_strtol(this_opt + 13, NULL, 0);
 			if((temp >= -32) && (temp <= 32)) {
 			   sisfb_tvyposoffset = temp;
 			}
-		} else if(!strnicmp(this_opt, "specialtiming:", 14)) {
+		} else if(!strncasecmp(this_opt, "specialtiming:", 14)) {
 			sisfb_search_specialtiming(this_opt + 14);
-		} else if(!strnicmp(this_opt, "lvdshl:", 7)) {
+		} else if(!strncasecmp(this_opt, "lvdshl:", 7)) {
 			int temp = 4;
 			temp = simple_strtoul(this_opt + 7, NULL, 0);
 			if((temp >= 0) && (temp <= 3)) {
@@ -4022,9 +4022,9 @@ static int __init sisfb_setup(char *opti
 		} else if(this_opt[0] >= '0' && this_opt[0] <= '9') {
 			sisfb_search_mode(this_opt, true);
 #if !defined(__i386__) && !defined(__x86_64__)
-		} else if(!strnicmp(this_opt, "resetcard", 9)) {
+		} else if(!strncasecmp(this_opt, "resetcard", 9)) {
 			sisfb_resetcard = 1;
-	        } else if(!strnicmp(this_opt, "videoram:", 9)) {
+	        } else if(!strncasecmp(this_opt, "videoram:", 9)) {
 			sisfb_videoram = simple_strtoul(this_opt + 9, NULL, 0);
 #endif
 		} else {
diff -puN drivers/video/fbdev/sm501fb.c~video-fbdev-replace-strnicmp-with-strncasecmp drivers/video/fbdev/sm501fb.c
--- a/drivers/video/fbdev/sm501fb.c~video-fbdev-replace-strnicmp-with-strncasecmp
+++ a/drivers/video/fbdev/sm501fb.c
@@ -1187,9 +1187,9 @@ static ssize_t sm501fb_crtsrc_store(stru
 	if (len < 1)
 		return -EINVAL;
 
-	if (strnicmp(buf, "crt", 3) == 0)
+	if (strncasecmp(buf, "crt", 3) == 0)
 		head = HEAD_CRT;
-	else if (strnicmp(buf, "panel", 5) == 0)
+	else if (strncasecmp(buf, "panel", 5) == 0)
 		head = HEAD_PANEL;
 	else
 		return -EINVAL;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

linux-next.patch
lib-string-remove-duplicated-function.patch
lib-string-make-all-calls-to-strnicmp-into-calls-to-strncasecmp.patch
arm-replace-strnicmp-with-strncasecmp.patch
block-replace-strnicmp-with-strncasecmp.patch
netfilter-replace-strnicmp-with-strncasecmp.patch
video-fbdev-replace-strnicmp-with-strncasecmp.patch
cifs-replace-strnicmp-with-strncasecmp.patch
ocfs2-replace-strnicmp-with-strncasecmp.patch
isofs-replace-strnicmp-with-strncasecmp.patch
batman-adv-replace-strnicmp-with-strncasecmp.patch
acpi-battery-replace-strnicmp-with-strncasecmp.patch
cpufreq-replace-strnicmp-with-strncasecmp.patch
cpuidle-replace-strnicmp-with-strncasecmp.patch
scsi-replace-strnicmp-with-strncasecmp.patch
ib_srpt-replace-strnicmp-with-strncasecmp.patch
input-edt-ft5x06-replace-strnicmp-with-strncasecmp.patch
altera-stapl-replace-strnicmp-with-strncasecmp.patch
thinkpad_acpi-replace-strnicmp-with-strncasecmp.patch
pnp-replace-strnicmp-with-strncasecmp.patch
s390-cio-replace-strnicmp-with-strncasecmp.patch
staging-r8188eu-replace-strnicmp-with-strncasecmp.patch
thermal-replace-strnicmp-with-strncasecmp.patch
kdb-replace-strnicmp-with-strncasecmp.patch

