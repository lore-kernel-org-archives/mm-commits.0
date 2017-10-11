From: akpm@linux-foundation.org
Subject: + pid-remove-pidhash-v6.patch added to -mm tree
Date: Wed, 11 Oct 2017 15:41:11 -0700
Message-ID: <59de9e07.0eote3CmzuGJOHC6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750718AbdJKWlM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2017 18:41:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gs051095@gmail.com, ebiederm@xmission.com, hch@infradead.org, julia.lawall@lip6.fr, ktkhai@virtuozzo.com, mingo@kernel.org, oleg@redhat.com, pasha.tatashin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pid-remove-pidhash-v6
has been added to the -mm tree.  Its filename is
     pid-remove-pidhash-v6.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pid-remove-pidhash-v6.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pid-remove-pidhash-v6.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -30,8 +30,8 @@ void foo(void)
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
