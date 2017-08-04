From: akpm@linux-foundation.org
Subject: [merged] pid-kill-pidhash_size-in-pidhash_init.patch
 removed from -mm tree
Date: Fri, 04 Aug 2017 14:18:17 -0700
Message-ID: <20170804211817.tAlQrdHmj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51746 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751312AbdHDVSS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2017 17:18:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, Pasha.Tatashin@Oracle.com, wangkefeng.wang@huawei.com


The patch titled
     Subject: pid: kill pidhash_size in pidhash_init()
has been removed from the -mm tree.  Its filename was
     pid-kill-pidhash_size-in-pidhash_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: pid: kill pidhash_size in pidhash_init()

After 3d375d78593c ("mm: update callers to use HASH_ZERO flag"), drop
unused pidhash_size in pidhash_init().

Link: http://lkml.kernel.org/r/1500389267-49222-1-git-send-email-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Pavel Tatashin <Pasha.Tatashin@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/pid.c~pid-kill-pidhash_size-in-pidhash_init kernel/pid.c
--- a/kernel/pid.c~pid-kill-pidhash_size-in-pidhash_init
+++ a/kernel/pid.c
@@ -575,13 +575,10 @@ struct pid *find_ge_pid(int nr, struct p
  */
 void __init pidhash_init(void)
 {
-	unsigned int pidhash_size;
