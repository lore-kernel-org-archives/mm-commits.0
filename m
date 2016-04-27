From: akpm@linux-foundation.org
Subject: + mm-vmstat-calculate-particular-vm-event.patch added to -mm tree
Date: Wed, 27 Apr 2016 14:17:18 -0700
Message-ID: <57212c5e.pxfKSrShdkOsnKAH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbcD0VRT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 17:17:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, cl@linux.com, kirill.shutemov@linux.intel.com, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmstat: calculate particular vm event
has been added to the -mm tree.  Its filename is
     mm-vmstat-calculate-particular-vm-event.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-calculate-particular-vm-event.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-calculate-particular-vm-event.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Subject: mm, vmstat: calculate particular vm event

Currently, vmstat can calculate a specific vm event with all_vm_events()
however it calculates all vm events at a time.  This patch introduces a
new function to calculate only single event at a time.

Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    6 ++++++
 mm/vmstat.c            |   12 ++++++++++++
 2 files changed, 18 insertions(+)

diff -puN include/linux/vmstat.h~mm-vmstat-calculate-particular-vm-event include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-vmstat-calculate-particular-vm-event
+++ a/include/linux/vmstat.h
@@ -53,6 +53,8 @@ static inline void count_vm_events(enum
 
 extern void all_vm_events(unsigned long *);
 
+extern unsigned long sum_vm_event(enum vm_event_item item);
+
 extern void vm_events_fold_cpu(int cpu);
 
 #else
@@ -73,6 +75,10 @@ static inline void __count_vm_events(enu
 static inline void all_vm_events(unsigned long *ret)
 {
 }
+static inline unsigned long sum_vm_event(enum vm_event_item item)
+{
+	return 0;
+}
 static inline void vm_events_fold_cpu(int cpu)
 {
 }
diff -puN mm/vmstat.c~mm-vmstat-calculate-particular-vm-event mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-calculate-particular-vm-event
+++ a/mm/vmstat.c
@@ -34,6 +34,18 @@
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
 EXPORT_PER_CPU_SYMBOL(vm_event_states);
 
+unsigned long sum_vm_event(enum vm_event_item item)
+{
+	int cpu;
+	unsigned long ret = 0;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		ret += per_cpu(vm_event_states, cpu).event[item];
+	put_online_cpus();
+	return ret;
+}
+
 static void sum_vm_events(unsigned long *ret)
 {
 	int cpu;
_

Patches currently in -mm which might be from ebru.akagunduz@gmail.com are

mm-make-optimistic-check-for-swapin-readahead.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch
mm-vmstat-calculate-particular-vm-event.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged.patch

