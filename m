From: akpm@linux-foundation.org
Subject: [merged] clocksource-sh_cmt-clocksource-support.patch removed from -mm tree
Date: Thu, 23 Apr 2009 12:25:11 -0700
Message-ID: <200904231925.n3NJPB7j025190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110AbZDWT3B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 15:29:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@igel.co.jp, johnstul@us.ibm.com, lethal@linux-sh.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: sh_cmt clocksource support
has been removed from the -mm tree.  Its filename was
     clocksource-sh_cmt-clocksource-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource: sh_cmt clocksource support
From: Magnus Damm <damm@igel.co.jp>


Add clocksource support to the sh_cmt driver. With this in
place we can do tickless with a single CMT channel.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/sh_cmt.c |   66 +++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff -puN drivers/clocksource/sh_cmt.c~clocksource-sh_cmt-clocksource-support drivers/clocksource/sh_cmt.c
--- a/drivers/clocksource/sh_cmt.c~clocksource-sh_cmt-clocksource-support
+++ a/drivers/clocksource/sh_cmt.c
@@ -47,6 +47,7 @@ struct sh_cmt_priv {
 	unsigned long rate;
 	spinlock_t lock;
 	struct clock_event_device ced;
+	struct clocksource cs;
 	unsigned long total_cycles;
 };
 
@@ -376,6 +377,68 @@ static void sh_cmt_stop(struct sh_cmt_pr
 	spin_unlock_irqrestore(&p->lock, flags);
 }
 
+static struct sh_cmt_priv *cs_to_sh_cmt(struct clocksource *cs)
+{
+	return container_of(cs, struct sh_cmt_priv, cs);
+}
+
+static cycle_t sh_cmt_clocksource_read(struct clocksource *cs)
+{
+	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
+	unsigned long flags, raw;
+	unsigned long value;
+	int has_wrapped;
+
+	spin_lock_irqsave(&p->lock, flags);
+	value = p->total_cycles;
+	raw = sh_cmt_get_counter(p, &has_wrapped);
+
+	if (unlikely(has_wrapped))
+		raw = p->match_value;
+	spin_unlock_irqrestore(&p->lock, flags);
+
+	return value + raw;
+}
+
+static int sh_cmt_clocksource_enable(struct clocksource *cs)
+{
+	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
+	int ret;
+
+	p->total_cycles = 0;
+
+	ret = sh_cmt_start(p, FLAG_CLOCKSOURCE);
+	if (ret)
+		return ret;
+
+	/* TODO: calculate good shift from rate and counter bit width */
+	cs->shift = 0;
+	cs->mult = clocksource_hz2mult(p->rate, cs->shift);
+	return 0;
+}
+
+static void sh_cmt_clocksource_disable(struct clocksource *cs)
+{
+	sh_cmt_stop(cs_to_sh_cmt(cs), FLAG_CLOCKSOURCE);
+}
+
+static int sh_cmt_register_clocksource(struct sh_cmt_priv *p,
+				       char *name, unsigned long rating)
+{
+	struct clocksource *cs = &p->cs;
+
+	cs->name = name;
+	cs->rating = rating;
+	cs->read = sh_cmt_clocksource_read;
+	cs->enable = sh_cmt_clocksource_enable;
+	cs->disable = sh_cmt_clocksource_disable;
+	cs->mask = CLOCKSOURCE_MASK(sizeof(unsigned long) * 8);
+	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
+	pr_info("sh_cmt: %s used as clock source\n", cs->name);
+	clocksource_register(cs);
+	return 0;
+}
+
 static struct sh_cmt_priv *ced_to_sh_cmt(struct clock_event_device *ced)
 {
 	return container_of(ced, struct sh_cmt_priv, ced);
@@ -483,6 +546,9 @@ int sh_cmt_register(struct sh_cmt_priv *
 	if (clockevent_rating)
 		sh_cmt_register_clockevent(p, name, clockevent_rating);
 
+	if (clocksource_rating)
+		sh_cmt_register_clocksource(p, name, clocksource_rating);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from damm@igel.co.jp are

linux-next.patch

