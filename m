Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FFEC388F7
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA19E24248
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408198;
	bh=br45YLOCZLQI0qTipjMgK0e95L5clS9BLn+oQ/8RDN0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0PFBpo6dreby4sN+dm3FjH81c6d+J6sjsX6DcLLzpKqKkdIhelqlrFeFhYS28rPFl
	 /1DNh2KHeiyXV02O4GQ4feUfz+srWqQHjS9FgVm8JwApdr2fw8d7VKDj1JlG3Dabrw
	 VwS69ho/7rvKX3ujNX/TezuwKcG6a5DHD2TJOEs0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373253AbgJVXJ5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373127AbgJVXJ4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:09:56 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FF74223C7;
        Thu, 22 Oct 2020 23:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408194;
        bh=br45YLOCZLQI0qTipjMgK0e95L5clS9BLn+oQ/8RDN0=;
        h=Date:From:To:Subject:From;
        b=NHL0Vhwldk4zThTey//OB5qbchQqaL+u65JrQK4L8UexM1A3+GFoW+e/IhwZQDG94
         yNA8QJgluc3Mzf4NrLdD671lfvlxhH6h5TQw65v1D5wjCaepz16n24Iia2u9FkQimC
         6PPM2EM14psr6x9juh3qDt8Kga8YMThNLpyUu50g=
Date:   Thu, 22 Oct 2020 16:09:52 -0700
From:   akpm@linux-foundation.org
To:     alexander.h.duyck@linux.intel.com, axboe@kernel.dk,
        bgeffon@google.com, christian.brauner@ubuntu.com,
        dancol@google.com, fw@deneb.enyo.de, hannes@cmpxchg.org,
        jannh@google.com, joaodias@google.com, joel@joelfernandes.org,
        ktkhai@virtuozzo.com, linux-man@vger.kernel.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        oleksandr@redhat.com, rientjes@google.com, shakeelb@google.com,
        sj38.park@gmail.com, sjpark@amazon.de, sonnyrao@google.com,
        sspatil@google.com, surenb@google.com, timmurray@google.com,
        vbabka@suse.cz
Subject:  [merged] pid-move-pidfd_get_pid-to-pidc.patch removed
 from -mm tree
Message-ID: <20201022230952.VlMFOARgW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: pid: move pidfd_get_pid() to pid.c
has been removed from the -mm tree.  Its filename was
     pid-move-pidfd_get_pid-to-pidc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: pid: move pidfd_get_pid() to pid.c

process_madvise syscall needs pidfd_get_pid function to translate pidfd to
pid so this patch move the function to kernel/pid.c.

Link: http://lkml.kernel.org/r/20200302193630.68771-5-minchan@kernel.org
Link: http://lkml.kernel.org/r/20200622192900.22757-3-minchan@kernel.org
Link: https://lkml.kernel.org/r/20200901000633.1920247-3-minchan@kernel.org
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jann Horn <jannh@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Daniel Colascione <dancol@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Dias <joaodias@google.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: Sandeep Patil <sspatil@google.com>
Cc: SeongJae Park <sj38.park@gmail.com>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Florian Weimer <fw@deneb.enyo.de>
Cc: <linux-man@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |    1 +
 kernel/exit.c       |   19 -------------------
 kernel/pid.c        |   19 +++++++++++++++++++
 3 files changed, 20 insertions(+), 19 deletions(-)

--- a/include/linux/pid.h~pid-move-pidfd_get_pid-to-pidc
+++ a/include/linux/pid.h
@@ -77,6 +77,7 @@ extern const struct file_operations pidf
 struct file;
 
 extern struct pid *pidfd_pid(const struct file *file);
+struct pid *pidfd_get_pid(unsigned int fd, unsigned int *flags);
 
 static inline struct pid *get_pid(struct pid *pid)
 {
--- a/kernel/exit.c~pid-move-pidfd_get_pid-to-pidc
+++ a/kernel/exit.c
@@ -1474,25 +1474,6 @@ end:
 	return retval;
 }
 
-static struct pid *pidfd_get_pid(unsigned int fd, unsigned int *flags)
-{
-	struct fd f;
-	struct pid *pid;
-
-	f = fdget(fd);
-	if (!f.file)
-		return ERR_PTR(-EBADF);
-
-	pid = pidfd_pid(f.file);
-	if (!IS_ERR(pid)) {
-		get_pid(pid);
-		*flags = f.file->f_flags;
-	}
-
-	fdput(f);
-	return pid;
-}
-
 static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
 			  int options, struct rusage *ru)
 {
--- a/kernel/pid.c~pid-move-pidfd_get_pid-to-pidc
+++ a/kernel/pid.c
@@ -520,6 +520,25 @@ struct pid *find_ge_pid(int nr, struct p
 	return idr_get_next(&ns->idr, &nr);
 }
 
+struct pid *pidfd_get_pid(unsigned int fd, unsigned int *flags)
+{
+	struct fd f;
+	struct pid *pid;
+
+	f = fdget(fd);
+	if (!f.file)
+		return ERR_PTR(-EBADF);
+
+	pid = pidfd_pid(f.file);
+	if (!IS_ERR(pid)) {
+		get_pid(pid);
+		*flags = f.file->f_flags;
+	}
+
+	fdput(f);
+	return pid;
+}
+
 /**
  * pidfd_create() - Create a new pid file descriptor.
  *
_

Patches currently in -mm which might be from minchan@kernel.org are


