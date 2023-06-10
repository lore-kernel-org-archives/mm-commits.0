Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30091C7EE29
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjFJAdx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjFJAdw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:33:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2FF30D2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:33:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B640613EA
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4423C433D2;
        Sat, 10 Jun 2023 00:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357230;
        bh=M0+c1yqujGdTLqh800O/heR0jgCuZ0DmbRE+yTowhbQ=;
        h=Date:To:From:Subject:From;
        b=TYhwBQtexnkSUl3HjNibTWZFEnOG8gYXtF7e0KYHIsQj/9LbxnCVF9HiQVaE7FuGF
         9AWMEZI4vaAC2IwkEMCUfOqyHw+VE/BhWy3VdJ1Z6F62+y2biNrzr2U940DeH+UwQa
         1rcGwowAWTOci3jVRI9S8gzjcUqWDjdIFcS7PLWs=
Date:   Fri, 09 Jun 2023 17:33:49 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com,
        dianders@chromium.org, trix@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] watchdog-delete-old-declarations-for-watchdog_softhardlockup_user_enabled-make-static.patch removed from -mm tree
Message-Id: <20230610003349.E4423C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog: delete old declarations for watchdog_soft,hardlockup_user_enabled + make static
has been removed from the -mm tree.  Its filename was
     watchdog-delete-old-declarations-for-watchdog_softhardlockup_user_enabled-make-static.patch

This patch was dropped because it was folded into watchdog-hardlockup-rename-some-nmi-watchdog-constants-function.patch

------------------------------------------------------
From: Tom Rix <trix@redhat.com>
Subject: watchdog: delete old declarations for watchdog_soft,hardlockup_user_enabled + make static
Date: Thu, 25 May 2023 16:28:32 -0700

smatch reports
kernel/watchdog.c:40:19: warning: symbol
  'watchdog_hardlockup_user_enabled' was not declared. Should it be static?
kernel/watchdog.c:41:19: warning: symbol
  'watchdog_softlockup_user_enabled' was not declared. Should it be static?

These variables are only used in their defining file, so they should
be static.

This problem showed up after the patch ("watchdog/hardlockup: rename some
"NMI watchdog" constants/function") because that rename missed the header
file.  That didn't cause any compile-time errors because, since commit
dd0693fdf054 ("watchdog: move watchdog sysctl interface to watchdog.c"),
nobody outside of "watchdog.c" was actually referring to them.  Thus, not
only should we make these variables static but we should remove the old
declarations in the header file that we missed renaming.

[dianders@chromium.org: updated subject + commit message; squashed in Petr's suggestion]
Link: https://lkml.kernel.org/r/20230525162822.1.I0fb41d138d158c9230573eaa37dc56afa2fb14ee@changeid
Fixes: 4b95b620dcd5 ("watchdog/hardlockup: rename some "NMI watchdog" constants/function")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Tom Rix <trix@redhat.com>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    6 ++----
 kernel/watchdog.c   |    4 ++--
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/include/linux/nmi.h~watchdog-delete-old-declarations-for-watchdog_softhardlockup_user_enabled-make-static
+++ a/include/linux/nmi.h
@@ -17,8 +17,6 @@ void lockup_detector_soft_poweroff(void)
 void lockup_detector_cleanup(void);
 
 extern int watchdog_user_enabled;
-extern int nmi_watchdog_user_enabled;
-extern int soft_watchdog_user_enabled;
 extern int watchdog_thresh;
 extern unsigned long watchdog_enabled;
 
@@ -68,8 +66,8 @@ static inline void reset_hung_task_detec
  * 'watchdog_enabled' variable. Each lockup detector has its dedicated bit -
  * bit 0 for the hard lockup detector and bit 1 for the soft lockup detector.
  *
- * 'watchdog_user_enabled', 'nmi_watchdog_user_enabled' and
- * 'soft_watchdog_user_enabled' are variables that are only used as an
+ * 'watchdog_user_enabled', 'watchdog_hardlockup_user_enabled' and
+ * 'watchdog_softlockup_user_enabled' are variables that are only used as an
  * 'interface' between the parameters in /proc/sys/kernel and the internal
  * state bits in 'watchdog_enabled'. The 'watchdog_thresh' variable is
  * handled differently because its value is not boolean, and the lockup
--- a/kernel/watchdog.c~watchdog-delete-old-declarations-for-watchdog_softhardlockup_user_enabled-make-static
+++ a/kernel/watchdog.c
@@ -37,8 +37,8 @@ static DEFINE_MUTEX(watchdog_mutex);
 
 unsigned long __read_mostly watchdog_enabled;
 int __read_mostly watchdog_user_enabled = 1;
-int __read_mostly watchdog_hardlockup_user_enabled = WATCHDOG_HARDLOCKUP_DEFAULT;
-int __read_mostly watchdog_softlockup_user_enabled = 1;
+static int __read_mostly watchdog_hardlockup_user_enabled = WATCHDOG_HARDLOCKUP_DEFAULT;
+static int __read_mostly watchdog_softlockup_user_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
 static int __read_mostly watchdog_hardlockup_available;
 
_

Patches currently in -mm which might be from trix@redhat.com are

watchdog-hardlockup-rename-some-nmi-watchdog-constants-function.patch

