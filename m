Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8777FC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72577610E6
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347933AbhIBV4b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347857AbhIBV4G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:56:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C58D8610A0;
        Thu,  2 Sep 2021 21:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619708;
        bh=9Khd0fiL6Y0w4zEeD14hyDQqzQXIFxHV6a86me1iQ00=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tOxB9lvSvXhJP6ZDhH+Nf3AP/dJOy4Ky9xWVXo7+J72mcjhyP5RO3lMqyG0+VGDo7
         aluU3VPMoOY2IfMF9SP06g41fXbEvi1FsBP1HsfBJpF3UYD1tAvln6/npfwjncByW+
         5ekoBjVhsHWGLH72lHFiutLbZwXhhEPHXumAQ2Iw=
Date:   Thu, 02 Sep 2021 14:55:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, nglaive@gmail.com,
        shakeelb@google.com, shenwenbo@zju.edu.cn,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject:  [patch 098/212] memcg: charge fs_context and
 legacy_fs_context
Message-ID: <20210902215507.FVhZ-cq1V%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yutian Yang <nglaive@gmail.com>
Subject: memcg: charge fs_context and legacy_fs_context

This patch adds accounting flags to fs_context and legacy_fs_context
allocation sites so that kernel could correctly charge these objects.

We have written a PoC to demonstrate the effect of the missing-charging
bugs.  The PoC takes around 1,200MB unaccounted memory, while it is
charged for only 362MB memory usage.  We evaluate the PoC on QEMU x86_64
v5.2.90 + Linux kernel v5.10.19 + Debian buster.  All the limitations
including ulimits and sysctl variables are set as default.  Specifically,
the hard NOFILE limit and nr_open in sysctl are both 1,048,576.

/*------------------------- POC code ----------------------------*/

#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/file.h>
#include <time.h>
#include <sys/wait.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>
#include <sched.h>
#include <fcntl.h>
#include <linux/mount.h>

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)

#define STACK_SIZE (8 * 1024)
#ifndef __NR_fsopen
#define __NR_fsopen 430
#endif
static inline int fsopen(const char *fs_name, unsigned int flags)
{
        return syscall(__NR_fsopen, fs_name, flags);
}

static char thread_stack[512][STACK_SIZE];

int thread_fn(void* arg)
{
  for (int i = 0; i< 800000; ++i) {
    int fsfd = fsopen("nfs", FSOPEN_CLOEXEC);
    if (fsfd == -1) {
      errExit("fsopen");
    }
  }
  while(1);
  return 0;
}

int main(int argc, char *argv[]) {
  int thread_pid;
  for (int i = 0; i < 1; ++i) {
    thread_pid = clone(thread_fn, thread_stack[i] + STACK_SIZE, \
      SIGCHLD, NULL);
  }
  while(1);
  return 0;
}

/*-------------------------- end --------------------------------*/

Link: https://lkml.kernel.org/r/1626517201-24086-1-git-send-email-nglaive@gmail.com
Signed-off-by: Yutian Yang <nglaive@gmail.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <shenwenbo@zju.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs_context.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/fs_context.c~memcg-charge-fs_context-and-legacy_fs_context
+++ a/fs/fs_context.c
@@ -254,7 +254,7 @@ static struct fs_context *alloc_fs_conte
 	struct fs_context *fc;
 	int ret = -ENOMEM;
 
-	fc = kzalloc(sizeof(struct fs_context), GFP_KERNEL);
+	fc = kzalloc(sizeof(struct fs_context), GFP_KERNEL_ACCOUNT);
 	if (!fc)
 		return ERR_PTR(-ENOMEM);
 
@@ -649,7 +649,7 @@ const struct fs_context_operations legac
  */
 static int legacy_init_fs_context(struct fs_context *fc)
 {
-	fc->fs_private = kzalloc(sizeof(struct legacy_fs_context), GFP_KERNEL);
+	fc->fs_private = kzalloc(sizeof(struct legacy_fs_context), GFP_KERNEL_ACCOUNT);
 	if (!fc->fs_private)
 		return -ENOMEM;
 	fc->ops = &legacy_fs_context_ops;
_
