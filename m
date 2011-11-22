From: akpm@linux-foundation.org
Subject: + x86-mpparse-account-for-bus-types-other-than-isa-and-pci.patch added to -mm tree
Date: Tue, 22 Nov 2011 13:58:41 -0800
Message-ID: <201111222158.pAMLwfd7003899@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:46046 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304Ab1KVV6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 16:58:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhelgaas@google.com, jrnieder@gmail.com, stable@vger.kernel.org, troubledaemon@gmail.com


The patch titled
     Subject: x86: mpparse: account for bus types other than ISA and PCI
has been added to the -mm tree.  Its filename is
     x86-mpparse-account-for-bus-types-other-than-isa-and-pci.patch

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
From: Bjorn Helgaas <bhelgaas@google.com>
Subject: x86: mpparse: account for bus types other than ISA and PCI

In commit f8924e770e04 ("x86: unify mp_bus_info"), the 32-bit and 64-bit
versions of MP_bus_info were rearranged to match each other better. 
Unfortunately it introduced a regression: prior to that change we used to
always set the mp_bus_not_pci bit, then clear it if we found a PCI bus. 
After it, we set mp_bus_not_pci for ISA buses, clear it for PCI buses, and
leave it alone otherwise.

In the cases of ISA and PCI, there's not much difference.  But ISA is not
the only non-PCI bus, so it's better to always set mp_bus_not_pci and
clear it only for PCI.

Without this change, Dan's Dell PowerEdge 4200 panics on boot with a log
indicating interrupt routing trouble unless the "noapic" option is
supplied.  With this change, the machine boots reliably without "noapic".

Fixes http://bugs.debian.org/586494

[jrnieder@gmail.com: clarified commit message]
Reported-bisected-and-tested-by: Dan McGrath <troubledaemon@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Cc: <stable@vger.kernel.org>	# 2.6.26+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/mpparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/mpparse.c~x86-mpparse-account-for-bus-types-other-than-isa-and-pci arch/x86/kernel/mpparse.c
--- a/arch/x86/kernel/mpparse.c~x86-mpparse-account-for-bus-types-other-than-isa-and-pci
+++ a/arch/x86/kernel/mpparse.c
@@ -95,8 +95,8 @@ static void __init MP_bus_info(struct mp
 	}
 #endif
 
+	set_bit(m->busid, mp_bus_not_pci);
 	if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
-		set_bit(m->busid, mp_bus_not_pci);
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 		mp_bus_id_to_type[m->busid] = MP_BUS_ISA;
 #endif
_
Subject: Subject: x86: mpparse: account for bus types other than ISA and PCI

Patches currently in -mm which might be from bhelgaas@google.com are

linux-next.patch
x86-mpparse-account-for-bus-types-other-than-isa-and-pci.patch

