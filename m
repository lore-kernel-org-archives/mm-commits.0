From: akpm@linux-foundation.org
Subject: + hung_task-check-the-value-of-sysctl_hung_task_timeout_sec.patch added to -mm tree
Date: Fri, 28 Mar 2014 13:24:39 -0700
Message-ID: <5335da87.IKFDnAij06q/GW24%akpm__46602.1794862629$1396038288$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52830 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaC1UYk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Mar 2014 16:24:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, satoru.takeuchi@gmail.com, sdu.liu@huawei.com

Subject: + hung_task-check-the-value-of-sysctl_hung_task_timeout_sec.patch added to -mm tree
To: sdu.liu@huawei.com,satoru.takeuchi@gmail.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 28 Mar 2014 13:24:39 -0700


The patch titled
     Subject: hung_task: check the value of "sysctl_hung_task_timeout_sec"
has been added to the -mm tree.  Its filename is
     hung_task-check-the-value-of-sysctl_hung_task_timeout_sec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hung_task-check-the-value-of-sysctl_hung_task_timeout_sec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hung_task-check-the-value-of-sysctl_hung_task_timeout_sec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liu Hua <sdu.liu@huawei.com>
Subject: hung_task: check the value of "sysctl_hung_task_timeout_sec"

As sysctl_hung_task_timeout_sec is unsigned long, when this value is
larger then LONG_MAX/HZ, the function schedule_timeout_interruptible in
watchdog will return immediately without sleep and with print :

[  205.452934] schedule_timeout: wrong timeout value ffffffffffffff83

and then the funtion watchdog will call schedule_timeout_interruptible
again and again.  The screen will be filled with

	"schedule_timeout: wrong timeout value ffffffffffffff83"

This patch does some check and correction in sysctl, to let the function
schedule_timeout_interruptible allways get the valid parameter.

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
Tested-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: <stable@vger.kernel.org>	[3.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    1 +
 kernel/sysctl.c                 |    6 ++++++
 2 files changed, 7 insertions(+)

diff -puN Documentation/sysctl/kernel.txt~hung_task-check-the-value-of-sysctl_hung_task_timeout_sec Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~hung_task-check-the-value-of-sysctl_hung_task_timeout_sec
+++ a/Documentation/sysctl/kernel.txt
@@ -317,6 +317,7 @@ for more than this value report a warnin
 This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
 
 0: means infinite timeout - no checking done.
+Possible values to set are in range {0..LONG_MAX/HZ}.
 
 ==============================================================
 
diff -puN kernel/sysctl.c~hung_task-check-the-value-of-sysctl_hung_task_timeout_sec kernel/sysctl.c
--- a/kernel/sysctl.c~hung_task-check-the-value-of-sysctl_hung_task_timeout_sec
+++ a/kernel/sysctl.c
@@ -144,6 +144,11 @@ static int min_percpu_pagelist_fract = 8
 static int ngroups_max = NGROUPS_MAX;
 static const int cap_last_cap = CAP_LAST_CAP;
 
+/*this is needed for proc_doulongvec_minmax of sysctl_hung_task_timeout_secs */
+#ifdef CONFIG_DETECT_HUNG_TASK
+static unsigned long hung_task_timeout_max = (LONG_MAX/HZ);
+#endif
+
 #ifdef CONFIG_INOTIFY_USER
 #include <linux/inotify.h>
 #endif
@@ -995,6 +1000,7 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_dohung_task_timeout_secs,
+		.extra2		= &hung_task_timeout_max,
 	},
 	{
 		.procname	= "hung_task_warnings",
_

Patches currently in -mm which might be from sdu.liu@huawei.com are

hung_task-check-the-value-of-sysctl_hung_task_timeout_sec.patch

