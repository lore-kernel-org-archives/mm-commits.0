From: akpm@linux-foundation.org
Subject: - parport-dev-timeslice-is-an-unsigned-long-not-an-int.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:35:52 -0800
Message-ID: <200712202335.lBKNZqU6018751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46537 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753626AbXLTXgX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:36:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, mm-commits@vger.kernel.org


The patch titled
     parport: "dev->timeslice" is an unsigned long, not an int
has been removed from the -mm tree.  Its filename was
     parport-dev-timeslice-is-an-unsigned-long-not-an-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: parport: "dev->timeslice" is an unsigned long, not an int
From: Eric Dumazet <dada1@cosmosbay.com>

While auditing proc_doulongvec_ms_jiffies_minmax() usage in kernel, I found
a bug in drivers/parport/procfs.c, incorrectly using sizeof(int) instead of
sizeof(unsigned long)

Only 64bit arches are affected by this old bug.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/procfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/parport/procfs.c~parport-dev-timeslice-is-an-unsigned-long-not-an-int drivers/parport/procfs.c
--- a/drivers/parport/procfs.c~parport-dev-timeslice-is-an-unsigned-long-not-an-int
+++ a/drivers/parport/procfs.c
@@ -384,7 +384,7 @@ parport_device_sysctl_template = {
 		{
 			.procname 	= "timeslice",
 			.data		= NULL,
-			.maxlen		= sizeof(int),
+			.maxlen		= sizeof(unsigned long),
 			.mode		= 0644,
 			.proc_handler	= &proc_doulongvec_ms_jiffies_minmax,
 			.extra1		= (void*) &parport_min_timeslice_value,
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
git-net.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
lib-extablec-removes-an-expensive-integer-divide-in-search_extable.patch
kernel-sysc-get-rid-of-expensive-divides-in-groups_sort.patch
