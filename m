Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6828EC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F05420709
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597795009;
	bh=DH+7EjcBu54cfDULw0QFhd2djya2KR7voi/Pne21bJs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=te5lwOJkDlrYd1t7/mPgy5gl0iWKHRzQ9sOWSBJs49E8ikAnfCilcJzj3Qx8yegNG
	 JE2z3w5NvRd7bgDIX17bUe0WYwAsifYUdJXmGZFK0eoE6fxGCzyNC38tL5ING96VJQ
	 ZivO4/0RIeBZJ71GwbyOeMNyZiX2zXMatZuqfMuY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgHRX4s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 19:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726799AbgHRX4q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 19:56:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEFF020789;
        Tue, 18 Aug 2020 23:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597795006;
        bh=DH+7EjcBu54cfDULw0QFhd2djya2KR7voi/Pne21bJs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=l5uaTYLkTWIBdFbtFfCvgH/I2s/qpgDDeFFx1KfFRsxfgsYj7ZhfZHfaxkHV2J/Cg
         jNGnku0yCAF72YHAIxc6GL3yv902jKumf9W6sAQUzjBqst88bfTspx5EtiSABwsGfl
         junm0q56NE7AwBaWj233eOPVT4HMBr/wnht9xFXA=
Date:   Tue, 18 Aug 2020 16:56:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     jan.kiszka@siemens.com, kbingham@kernel.org,
        mm-commits@vger.kernel.org, riteshh@linux.ibm.com
Subject:  + tasks-add-headers-and-improve-spacing-format.patch
 added to -mm tree
Message-ID: <20200818235645.GU0ytY_h5%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb/tasks: add headers and improve spacing format
has been added to the -mm tree.  Its filename is
     tasks-add-headers-and-improve-spacing-format.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tasks-add-headers-and-improve-spacing-format.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tasks-add-headers-and-improve-spacing-format.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ritesh Harjani <riteshh@linux.ibm.com>
Subject: scripts/gdb/tasks: add headers and improve spacing format

With the patch.
<e.g. o/p>
      TASK          PID    COMM
0xffffffff82c2b8c0   0   swapper/0
0xffff888a0ba20040   1   systemd
0xffff888a0ba24040   2   kthreadd
0xffff888a0ba28040   3   rcu_gp

w/o
0xffffffff82c2b8c0 <init_task> 0 swapper/0
0xffff888a0ba20040 1 systemd
0xffff888a0ba24040 2 kthreadd
0xffff888a0ba28040 3 rcu_gp

Link: http://lkml.kernel.org/r/54c868c79b5fc364a8be7799891934a6fe6d1464.1597742951.git.riteshh@linux.ibm.com
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/tasks.py |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/scripts/gdb/linux/tasks.py~tasks-add-headers-and-improve-spacing-format
+++ a/scripts/gdb/linux/tasks.py
@@ -73,11 +73,12 @@ class LxPs(gdb.Command):
         super(LxPs, self).__init__("lx-ps", gdb.COMMAND_DATA)
 
     def invoke(self, arg, from_tty):
+        gdb.write("{:>10} {:>12} {:>7}\n".format("TASK", "PID", "COMM"))
         for task in task_lists():
-            gdb.write("{address} {pid} {comm}\n".format(
-                address=task,
-                pid=task["pid"],
-                comm=task["comm"].string()))
+            gdb.write("{} {:^5} {}\n".format(
+                task.format_string().split()[0],
+                task["pid"].format_string(),
+                task["comm"].string()))
 
 
 LxPs()
_

Patches currently in -mm which might be from riteshh@linux.ibm.com are

proc-add-struct-mount-struct-super_block-addr-in-lx-mounts-command.patch
tasks-add-headers-and-improve-spacing-format.patch

