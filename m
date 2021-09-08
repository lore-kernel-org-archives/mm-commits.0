Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9D8C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FA4E6113E
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347443AbhIHC5t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347371AbhIHC5t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:57:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E51C6113C;
        Wed,  8 Sep 2021 02:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069802;
        bh=rGh/JolG2PdRJ3jzIfdn/8uyAyutZM8V2U+D6HtEHN4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ycQI1O4eL3gaMzlfR4z7eJ3SbYzKgRQsnfCotbDrUN65+lYfrkqwqpQ20fDt6igRO
         N1ZvrJdDdQvEDAkbMvWIqhn1vwC+VnBihOSAePTs2HSljaCFkLfJErL+anBFj6MTgA
         5JHMfg/YqFw55pvR9sHXvpba27LrnT7ZskL6obIE=
Date:   Tue, 07 Sep 2021 19:56:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.shishkin@linux.intel.com,
        amit@kernel.org, benh@kernel.crashing.org,
        brendanhiggins@google.com, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, fan.du@intel.com,
        foersleo@amazon.de, greg@kroah.com, gthelen@google.com,
        joe@perches.com, Jonathan.Cameron@huawei.com, linux-mm@kvack.org,
        markubo@amazon.de, mgorman@suse.de, mheyne@amazon.de,
        minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        namhyung@kernel.org, peterz@infradead.org, riel@surriel.com,
        rientjes@google.com, rostedt@goodmis.org, shakeelb@google.com,
        shuah@kernel.org, sieberf@amazon.com, sjpark@amazon.de,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  [patch 066/147] mm/idle_page_tracking: make PG_idle
 reusable
Message-ID: <20210908025640.0BpdCTuwq%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>
Subject: mm/idle_page_tracking: make PG_idle reusable

PG_idle and PG_young allow the two PTE Accessed bit users, Idle Page
Tracking and the reclaim logic concurrently work while not interfering
with each other.  That is, when they need to clear the Accessed bit, they
set PG_young to represent the previous state of the bit, respectively. 
And when they need to read the bit, if the bit is cleared, they further
read the PG_young to know whether the other has cleared the bit meanwhile
or not.

For yet another user of the PTE Accessed bit, we could add another page
flag, or extend the mechanism to use the flags.  For the DAMON usecase,
however, we don't need to do that just yet.  IDLE_PAGE_TRACKING and DAMON
are mutually exclusive, so there's only ever going to be one user of the
current set of flags.

In this commit, we split out the CONFIG options to allow for the use of
PG_young and PG_idle outside of idle page tracking.

In the next commit, DAMON's reference implementation of the virtual memory
address space monitoring primitives will use it.

[sjpark@amazon.de: set PAGE_EXTENSION for non-64BIT]
  Link: https://lkml.kernel.org/r/20210806095153.6444-1-sj38.park@gmail.com
[akpm@linux-foundation.org: tweak Kconfig text]
[sjpark@amazon.de: hide PAGE_IDLE_FLAG from users]
  Link: https://lkml.kernel.org/r/20210813081238.34705-1-sj38.park@gmail.com
Link: https://lkml.kernel.org/r/20210716081449.22187-5-sj38.park@gmail.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Fernand Sieber <sieberf@amazon.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Fan Du <fan.du@intel.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Maximilian Heyne <mheyne@amazon.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h     |    4 ++--
 include/linux/page_ext.h       |    2 +-
 include/linux/page_idle.h      |    6 +++---
 include/trace/events/mmflags.h |    2 +-
 mm/Kconfig                     |   10 +++++++++-
 mm/page_ext.c                  |   12 +++++++++++-
 mm/page_idle.c                 |   10 ----------
 7 files changed, 27 insertions(+), 19 deletions(-)

