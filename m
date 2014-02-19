From: akpm@linux-foundation.org
Subject: +
 fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch
 added to -mm tree
Date: Wed, 19 Feb 2014 13:40:47 -0800
Message-ID: <530524df.6CwFQ1dT+NBWVT4b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbaBSVks (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Feb 2014 16:40:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, davej@fedoraproject.org, akinobu.mita@gmail.com, davej@redhat.com

Subject: + fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch added to -mm tree
To: davej@redhat.com,akinobu.mita@gmail.com,davej@fedoraproject.org,rientjes@google.com
From: akpm@linux-foundation.org
Date: Wed, 19 Feb 2014 13:40:47 -0800


The patch titled
     Subject: fault-injection: set bounds on what /proc/self/make-it-fail accepts.
has been added to the -mm tree.  Its filename is
     fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: fault-injection: set bounds on what /proc/self/make-it-fail accepts.

/proc/self/make-it-fail is a boolean, but accepts any number, including
negative ones.  Change variable to unsigned, and cap upper bound at 1.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts fs/proc/base.c
--- a/fs/proc/base.c~fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts
+++ a/fs/proc/base.c
@@ -1207,7 +1207,7 @@ static ssize_t proc_fault_inject_read(st
 	struct task_struct *task = get_proc_task(file_inode(file));
 	char buffer[PROC_NUMBUF];
 	size_t len;
-	int make_it_fail;
+	unsigned int make_it_fail;
 
 	if (!task)
 		return -ESRCH;
@@ -1224,7 +1224,7 @@ static ssize_t proc_fault_inject_write(s
 {
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF], *end;
-	int make_it_fail;
+	unsigned int make_it_fail;
 
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
@@ -1236,6 +1236,9 @@ static ssize_t proc_fault_inject_write(s
 	make_it_fail = simple_strtol(strstrip(buffer), &end, 0);
 	if (*end)
 		return -EINVAL;
+	if (make_it_fail > 1)
+		return -EINVAL;
+
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		return -ESRCH;
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
dma-debug-account-for-cachelines-and-read-only-mappings-in-overlap-tracking.patch
dma-debug-account-for-cachelines-and-read-only-mappings-in-overlap-tracking-v2.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
linux-next.patch

