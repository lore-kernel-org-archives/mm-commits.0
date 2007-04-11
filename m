From: akpm@linux-foundation.org
Subject: + statistics-infrastructure-fix-cpu-hot-unplug-related-memory-leak.patch added to -mm tree
Date: Tue, 10 Apr 2007 17:03:12 -0700
Message-ID: <200704110003.l3B03CTC023625@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53007 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161137AbXDKADS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 20:03:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mp3@de.ibm.com


The patch titled
     statistics infrastructure: fix cpu hot unplug related memory leak
has been added to the -mm tree.  Its filename is
     statistics-infrastructure-fix-cpu-hot-unplug-related-memory-leak.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

statistics-infrastructure-prerequisite-list.patch
statistics-infrastructure-prerequisite-parser.patch
statistics-infrastructure-prerequisite-parser-fix.patch
add-for_each_substring-and-match_substring.patch
statistics-infrastructure-prerequisite-timestamp.patch
statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch
statistics-infrastructure-documentation.patch
statistics-infrastructure.patch
statistics-infrastructure-add-for_each_substring-and-match_substring-exploitation.patch
statistics-infrastructure-fix-parsing-of-statistics-type-attribute.patch
statistics-infrastructure-simplify-statistics-debugfs-write-function.patch
statistics-infrastructure-simplify-statistics-debugfs-read-functions.patch
statistics-infrastructure-fix-string-termination.patch
statistics-infrastructure-small-cleanup-in-debugfs-write-function.patch
statistics-infrastructure-fix-cpu-hot-unplug-related-memory-leak.patch
statistics-infrastructure-exploitation-zfcp.patch
