From: akpm@linux-foundation.org
Subject: + config-android-enable-config_seccomp.patch added to -mm tree
Date: Thu, 08 Sep 2016 15:05:10 -0700
Message-ID: <57d1e096.KmTfUuIVcEKkH1Gi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45621 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941100AbcIHWFL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2016 18:05:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robh@kernel.org, amit.pundir@linaro.org, dimitrysh@google.com, john.stultz@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: config: android: enable CONFIG_SECCOMP
has been added to the -mm tree.  Its filename is
     config-android-enable-config_seccomp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/config-android-enable-config_seccomp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/config-android-enable-config_seccomp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from robh@kernel.org are

config-android-move-device-mapper-options-to-recommended.patch
config-android-set-selinux-as-default-security-mode.patch
config-android-enable-config_seccomp.patch

