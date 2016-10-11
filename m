From: akpm@linux-foundation.org
Subject: [patch 076/102] config: android: enable CONFIG_SECCOMP
Date: Tue, 11 Oct 2016 13:54:44 -0700
Message-ID: <57fd5194.X9w04oi/F94tM1xp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38528 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751993AbcJKVAu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 17:00:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, robh@kernel.org, amit.pundir@linaro.org, dimitrysh@google.com, john.stultz@linaro.org

From: Rob Herring <robh@kernel.org>
Subject: config: android: enable CONFIG_SECCOMP

As of Android N, SECCOMP is required. Without it, we will get
mediaextractor error:

E /system/bin/mediaextractor: libminijail: prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER): Invalid argument

Link: http://lkml.kernel.org/r/20160908185934.18098-3-robh@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Acked-by: John Stultz <john.stultz@linaro.org>
Cc: Amit Pundir <amit.pundir@linaro.org>
Cc: Dmitry Shmidt <dimitrysh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs/android-base.config |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/configs/android-base.config~config-android-enable-config_seccomp kernel/configs/android-base.config
--- a/kernel/configs/android-base.config~config-android-enable-config_seccomp
+++ a/kernel/configs/android-base.config
@@ -131,6 +131,7 @@ CONFIG_PREEMPT=y
 CONFIG_QUOTA=y
 CONFIG_RTC_CLASS=y
 CONFIG_RT_GROUP_SCHED=y
+CONFIG_SECCOMP=y
 CONFIG_SECURITY=y
 CONFIG_SECURITY_NETWORK=y
 CONFIG_SECURITY_SELINUX=y
_
