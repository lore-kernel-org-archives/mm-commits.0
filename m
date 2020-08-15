Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72470C433E1
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A6412065C
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529490;
	bh=a75//nuJqj8HMG+JgXFzyRjdz5w6Wfl4RUCLGGDhVB8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Ob6Tuehk4OEyBG9cqfMDJHw9LQg7fSqTwPAm36ZacX032UP9gyxToTA9GeQQT+b5h
	 1LXL49MfwBhgFak/GM5wqkzf5lx7CClf6L7jS47bQ3fu5Q9CJ6S9hoRoecywbRgXYB
	 KR+4xqlKLQRX4l9QULmC1Gqx3yXrOSAPmGbU2NJg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbgHOWLU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:11:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729374AbgHOWKa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84ECD22CBB;
        Sat, 15 Aug 2020 00:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451455;
        bh=a75//nuJqj8HMG+JgXFzyRjdz5w6Wfl4RUCLGGDhVB8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ROTePZXJiSa2fbuQqcJ3i3kREaaqmJz8g3AfunWC2HZwXsu5Kr9Wsq3qYXQnpAH2u
         YWvwvWTHXv/FDsUid8v2FUnZlAoqqFJKObXrCTJuCy6UNhGh+4qF08iaQQAR0pjxPw
         hy/s7e7jTkzjZFFx4SeQ0K6fQa/SA6DNwJ9UK0Kg=
Date:   Fri, 14 Aug 2020 17:30:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        axboe@kernel.dk, bgeffon@google.com, christian.brauner@ubuntu.com,
        dancol@google.com, hannes@cmpxchg.org, jannh@google.com,
        joaodias@google.com, joel@joelfernandes.org, ktkhai@virtuozzo.com,
        linux-man@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        oleksandr@redhat.com, rientjes@google.com, shakeelb@google.com,
        sj38.park@gmail.com, sjpark@amazon.de, sonnyrao@google.com,
        sspatil@google.com, surenb@google.com, timmurray@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 16/39] pid: move pidfd_get_pid() to pid.c
Message-ID: <20200815003054.OgBLpWc6x%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: pid: move pidfd_get_pid() to pid.c

process_madvise syscall needs pidfd_get_pid function to translate pidfd to
pid so this patch move the function to kernel/pid.c.

Link: http://lkml.kernel.org/r/20200302193630.68771-5-minchan@kernel.org
Link: http://lkml.kernel.org/r/20200622192900.22757-3-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
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
Cc: <linux-man@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |    1 +
 kernel/exit.c       |   17 -----------------
 kernel/pid.c        |   17 +++++++++++++++++
 3 files changed, 18 insertions(+), 17 deletions(-)

--- a/include/linux/pid.h~pid-move-pidfd_get_pid-to-pidc
+++ a/include/linux/pid.h
@@ -77,6 +77,7 @@ extern const struct file_operations pidf
 struct file;
 
 extern struct pid *pidfd_pid(const struct file *file);
+struct pid *pidfd_get_pid(unsigned int fd);
 
 static inline struct pid *get_pid(struct pid *pid)
 {
--- a/kernel/exit.c~pid-move-pidfd_get_pid-to-pidc
+++ a/kernel/exit.c
@@ -1474,23 +1474,6 @@ end:
 	return retval;
 }
 
-static struct pid *pidfd_get_pid(unsigned int fd)
-{
-	struct fd f;
-	struct pid *pid;
-
-	f = fdget(fd);
-	if (!f.file)
-		return ERR_PTR(-EBADF);
-
-	pid = pidfd_pid(f.file);
-	if (!IS_ERR(pid))
-		get_pid(pid);
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
@@ -519,6 +519,23 @@ struct pid *find_ge_pid(int nr, struct p
 	return idr_get_next(&ns->idr, &nr);
 }
 
+struct pid *pidfd_get_pid(unsigned int fd)
+{
+	struct fd f;
+	struct pid *pid;
+
+	f = fdget(fd);
+	if (!f.file)
+		return ERR_PTR(-EBADF);
+
+	pid = pidfd_pid(f.file);
+	if (!IS_ERR(pid))
+		get_pid(pid);
+
+	fdput(f);
+	return pid;
+}
+
 /**
  * pidfd_create() - Create a new pid file descriptor.
  *
_
