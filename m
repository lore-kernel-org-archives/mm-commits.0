Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF27C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B113E20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816630;
	bh=t45PfkdyaF7hQO6bY6Y3LA267TufjMUPeX5WpRRFXOk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=mU/fWfUmzo+T6bdvaeCUo9IXI3uM7ooLFO7ODRNJ4JZlmfE2M0MMmVm0C3jOG6GZs
	 l/ur65FmUTmCg30RZafOiLJD/7On7Mij6eFwlCesuPlrFKBYkbeScICSbqaLkkPkdI
	 4Wljx/37IsFqyxW9s1Su8jwssc4aQg8MJy8xMl3g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404398AbgJPCua (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:50:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404127AbgJPCu3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:50:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A0302074D;
        Fri, 16 Oct 2020 02:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816629;
        bh=t45PfkdyaF7hQO6bY6Y3LA267TufjMUPeX5WpRRFXOk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Xm30IEkYYCy1OJMr30sJonAYQouw24gc8jcxJ5iEOmhjv5onHWc5tBBBfVZsra5zD
         g+qdMUTldE6qzd+Jb6ISZY+6R3HY4ovv1UPKWOoJ/mOEcyZdAT3D3CreAieJWUbcw6
         Wr9Z715y+IDny2d/AlxB5+OC2yiTnZ3KQ81Ud4Wg=
Date:   Thu, 15 Oct 2020 19:50:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jan.kiszka@siemens.com,
        kbingham@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, riteshh@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 151/156] scripts/gdb/tasks: add headers and
 improve spacing format
Message-ID: <20201016025028.YSQN5Cdyu%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
