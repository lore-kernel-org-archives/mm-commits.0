From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-fix-cpu-hot-unplug-related-memory-leak.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:18:43 -0700
Message-ID: <200708250518.l7P5IhFc031902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39851 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754865AbXHYFSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     statistics infrastructure: fix cpu hot unplug related memory leak
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-fix-cpu-hot-unplug-related-memory-leak.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: statistics infrastructure: fix cpu hot unplug related memory leak
From: Martin Peschke <mp3@de.ibm.com>

In case of CPU hotunplug statistics might have leaked some memory (lists of
struct statistic_entry_sparse, about 32 byte each, freed by
statistic_sparse_reset()).

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/statistic.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN lib/statistic.c~statistics-infrastructure-fix-cpu-hot-unplug-related-memory-leak lib/statistic.c
--- a/lib/statistic.c~statistics-infrastructure-fix-cpu-hot-unplug-related-memory-leak
+++ a/lib/statistic.c
@@ -308,6 +308,7 @@ static int _statistic_hotcpu(struct stat
 		src = percpu_ptr(stat->data, cpu);
 		disc->merge(stat, dst, src);
 		local_irq_restore(flags);
+		disc->reset(stat, src);
 		percpu_depopulate(stat->data, cpu);
 		break;
 	}
_

Patches currently in -mm which might be from mp3@de.ibm.com are