--- a/include/linux/page_ext.h~mm-idle_page_tracking-make-pg_idle-reusable
+++ a/include/linux/page_ext.h
@@ -19,7 +19,7 @@ struct page_ext_operations {
 enum page_ext_flags {
 	PAGE_EXT_OWNER,
 	PAGE_EXT_OWNER_ALLOCATED,
-#if defined(CONFIG_IDLE_PAGE_TRACKING) && !defined(CONFIG_64BIT)
+#if defined(CONFIG_PAGE_IDLE_FLAG) && !defined(CONFIG_64BIT)
 	PAGE_EXT_YOUNG,
 	PAGE_EXT_IDLE,
 #endif
--- a/include/linux/page-flags.h~mm-idle_page_tracking-make-pg_idle-reusable
+++ a/include/linux/page-flags.h
@@ -131,7 +131,7 @@ enum pageflags {
 #ifdef CONFIG_MEMORY_FAILURE
 	PG_hwpoison,		/* hardware poisoned page. Don't touch */
 #endif
-#if defined(CONFIG_IDLE_PAGE_TRACKING) && defined(CONFIG_64BIT)
+#if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
 	PG_young,
 	PG_idle,
 #endif
@@ -441,7 +441,7 @@ PAGEFLAG_FALSE(HWPoison)
 #define __PG_HWPOISON 0
 #endif
 
-#if defined(CONFIG_IDLE_PAGE_TRACKING) && defined(CONFIG_64BIT)
+#if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
 TESTPAGEFLAG(Young, young, PF_ANY)
 SETPAGEFLAG(Young, young, PF_ANY)
 TESTCLEARFLAG(Young, young, PF_ANY)
--- a/include/linux/page_idle.h~mm-idle_page_tracking-make-pg_idle-reusable
+++ a/include/linux/page_idle.h
@@ -6,7 +6,7 @@
 #include <linux/page-flags.h>
 #include <linux/page_ext.h>
 
-#ifdef CONFIG_IDLE_PAGE_TRACKING
+#ifdef CONFIG_PAGE_IDLE_FLAG
 
 #ifdef CONFIG_64BIT
 static inline bool page_is_young(struct page *page)
@@ -106,7 +106,7 @@ static inline void clear_page_idle(struc
 }
 #endif /* CONFIG_64BIT */
 
-#else /* !CONFIG_IDLE_PAGE_TRACKING */
+#else /* !CONFIG_PAGE_IDLE_FLAG */
 
 static inline bool page_is_young(struct page *page)
 {
@@ -135,6 +135,6 @@ static inline void clear_page_idle(struc
 {
 }
 
-#endif /* CONFIG_IDLE_PAGE_TRACKING */
+#endif /* CONFIG_PAGE_IDLE_FLAG */
 
 #endif /* _LINUX_MM_PAGE_IDLE_H */
--- a/include/trace/events/mmflags.h~mm-idle_page_tracking-make-pg_idle-reusable
+++ a/include/trace/events/mmflags.h
@@ -75,7 +75,7 @@
 #define IF_HAVE_PG_HWPOISON(flag,string)
 #endif
 
-#if defined(CONFIG_IDLE_PAGE_TRACKING) && defined(CONFIG_64BIT)
+#if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
 #define IF_HAVE_PG_IDLE(flag,string) ,{1UL << flag, string}
 #else
 #define IF_HAVE_PG_IDLE(flag,string)
--- a/mm/Kconfig~mm-idle_page_tracking-make-pg_idle-reusable
+++ a/mm/Kconfig
@@ -739,10 +739,18 @@ config DEFERRED_STRUCT_PAGE_INIT
 	  lifetime of the system until these kthreads finish the
 	  initialisation.
 
+config PAGE_IDLE_FLAG
+	bool
+	select PAGE_EXTENSION if !64BIT
+	help
+	  This adds PG_idle and PG_young flags to 'struct page'.  PTE Accessed
+	  bit writers can set the state of the bit in the flags so that PTE
+	  Accessed bit readers may avoid disturbance.
+
 config IDLE_PAGE_TRACKING
 	bool "Enable idle page tracking"
 	depends on SYSFS && MMU
-	select PAGE_EXTENSION if !64BIT
+	select PAGE_IDLE_FLAG
 	help
 	  This feature allows to estimate the amount of user pages that have
 	  not been touched during a given period of time. This information can
--- a/mm/page_ext.c~mm-idle_page_tracking-make-pg_idle-reusable
+++ a/mm/page_ext.c
@@ -58,11 +58,21 @@
  * can utilize this callback to initialize the state of it correctly.
  */
 
+#if defined(CONFIG_PAGE_IDLE_FLAG) && !defined(CONFIG_64BIT)
+static bool need_page_idle(void)
+{
+	return true;
+}
+struct page_ext_operations page_idle_ops = {
+	.need = need_page_idle,
+};
+#endif
+
 static struct page_ext_operations *page_ext_ops[] = {
 #ifdef CONFIG_PAGE_OWNER
 	&page_owner_ops,
 #endif
-#if defined(CONFIG_IDLE_PAGE_TRACKING) && !defined(CONFIG_64BIT)
+#if defined(CONFIG_PAGE_IDLE_FLAG) && !defined(CONFIG_64BIT)
 	&page_idle_ops,
 #endif
 };
--- a/mm/page_idle.c~mm-idle_page_tracking-make-pg_idle-reusable
+++ a/mm/page_idle.c
@@ -207,16 +207,6 @@ static const struct attribute_group page
 	.name = "page_idle",
 };
 
-#ifndef CONFIG_64BIT
-static bool need_page_idle(void)
-{
-	return true;
-}
-struct page_ext_operations page_idle_ops = {
-	.need = need_page_idle,
-};
-#endif
-
 static int __init page_idle_init(void)
 {
 	int err;
_
