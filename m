From: akpm@linux-foundation.org
Subject: + ipmi-add-new-kernel-options-to-prevent-automatic-ipmi-init.patch added to -mm tree
Date: Mon, 07 Jan 2013 15:44:14 -0800
Message-ID: <20130107234415.27C84820123@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:51947 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3AGXoQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 18:44:16 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so1305467yen.5
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 15:44:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cminyard@mvista.com, Robert.Evans@stratus.com, jparadis@redhat.com, tcamuso@redhat.com


The patch titled
     Subject: ipmi: add new kernel options to prevent automatic ipmi init
has been added to the -mm tree.  Its filename is
     ipmi-add-new-kernel-options-to-prevent-automatic-ipmi-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Corey Minyard <cminyard@mvista.com>
Subject: ipmi: add new kernel options to prevent automatic ipmi init

The configuration change building ipmi_si into the kernel precludes the
use of a custom driver that can utilize more than one KCS interface,
multiple IPMBs, and more than one BMC.  This capability is important for
fault-tolerant systems.

Even if the kernel option ipmi_si.trydefaults=0 is specified, ipmi_si
discovers and claims one of the KCS interfaces on a Stratus server.  The
inability to now prevent the kernel from managing this device is a
regression from previous kernels.  The regression breaks a capability
fault-tolerant vendors have relied upon.

To support both ACPI opregion access and the need to avoid activation of
ipmi_si on some platforms, we've added two new kernel options,
ipmi_si.tryacpi and ipmi_si.trydmi be added to prevent ipmi_si from
initializing when these options are set to 0 on the kernel command line. 
With these options at the default value of 1, ipmi_si init proceeds
according to the kernel default.

Tested-by: Jim Paradis <jparadis@redhat.com>
Signed-off-by: Robert Evans <Robert.Evans@stratus.com>
Signed-off-by: Jim Paradis <jparadis@redhat.com>
Signed-off-by: Tony Camuso <tcamuso@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-add-new-kernel-options-to-prevent-automatic-ipmi-init drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-add-new-kernel-options-to-prevent-automatic-ipmi-init
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -1208,6 +1208,12 @@ static int smi_num; /* Used to sequence 
 #define DEFAULT_REGSPACING	1
 #define DEFAULT_REGSIZE		1
 
+#ifdef CONFIG_ACPI
+static bool          si_tryacpi = 1;
+#endif
+#ifdef CONFIG_DMI
+static bool          si_trydmi = 1;
+#endif
 static bool          si_trydefaults = 1;
 static char          *si_type[SI_MAX_PARMS];
 #define MAX_SI_TYPE_STR 30
@@ -1238,6 +1244,16 @@ MODULE_PARM_DESC(hotmod, "Add and remove
 		 " Documentation/IPMI.txt in the kernel sources for the"
 		 " gory details.");
 
+#ifdef CONFIG_ACPI
+module_param_named(tryacpi, si_tryacpi, bool, 0);
+MODULE_PARM_DESC(tryacpi, "Setting this to zero will disable the"
+		 " default scan of the interfaces identified via ACPI");
+#endif
+#ifdef CONFIG_DMI
+module_param_named(trydmi, si_trydmi, bool, 0);
+MODULE_PARM_DESC(trydmi, "Setting this to zero will disable the"
+		 " default scan of the interfaces identified via DMI");
+#endif
 module_param_named(trydefaults, si_trydefaults, bool, 0);
 MODULE_PARM_DESC(trydefaults, "Setting this to 'false' will disable the"
 		 " default scan of the KCS and SMIC interface at the standard"
@@ -3408,16 +3424,20 @@ static int init_ipmi_si(void)
 #endif
 
 #ifdef CONFIG_ACPI
-	pnp_register_driver(&ipmi_pnp_driver);
-	pnp_registered = 1;
+	if (si_tryacpi) {
+		pnp_register_driver(&ipmi_pnp_driver);
+		pnp_registered = 1;
+	}
 #endif
 
 #ifdef CONFIG_DMI
-	dmi_find_bmc();
+	if (si_trydmi)
+		dmi_find_bmc();
 #endif
 
 #ifdef CONFIG_ACPI
-	spmi_find_bmc();
+	if (si_tryacpi)
+		spmi_find_bmc();
 #endif
 
 	/* We prefer devices with interrupts, but in the case of a machine
_

Patches currently in -mm which might be from cminyard@mvista.com are

ipmi-remove-superfluous-kernel-userspace-explanation.patch
ipmi-add-new-kernel-options-to-prevent-automatic-ipmi-init.patch
ipmi-add-options-to-disable-openfirmware-and-pci-scanning.patch

