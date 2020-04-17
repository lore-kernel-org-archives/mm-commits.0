From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mm-vmstatc-do-not-show-lowmem-reserve-protection-information?=
 =?US-ASCII?Q?-of-empty-zone.patch?= added to -mm tree
Date: Thu, 16 Apr 2020 20:21:47 -0700
Message-ID: <20200417032147.vI9Cn0K-4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgDQDVu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Apr 2020 23:21:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat.c: do not show lowmem reserve protection information of empty zone
has been added to the -mm tree.  Its filename is
     mm-vmstatc-do-not-show-lowmem-reserve-protection-information-of-empty-zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstatc-do-not-show-lowmem-reserve-protection-information-of-empty-zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstatc-do-not-show-lowmem-reserve-protection-information-of-empty-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmstat.c: do not show lowmem reserve protection information of empty zone

Because the lowmem reserve protection of a zone can't tell anything if the
zone is empty, except of adding one more line in /proc/zoneinfo.

Let's remove it from that zone's showing.

Link: http://lkml.kernel.org/r/20200402140113.3696-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/vmstat.c~mm-vmstatc-do-not-show-lowmem-reserve-protection-information-of-empty-zone
+++ a/mm/vmstat.c
@@ -1590,6 +1590,12 @@ static void zoneinfo_show_print(struct s
 		   zone->present_pages,
 		   zone_managed_pages(zone));
 
+	/* If unpopulated, no other information is useful */
+	if (!populated_zone(zone)) {
+		seq_putc(m, '\n');
+		return;
+	}
+
 	seq_printf(m,
 		   "\n        protection: (%ld",
 		   zone->lowmem_reserve[0]);
@@ -1597,12 +1603,6 @@ static void zoneinfo_show_print(struct s
 		seq_printf(m, ", %ld", zone->lowmem_reserve[i]);
 	seq_putc(m, ')');
 
-	/* If unpopulated, no other information is useful */
-	if (!populated_zone(zone)) {
-		seq_putc(m, '\n');
-		return;
-	}
