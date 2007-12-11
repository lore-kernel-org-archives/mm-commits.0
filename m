From: akpm@linux-foundation.org
Subject: + parport-dev-timeslice-is-an-unsigned-long-not-an-int.patch added to -mm tree
Date: Tue, 11 Dec 2007 15:30:58 -0800
Message-ID: <200712112331.lBBNV3SW014665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52340 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226AbXLKXcT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 18:32:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com


The patch titled
     parport: "dev->timeslice" is an unsigned long, not an int
has been added to the -mm tree.  Its filename is
     parport-dev-timeslice-is-an-unsigned-long-not-an-int.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

parport-dev-timeslice-is-an-unsigned-long-not-an-int.patch
git-net.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
