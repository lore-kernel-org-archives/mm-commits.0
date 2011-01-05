From: akpm@linux-foundation.org
Subject: + fix-miscompiling-with-gcc-45-finline-functions.patch added to -mm tree
Date: Wed, 05 Jan 2011 15:02:36 -0800
Message-ID: <201101052302.p05N2a8x023318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681Ab1AEXDk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2011 18:03:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mahatma@bspu.unibel.by, avi@redhat.com, hverkuil@xs4all.nl, mahatma@eu.by, mchehab@infradead.org, mtosatti@redhat.com


The patch titled
     fix miscompiling with GCC 4.5 -finline-functions
has been added to the -mm tree.  Its filename is
     fix-miscompiling-with-gcc-45-finline-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix miscompiling with GCC 4.5 -finline-functions
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>

Fixing broken automatic inlining for GCC 4.5+  (breaks build with
-finline-functions or -O3 on x86_*).

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/vmx.c                  |    2 +-
 drivers/media/radio/radio-aimslab.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kvm/vmx.c~fix-miscompiling-with-gcc-45-finline-functions arch/x86/kvm/vmx.c
--- a/arch/x86/kvm/vmx.c~fix-miscompiling-with-gcc-45-finline-functions
+++ a/arch/x86/kvm/vmx.c
@@ -569,7 +569,7 @@ static inline void ept_sync_individual_a
 	}
 }
 
-static unsigned long vmcs_readl(unsigned long field)
+static noinline unsigned long vmcs_readl(unsigned long field)
 {
 	unsigned long value = 0;
 
diff -puN drivers/media/radio/radio-aimslab.c~fix-miscompiling-with-gcc-45-finline-functions drivers/media/radio/radio-aimslab.c
--- a/drivers/media/radio/radio-aimslab.c~fix-miscompiling-with-gcc-45-finline-functions
+++ a/drivers/media/radio/radio-aimslab.c
@@ -71,7 +71,7 @@ static struct rtrack rtrack_card;
 
 /* local things */
 
-static void sleep_delay(long n)
+static noinline void sleep_delay(long n)
 {
 	/* Sleep nicely for 'n' uS */
 	int d = n / msecs_to_jiffies(1000);
_

Patches currently in -mm which might be from mahatma@bspu.unibel.by are

fix-miscompiling-with-gcc-45-finline-functions.patch
fix-miscompiling-with-gcc-45-finline-functions-fix.patch

