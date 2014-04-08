From: akpm@linux-foundation.org
Subject: [merged]
 fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:37:05 -0700
Message-ID: <53446c01.a9L3qZpfpWVtE8tp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898AbaDHVhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:37:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, davej@fedoraproject.org, akinobu.mita@gmail.com, davej@redhat.com

Subject: [merged] fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch removed from -mm tree
To: davej@redhat.com,akinobu.mita@gmail.com,davej@fedoraproject.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:37:05 -0700


The patch titled
     Subject: fault-injection: set bounds on what /proc/self/make-it-fail accepts.
has been removed from the -mm tree.  Its filename was
     fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: fault-injection: set bounds on what /proc/self/make-it-fail accepts.

/proc/self/make-it-fail is a boolean, but accepts any number, including
negative ones.  Change variable to unsigned, and cap upper bound at 1.

[akpm@linux-foundation.org: don't make make_it_fail unsigned]
Signed-off-by: Dave Jones <davej@fedoraproject.org>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/proc/base.c~fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts fs/proc/base.c
--- a/fs/proc/base.c~fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts
+++ a/fs/proc/base.c
@@ -1236,6 +1236,9 @@ static ssize_t proc_fault_inject_write(s
 	make_it_fail = simple_strtol(strstrip(buffer), &end, 0);
 	if (*end)
 		return -EINVAL;
+	if (make_it_fail < 0 || make_it_fail > 1)
+		return -EINVAL;
+
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		return -ESRCH;
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch

