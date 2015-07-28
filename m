From: akpm@linux-foundation.org
Subject: + remove-not-used-poison-pointer-macros.patch added to -mm tree
Date: Tue, 28 Jul 2015 14:49:33 -0700
Message-ID: <55b7f8ed.jF6d1UvWcfZmCHRW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbG1Vte (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jul 2015 17:49:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, kirill.shutemov@linux.intel.com, solar@openwall.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/poison.h: remove not-used poison pointer macros
has been added to the -mm tree.  Its filename is
     remove-not-used-poison-pointer-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/remove-not-used-poison-pointer-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/remove-not-used-poison-pointer-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vasily Kulikov <segoon@openwall.com>
Subject: include/linux/poison.h: remove not-used poison pointer macros

Signed-off-by: Vasily Kulikov <segoon@openwall.com>
Cc: Solar Designer <solar@openwall.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poison.h |    7 -------
 1 file changed, 7 deletions(-)

diff -puN include/linux/poison.h~remove-not-used-poison-pointer-macros include/linux/poison.h
--- a/include/linux/poison.h~remove-not-used-poison-pointer-macros
+++ a/include/linux/poison.h
@@ -73,10 +73,6 @@
 #define ATM_POISON_FREE		0x12
 #define ATM_POISON		0xdeadbeef
 
-/********** net/ **********/
-#define NEIGHBOR_DEAD		0xdeadbeef
-#define NETFILTER_LINK_POISON	0xdead57ac
-
 /********** kernel/mutexes **********/
 #define MUTEX_DEBUG_INIT	0x11
 #define MUTEX_DEBUG_FREE	0x22
@@ -87,7 +83,4 @@
 /********** security/ **********/
 #define KEY_DESTROY		0xbd
 
-/********** sound/oss/ **********/
-#define OSS_POISON_FREE		0xAB
