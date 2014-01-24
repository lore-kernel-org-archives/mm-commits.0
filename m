From: akpm@linux-foundation.org
Subject: [merged]
 mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 10:59:07 -0800
Message-ID: <52e2b7fb.S9hCn4mprPDcxAiP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS7I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, hanpt@linux.vnet.ibm.com

Subject: [merged] mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch removed from -mm tree
To: hanpt@linux.vnet.ibm.com,mhocko@suse.cz,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:07 -0800


The patch titled
     Subject: mm: prevent setting of a value less than 0 to min_free_kbytes
has been removed from the -mm tree.  Its filename was
     mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
Subject: mm: prevent setting of a value less than 0 to min_free_kbytes

If echo -1 > /proc/vm/sys/min_free_kbytes, the system will hang.  Changing
proc_dointvec() to proc_dointvec_minmax() in the
min_free_kbytes_sysctl_handler() can prevent this to happen.

mhocko said:

: You can still do echo $BIG_VALUE > /proc/vm/sys/min_free_kbytes and make
: your machine unusable but I agree that proc_dointvec_minmax is more
: suitable here as we already have:
: 
: 	.proc_handler   = min_free_kbytes_sysctl_handler,
: 	.extra1         = &zero,
: 
: It used to work properly but then 6fce56ec91b5 ("sysctl: Remove references
: to ctl_name and strategy from the generic sysctl table") has removed
: sysctl_intvec strategy and so extra1 is ignored.

Signed-off-by: Han Pingtian <hanpt@linux.vnet.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes
+++ a/mm/page_alloc.c
@@ -5754,7 +5754,12 @@ module_init(init_per_zone_wmark_min)
 int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
-	proc_dointvec(table, write, buffer, length, ppos);
+	int rc;
+
+	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (rc)
+		return rc;
+
 	if (write) {
 		user_min_free_kbytes = min_free_kbytes;
 		setup_per_zone_wmarks();
_

Patches currently in -mm which might be from hanpt@linux.vnet.ibm.com are

origin.patch

