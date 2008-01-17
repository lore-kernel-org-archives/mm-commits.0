From: akpm@linux-foundation.org
Subject: + acpi-enable-c3-power-state-on-dell-inspiron-8200-update.patch added to -mm tree
Date: Thu, 17 Jan 2008 14:00:41 -0800
Message-ID: <200801172200.m0HM0f3T015404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47899 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259AbYAQWBo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 17:01:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dag@bakke.com, arjan@infradead.org, lenb@kernel.org


The patch titled
     acpi-enable-c3-power-state-on-dell-inspiron-8200-update
has been added to the -mm tree.  Its filename is
     acpi-enable-c3-power-state-on-dell-inspiron-8200-update.patch

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
Subject: acpi-enable-c3-power-state-on-dell-inspiron-8200-update
From: Dag Bakke <dag@bakke.com>

Tested-by: Arjan van de Ven <arjan@infradead.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/processor_idle.c~acpi-enable-c3-power-state-on-dell-inspiron-8200-update drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-enable-c3-power-state-on-dell-inspiron-8200-update
+++ a/drivers/acpi/processor_idle.c
@@ -123,9 +123,9 @@ static int set_max_cstate(const struct d
 }
 
 /*
- * Some (Dell) machines have a too large C3 latency set, but it still works
- * completely.  Dell provides a driver for other operating systems to hack
- * around this bug, so we know it's safe.
+ * Some (Dell) machines set the C3 latency to a value which effectively says:
+ * "Don't use C3." Still, C3 works if we force it.
+ * This enables C3 on Dell Inspiron 8200 machines.
  */
 static int dmi_force_c3(const struct dmi_system_id *id)
 {
_

Patches currently in -mm which might be from dag@bakke.com are

acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200-update.patch
