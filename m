From: akpm@linux-foundation.org
Subject: + pid-kill-pidhash_size-in-pidhash_init.patch added to -mm tree
Date: Tue, 18 Jul 2017 15:09:45 -0700
Message-ID: <596e8729.eMXOlQCkpFV+8ObI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48400 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751725AbdGRWJq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2017 18:09:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangkefeng.wang@huawei.com, Pasha.Tatashin@Oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pid: kill pidhash_size in pidhash_init()
has been added to the -mm tree.  Its filename is
     pid-kill-pidhash_size-in-pidhash_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pid-kill-pidhash_size-in-pidhash_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pid-kill-pidhash_size-in-pidhash_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
