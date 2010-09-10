From: akpm@linux-foundation.org
Subject: + ipmi-fix-__init-and-__exit-attribute-locations.patch added to -mm tree
Date: Fri, 10 Sep 2010 16:44:12 -0700
Message-ID: <201009102344.o8ANiC8l009880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755362Ab0IJXoO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 19:44:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cminyard@mvista.com


The patch titled
     ipmi: fix __init and __exit attribute locations
has been added to the -mm tree.  Its filename is
     ipmi-fix-__init-and-__exit-attribute-locations.patch

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
Subject: ipmi: fix __init and __exit attribute locations
From: Corey Minyard <cminyard@mvista.com>

__init and __exit belong after the return type on functions, not
before.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_devintf.c    |    4 ++--
 drivers/char/ipmi/ipmi_msghandler.c |    4 ++--
 drivers/char/ipmi/ipmi_si_intf.c    |   14 +++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/char/ipmi/ipmi_devintf.c~ipmi-fix-__init-and-__exit-attribute-locations drivers/char/ipmi/ipmi_devintf.c
--- a/drivers/char/ipmi/ipmi_devintf.c~ipmi-fix-__init-and-__exit-attribute-locations
+++ a/drivers/char/ipmi/ipmi_devintf.c
@@ -915,7 +915,7 @@ static struct ipmi_smi_watcher smi_watch
 	.smi_gone = ipmi_smi_gone,
 };
 
-static __init int init_ipmi_devintf(void)
+static int __init init_ipmi_devintf(void)
 {
 	int rv;
 
@@ -953,7 +953,7 @@ static __init int init_ipmi_devintf(void
 }
 module_init(init_ipmi_devintf);
 
-static __exit void cleanup_ipmi(void)
+static void __exit cleanup_ipmi(void)
 {
 	struct ipmi_reg_list *entry, *entry2;
 	mutex_lock(&reg_list_mutex);
diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-__init-and-__exit-attribute-locations drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-__init-and-__exit-attribute-locations
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -4442,13 +4442,13 @@ static int ipmi_init_msghandler(void)
 	return 0;
 }
 
-static __init int ipmi_init_msghandler_mod(void)
+static int __init ipmi_init_msghandler_mod(void)
 {
 	ipmi_init_msghandler();
 	return 0;
 }
 
-static __exit void cleanup_ipmi(void)
+static void __exit cleanup_ipmi(void)
 {
 	int count;
 
diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-__init-and-__exit-attribute-locations drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-__init-and-__exit-attribute-locations
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -1832,7 +1832,7 @@ static int hotmod_handler(const char *va
 	return rv;
 }
 
-static __devinit void hardcode_find_bmc(void)
+static void __devinit hardcode_find_bmc(void)
 {
 	int             i;
 	struct smi_info *info;
@@ -2016,7 +2016,7 @@ struct SPMITable {
 	s8      spmi_id[1]; /* A '\0' terminated array starts here. */
 };
 
-static __devinit int try_init_spmi(struct SPMITable *spmi)
+static int __devinit try_init_spmi(struct SPMITable *spmi)
 {
 	struct smi_info  *info;
 
@@ -2099,7 +2099,7 @@ static __devinit int try_init_spmi(struc
 	return 0;
 }
 
-static __devinit void spmi_find_bmc(void)
+static void __devinit spmi_find_bmc(void)
 {
 	acpi_status      status;
 	struct SPMITable *spmi;
@@ -2312,7 +2312,7 @@ static int __devinit decode_dmi(const st
 	return 0;
 }
 
-static __devinit void try_init_dmi(struct dmi_ipmi_data *ipmi_data)
+static void __devinit try_init_dmi(struct dmi_ipmi_data *ipmi_data)
 {
 	struct smi_info *info;
 
@@ -2999,7 +2999,7 @@ static __devinitdata struct ipmi_default
 	{ .port = 0 }
 };
 
-static __devinit void default_find_bmc(void)
+static void __devinit default_find_bmc(void)
 {
 	struct smi_info *info;
 	int             i;
@@ -3302,7 +3302,7 @@ static int try_smi_init(struct smi_info 
 	return rv;
 }
 
-static __devinit int init_ipmi_si(void)
+static int __devinit init_ipmi_si(void)
 {
 	int  i;
 	char *str;
@@ -3514,7 +3514,7 @@ static void cleanup_one_si(struct smi_in
 	kfree(to_clean);
 }
 
-static __exit void cleanup_ipmi_si(void)
+static void __exit cleanup_ipmi_si(void)
 {
 	struct smi_info *e, *tmp_e;
 
_

Patches currently in -mm which might be from cminyard@mvista.com are

ipmi-fix-acpi-probe-print.patch
ipmi-fix-__init-and-__exit-attribute-locations.patch

