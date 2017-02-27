From: akpm@linux-foundation.org
Subject: [patch 28/78] config: android-recommended: disable aio support
Date: Mon, 27 Feb 2017 14:28:03 -0800
Message-ID: <58b4a7f3.QIyj15FIMeiGFq25%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45540 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751910AbdB0WgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:36:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, danielmicay@gmail.com, amit.pundir@linaro.org, john.stultz@linaro.org, rob.herring@linaro.org

From: Daniel Micay <danielmicay@gmail.com>
Subject: config: android-recommended: disable aio support

The aio interface adds substantial attack surface for a feature that's not
being exposed by Android at all.  It's unlikely that anyone is using the
kernel feature directly either.  This feature is rarely used even on
servers.  The glibc POSIX aio calls really use thread pools.  The lack of
widespread usage also means this is relatively poorly audited/tested.

The kernel's aio rarely provides performance benefits over using a thread
pool and is quite incomplete in terms of system call coverage along with
having edge cases where blocking can occur.  Part of the performance issue
is the fact that it only supports direct io, not buffered io.  The
existing API is considered fundamentally flawed and it's unlikely it will
be expanded, but rather replaced:

https://marc.info/?l=linux-aio&m=145255815216051&w=2

Since ext4 encryption means no direct io support, kernel aio isn't even
going to work properly on Android devices using file-based encryption.

Reviewed-at: https://android-review.googlesource.com/#/c/292158/

Link: http://lkml.kernel.org/r/1481113148-29204-1-git-send-email-amit.pundir@linaro.org
Signed-off-by: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Cc: Rob Herring <rob.herring@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs/android-recommended.config |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/configs/android-recommended.config~config-android-recommended-disable-aio-support kernel/configs/android-recommended.config
--- a/kernel/configs/android-recommended.config~config-android-recommended-disable-aio-support
+++ a/kernel/configs/android-recommended.config
@@ -1,4 +1,5 @@
 #  KEEP ALPHABETICALLY SORTED
+# CONFIG_AIO is not set
 # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
 # CONFIG_INPUT_MOUSE is not set
 # CONFIG_LEGACY_PTYS is not set
_
