From: akpm@linux-foundation.org
Subject: + thermal-replace-strnicmp-with-strncasecmp.patch added to -mm
 tree
Date: Thu, 18 Sep 2014 14:36:25 -0700
Message-ID: <541b5059.HUvEtabX60c9HAnU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504AbaIRVg0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 17:36:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, edubezval@gmail.com, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal: replace strnicmp with strncasecmp
has been added to the -mm tree.  Its filename is
     thermal-replace-strnicmp-with-strncasecmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thermal-replace-strnicmp-with-strncasecmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thermal-replace-strnicmp-with-strncasecmp.patch

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
Subject: thermal: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/thermal/thermal_core.c~thermal-replace-strnicmp-with-strncasecmp drivers/thermal/thermal_core.c
--- a/drivers/thermal/thermal_core.c~thermal-replace-strnicmp-with-strncasecmp
+++ a/drivers/thermal/thermal_core.c
@@ -66,7 +66,7 @@ static struct thermal_governor *__find_g
 		return def_governor;
 
 	list_for_each_entry(pos, &thermal_governor_list, governor_list)
-		if (!strnicmp(name, pos->name, THERMAL_NAME_LENGTH))
+		if (!strncasecmp(name, pos->name, THERMAL_NAME_LENGTH))
 			return pos;
 
 	return NULL;
@@ -104,7 +104,7 @@ int thermal_register_governor(struct the
 
 		name = pos->tzp->governor_name;
 
-		if (!strnicmp(name, governor->name, THERMAL_NAME_LENGTH))
+		if (!strncasecmp(name, governor->name, THERMAL_NAME_LENGTH))
 			pos->governor = governor;
 	}
 
@@ -129,7 +129,7 @@ void thermal_unregister_governor(struct
 	mutex_lock(&thermal_list_lock);
 
 	list_for_each_entry(pos, &thermal_tz_list, node) {
-		if (!strnicmp(pos->governor->name, governor->name,
+		if (!strncasecmp(pos->governor->name, governor->name,
 						THERMAL_NAME_LENGTH))
 			pos->governor = NULL;
 	}
@@ -1665,7 +1665,7 @@ struct thermal_zone_device *thermal_zone
 
 	mutex_lock(&thermal_list_lock);
 	list_for_each_entry(pos, &thermal_tz_list, node)
-		if (!strnicmp(name, pos->type, THERMAL_NAME_LENGTH)) {
+		if (!strncasecmp(name, pos->type, THERMAL_NAME_LENGTH)) {
 			found++;
 			ref = pos;
 		}
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

