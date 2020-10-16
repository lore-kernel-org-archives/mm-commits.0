Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CFC0C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B20C218AC
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881717;
	bh=sZBmw0SQUaY30/H+QIQm+Za00XUFuBw0Rvya8DHPNbI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=iGvgOTHJUbAdmbaotdH1ioltR5jGvmW636BSm6ABe9rMMdbELPasPqzJk1w5LP/6c
	 gXo2Sf7IIRYeQQIcS4+YCgN/eRjH4a7gKIKvaLPy8YR8CxiAgDO4KjwwcnfADjFYCP
	 NKUOUzgMk9FdyJC2/BP0S6wi83B2wh8EqY86IrAY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390233AbgJPUzQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732596AbgJPUzQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:55:16 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 925062076C;
        Fri, 16 Oct 2020 20:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881715;
        bh=sZBmw0SQUaY30/H+QIQm+Za00XUFuBw0Rvya8DHPNbI=;
        h=Date:From:To:Subject:From;
        b=W1jB1uqVZ0joz1MUehTwoyayb7PPtw4OwxfEu3a9BtBzyVDfNA61BxrhTSr6IRrRc
         ArMtYZ3jxoO1gKmAJT6YnDKlVgritfRG9GaNiQ86tdQiqvJ3mcOA2+CJwF2uy5/eGo
         MvXvpzjKoIPKEUfEMysgNRXytnNfUhvbJmD2BBq8=
Date:   Fri, 16 Oct 2020 13:55:15 -0700
From:   akpm@linux-foundation.org
To:     jan.kiszka@siemens.com, kbingham@kernel.org,
        mm-commits@vger.kernel.org, riteshh@linux.ibm.com
Subject:  [merged]
 tasks-add-headers-and-improve-spacing-format.patch removed from -mm tree
Message-ID: <20201016205515.le4EBdX6t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb/tasks: add headers and improve spacing format
has been removed from the -mm tree.  Its filename was
     tasks-add-headers-and-improve-spacing-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


