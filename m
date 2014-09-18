From: akpm@linux-foundation.org
Subject: + cpufreq-replace-strnicmp-with-strncasecmp.patch added to -mm
 tree
Date: Thu, 18 Sep 2014 14:36:15 -0700
Message-ID: <541b504f.dAn9K5pJAnqNn/qo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311AbaIRVgQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 17:36:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, rjw@rjwysocki.net, viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cpufreq: replace strnicmp with strncasecmp
has been added to the -mm tree.  Its filename is
     cpufreq-replace-strnicmp-with-strncasecmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpufreq-replace-strnicmp-with-strncasecmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpufreq-replace-strnicmp-with-strncasecmp.patch

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
Subject: cpufreq: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~cpufreq-replace-strnicmp-with-strncasecmp drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-replace-strnicmp-with-strncasecmp
+++ a/drivers/cpufreq/cpufreq.c
@@ -437,7 +437,7 @@ static struct cpufreq_governor *__find_g
 	struct cpufreq_governor *t;
 
 	list_for_each_entry(t, &cpufreq_governor_list, governor_list)
-		if (!strnicmp(str_governor, t->name, CPUFREQ_NAME_LEN))
+		if (!strncasecmp(str_governor, t->name, CPUFREQ_NAME_LEN))
 			return t;
 
 	return NULL;
@@ -455,10 +455,10 @@ static int cpufreq_parse_governor(char *
 		goto out;
 
 	if (cpufreq_driver->setpolicy) {
-		if (!strnicmp(str_governor, "performance", CPUFREQ_NAME_LEN)) {
+		if (!strncasecmp(str_governor, "performance", CPUFREQ_NAME_LEN)) {
 			*policy = CPUFREQ_POLICY_PERFORMANCE;
 			err = 0;
-		} else if (!strnicmp(str_governor, "powersave",
+		} else if (!strncasecmp(str_governor, "powersave",
 						CPUFREQ_NAME_LEN)) {
 			*policy = CPUFREQ_POLICY_POWERSAVE;
 			err = 0;
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

