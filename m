From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch added to -mm tree
Date: Thu, 12 Apr 2012 11:07:47 -0700
Message-ID: <20120412185211.7F2F310004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:43856 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab2DLSwM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Apr 2012 14:52:12 -0400
Received: by yenq2 with SMTP id q2so283648yen.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Apr 2012 11:52:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Subject: arch/x86/kernel/apic/io_apic.c: move io_apic_level_ack_pending() inside CONFIG_GENERIC_PENDING_IRQ
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/x86/kernel/apic/io_apic.c: move io_apic_level_ack_pending() inside CONFIG_GENERIC_PENDING_IRQ

x86_64 allnoconfig:

arch/x86/kernel/apic/io_apic.c:382: warning: 'io_apic_level_ack_pending' defined but not used

Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apic/io_apic.c |   47 +++++++++++++++----------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff -puN arch/x86/kernel/apic/io_apic.c~arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq arch/x86/kernel/apic/io_apic.c
--- a/arch/x86/kernel/apic/io_apic.c~arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq
+++ a/arch/x86/kernel/apic/io_apic.c
@@ -379,29 +379,6 @@ static void __io_apic_modify(unsigned in
 	writel(value, &io_apic->data);
 }
 
-static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
-{
-	struct irq_pin_list *entry;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	for_each_irq_pin(entry, cfg->irq_2_pin) {
-		unsigned int reg;
-		int pin;
-
-		pin = entry->pin;
-		reg = io_apic_read(entry->apic, 0x10 + pin*2);
-		/* Is the remote IRR bit set? */
-		if (reg & IO_APIC_REDIR_REMOTE_IRR) {
-			raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-			return true;
-		}
-	}
-	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-
-	return false;
-}
-
 union entry_union {
 	struct { u32 w1, w2; };
 	struct IO_APIC_route_entry entry;
@@ -2552,6 +2529,30 @@ static void ack_apic_edge(struct irq_dat
 atomic_t irq_mis_count;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
+
+static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
+{
+	struct irq_pin_list *entry;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
+		unsigned int reg;
+		int pin;
+
+		pin = entry->pin;
+		reg = io_apic_read(entry->apic, 0x10 + pin*2);
+		/* Is the remote IRR bit set? */
+		if (reg & IO_APIC_REDIR_REMOTE_IRR) {
+			raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+			return true;
+		}
+	}
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+
+	return false;
+}
+
 static inline bool ioapic_irqd_mask(struct irq_data *data, struct irq_cfg *cfg)
 {
 	/* If we are moving the irq we need to mask it */
_
Subject: Subject: arch/x86/kernel/apic/io_apic.c: move io_apic_level_ack_pending() inside CONFIG_GENERIC_PENDING_IRQ

Patches currently in -mm which might be from akpm@linux-foundation.org are


