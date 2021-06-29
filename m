Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AE6C11F68
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5E5D61D00
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbhF2Cgt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhF2Cgs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:36:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2887861D01;
        Tue, 29 Jun 2021 02:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934061;
        bh=2iRfE0JTm6wyFLp7XVFXiRgUs+z0poBaTfg/hkmSe8o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=U/qDB6zwY4nt6jSekUXJUkkKy9UUvJtVfD1da5IzGmwqgx2NZgAeSl6bEQ//bHNWc
         h2I5pkH4b6K8hthZw3LY0GUEGSQFq5MOL+ga7i/8Fp7NVy5KjaLzI0W3pvOUDMTB0P
         mqNzGXR1MCGBrAIX0Qh5JnJKbcDsy/wjGBSPqZiQ=
Date:   Mon, 28 Jun 2021 19:34:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, gpiccoli@canonical.com,
        joe@perches.com, keescook@chromium.org, linux-mm@kvack.org,
        mchehab+huawei@kernel.org, mm-commits@vger.kernel.org,
        pmladek@suse.com, qais.yousef@arm.com, rdunlap@infradead.org,
        santosh@fossix.org, steve@sk2.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, wangqing@vivo.com
Subject:  [patch 020/192] doc: watchdog: modify the explanation
 related to watchdog thread
Message-ID: <20210629023420.2GMMUS9s8%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>
Subject: doc: watchdog: modify the explanation related to watchdog thread

"watchdog/%u" threads has be replaced by cpu_stop_work.  The current
description is extremely misleading.

Link: https://lkml.kernel.org/r/1619687073-24686-4-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Qais Yousef <qais.yousef@arm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Santosh Sivaraj <santosh@fossix.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/lockup-watchdogs.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/lockup-watchdogs.rst~doc-watchdog-modify-the-explanation-related-to-watchdog-thread
+++ a/Documentation/admin-guide/lockup-watchdogs.rst
@@ -39,7 +39,7 @@ in principle, they should work in any ar
 subsystems are present.
 
 A periodic hrtimer runs to generate interrupts and kick the watchdog
-task. An NMI perf event is generated every "watchdog_thresh"
+job. An NMI perf event is generated every "watchdog_thresh"
 (compile-time initialized to 10 and configurable through sysctl of the
 same name) seconds to check for hardlockups. If any CPU in the system
 does not receive any hrtimer interrupt during that time the
@@ -47,7 +47,7 @@ does not receive any hrtimer interrupt d
 generate a kernel warning or call panic, depending on the
 configuration.
 
-The watchdog task is a high priority kernel thread that updates a
+The watchdog job runs in a stop scheduling thread that updates a
 timestamp every time it is scheduled. If that timestamp is not updated
 for 2*watchdog_thresh seconds (the softlockup threshold) the
 'softlockup detector' (coded inside the hrtimer callback function)
_
