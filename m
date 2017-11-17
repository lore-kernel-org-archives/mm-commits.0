From: akpm@linux-foundation.org
Subject: [folded-merged] pid-remove-pidhash-v6.patch removed from -mm tree
Date: Fri, 17 Nov 2017 15:17:17 -0800
Message-ID: <5a0f6dfd./Ps++N95Cbb4YLRj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53832 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965653AbdKQXRT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:17:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gs051095@gmail.com, ebiederm@xmission.com, hch@infradead.org, julia.lawall@lip6.fr, ktkhai@virtuozzo.com, mingo@kernel.org, oleg@redhat.com, pasha.tatashin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pid-remove-pidhash-v6
has been removed from the -mm tree.  Its filename was
     pid-remove-pidhash-v6.patch

This patch was dropped because it was folded into pid-remove-pidhash.patch

------------------------------------------------------
From: Gargi Sharma <gs051095@gmail.com>
Subject: pid-remove-pidhash-v6

Link: http://lkml.kernel.org/r/1507760379-21662-3-git-send-email-gs051095@gmail.com
Signed-off-by: Gargi Sharma <gs051095@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/asm-offsets.c |    4 ++--
 kernel/pid.c                   |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/ia64/kernel/asm-offsets.c~pid-remove-pidhash-v6 arch/ia64/kernel/asm-offsets.c
--- a/arch/ia64/kernel/asm-offsets.c~pid-remove-pidhash-v6
+++ a/arch/ia64/kernel/asm-offsets.c
@@ -31,8 +31,8 @@ void foo(void)
 	DEFINE(SIGFRAME_SIZE, sizeof (struct sigframe));
 	DEFINE(UNW_FRAME_INFO_SIZE, sizeof (struct unw_frame_info));
 
-	BUILD_BUG_ON(sizeof(struct upid) != 32);
-	DEFINE(IA64_UPID_SHIFT, 5);
+	BUILD_BUG_ON(sizeof(struct upid) != 16);
+	DEFINE(IA64_UPID_SHIFT, 4);
 
 	BLANK();
 
diff -puN kernel/pid.c~pid-remove-pidhash-v6 kernel/pid.c
--- a/kernel/pid.c~pid-remove-pidhash-v6
+++ a/kernel/pid.c
@@ -118,8 +118,7 @@ void free_pid(struct pid *pid)
 	for (i = 0; i <= pid->level; i++) {
 		struct upid *upid = pid->numbers + i;
 		struct pid_namespace *ns = upid->ns;
