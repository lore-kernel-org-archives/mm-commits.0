From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-use-max-instead-of-infinity-in-control-knobs.patch added to
 -mm tree
Date: Wed, 18 Feb 2015 13:56:48 -0800
Message-ID: <54e50aa0.TWtAiFIFjL5fhFHv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbbBRV4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 16:56:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: use "max" instead of "infinity" in control knobs
has been added to the -mm tree.  Its filename is
     mm-memcontrol-use-max-instead-of-infinity-in-control-knobs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-use-max-instead-of-infinity-in-control-knobs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-use-max-instead-of-infinity-in-control-knobs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: use "max" instead of "infinity" in control knobs

The memcg control knobs indicate the highest possible value using the
symbolic name "infinity", which is long and awkward to type.

Switch to the string "max", which is just as descriptive but shorter
and sweeter.

This changes a user interface, so do it before the release and before
the development flag is dropped from the default hierarchy.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/unified-hierarchy.txt |    4 ++--
 mm/memcontrol.c                             |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN Documentation/cgroups/unified-hierarchy.txt~mm-memcontrol-use-max-instead-of-infinity-in-control-knobs Documentation/cgroups/unified-hierarchy.txt
--- a/Documentation/cgroups/unified-hierarchy.txt~mm-memcontrol-use-max-instead-of-infinity-in-control-knobs
+++ a/Documentation/cgroups/unified-hierarchy.txt
@@ -404,8 +404,8 @@ supported and the interface files "relea
   be understood as an underflow into the highest possible value, -2 or
   -10M etc. do not work, so it's not consistent.
 
-  memory.low, memory.high, and memory.max will use the string
-  "infinity" to indicate and set the highest possible value.
+  memory.low, memory.high, and memory.max will use the string "max" to
+  indicate and set the highest possible value.
 
 5. Planned Changes
 
diff -puN mm/memcontrol.c~mm-memcontrol-use-max-instead-of-infinity-in-control-knobs mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-use-max-instead-of-infinity-in-control-knobs
+++ a/mm/memcontrol.c
@@ -5247,7 +5247,7 @@ static int memory_low_show(struct seq_fi
 	unsigned long low = ACCESS_ONCE(memcg->low);
 
 	if (low == PAGE_COUNTER_MAX)
-		seq_puts(m, "infinity\n");
+		seq_puts(m, "max\n");
 	else
 		seq_printf(m, "%llu\n", (u64)low * PAGE_SIZE);
 
@@ -5262,7 +5262,7 @@ static ssize_t memory_low_write(struct k
 	int err;
 
 	buf = strstrip(buf);
-	err = page_counter_memparse(buf, "infinity", &low);
+	err = page_counter_memparse(buf, "max", &low);
 	if (err)
 		return err;
 
@@ -5277,7 +5277,7 @@ static int memory_high_show(struct seq_f
 	unsigned long high = ACCESS_ONCE(memcg->high);
 
 	if (high == PAGE_COUNTER_MAX)
-		seq_puts(m, "infinity\n");
+		seq_puts(m, "max\n");
 	else
 		seq_printf(m, "%llu\n", (u64)high * PAGE_SIZE);
 
@@ -5292,7 +5292,7 @@ static ssize_t memory_high_write(struct
 	int err;
 
 	buf = strstrip(buf);
-	err = page_counter_memparse(buf, "infinity", &high);
+	err = page_counter_memparse(buf, "max", &high);
 	if (err)
 		return err;
 
@@ -5307,7 +5307,7 @@ static int memory_max_show(struct seq_fi
 	unsigned long max = ACCESS_ONCE(memcg->memory.limit);
 
 	if (max == PAGE_COUNTER_MAX)
-		seq_puts(m, "infinity\n");
+		seq_puts(m, "max\n");
 	else
 		seq_printf(m, "%llu\n", (u64)max * PAGE_SIZE);
 
@@ -5322,7 +5322,7 @@ static ssize_t memory_max_write(struct k
 	int err;
 
 	buf = strstrip(buf);
-	err = page_counter_memparse(buf, "infinity", &max);
+	err = page_counter_memparse(buf, "max", &max);
 	if (err)
 		return err;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-fix-low-limit-calculation.patch
mm-memcontrol-use-max-instead-of-infinity-in-control-knobs.patch
mm-memcontrol-update-copyright-notice.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

