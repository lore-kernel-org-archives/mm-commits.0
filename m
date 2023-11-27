Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8930C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 20:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjK0Uco (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 15:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbjK0Uco (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 15:32:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495E9BD
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 12:32:50 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC36BC433C7;
        Mon, 27 Nov 2023 20:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701117169;
        bh=Tmnm8fsecdB2YlEDHp1M3hzQWAytjpvjoI8kpkH/zbU=;
        h=Date:To:From:Subject:From;
        b=Pgtv6l60A3/jeXVcDkA+qmXUVs/2Vom22urnTBecbQHv/Eu3hLZ9Bg2syctXrYo+m
         Ye24wu6EJQTK9ZAcuhx/1NSNpzrz9Er9S3ouXtKirt9U5kmMl051yEajRa6O+UHcAQ
         DUyTktoo/DEihGybmvdXirt09aEbLjTztOqhCOt8=
Date:   Mon, 27 Nov 2023 12:32:48 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, ddrokosov@salutedevices.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-introduce-new-samples-subdir-for-cgroup.patch added to mm-unstable branch
Message-Id: <20231127203249.DC36BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: samples: introduce new samples subdir for cgroup
has been added to the -mm mm-unstable branch.  Its filename is
     samples-introduce-new-samples-subdir-for-cgroup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-introduce-new-samples-subdir-for-cgroup.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dmitry Rokosov <ddrokosov@salutedevices.com>
Subject: samples: introduce new samples subdir for cgroup
Date: Thu, 23 Nov 2023 10:19:43 +0300

Patch series "samples: introduce cgroup events listeners", v3.

To begin with, this patch series relocates the cgroup example code to the
samples/cgroup directory, which is the appropriate location for such code
snippets.

Furthermore, a new memcg events listener is introduced.  This listener is
a simple yet effective tool for monitoring memory events and managing
counter changes during runtime.

Additionally, as per Andrew Morton's suggestion, a helpful reminder
comment is included in the memcontrol implementation.  This comment serves
to ensure that the samples code is updated whenever new events are added.


This patch (of 3):

Move the cgroup_event_listener for cgroup v1 to the samples directory. 
This suggestion was proposed by Andrew Morton during the discussion [1].

Link: https://lore.kernel.org/all/20231106140934.3f5d4960141562fe8da53906@linux-foundation.org/ [1]
Link: https://lkml.kernel.org/r/20231123071945.25811-1-ddrokosov@salutedevices.com
Link: https://lkml.kernel.org/r/20231123071945.25811-2-ddrokosov@salutedevices.com
Signed-off-by: Dmitry Rokosov <ddrokosov@salutedevices.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS             |    1 +
 samples/Kconfig         |    6 ++++++
 samples/Makefile        |    1 +
 samples/cgroup/Makefile |    5 +++++
 tools/cgroup/Makefile   |   11 -----------
 5 files changed, 13 insertions(+), 11 deletions(-)

--- a/MAINTAINERS~samples-introduce-new-samples-subdir-for-cgroup
+++ a/MAINTAINERS
@@ -5352,6 +5352,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/memcontrol.c
 F:	mm/swap_cgroup.c
+F:	samples/cgroup/*
 F:	tools/testing/selftests/cgroup/memcg_protection.m
 F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
 F:	tools/testing/selftests/cgroup/test_kmem.c
--- /dev/null
+++ a/samples/cgroup/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
+userprogs-always-y += cgroup_event_listener
+
+userccflags += -I usr/include
--- a/samples/Kconfig~samples-introduce-new-samples-subdir-for-cgroup
+++ a/samples/Kconfig
@@ -285,6 +285,12 @@ config SAMPLE_KMEMLEAK
           Build a sample program which have explicitly leaks memory to test
           kmemleak
 
+config SAMPLE_CGROUP
+	bool "Build cgroup sample code"
+	depends on CGROUPS && CC_CAN_LINK && HEADERS_INSTALL
+	help
+	  Build samples that demonstrate the usage of the cgroup API.
+
 source "samples/rust/Kconfig"
 
 endif # SAMPLES
--- a/samples/Makefile~samples-introduce-new-samples-subdir-for-cgroup
+++ a/samples/Makefile
@@ -3,6 +3,7 @@
 
 subdir-$(CONFIG_SAMPLE_AUXDISPLAY)	+= auxdisplay
 subdir-$(CONFIG_SAMPLE_ANDROID_BINDERFS) += binderfs
+subdir-$(CONFIG_SAMPLE_CGROUP) += cgroup
 obj-$(CONFIG_SAMPLE_CONFIGFS)		+= configfs/
 obj-$(CONFIG_SAMPLE_CONNECTOR)		+= connector/
 obj-$(CONFIG_SAMPLE_FANOTIFY_ERROR)	+= fanotify/
--- a/tools/cgroup/Makefile
+++ /dev/null
@@ -1,11 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-# Makefile for cgroup tools
-
-CFLAGS = -Wall -Wextra
-
-all: cgroup_event_listener
-%: %.c
-	$(CC) $(CFLAGS) -o $@ $^
-
-clean:
-	$(RM) cgroup_event_listener
_

Patches currently in -mm which might be from ddrokosov@salutedevices.com are

mm-memcg-print-out-cgroup-ino-in-the-memcg-tracepoints.patch
mm-memcg-introduce-new-event-to-trace-shrink_memcg.patch
samples-introduce-new-samples-subdir-for-cgroup.patch
samples-cgroup-introduce-memcg-memoryevents-listener.patch
mm-memcg-add-reminder-comment-for-the-memcg-v2-events.patch

