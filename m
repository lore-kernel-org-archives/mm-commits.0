From: akpm@linux-foundation.org
Subject: [patch 29/78] config: android-base: enable hardened usercopy and
 kernel ASLR
Date: Mon, 27 Feb 2017 14:28:06 -0800
Message-ID: <58b4a7f6.U5SUt2JuAGmMszGO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45430 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751568AbdB0Wgl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:36:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, amit.pundir@linaro.org, danielmicay@gmail.com, john.stultz@linaro.org, rob.herring@linaro.org

From: Amit Pundir <amit.pundir@linaro.org>
Subject: config: android-base: enable hardened usercopy and kernel ASLR

Enable CONFIG_HARDENED_USERCOPY and CONFIG_RANDOMIZE_BASE in Android
base config fragment.

Reviewed at https://android-review.googlesource.com/#/c/283659/
Reviewed at https://android-review.googlesource.com/#/c/278133/

Link: http://lkml.kernel.org/r/1481113148-29204-2-git-send-email-amit.pundir@linaro.org
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Cc: Rob Herring <rob.herring@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs/android-base.config |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/configs/android-base.config~config-android-base-enable-hardened-usercopy-and-kernel-aslr kernel/configs/android-base.config
--- a/kernel/configs/android-base.config~config-android-base-enable-hardened-usercopy-and-kernel-aslr
+++ a/kernel/configs/android-base.config
@@ -21,6 +21,7 @@ CONFIG_CP15_BARRIER_EMULATION=y
 CONFIG_DEFAULT_SECURITY_SELINUX=y
 CONFIG_EMBEDDED=y
 CONFIG_FB=y
+CONFIG_HARDENED_USERCOPY=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_INET6_AH=y
 CONFIG_INET6_ESP=y
@@ -129,6 +130,7 @@ CONFIG_PPP_DEFLATE=y
 CONFIG_PPP_MPPE=y
 CONFIG_PREEMPT=y
 CONFIG_QUOTA=y
+CONFIG_RANDOMIZE_BASE=y
 CONFIG_RTC_CLASS=y
 CONFIG_RT_GROUP_SCHED=y
 CONFIG_SECCOMP=y
_
