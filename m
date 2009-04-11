From: akpm@linux-foundation.org
Subject: + irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch added to -mm tree
Date: Fri, 10 Apr 2009 17:26:04 -0700
Message-ID: <200904110026.n3B0Q4G0008572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681AbZDKAcM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 20:32:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rgetz@blackfin.uclinux.org, mingo@elte.hu, mpm@selenic.com, randy.dunlap@oracle.com, tglx@linutronix.de, tytso@mit.edu


The patch titled
     irqs: add IRQF_SAMPLE_RANDOM to the feature-removal-schedule.txt (deprecated) list
has been added to the -mm tree.  Its filename is
     irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch

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
Subject: irqs: add IRQF_SAMPLE_RANDOM to the feature-removal-schedule.txt (deprecated) list
From: Robin Getz <rgetz@blackfin.uclinux.org>

This adds IRQF_SAMPLE_RANDOM to the feature-removal (deprecated) list
since most of the IRQF_SAMPLE_RANDOM users are technically bogus as
entropy sources in the kernel's current entropy model.

This was discussed on the lkml the past few days, which started here:
http://lkml.org/lkml/2009/4/6/283

Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN Documentation/feature-removal-schedule.txt~irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list
+++ a/Documentation/feature-removal-schedule.txt
@@ -6,6 +6,20 @@ be removed from this file.
 
 ---------------------------
 
+What:	IRQF_SAMPLE_RANDOM
+Check:	IRQF_SAMPLE_RANDOM
+When:	July 2009
+
+Why:	Many of IRQF_SAMPLE_RANDOM users are technically bogus as entropy
+	sources in the kernel's current entropy model. To resolve this, every
+	input point to the kernel's entropy pool needs to better document the
+	type of entropy source it actually is. This will be replaced with
+	additional add_*_randomness functions in drivers/char/random.c
+
+Who:	Robin Getz <rgetz@blackfin.uclinux.org> & Matt Mackall <mpm@selenic.com>
+
+---------------------------
+
 What:	The ieee80211_regdom module parameter
 When:	March 2010 / desktop catchup
 
_

Patches currently in -mm which might be from rgetz@blackfin.uclinux.org are

irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch

